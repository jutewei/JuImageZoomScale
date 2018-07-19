//
//  JuLargeimageVC.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuLargeImageVC.h"
#import "JuImagesCollectView.h"
#import "UIView+JuLayout.h"
#import "JuAnimated.h"
#import "JuImageObject.h"
@interface JuLargeImageVC ()<UIViewControllerTransitioningDelegate>{
     JuImagesCollectView *ju_imgCollectView;
}
@property (nonatomic,strong) JuAnimated *ju_animator;
@end

@implementation JuLargeImageVC

-(instancetype)init{
    self=[super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;//转场管理者
        ju_imgCollectView=[[JuImagesCollectView alloc]init];
    }
    return self;
}
- (JuAnimated *)ju_animator {
    if (!_ju_animator) {
        _ju_animator = [[JuAnimated alloc] init];
    }
    return _ju_animator;
}

+(instancetype)initRect:(JuHandle)handle{
    JuLargeImageVC *vc=[[JuLargeImageVC alloc]init];
    vc.ju_handle =  handle;
    return vc;
}
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index finishHandle:(JuHandle)handle{
    return [self initRect:frame images:arrList currentIndex:index thumbSize:CGSizeZero finishHandle:handle];
}
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index thumbSize:(CGSize)size finishHandle:(JuHandle)handle{
    JuLargeImageVC *vc=[JuLargeImageVC initRect:handle];
    [vc juSetImages:arrList thumbSize:size currentIndex:index startRect:frame];
    return vc;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    ju_imgCollectView.ju_handle = self.ju_handle;
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    __weak typeof(self) weakSelf = self;
    ju_imgCollectView.ju_completion = ^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
    // Do any additional setup after loading the view.
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
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index startRect:(CGRect)frame{

    [self juSetImages:arrList thumbSize:CGSizeZero currentIndex:index startRect:frame];
}
-(void)juSetImages:(NSArray *)arrList thumbSize:(CGSize)size currentIndex:(NSInteger)index startRect:(CGRect)frame{
    [ju_imgCollectView juSetImages:[JuImageObject juSwithObject:arrList size:size] currentIndex:index rect:frame];
}
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
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
