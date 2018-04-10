//
//  JuNavigationController.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/9.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuNavigationController.h"
#import "JuAnimated.h"
@interface JuNavigationController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) JuAnimated *ju_animator;
@end

@implementation JuNavigationController
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self=[super initWithRootViewController:rootViewController];
    if (self) {
       
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;//转场管理者
    }
    return self;
}
- (JuAnimated *)ju_animator {
    if (!_ju_animator) {
        _ju_animator = [[JuAnimated alloc] init];
    }
    return _ju_animator;
}
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.ju_animator.presented = YES;
    return self.ju_animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.ju_animator.presented = NO;
    return self.ju_animator;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(BOOL)prefersStatusBarHidden{
    return self.topViewController.prefersStatusBarHidden;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
