//
//  UIImage+Cropping.h
//  PFBDoctor
//
//  Created by Juvid on 2017/1/3.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (Cropping)


/**
 取小图

 @return 图片
 */
- (UIImage*)setThumbnail;

/**
 取指定大小图片

 @param newSize 尺寸
 @return 图片
 */
- (UIImage*)setTailoring:(CGSize)newSize;

/**
 裁剪图片

 @param maxPix 指定像素
 @return 图片
 */
-(UIImage *)getImageMaxPix:(CGFloat)maxPix;

/**
 获取最大像素的尺寸

 @param maxPix 最大像素
 @param imageSize 图片size
 @return 最新尺寸
 */
+(CGSize)getMaxPix:(CGFloat)maxPix imageS:(CGSize)imageS;


/**
 根据最大边获取size

 @param size 尺寸
 @param images 图片size
 @return 最新尺寸
 */
+(CGSize)getMaxSize:(CGSize)size imageS:(CGSize)images;



@end
