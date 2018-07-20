//
//  JuTransitionDelegate.m
//  JuPresent
//
//  Created by Juvid on 2018/4/24.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuTransitionDelegate.h"
#import "JuNaviTransitioning.h"

#import "JuModelTransitioning.h"

@interface JuTransitionDelegate ()
@property (nonatomic,strong) JuInteractiveTransition *ju_interavtive;

@end


@implementation JuTransitionDelegate

+ (instancetype)initTransitionDelegate:(JuTransitionType)type vcItem:(UIViewController *)viewVc{
    return [self initTransitionDelegate:type gestureDirection:JuInteractiveTransitionGestureDirectionRight vcItem:viewVc];
}

+ (instancetype)initTransitionDelegate:(JuTransitionType)type gestureDirection:(JuInteractiveTransitionGestureDirection)direction vcItem:(UIViewController *)viewVc{
    return [[JuTransitionDelegate alloc]initTransitionDelegate:type gestureDirection:direction vcItem:viewVc];
}

- (instancetype)initTransitionDelegate:(JuTransitionType)type gestureDirection:(JuInteractiveTransitionGestureDirection)direction vcItem:(UIViewController *)viewVc{
    self = [super init];
    if (self) {
        if (type>1) {
//            UINavigationController *vc=(UINavigationController *)viewVc;
//            vc.delegate=self;
        }else{
            viewVc.transitioningDelegate = self;
            viewVc.modalPresentationStyle = UIModalPresentationCustom;
        }
//        _ju_interavtive=[JuInteractiveTransition interactiveTransitionWithTransitionType:type GestureDirection:direction];
//        [_ju_interavtive addPanGestureForViewController:viewVc];
    }
    return self;
}


#pragma mark - UIViewControllerTransitioningDelegate
/*=================================model===================================*/
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [JuModelTransitioning juTransitionType:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //    self.animator.presented = NO;
    return [JuModelTransitioning juTransitionType:NO];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _ju_interavtive.interation?_ju_interavtive:nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return  nil;
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return nil;
}
/*=================================push===================================*/
//导航栏push动画 //返回手势过渡管理对象
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {

    return _ju_interavtive.interation?_ju_interavtive:nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    return [JuNaviTransitioning juTransitionType:operation];
}
@end
