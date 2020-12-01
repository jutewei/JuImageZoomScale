//
//  JuProgressView.h
//  TestSwift
//
//  Created by Juvid on 2016/10/28.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuProgressView : UIView
/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat ju_Progress;

/**
 *  进度边宽
 */
@property(nonatomic,assign) CGFloat ju_progressWidth;
/**
 *  进度条颜色
 */
@property(nonatomic,strong)UIColor *ju_progressColor;

/**
 *  背景边宽
 */
@property(nonatomic,assign) CGFloat ju_backWidth;


/**
 *  进度背景颜色
 */
@property(nonatomic,strong)UIColor *ju_backColor;
/**
 *  显示进度标签
 */
@property (nonatomic) BOOL isShowProgress;
/**
 *  标签颜色
 */
@property (nonatomic,strong) UIColor *ju_textColor;
/**
 *  标签字体
 */
@property (nonatomic,strong) UIFont *ju_textFont;
@end
