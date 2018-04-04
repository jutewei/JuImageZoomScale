//
//  JuLayout.m
//  JuLayout
//
//  Created by Juvid on 16/7/17.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import "JuLayout.h"
#import "UIView+JuLayout.h"

@implementation JuLayout
-(id)init{
    self=[super init];
    if (self) {
        self.juMulti=1;
        _prioritys=UILayoutPriorityRequired;
    }
    return self;
}
/**
 *  @author Juvid, 16-07-18 09:07:29
 *
 *  添加约束
 *
 *  @return 约束
 */
-(NSLayoutConstraint *)juAddConstraint{
     if (!_juView1.superview) return nil;
    _juView1.translatesAutoresizingMaskIntoConstraints=NO;
    id toItem=_juView2;
    UIView *ju_View=_juView1.superview;
    CGFloat constant=_juConstant;
    if (self.juAttr1==NSLayoutAttributeWidth||_juAttr1==NSLayoutAttributeHeight) {
        if (!toItem) {
            if (constant==0) {///< 等于0时约束等于父view
                toItem=_juView1.superview;
            }else{///< 自己加约束
                ju_View=_juView1;
            }
        }
        else if([toItem isEqual:_juView1]){///< 长宽比例时
            ju_View=_juView1;
        }
    }else{
        if (!toItem) {
            toItem=_juView1.superview;
        }
    }
    if(_isSafe){
        if (@available(iOS 11.0, *)) {
            toItem=_juView1.superview.safeAreaLayoutGuide;
        } 
    }
    UIView *firstView=_isMinus?toItem:_juView1;
    UIView *secondView=_isMinus?_juView1:toItem;
    NSLayoutAttribute firstAtt=_isMinus?_juAttr2:_juAttr1;
    NSLayoutAttribute secondAtt=_isMinus?_juAttr1:_juAttr2;

    NSLayoutConstraint *layoutConstraint=[NSLayoutConstraint constraintWithItem:firstView attribute:firstAtt relatedBy:_juRelation toItem:secondView attribute:secondAtt multiplier:_juMulti constant:constant];
    layoutConstraint.priority=_prioritys;
    layoutConstraint.juLayType=_juLayoutType;
    
    [_juView1 juCompareSameCons:layoutConstraint];
    
    if (!_juView1.ju_Constraints) _juView1.ju_Constraints=[NSMutableArray array];
    [_juView1.ju_Constraints addObject:layoutConstraint];
    
    [ju_View addConstraint:layoutConstraint];
    
    return layoutConstraint;
}
/***************************************************************/

-(void)setJuConstant:(CGFloat)juConstant{
    _juConstant=juConstant;
}
-(void)setJuLayoutType:(JuLayoutType)juLayoutType{
    _juLayoutType=juLayoutType;
    if (juLayoutType==JuLayoutAspectWH) {
        _juView2=_juView1;
    }
}
/***=====================添加过程约束==============================*/

-(JuLayout *(^)(CGFloat  prioritys))priority{
    return ^JuLayout* (CGFloat  prioritys){
        self->_prioritys=prioritys;
        return self;
    };
}
-(JuLayout *(^)(CGFloat  mulits))multi{
    return ^JuLayout* (CGFloat  mulits){
        self->_juMulti=mulits;
        return self;
    };
}
-(JuLayout *(^)(UIView * toItem))toView{
    return ^JuLayout* (UIView * toItem){///< block实现返回block变量
        self->_juView2=toItem;
        return self;///< block返回值
    };
}
/**
 *  安全区域
 */
-(JuLayout *)safe{
    _isSafe=YES;
    return self;
}
/**======================最终生成约束=============================**/

-(NSLayoutConstraint *(^)(CGFloat constion))equal{
    return ^NSLayoutConstraint* (CGFloat constion){
        self->_juRelation=NSLayoutRelationEqual;
        self.juConstant=constion;
        return  [self juAddConstraint];
    };
}
-(NSLayoutConstraint *(^)(CGFloat constion))greatEqual{
    return ^NSLayoutConstraint* (CGFloat constion){
        self->_juRelation=NSLayoutRelationGreaterThanOrEqual;
        self.juConstant=constion;
        return [self juAddConstraint];
    };
}
-(NSLayoutConstraint *(^)(CGFloat constion))lessEqual{
    return ^NSLayoutConstraint* (CGFloat constion){
        self->_juRelation=NSLayoutRelationLessThanOrEqual;
        self.juConstant=constion;
        return [self juAddConstraint];
    };
}

@end
