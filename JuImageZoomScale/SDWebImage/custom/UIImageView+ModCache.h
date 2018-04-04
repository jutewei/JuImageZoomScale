//
//  UIImageView+ModCache.h
//  BGSever
//
//  Created by Juvid on 14-7-10.
//  Copyright (c) 2014年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
//#import "PFBUrlSet.h"
@interface UIImageView (ModCache)
/**医生头像**/
-(void)setUserThumbImage:(NSString *)strurl;
-(void)setUserThumbImage:(NSString *)strurl placeholderImage:(id)placeholder;///< 头像

/**方形略缩图默认80*80**/
- (void)setThumbImageWithStr:(NSString *)strurl;
- (void)setThumbImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder;

/**略缩图自定义尺寸**/
- (void)setThumbImageWithStr:(NSString *)strurl width:(CGFloat)width placeholderImage:(id)placeholder;
- (void)setThumbImageWithStr:(NSString *)strurl size:(CGSize)size placeholderImage:(id)placeholder;

/**原图**/
- (void)setImageWithStr:(NSString *)strUrl;
- (void)setImageWithStr:(NSString *)strurl progress:(SDWebImageDownloaderProgressBlock)progressBlock;
- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholde;
- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder options:(SDWebImageOptions)options;
- (void)setImageWithStr:(NSString *)strurl completed:(SDWebImageCompletionBlock)completedBlock;
- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;

- (void)setImageWithStr:(NSString *)strurl placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 略缩图片地址
 */
-(NSString *)shThumbnail:(NSString *)imgUrl;
-(NSString *)shThumbnail:(NSString *)imgUrl size:(CGSize)size;
//- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs;
@end
