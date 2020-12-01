//
//  UIView+JuLayoutFrame.h
//  JuLayout
//
//  Created by Juvid on 16/7/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>

///< 左右上高度
typedef struct JuLayEdgeHeight {
    CGFloat lead, trail, y, height;
} JuLayEdgeHeight;
UIKIT_STATIC_INLINE JuLayEdgeHeight JuEdgeHMake(CGFloat lead, CGFloat trail, CGFloat y, CGFloat height) {
    JuLayEdgeHeight julrth = {lead, trail, y, height};
    return julrth;
}
///< 上下左宽度
typedef struct JuLayEdgeWidth {
    CGFloat top, bottom, x, width;
} JuLayEdgeWidth;
UIKIT_STATIC_INLINE JuLayEdgeWidth JuEdgeWMake(CGFloat top, CGFloat bottom, CGFloat x, CGFloat width) {
    JuLayEdgeWidth jutblw = {top, bottom, x, width};
    return jutblw;
}


@interface UIView(JuLayGroup)

/*
 *本类所以方法为辅助作用，只对同一个view相对约束
 */

/**
 *  XY约束:X（>0左边,<0右边，=0中间）,Y（>0顶端,<0底端，=0中间）
 */
-(void(^)(CGPoint origin))juOrigin;
/**
 *  XY坐标等于另一个view
 */
-(void(^)(UIView *view))juOriginEqual;

-(void(^)(CGPoint origin))juSafeOrigin;

/**
 *  宽度高度
 */
-(void(^)(CGSize size))juSize;
/**
 *  宽度高度坐标等于另一个view
 */
-(void(^)(UIView *view))juSizeEqual;

/**
 *  frame约束（xy等同juOrigin）
 */
-(void(^)(CGRect frame))juFrame;
-(void(^)(CGRect frame))juSafeFrame;
/**
 *  整个约束等于另一个View（一般是等于父view）
 */
-(void(^)(UIView *view))juFrameEqual;
/**
 *  四边约束
 */
-(void(^)(UIEdgeInsets edge))juEdge;
-(void(^)(UIEdgeInsets edge))juSafeEdge;
-(void(^)(UIEdgeInsets edge,UIView *view))juEdgeTo;

/**
 *  左,右 ,Y方向（>0顶端,<0底端，=0中间）,高度约束
 */
-(void(^)(JuLayEdgeHeight juEdgeH))juEdgeH;
-(void(^)(JuLayEdgeHeight juEdgeH))juSafeEdgeH;
-(void(^)(JuLayEdgeHeight juEdgeH,UIView *view))juEdgeHTo;

/**
 *  上,下, X方向（>0坐边,<0右边，=0中间）,高度约束
 */
-(void(^)(JuLayEdgeWidth juEdgeW))juEdgeW;
-(void(^)(JuLayEdgeWidth juEdgeW))juSafeEdgeW;
-(void(^)(JuLayEdgeWidth juEdgeW,UIView *view))juEdgeWTo;


@end
