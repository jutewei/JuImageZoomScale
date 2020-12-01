//
//  JuPhotoGroupViewController.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoDelegate.h"
//#import "JuBaseViewController.h"

typedef NS_ENUM(NSInteger, JuPhotoType) {
    JuPhotoTypeNone = 0, // 所有
    JuPhotoTypePic = 1, // 图片
    JuPhotoTypeVideo  = 2, // 视频
};

@interface JuPhotoGroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSUInteger ju_maxNumSelection;

@property (nonatomic,weak) id<JuPhotoDelegate> juDelegate;

@property (nonatomic,assign) JuPhotoType *ju_photoType;

@end
