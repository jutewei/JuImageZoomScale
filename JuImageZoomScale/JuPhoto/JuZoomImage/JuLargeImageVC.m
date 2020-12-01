//
//  JuLargeimageVC.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuLargeImageVC.h"

#import "JuLayoutFrame.h"
#import "JuAnimated.h"
#import "JuImageObject.h"
#import "JuFullWindow.h"
@interface JuLargeImageVC ()<UIViewControllerTransitioningDelegate>{
//     JuImagesCollectView *_ju_imgCollectView;
//    BOOL isLandscape;

}
@property (nonatomic,strong) JuAnimated *ju_animator;
@property (nonatomic,assign) BOOL isHidderStatus;
@end

@implementation JuLargeImageVC

-(instancetype)init{
    self=[super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.transitioningDelegate = self;//转场管理者
        _ju_imgCollectView=[[JuImagesCollectView alloc]init];
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
    JuLargeImageVC *vc=[[self alloc]init];
    vc.ju_handle =  handle;
    return vc;
}
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index finishHandle:(JuHandle)handle{
    return [self initRect:frame images:arrList currentIndex:index thumbSize:CGSizeZero finishHandle:handle];
}
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index thumbSize:(CGSize)size finishHandle:(JuHandle)handle{
    if (arrList.count==0) {
        return nil;
    }
    JuLargeImageVC *vc=[self initRect:handle];
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

    _ju_imgCollectView.ju_handle = self.ju_handle;
    
    [self.view addSubview:_ju_imgCollectView];
    _ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    __weak typeof(self) weakSelf = self;
    _ju_imgCollectView.ju_completion = ^{
//        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        [weakSelf juHide];
    };
    _ju_imgCollectView.ju_scaleHandle = ^(CGFloat scale) {
        [weakSelf juSetBarStatus:scale];
    };
    _ju_imgCollectView.ju_handelIndex = ^(NSInteger current) {
        [weakSelf juGetCurrentIndex:current];
    };
    // Do any additional setup after loading the view.
}
-(void)juShow{
    JuFullWindow *window=[JuFullWindow sharedClient];
    [window juShowWindow:self];
}
-(void)juHide{
    [[JuFullWindow sharedClient] juHideWindow];
}

-(void)juSetBarStatus:(CGFloat)scale{
    BOOL hide=scale==1;
    if (self.isHidderStatus!=hide) {
        self.isHidderStatus=hide;
        [self setNeedsStatusBarAppearanceUpdate];
        if (self.ju_scaleHandle) {
            self.ju_scaleHandle();
        }
    }
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self juSetBarStatus:1];
    });
}
-(void)juSetImages:(NSArray *)arrList thumbSize:(CGSize)size currentIndex:(NSInteger)index startRect:(CGRect)frame{
    [_ju_imgCollectView juSetImages:[JuImageObject juSwithObject:arrList size:size] currentIndex:index rect:frame];
    [self juGetCurrentIndex:index];
}
/**当前显示的是第几张**/
-(void)juGetCurrentIndex:(NSInteger)currentIndex{

}
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [_ju_imgCollectView changeFrame:nil];
}


//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    [self setNeedsStatusBarAppearanceUpdate];
//}


//-(BOOL)prefersStatusBarHidden{
//    UIDeviceOrientation deviceOrientation=[UIDevice currentDevice].orientation;
//    BOOL isLandscape=deviceOrientation==UIDeviceOrientationLandscapeLeft||deviceOrientation==UIDeviceOrientationLandscapeRight;
//    return self.isHidderStatus&&!isLandscape;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
