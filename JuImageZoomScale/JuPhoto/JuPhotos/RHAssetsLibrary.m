//
//  RHAssetsLibrary.m
//  XYLEPlay
//
//  Created by juvid on 15/7/28.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "RHAssetsLibrary.h"

@implementation RHAssetsLibrary

+(ALAssetsLibrary *)rh_getShareAssetsLibrary{
    
    static ALAssetsLibrary* singleton;
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^{
        
        singleton = [[ALAssetsLibrary alloc]init];
        
    });
    
    return singleton;
}

@end
