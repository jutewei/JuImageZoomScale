//
//  JuZoomScaleImageView.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuDefine.h"
@protocol JuImageZoomScaleDelegate <NSObject>
@optional
/**
 当前预览坐标
 */
-(CGRect)juCurrentRect;
-(void)juTapHidder;
-(void)juChangeSacle:(CGFloat)scale;

@end

@interface JuZoomScaleView : UIScrollView

@property (nonatomic,assign) id<JuImageZoomScaleDelegate> ju_delegate;
@property(nonatomic,assign) BOOL  ju_isAlbum;///< 相册
@property (nonatomic,strong) UIImageView *ju_imgView;

//- (void) setContentWithFrame:(CGRect)rect isAnimate:(BOOL)isAnimate;

- (void) setItemImage:(id)imageObject originalRect:(CGRect)originalRect;
//- (void) juStatusBarOrientationChange:(NSNotification *)notification;
//- (void) juShowBigImage:(id)imageData  withSize:(CGSize)size;
//- (void) juShowSmallImage:(id)imageData withSize:(CGSize)size;
//- (void) juShowAnimation;
//- (void) juHiddenAnimation;

@end
