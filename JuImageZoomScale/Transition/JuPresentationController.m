//
//  JuPresentationController.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/8.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuPresentationController.h"

@interface JuPresentationController ()

@property (nonatomic,strong) UIVisualEffectView *visualView;
@end


@implementation JuPresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if ((self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController])) {

    }
    return self;
}

//点击透明部分视图消失时间
-(void)hidssViewTouch{
    if (self.hidssView) {
        self.hidssView();
    }
}
//页面进入的时候调用
- (void)presentationTransitionWillBegin
{

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _visualView.frame = self.containerView.bounds;
    _visualView.backgroundColor = [UIColor blackColor];
    [self.containerView addSubview:_visualView];
    UITapGestureRecognizer *hidssTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidssViewTouch)];
    [_visualView addGestureRecognizer:hidssTouch];


    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        _visualView.alpha = 0.4;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    }];
}

//页面消失的时候调用
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed) {
//        [_dimmingView removeFromSuperview];
         [_visualView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin{
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _visualView.alpha = 0.0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {

         [_visualView removeFromSuperview];
    }
}
//改变页面的frame
- (CGRect)frameOfPresentedViewInContainerView{

    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;

    self.presentedView.frame = CGRectMake(0, windowH - 300, windowW, 300);

    return self.presentedView.frame;
}

- (UIView *)presentedView{
    UIView *pretedView = self.presentedViewController.view;
    pretedView.layer.cornerRadius = 8.0f;
    return pretedView;
}

//延迟加载
/*- (JuModelTransitioning *)animator {
    if (!_animator) {
        _animator = [[JuModelTransitioning alloc] init];
    }
    return _animator;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.animator.presented = YES;
    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.animator.presented = NO;
    return self.animator;
}
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return nil;
}

//导航控制器实现如下2个代理方法
//返回转场动画过渡管理对象
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    self.animator.presented = YES;
    return self.animator;
}
//返回手势过渡管理对象
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    self.animator.presented = NO;
    return self.animator;
}


//标签控制器也有相应的两个方法
- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController {
    return nil;

}
//返回手势过渡管理对象
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC  {
    return nil;

}*/




@end
