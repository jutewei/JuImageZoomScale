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
@interface JuLargeImageVC ()<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>{
     JuImagesCollectView *ju_imgCollectView;
}

@end

@implementation JuLargeImageVC

-(instancetype)init{
    self=[super init];
    if (self) {
        ju_imgCollectView=[[JuImagesCollectView alloc]init];
    }
    return self;
}
+(instancetype)initView:(UIView *)view{
    return [self initView:view endRect:nil];
}
+(instancetype)initView:(UIView *)view endRect:(JuHandle)handle{
    JuLargeImageVC *vc=[[JuLargeImageVC alloc]init];
    vc.ju_handle =  handle;
//    [view addSubview:vc.view];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ju_imgCollectView.ju_handle = self.ju_handle;
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    __weak typeof(self) weakSelf = self;
    ju_imgCollectView.ju_completion = ^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
    // Do any additional setup after loading the view.
}
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index startRect:(CGRect)frame{
    [ju_imgCollectView juSetImages:arrList currentIndex:index rect:frame];
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
