//
//  JuImageObject.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImageObject.h"

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
            NSString *stringUrl=imageObject;
            imageM.ju_imageUrl=imageObject;
            if ([stringUrl hasPrefix:@"http"]) {
                imageM.ju_imageType=JuImageTypeUrl;
            }else{
//                 imageM.ju_thumbImageUrl=[NSString stringWithFormat:@"%@mini",imageObject];
                imageM.ju_imageType=JuImageTypeLocal;
            }
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
