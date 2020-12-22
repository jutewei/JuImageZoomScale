//
//  JuImageRotatingView.m
//  图片旋转
//
//  Created by Juvid on 2020/12/22.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "JuImageRotatingVC.h"
#import "JuLayoutFrame.h"
#import "UIImage+category.h"

@implementation JuImageRotatingVC{
    UIImageView *ju_imageView;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self juActionView];
}

-(void)setJu_image:(UIImage *)ju_image{
//    [ju_imageView juRemoveAllConstraints];
    ju_imageView.juFrame([ju_imageView juSetImage:ju_image]);
    ju_imageView.image=ju_image;
}

-(void)juActionView{
    if (!ju_imageView) {
//        UIView *view=[[UIView alloc]init];
//        [self.view addSubview:view];
//        view.juSafeEdge(UIEdgeInsetsMake(40, 0, 40, 0));
        ju_imageView=[[UIImageView alloc]init];
        [self.view addSubview:ju_imageView];
    }
    UIView *viewAction=[[UIView alloc]init];
    [self.view addSubview:viewAction];
    viewAction.juSafeFrame(CGRectMake(0, -.01, 0, 40));
    NSArray *arrList=@[@"取消",@"旋转",@"确定"];
    CGFloat itemW=ju_imageView.juWindowWidth/3;
    for (int i=0; i<arrList.count; i++) {
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arrList[i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:18];
        [btn addTarget:self action:@selector(juTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewAction addSubview:btn];
        btn.juFrame(CGRectMake(0.01+i*itemW, 0, itemW, 0));
    }
}

-(void)juTouchAction:(UIButton *)sender{
    if (sender.tag==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(sender.tag==1){
        [ju_imageView juRotationView];
    }else{
        [ju_imageView juSaveRotationResult];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
