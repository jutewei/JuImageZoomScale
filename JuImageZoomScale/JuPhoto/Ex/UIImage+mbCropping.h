//
//  UIImage+mbCropping.h
//  MTSkinPublic
//
//  Created by Juvid on 2017/1/3.
//  Copyright © 2017年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mbCropping)
/**尺寸压缩*/
/**
 取大图

 @return 图片
 */
- (UIImage*)juSetHeadTailoring;

/**
 取小图

 @return 图片
 */
- (UIImage*)juSetThumbnail;

/**
 取指定大小图片（压缩图片）

 @param newSize 尺寸
 @return 图片
 */
- (UIImage*)juSetTailoring:(CGSize)newSize;

/**
 裁剪图片（压缩图片）

 @param maxPix 指定像素
 @return 图片
 */
-(UIImage *)juGetImageMaxPix:(CGFloat)maxPix;

/**
 获取最大像素的尺寸

 @param maxPix 最大像素
 @param imageS 图片size
 @return 最新尺寸
 */
+(CGSize)juGetMaxPix:(CGFloat)maxPix imageS:(CGSize)imageS;


/**
 根据最大边获取size

 @param size 尺寸
 @param images 图片size
 @return 最新尺寸
 */
+(CGSize)juGetMaxSize:(CGSize)size imageS:(CGSize)images;

/***最大尺寸压缩，以最大边压缩**/
-(UIImage *)juGetMinTailoring:(CGFloat)minSize;


//图片裁剪(裁剪多余部分)
- (UIImage *)juImageFromInRect:(CGRect)rect original:(CGRect)original;

/**指定尺寸裁剪*/
-(UIImage *)juFixImage:(CGSize)fixSize;

/*质量压缩*/
+(NSData *)juSetImageData:(id)imageData;

+(NSData *)juSetImageData:(id)imageData withScale:(CGFloat)scale;

@end
