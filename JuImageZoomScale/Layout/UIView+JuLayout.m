//
//  UIView+Layout.m
//  JuLayout
//
//  Created by Juvid on 16/7/17.
//  Copyright © 2016年 Juvid. All rights reserved.
//

#import "UIView+JuLayout.h"
//#import "JuLayout.h"
@implementation UIView (JuLayout)

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
-(JuLayout *)juLeftSpace{
    return [self newJuLay:NSLayoutAttributeLeading secondAtt:NSLayoutAttributeTrailing withType:JuLayoutLead];
}
-(JuLayout *)juRighSpace{
    return [self newJuLayMinus:NSLayoutAttributeTrailing secondAtt:NSLayoutAttributeLeading withType:JuLayoutTrail];
}

-(JuLayout *)juTopSpace{
    return [self newJuLay:NSLayoutAttributeTop secondAtt:NSLayoutAttributeBottom withType:JuLayoutTop];
}
-(JuLayout *)juBomSpace{
    return [self newJuLayMinus:NSLayoutAttributeBottom secondAtt:NSLayoutAttributeTop withType:JuLayoutBottom];
}
-(JuLayout *)juLastLine{
    return [self newJuLay:NSLayoutAttributeLastBaseline withType:JuLayoutBottom];
}

-(JuLayout *)juFirstLine{
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

/**
 内容优先级
 */
-(void(^)(UILayoutPriority priority))juHorConHugPri{
    return ^(UILayoutPriority priority){
        [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
    };
}
-(void(^)(UILayoutPriority priority))juVerConHugPri{
    return ^(UILayoutPriority priority){
         [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
    };
}
-(void(^)(UILayoutPriority priority))juVerConComResPri{
    return ^(UILayoutPriority priority){
        [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
    };
}
-(void(^)(UILayoutPriority priority))juHorConComResPri{
    return ^(UILayoutPriority priority){
         [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
    };
}
@end
