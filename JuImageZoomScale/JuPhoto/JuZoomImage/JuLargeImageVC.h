//
//  JuLargeimageVC.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuDefine.h"
#import "JuImagesCollectView.h"
@interface JuLargeImageVC : UIViewController<UINavigationControllerDelegate>

+(instancetype)initRect:(JuHandle)handle;
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index finishHandle:(JuHandle)handle;
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index thumbSize:(CGSize)size finishHandle:(JuHandle)handle;

@property (nonatomic,copy) JuHandle ju_handle;

@property (nonatomic,copy) JuCompletion ju_scaleHandle;

@property (nonatomic,readonly) JuImagesCollectView *ju_imgCollectView;

-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index startRect:(CGRect)frame;
-(void)juShow;
-(void)juHide;
@end
