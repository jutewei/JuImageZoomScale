//
//  JuProgressView.m
//  TestSwift
//
//  Created by Juvid on 2016/10/28.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import "JuProgressView.h"

@interface JuProgressView (){
    CAShapeLayer *ju_backLayer; //背景图层
    CAShapeLayer *ju_progressLayer;      //用来填充的图层
    UIBezierPath *ju_backPath; //背景贝赛尔曲线
    UIBezierPath *ju_progressPath;  //用来填充的贝赛尔曲线
    UILabel *_ju_labProgressl;///< 进度
}

@end

@implementation JuProgressView
@synthesize ju_Progress=_ju_Progress;
@synthesize ju_backColor=_ju_backColor;
@synthesize ju_backWidth=_ju_backWidth;
@synthesize ju_progressColor=_ju_progressColor;
@synthesize ju_progressWidth=_ju_progressWidth;
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self juInitPath];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self juInitPath];

    }
    return self;
    
}
- (void)juInitPath
{
//    self.backgroundColor=MFColor_White;
    //创建背景图层
    ju_backLayer = [CAShapeLayer layer];
    ju_backLayer.fillColor = nil;
    ju_backLayer.frame = self.bounds;

    //创建填充图层
    ju_progressLayer = [CAShapeLayer layer];
    ju_progressLayer.fillColor = nil;
    ju_progressLayer.frame = self.bounds;
    ju_progressLayer.lineCap = kCALineCapRound; // 设置线为圆角

    [self.layer addSublayer:ju_backLayer];
    [self.layer addSublayer:ju_progressLayer];
}
-(void)setJu_progressColor:(UIColor *)ju_progressColor{
    _ju_progressColor=ju_progressColor;
    ju_progressLayer.strokeColor=_ju_progressColor.CGColor;

}
-(void)setJu_backColor:(UIColor *)ju_backColor{
    _ju_backColor=ju_backColor;
    ju_backLayer.strokeColor=_ju_backColor.CGColor;
    ju_backPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0) radius:(CGRectGetWidth(self.bounds)-_ju_backWidth)/2.f startAngle:0 endAngle:M_PI*2
                                                       clockwise:YES];
    ju_backLayer.path = ju_backPath.CGPath;
}
-(void)setJu_Progress:(CGFloat)ju_Progress{
    _ju_Progress = ju_Progress;
    ju_progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0)  radius:(CGRectGetWidth(self.bounds)-_ju_progressWidth)/2.f startAngle:-M_PI_2 endAngle:(2*M_PI)*_ju_Progress-M_PI_2 clockwise:YES];

    ju_progressLayer.path = ju_progressPath.CGPath;
    if (_isShowProgress) {
        self.ju_labProgressl.text=[NSString stringWithFormat:@"%d%%",(int)(_ju_Progress*100)];
    }
}
-(void)setJu_progressWidth:(CGFloat)ju_progressWidth{
    _ju_progressWidth = ju_progressWidth;
    ju_progressLayer.lineWidth = _ju_progressWidth;
}
-(void)setJu_backWidth:(CGFloat)ju_backWidth{
    _ju_backWidth=ju_backWidth;
    ju_backLayer.lineWidth=_ju_backWidth;
}
-(void)setIsShowProgress:(BOOL)isShowProgress{
    _isShowProgress=isShowProgress;
    self.ju_labProgressl.hidden=!_isShowProgress;
}
-(void)setJu_textFont:(UIFont *)ju_textFont{
    _ju_textFont=ju_textFont;
    self.ju_labProgressl.font=ju_textFont;
}
-(void)setJu_textColor:(UIColor *)ju_textColor{
    _ju_textColor=ju_textColor;
    self.ju_labProgressl.textColor=ju_textColor;
}
-(UILabel *)ju_labProgressl{
    if (!_ju_labProgressl) {
        _ju_labProgressl=[[UILabel alloc]initWithFrame:self.bounds];
        _ju_labProgressl.backgroundColor=[UIColor clearColor];
        _ju_labProgressl.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_ju_labProgressl];
    }
    return _ju_labProgressl;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
