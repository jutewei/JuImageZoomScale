//
//  RHAssetsLibrary.h
//  XYLEPlay
//
//  Created by juvid on 15/7/28.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RHAssetsLibrary : NSObject

+(ALAssetsLibrary*)rh_getShareAssetsLibrary;

@end
