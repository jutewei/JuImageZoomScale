//
//  JuAnimated.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/8.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuAnimated.h"

@implementation JuAnimated
// 指定动画的持续时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.isPresented?0.3:0;

}
// 转场动画的具体内容
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext  viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];

    if (toView) {
        [containerView addSubview:toView];
        toView.frame = toViewFinalFrame;
    }
    if (self.isPresented) {
        toVC.view.alpha=0;
    }
    // Animate using the animator's own duration value.
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         if (self.isPresented) {
                             // Move the presented view into position.
                             toView.alpha=1;
                         }
                         else {
                             // Move the dismissed view offscreen.
                             fromVC.view.alpha=0;
                         }
                     }
                     completion:^(BOOL finished){
                         BOOL success = ![transitionContext transitionWasCancelled];

                         // After a failed presentation or successful dismissal, remove the view.
                         if ((self.isPresented && !success) || (!self.isPresented && success)) {
                             [toView removeFromSuperview];
                         }

                         // Notify UIKit that the transition has finished
                         [transitionContext completeTransition:success];
                     }];


}
@end
