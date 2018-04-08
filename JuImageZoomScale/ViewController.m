//
//  ViewController.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "ViewController.h"
#import "JuAlbumPreviewVC.h"
#import "JuLargeImageVC.h"


@interface ViewController (){
   
    __weak IBOutlet UIButton *ju_btnTouch;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerPreviewingView=ju_btnTouch;

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//      viewC.ju_ArrList=@[@"3.jpg",@"1.jpg"];
   
}
- (IBAction)juTouchAlbum:(id)sender {
    
    JuAlbumPreviewVC *vc=[[JuAlbumPreviewVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)juTouchLarge:(id)sender {
    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) {
        return CGRectMake(100, 150, 100, 100);
    }];
    [vc juSetImages:@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] currentIndex:0 startRect:CGRectMake(100, 200, 100, 100)];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)setRegisterPreviewingView:(UIView *)view{

        //给cell注册3DTouch的peek（预览）和pop功能
    [self registerForPreviewingWithDelegate:self sourceView:ju_btnTouch];

}
-(UIViewController *)shPreviewVC:(id <UIViewControllerPreviewing>)previewingContext{
    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) {
        return CGRectMake(100, 150, 100, 100);
    }];
    [vc juSetImages:@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] currentIndex:0 startRect:CGRectMake(100, 200, 100, 100)];

    return vc;
}
//pop（按用点力进入视图）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    UIViewController *showVC=viewControllerToCommit;
    if ([viewControllerToCommit isKindOfClass:[UINavigationController class]]&&viewControllerToCommit.childViewControllers.count) {
        showVC=viewControllerToCommit.childViewControllers.firstObject;
        viewControllerToCommit=nil;
    }
    [self showViewController:showVC sender:self];
}
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    //设定预览的界面
    UIViewController *vc = [self shPreviewVC:previewingContext];
    vc.hidesBottomBarWhenPushed = YES;
    //    webViewVC.preferredContentSize = CGSizeMake(0.0f,0.0f);
//    JuBaseNavigationVC *navc=[JuBaseNavigationVC shBasicNation:vc];
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    //    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,120);
    //    previewingContext.sourceRect = rect;
    //返回预览界面
    return vc;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
