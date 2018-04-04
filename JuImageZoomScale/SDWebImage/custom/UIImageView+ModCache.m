//
//  UIImageView+ModCache.m
//  BGSever
//
//  Created by Juvid on 14-7-10.
//  Copyright (c) 2014年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImageView+ModCache.h"

@implementation UIImageView (ModCache)
/************************************************************************************************/
/**小头像**/
-(void)setUserThumbImage:(NSString *)strurl{
    [self setUserThumbImage:strurl  placeholderImage:@"doctor_default"];
}
-(void)setUserThumbImage:(NSString *)strurl placeholderImage:(id)placeholder{
    [self setThumbImageWithStr:strurl width:60 placeholderImage:placeholder];
}
/**略缩图*/
-(void)setThumbImageWithStr:(NSString *)strurl{
    [self setImagePlaceholder:[self shThumbnail:strurl] placeholderImage:nil options:0 progress:nil completed:nil];
}

/**略缩图带默认图片**/
- (void)setThumbImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder{
    [self setImagePlaceholder:[self shThumbnail:strurl] placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setThumbImageWithStr:(NSString *)strurl width:(CGFloat)width placeholderImage:(id)placeholder{
    [self setImagePlaceholder:[self shThumbnail:strurl size:CGSizeMake(width, width)] placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setThumbImageWithStr:(NSString *)strurl size:(CGSize)size placeholderImage:(id)placeholder{
    [self setImagePlaceholder:[self shThumbnail:strurl size:size] placeholderImage:placeholder options:0 progress:nil completed:nil];
}

/************************************************************************************************/
/*原图**/
- (void)setImageWithStr:(NSString *)strurl{
    [self setImagePlaceholder:strurl placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithStr:(NSString *)strurl progress:(SDWebImageDownloaderProgressBlock)progressBlock{
    [self setImagePlaceholder:strurl placeholderImage:nil options:0 progress:progressBlock completed:nil];
}

- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder{
    [self setImagePlaceholder:strurl placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder options:(SDWebImageOptions)options{
    [self setImagePlaceholder:strurl placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithStr:(NSString *)strurl completed:(SDWebImageCompletionBlock)completedBlock{
    
    [self setImagePlaceholder:strurl placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder completed:(SDWebImageCompletionBlock)completedBlock{
     [self setImagePlaceholder:strurl placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithStr:(NSString *)strurl placeholderImage:(id)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock{
      [self setImagePlaceholder:strurl placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

-(void)setImagePlaceholder:(NSString *)strurl  placeholderImage:(id)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock{
    UIImage *placeImg=[placeholder isKindOfClass:[NSString class]]?[UIImage imageNamed:placeholder]:placeholder;
    [self setImageWithStr:strurl placeholderImage:placeImg options:options progress:progressBlock completed:completedBlock];
}
/************************************************************************************************/

- (void)setImageWithStr:(NSString *)strurl placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",strurl]];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

///< 方形略缩图
-(NSString *)shThumbnail:(NSString *)imgUrl{
    return [self shThumbnail:imgUrl size:CGSizeMake(80, 80)];
}

///< 自定义大小
-(NSString *)shThumbnail:(NSString *)imgUrl size:(CGSize)size{
    int mulit= [UIScreen mainScreen].scale;
    NSString *imageURL=[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",imgUrl,(int)size.width*mulit,(int)size.height*mulit];
    return imageURL;
}
@end
