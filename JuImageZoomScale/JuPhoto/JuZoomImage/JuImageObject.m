//
//  JuImageObject.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImageObject.h"
#import <UIKit/UIKit.h>
//#import "NSString+ThumbURL.h"
@implementation JuImageObject

+(NSArray *)juSwithObject:(NSArray *)arrList size:(CGSize)size{
    NSMutableArray *arrListM=[NSMutableArray array];
    for (id imageObject in arrList) {
        JuImageObject *imageM=[JuImageObject new];
        imageM.ju_thumbSize=size;
        if ([imageObject isKindOfClass:[UIImage class]]) {
            imageM.ju_image=imageObject;
            imageM.ju_imageType=JuImageTypeImage;
        }else if ([imageObject isKindOfClass:[NSString class]]){
            imageM.ju_imageUrl=imageObject;
//            imageM.ju_thumbImageUrl=[imageObject shUrlWithNormalSize:CGSizeMake(80, 80)];
//            [UIImageView shThumbnail:imageObject size:CGSizeMake(80, 80)]
             imageM.ju_imageType=JuImageTypeUrl;
        }else if([imageObject isKindOfClass:[PHAsset class]]){
            imageM.ju_asset=imageObject;
             imageM.ju_imageType=JuImageTypeAsset;
        }else if ([imageObject isKindOfClass:[JuImageObject class]]){
            imageM=imageObject;
        }
        [arrListM addObject:imageM];
    }
    return arrListM;
}
@end
