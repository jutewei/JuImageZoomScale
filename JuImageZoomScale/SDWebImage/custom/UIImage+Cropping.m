//
//  UIImage+Size.m
//  PFBDoctor
//
//  Created by Juvid on 2017/1/3.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImage+Cropping.h"

@implementation UIImage (Cropping)

-(UIImage*)setThumbnail{
    return [self setTailoring:CGSizeMake(150, 150)];
}
- (UIImage*)setTailoring:(CGSize)newSize{
    return [self shFixImage:[UIImage getMaxSize:newSize imageS:self.size]];
    //    =CGSizeMake(newSize.width,newSize.width/(self.size.width/self.size.height));

}
+(CGSize)getMaxSize:(CGSize)newSize imageS:(CGSize)imageSize{
    if (imageSize.width<newSize.width||imageSize.height<newSize.height) {
        return imageSize;
    }
    CGSize  fixSize;
    //    =CGSizeMake(newSize.width,newSize.width/(self.size.width/self.size.height));
    if (imageSize.width>imageSize.height) {
        fixSize=CGSizeMake(newSize.width*(imageSize.width/imageSize.height),newSize.width);
    }else{
        fixSize=CGSizeMake(newSize.width,newSize.width*(imageSize.height/imageSize.width));
    }
    return fixSize;
}


-(UIImage *)getImageMaxPix:(CGFloat)maxPix{
    CGSize imageSize=self.size;
    CGFloat imagePix=imageSize.width*imageSize.height;///800
    if (imagePix<=maxPix) {
        return self;
    }else{
        CGSize size=[UIImage getMaxPix:maxPix imageS:imageSize];
        return [self shFixImage:size];
    }
}
+(CGSize)getMaxPix:(CGFloat)maxPix imageS:(CGSize)imageSize{
    CGFloat imagePix=imageSize.width*imageSize.height;///800
    if (imagePix<=maxPix) {
        return imageSize;
    }else{
        CGFloat  fixScale = sqrt(imagePix/maxPix);///maxPix 400 结果缩小2两倍
        return CGSizeMake((int)(imageSize.width/fixScale), (int)(imageSize.height/fixScale));
    }

}

-(UIImage *)shFixImage:(CGSize)fixSize{

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
@end
