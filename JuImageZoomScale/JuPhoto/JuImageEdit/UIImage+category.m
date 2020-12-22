//
//  UIImage+MUCommon.h
//  BigCalculat
//
//  Created by 罗文琦 on 16/10/27.
//  Copyright © 2016年 罗文琦. All rights reserved.
//
//

#import "UIImage+category.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation UIImage (category)

#pragma mark - 修正图片旋转
-(UIImage *_Nonnull)juFixOrientation{
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*)juRotatingOrientation{
    //No-op if the orientation is already correct
    UIImage *image=[self juFixOrientation];

    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;

    //CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;

        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);

    CGContextScaleCTM(context, scaleX, scaleY);

    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage*newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}


@end


@implementation UIImageView (category)

- (void)juRotationView {
    self.image= [self.image juFixOrientation];
//    //在本例子中,图片的最大高度设置为500,最大宽度为屏幕宽度,当然自己也可以根据自己的需要去调整自己的图片框的大小
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
        if (self.frame.size.width >= self.juWindowWidth) { //过长
            //计算比例系数
            CGFloat kSacale = self.juWindowWidth /self.frame.size.width;
            //大小缩放
            self.transform = CGAffineTransformScale(self.transform,kSacale, kSacale);
        }else{
            //判断当宽度缩放到屏幕宽度之后,高度与500哪一个更大
            CGFloat kSacale = self.juWindowWidth / self.frame.size.width;
            if (self.frame.size.height * kSacale > self.juWindowHeight) {
                kSacale = self.juWindowHeight / self.frame.size.height;
            }
            self.transform = CGAffineTransformScale(self.transform,kSacale, kSacale);
        }
    }];
}

- (UIImage *)juSaveRotationResult {
    //使用绘制的方法得到旋转之后的图片
    double rotationZ = [[self.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.image.size.width, self.image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotationZ);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.image.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap,rotationZ);
    CGContextScaleCTM(bitmap, 1, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.image.size.width / 2, -self.image.size.height / 2, self.image.size.width, self.image.size.height), [self.image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //把最终的图片存到相册看看是否成功
//    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    return newImage;
}

//设置图片展开
- (CGRect) juSetImage:(UIImage *)image{
    CGRect ju_originRect=CGRectZero;
    if (image){
        self.image=image;
        CGSize imgSize = image.size;
        //判断首先缩放的值
        float scaleX = self.juWindowWidth/imgSize.width;
        float scaleY = self.juWindowHeight/imgSize.height;
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            ju_originRect = (CGRect){self.juWindowWidth/2-imgViewWidth/2,0,imgViewWidth,self.juWindowHeight};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            ju_originRect = (CGRect){0,self.juWindowHeight/2-imgViewHeight/2+self.juSafeBottom,self.juWindowWidth,imgViewHeight};
        }
    }
    return ju_originRect;
}
-(CGFloat)juSafeBottom{
    CGFloat safe=0;
    if (@available(iOS 11.0, *)) {
        safe=[UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    return safe+60;
}
-(CGFloat)juWindowWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
-(CGFloat)juWindowHeight{
    return [UIScreen mainScreen].bounds.size.height-self.juSafeBottom*2;
}
@end
