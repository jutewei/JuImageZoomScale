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
   
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


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
//    此处需用自定义动画
    JuLargeImageVC *vc=[[JuLargeImageVC alloc]init];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
