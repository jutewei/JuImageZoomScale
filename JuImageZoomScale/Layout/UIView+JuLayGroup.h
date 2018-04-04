//
//  UIView+JuLayoutFrame.h
//  JuLayout
//
//  Created by Juvid on 16/7/17.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
///< 左右上高度
typedef struct JuLayEdgeHeight {
    CGFloat lead, trail, top, height;
} JuLayEdgeHeight;
UIKIT_STATIC_INLINE JuLayEdgeHeight JuEdgeHMake(CGFloat lead, CGFloat trail, CGFloat top, CGFloat height) {
    JuLayEdgeHeight julrth = {lead, trail, top, height};
    return julrth;
}
///< 上下左宽度
typedef struct JuLayEdgeWidth {
    CGFloat top, bottom, lead, width;
} JuLayEdgeWidth;
UIKIT_STATIC_INLINE JuLayEdgeWidth JuEdgeWMake(CGFloat top, CGFloat bottom, CGFloat lead, CGFloat width) {
    JuLayEdgeWidth jutblw = {top, bottom, lead, width};
    return jutblw;
}
///< X,Y,宽度，高度
/*typedef struct JuLayRect {
    CGFloat lead, top, width, height;
} JuLayRect;
UIKIT_STATIC_INLINE JuLayRect JuRectMake(CGFloat lead, CGFloat top, CGFloat width, CGFloat height) {
    JuLayRect jultwh = {lead, top, width, height};
    return jultwh;
}*/

@interface UIView(JuLayGroup)

/*
 *本类所以方法为辅助作用，只对同一个view相对约束 标有safe的为安全区域的约束
 */

/**
 *  XY约束:X（>0左边,<0右边，=0中间）,Y（>0顶端,<0底端，=0中间）
 */
-(void(^)(CGPoint origin))juOrigin;
-(void(^)(CGPoint origin))juSafeOrigin;///<在juOrigin基础上增加安全区域约束
-(void(^)(UIView *view))juOriginEqual;///< 约束针对另一个View的约束（不指定view默认为supview）

/**
 *  宽度高度
 */
-(void(^)(CGSize size))juSize;
-(void(^)(UIView *view))juSizeEqual;///< 宽度高度坐标等于另一个view
/**
 *  frame约束（xy等同juOrigin）
 */
-(void(^)(CGRect frame))juFrame;
-(void(^)(CGRect frame))juSafeFrame;
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

/**
 *  X轴对齐:X轴（>0坐边,<0右边，=0中间），Y（上边）宽度，高度
 */
/*-(void(^)(JuLayRect juFrame))juAlignX;
-(void(^)(JuLayRect juFrame))juSafeAlignX;
-(void(^)(JuLayRect juFrame,UIView *view))juAlignXTo;
*/
/**
 *  Y轴对齐:Y轴（>0坐边,<0右边，=0中间），X（左边边）宽度，高度
 */
/*-(void(^)(JuLayRect juFrame))juAlignY;
-(void(^)(JuLayRect juFrame))juSafeAlignY;
-(void(^)(JuLayRect juFrame,UIView *view))juAlignYTo;*/
@end
