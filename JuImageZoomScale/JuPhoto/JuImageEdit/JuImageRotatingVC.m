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
    if (!ju_imageView) {
//        UIView *view=[[UIView alloc]init];
//        [self.view addSubview:view];
//        view.juSafeEdge(UIEdgeInsetsMake(40, 0, 40, 0));
        ju_imageView=[[UIImageView alloc]init];
        [self.view addSubview:ju_imageView];
    }
//    [ju_imageView juRemoveAllConstraints];
    ju_imageView.juFrame([self setImage:ju_image]);
    ju_imageView.image=ju_image;
}

-(void)juActionView{
    UIView *viewAction=[[UIView alloc]init];
    [self.view addSubview:viewAction];
    viewAction.juSafeFrame(CGRectMake(0, -.01, 0, 40));
    NSArray *arrList=@[@"取消",@"旋转",@"确定"];
    CGFloat itemW=self.juWindowWidth/3;
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

//设置图片展开
- (CGRect) setImage:(UIImage *)image{
    CGRect ju_originRect=CGRectZero;
    if (image){
        ju_imageView.image=image;
        CGSize imgSize = image.size;
        //判断首先缩放的值
        float scaleX = self.juWindowWidth/imgSize.width;
        float scaleY = self.juWindowHeight/imgSize.height;
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            ju_originRect = (CGRect){self.juWindowWidth/2-imgViewWidth/2,0,imgViewWidth,self.juWindowHeight};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            ju_originRect = (CGRect){0,self.juWindowHeight/2-imgViewHeight/2,self.juWindowWidth,imgViewHeight};
        }
    }
    return ju_originRect;
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

-(CGFloat)juWindowWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
-(CGFloat)juWindowHeight{
    return [UIScreen mainScreen].bounds.size.height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
