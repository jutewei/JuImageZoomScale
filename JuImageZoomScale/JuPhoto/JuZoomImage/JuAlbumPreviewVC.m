//
//  JuAlbumPreviewVC.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuAlbumPreviewVC.h"
#import "JuImagesCollectView.h"
#import "JuLayoutFrame.h"
#import "JuImageObject.h"
#import "JuPhotoConfig.h"
@interface JuAlbumPreviewVC (){
    JuImagesCollectView *ju_imgCollectView;
    NSInteger currentNum;
    UIButton *ju_rightBarItem;
    NSArray *ju_MArrSelectImg;
    BOOL isHidderStatus;
}
@property (nonatomic,copy) JuEditFinish ju_finishHandle;
//@property BOOL isPreviewBack;///< 相册选择直接预览
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
    [self juSetRightButton];
    ju_imgCollectView.ju_isAlbum=YES;
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    __weak typeof(self) weakSelf = self;
    ju_imgCollectView.ju_completion = ^{
        [weakSelf juTapHideBar];
    };

    [self juSetToolBar];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        ju_imgCollectView.ju_collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.navigationController.navigationBar.translucent = YES;///< 透明
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
//导航栏右边按钮
-(void)juSetRightButton{

    UIButton *btnBack=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [btnBack setImage:JuPhotoImageName(@"photo_un_select") forState:UIControlStateNormal];
    [btnBack setImage:JuPhotoImageName(@"photo_select") forState:UIControlStateSelected];
    [btnBack addTarget:self action:@selector(juRightReturn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    btnBack.selected=YES;
    self.navigationItem.rightBarButtonItem=backItem;
    ju_rightBarItem=btnBack;
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

-(void)juRightReturn:(UIButton *)sender{
    JuImageObject *objcet=ju_MArrSelectImg[currentNum];
    objcet.ju_isNoSelect=!objcet.ju_isNoSelect;
    ju_rightBarItem.selected=!objcet.ju_isNoSelect;
}
-(void)juSetCurrentIndex:(NSInteger)index{
    currentNum=index;
    JuImageObject *objcet=ju_MArrSelectImg[currentNum];
    ju_rightBarItem.selected=!objcet.ju_isNoSelect;
}
- (void)juTouchFinish:(id)sender {
    NSMutableArray *arrSelect=[NSMutableArray array];
    for (JuImageObject *object in ju_MArrSelectImg) {
        if (!object.ju_isNoSelect) {
            [arrSelect addObject:object.ju_asset];
        }
    }
    self.ju_finishHandle(arrSelect);
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"完成");
}

-(BOOL)prefersStatusBarHidden{
    return isHidderStatus;
}
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index finish:(JuEditFinish)finishHaldle{
    self.ju_finishHandle=finishHaldle;
    ju_MArrSelectImg=[JuImageObject juSwithObject:arrList size:CGSizeZero];
    [ju_imgCollectView juSetImages:ju_MArrSelectImg currentIndex:index  rect:CGRectZero];
     __weak typeof(self)     weakSelf = self;
    ju_imgCollectView.ju_handelIndex = ^(NSInteger index) {
        [weakSelf juSetCurrentIndex:index];
    };
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
