//
//  JuTransitionDelegate.h
//  JuPresent
//
//  Created by Juvid on 2018/4/24.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JuInteractiveTransition.h"
typedef NS_ENUM(NSUInteger, JuInteractiveTransitionGestureDirection) {//手势的方向
    JuInteractiveTransitionGestureDirectionLeft = 0,
    JuInteractiveTransitionGestureDirectionRight,
    JuInteractiveTransitionGestureDirectionUp,
    JuInteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, JuTransitionType) {//手势控制哪种转场
    JuTransitionTypePresent = 0,
    JuTransitionTypeDismiss,
    JuTransitionTypePush,
    JuTransitionTypePop,
};


@interface JuTransitionDelegate : NSObject<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) JuInteractiveTransition *ju_interavtive;
+ (instancetype)initTransitionDelegate:(JuTransitionType)type vcItem:(UIViewController *)viewVc;

+ (instancetype)initTransitionDelegate:(JuTransitionType)type gestureDirection:(JuInteractiveTransitionGestureDirection)direction vcItem:(UIViewController *)viewVc;

@end
