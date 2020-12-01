//
//  UIImage+Size.m
//  MTSkinPublic
//
//  Created by Juvid on 2017/1/3.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImage+mbCropping.h"
#import "UIImage+PhotoManage.h"

@implementation UIImage (mbCropping)
/**等比例压缩，保证最小边等于压缩尺寸**/
-(UIImage*)juSetHeadTailoring{
    return [self juSetTailoring:CGSizeMake(320, 568)];
}
-(UIImage*)juSetThumbnail{
    return [self juSetTailoring:CGSizeMake(150, 150)];
}
- (UIImage*)juSetTailoring:(CGSize)newSize{
    return [self juFixImage:[UIImage juGetMaxSize:newSize imageS:self.size]];
}
/**以最小边压缩**/
+(CGSize)juGetMaxSize:(CGSize)newSize imageS:(CGSize)originalSize{
    if (originalSize.width<newSize.width||originalSize.height<newSize.height) {
        return originalSize;
    }
    CGSize  fixSize;
    if (originalSize.width>originalSize.height) {
        fixSize=CGSizeMake(newSize.width*(originalSize.width/originalSize.height),newSize.width);
    }else{
        fixSize=CGSizeMake(newSize.width,newSize.width*(originalSize.height/originalSize.width));
    }
    return fixSize;
}
/**最大尺寸压缩，以最大边压缩*/
-(UIImage *)juGetMinTailoring:(CGFloat)minSize{
    CGSize  fixSize;
    CGSize originalSize=self.size;
    if (originalSize.width>=originalSize.height) {
        fixSize=CGSizeMake(minSize,minSize*(originalSize.height/originalSize.width));
    }else{
        fixSize=CGSizeMake(minSize*(originalSize.width/originalSize.height),minSize);
    }
    return  [self juFixImage:fixSize];
}


/**允许图片的最大像素**/
-(UIImage *)juGetImageMaxPix:(CGFloat)maxPix{
    CGSize imageSize=self.size;
    CGFloat imagePix=imageSize.width*imageSize.height;///800
    if (imagePix<=maxPix) {
        return self;
    }else{
        CGSize size=[UIImage juGetMaxPix:maxPix imageS:imageSize];
        return [self juFixImage:size];
    }
}
/**允许图片的最大像素**/
+(CGSize)juGetMaxPix:(CGFloat)maxPix imageS:(CGSize)imageSize{
    CGFloat imagePix=imageSize.width*imageSize.height;///800
    if (imagePix<=maxPix) {
        return imageSize;
    }else{
        CGFloat  fixScale = sqrt(imagePix/maxPix);///maxPix 400 结果缩小2两倍
        return CGSizeMake((int)(imageSize.width/fixScale), (int)(imageSize.height/fixScale));
    }
}

-(UIImage *)juFixImage:(CGSize)fixSize{

    UIGraphicsBeginImageContext(fixSize);

    // Tell the old image to draw in this new context, with the desired
    // new size

    [self drawInRect:CGRectMake(0,0,fixSize.width,fixSize.height)];

    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;

}
//图片裁剪
- (UIImage *)juImageFromInRect:(CGRect)rect original:(CGRect)original{
    CGFloat cropingX=(rect.origin.x/original.size.width)*self.size.width;
    CGFloat cropingY=(rect.origin.y/original.size.height)*self.size.height;
    CGFloat cropingW=(rect.size.width/original.size.width)*self.size.width;
    CGFloat cropingH=(rect.size.height/original.size.height)*self.size.height;
    CGRect croping=CGRectMake(cropingX, cropingY, cropingW, cropingH);
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, croping);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

+(NSData *)juSetImageData:(id)imageData{
    return [self juSetImageData:imageData withScale:0];
}

+(NSData *)juSetImageData:(id)imageData withScale:(CGFloat)scale{
    __block UIImage *images;
    [imageData juGetfullScreenImage:^(UIImage *image) {
        images=image;
    }];

    NSData  *dataImage;
    if([imageData isKindOfClass:[NSData class]]){
        dataImage=imageData;
    }else{
        dataImage=UIImageJPEGRepresentation(images, 1);
        CGFloat dataLength=dataImage.length / 1024.;
        NSLog(@"原图大小: %.3fKB", dataLength);
        
        if(scale>0) return UIImageJPEGRepresentation(images, scale);

        if (dataLength>3000) {
            dataLength=dataLength/1024.0;///< M
            NSLog(@"原图大小: %.3f M", dataLength);
            scale=MAX(0.08,0.6-(dataLength-3)*.1);
            ///< 3M .8, 4M .75, 5M 0.7, 6M 0.65, 7M 0.6, 8M 0.55 ,9M 0.5 ,10M 0.45 ,11M 0.4
        }else if (dataLength<1000) {
            NSLog(@"原图大小: %.3f KB", dataLength);
            scale=1;
        }else{
            scale=0.6;
        }
        dataImage=nil;
        dataImage= UIImageJPEGRepresentation(images, scale);
    }
    NSLog(@"压缩后大小: %.3fKB", dataImage.length / 1024.);
    return dataImage;
}

@end
