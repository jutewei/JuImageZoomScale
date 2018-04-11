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
    [vc juSetImages:@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] currentIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)juTouchLarge:(id)sender {
    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) {
        return CGRectMake(100, 150, 180, 150);
    }];
//     JuNavigationController *NavVC=[[JuNavigationController alloc]initWithRootViewController:vc];
    [vc juSetImages:@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] currentIndex:0 startRect:CGRectMake(100, 200, 100, 100)];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)setRegisterPreviewingView:(UIView *)view{
        //给cell注册3DTouch的peek（预览）和pop功能
    [self registerForPreviewingWithDelegate:self sourceView:ju_btnTouch];

}
-(UIViewController *)shPreviewVC:(id <UIViewControllerPreviewing>)previewingContext{

    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) {
        return CGRectMake(100, 150, 180, 150);
    }];
    [vc juSetImages:@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] currentIndex:0 startRect:CGRectMake(100, 200, 100, 100)];

    return vc;
}
//pop（按用点力进入视图）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
//    [self showViewController:viewControllerToCommit sender:self];
}
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    return [self shPreviewVC:previewingContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
