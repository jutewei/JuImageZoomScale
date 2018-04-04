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
@interface JuLargeImageVC ()<UIViewControllerTransitioningDelegate>{
     JuImagesCollectView *ju_imgCollectView;
}

@end

@implementation JuLargeImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ju_imgCollectView=[[JuImagesCollectView alloc]init];
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    ju_imgCollectView.ju_handle = ^CGRect(id result) {
        return CGRectMake(100, 150, 100, 100);
    };
    [ju_imgCollectView juSetImages:@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] currentIndex:2 rect:CGRectMake(100, 200, 100, 100)];
    // Do any additional setup after loading the view.
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
