//
//  JuImageObject.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//
// 网络图片大图到小图时显示
#import <Foundation/Foundation.h>

@interface JuImageObject : NSObject
@property (nonatomic,copy) NSString *ju_imageUrl;///< 
@property (nonatomic,copy) NSString  *ju_thumbImageUrl;
@end
