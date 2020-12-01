//
//  UIView+Layout.m
//  testBlock
//
//  Created by Juvid on 16/7/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "UIView+JuLayout.h"
//#import "JuLayout.h"
@implementation UIView (JuLayout)
/*
 -(NSLayoutConstraint *)juAddConstraint:(JuLayout *)juLayout{
 self.translatesAutoresizingMaskIntoConstraints=NO;
 if (!self.superview) return nil;
 UIView *toItem=juLayout.juView2;
 UIView *addConsView=self.superview;
 CGFloat constant=juLayout.juConstant;
 if (juLayout.juAttr1==NSLayoutAttributeWidth||juLayout.juAttr1==NSLayoutAttributeHeight) {
 if (!toItem) {
 if (constant==0) {///< 等于0时约束等于父view
 toItem=self.superview;
 }else{///< 自己加约束
 addConsView=self;
 }
 }
 else if([toItem isEqual:self]){///< 长宽比例时
 addConsView=self;
 }
 }else{
 if (!toItem) {
 toItem=self.superview;
 }
 }
 NSLayoutConstraint *layoutConstraint=[NSLayoutConstraint constraintWithItem:self attribute:juLayout.juAttr1 relatedBy:juLayout.juRelation toItem:toItem attribute:juLayout.juAttr2 multiplier:juLayout.juMulti constant:constant];
 layoutConstraint.priority=juLayout.prioritys;
 layoutConstraint.juLayType=juLayout.juLayoutType;

 [self juCompareSameCons:layoutConstraint];

 if (!self.ju_Constraints) self.ju_Constraints=[NSMutableArray array];
 [self.ju_Constraints addObject:layoutConstraint];

 [addConsView addConstraint:layoutConstraint];
 return layoutConstraint;
 }*/


-(JuLayout *)newJuLayMinus:(NSLayoutAttribute)firstAtt withType:(JuLayoutType)layoutType{
    return [self newJuLayMinus:firstAtt secondAtt:firstAtt withType:layoutType];
}
-(JuLayout *)newJuLayMinus:(NSLayoutAttribute)firstAtt secondAtt:(NSLayoutAttribute)secondAtt withType:(JuLayoutType)layoutType{
    JuLayout *layout=[self newJuLay:firstAtt secondAtt:secondAtt withType:layoutType];
    layout.isMinus=YES;
    return layout;
}
-(JuLayout *)newJuLay:(NSLayoutAttribute)firstAtt withType:(JuLayoutType)layoutType{
    return [self newJuLay:firstAtt secondAtt:firstAtt withType:layoutType];
}
-(JuLayout *)newJuLay:(NSLayoutAttribute)firstAtt secondAtt:(NSLayoutAttribute)secondAtt withType:(JuLayoutType)layoutType{
    JuLayout *layout=[JuLayout new];
    layout.juAttr1=firstAtt;
    layout.juAttr2=secondAtt;
    layout.juView1=self;
    layout.juLayoutType=layoutType;
    return layout;
}
-(JuLayout *)juLead{
    return [self newJuLay:NSLayoutAttributeLeading withType:JuLayoutLead];
}
-(JuLayout *)juTrail{
    return [self newJuLayMinus:NSLayoutAttributeTrailing withType:JuLayoutTrail];
}
-(JuLayout *)juTop{
    return [self newJuLay:NSLayoutAttributeTop withType:JuLayoutTop];
}
-(JuLayout *)juBottom{
    return [self newJuLayMinus:NSLayoutAttributeBottom withType:JuLayoutBottom];
}
-(JuLayout *)juLeaSpace{
    return [self newJuLay:NSLayoutAttributeLeading secondAtt:NSLayoutAttributeTrailing withType:JuLayoutLead];
}
-(JuLayout *)juTraSpace{
    return [self newJuLayMinus:NSLayoutAttributeTrailing secondAtt:NSLayoutAttributeLeading withType:JuLayoutTrail];
}

-(JuLayout *)juTopSpace{
    return [self newJuLay:NSLayoutAttributeTop secondAtt:NSLayoutAttributeBottom withType:JuLayoutTop];
}
-(JuLayout *)juBtmSpace{
    return [self newJuLayMinus:NSLayoutAttributeBottom secondAtt:NSLayoutAttributeTop withType:JuLayoutBottom];
}
-(JuLayout *)juLastLine{
    return [self newJuLay:NSLayoutAttributeLastBaseline withType:JuLayoutBottom];
}

-(JuLayout *)juFirLine{
    return  [self newJuLay:NSLayoutAttributeFirstBaseline withType:JuLayoutTop];
}
-(JuLayout *)juCenterX{
    return [self newJuLay:NSLayoutAttributeCenterX withType:JuLayoutCenterX];
}
-(JuLayout *)juCenterY{
    return [self newJuLay:NSLayoutAttributeCenterY withType:JuLayoutCenterY];
}

-(JuLayout *)juWidth{
    return [self newJuLay:NSLayoutAttributeWidth withType:JuLayoutWidth];
}
-(JuLayout *)juHeight{
    return [self newJuLay:NSLayoutAttributeHeight withType:JuLayoutHeight];
}
-(JuLayout *)juAspectWH{
    return [self newJuLay:NSLayoutAttributeWidth secondAtt:NSLayoutAttributeHeight withType:JuLayoutAspectWH];
}


@end
