//
//  JuAlbumPreviewVC.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuAlbumPreviewVC.h"
#import "JuImagesCollectView.h"
#import "UIView+JuLayout.h"
@interface JuAlbumPreviewVC (){
    JuImagesCollectView *ju_imgCollectView;
    BOOL isHidderStatus;
}

@end

@implementation JuAlbumPreviewVC
-(instancetype)init{
    self =[super init];
    if (self) {
         ju_imgCollectView=[[JuImagesCollectView alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ju_imgCollectView.ju_isAlbum=YES;
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    __weak typeof(self) weakSelf = self;
    ju_imgCollectView.ju_completion = ^{
        [weakSelf juTapHideBar];
    };
    if (@available(iOS 11.0, *)) {
        ju_imgCollectView.ju_collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.navigationController.navigationBar.translucent = YES;///< 透明
    [self juSetToolBar];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
#pragma mark 照片代理
-(void)juTapHideBar{
    if (self.navigationController.toolbarHidden==YES) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController setToolbarHidden: NO animated: NO];
    }else{
        [self.navigationController setToolbarHidden: YES animated: NO];
        [self.navigationController setNavigationBarHidden:YES animated:NO];

    }
    isHidderStatus=self.navigationController.toolbarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)juSetToolBar{
    UIButton  *sh_doneItem = [UIButton buttonWithType: UIButtonTypeCustom];
    sh_doneItem.frame = CGRectMake(0, 0, 40, 40);
    sh_doneItem.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [sh_doneItem setTitle:@"完成" forState: UIControlStateNormal];
    [sh_doneItem setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [sh_doneItem addTarget:self action:@selector(juTouchFinish:) forControlEvents:UIControlEventTouchUpInside];
    {
        UIBarButtonItem* previewItem = [[UIBarButtonItem alloc] initWithCustomView: sh_doneItem];
        UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        self.toolbarItems = @[spaceItem, previewItem];
    }
}
- (void)juTouchFinish:(id)sender {
    NSLog(@"完成");
}

-(BOOL)prefersStatusBarHidden{
    return isHidderStatus;
}
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index{
    [ju_imgCollectView juSetImages:arrList currentIndex:index rect:CGRectZero];
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
