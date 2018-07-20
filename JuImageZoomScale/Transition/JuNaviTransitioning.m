//
//  JuNaviTransitioning.m
//  JuPresent
//
//  Created by Juvid on 2018/4/20.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuNaviTransitioning.h"

@implementation JuNaviTransitioning

+(JuNaviTransitioning *)juTransitionType:(UINavigationControllerOperation)operation{
    JuNaviTransitioning *trans=[[JuNaviTransitioning alloc]init];
    trans.push  =operation==UINavigationControllerOperationPush;
    return trans;
}
// 指定动画的持续时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.35;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPush) {
        [self juPushAnimation:transitionContext];
    }else{
        [self juPopAnimation:transitionContext];
    }
}
//实现present动画逻辑代码
- (void)juPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
//    UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:tempView];
    [containerView addSubview:toView];

    toView.alpha=0;
    //开始动画吧，使用产生弹簧效果的动画API
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0  options:0 animations:^{
        toView.alpha=1;
    } completion:^(BOOL finished) {

        [transitionContext completeTransition:YES];
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }
    }];
}

//实现dismiss动画逻辑代码
- (void)juPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //注意在dismiss的时候fromVC就是vc2了，toVC才是VC1了，注意这个关系
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    //参照push动画的逻辑，push成功后，containerView的最后一个子视图就是截图视图，我们将其取出准备动画
    UIView *tempView = containerView.subviews.lastObject;
     [containerView insertSubview:toVC.view belowSubview:tempView];
    //动画吧
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
//          [tempView addSubview:toVC.view];
        if ([transitionContext transitionWasCancelled]) {

            [transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
