//
//  JuPhotoOverlayView.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoOverlayView.h"
#import "JuLayoutFrame.h"
@interface JuPhotoOverlayView (){
    UIImageView *sh_imageView;
}

@end

@implementation JuPhotoOverlayView
-(instancetype)init{
    self=[super init];
    if (self) {
        [self shSetView];
    }
    return self;
}
-(void)shSetView{
    sh_imageView =[[UIImageView alloc]init];
    [self addSubview:sh_imageView];
    sh_imageView.juFrame(CGRectMake(-8, 8, 24, 24));
    self.isSelect=NO;
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect=isSelect;
    if (isSelect) {
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.4];
        sh_imageView.image=[UIImage imageNamed:@"photo_select"];
    }else{
        sh_imageView.image=[UIImage imageNamed:@"photo_un_select"];
        self.backgroundColor=[UIColor clearColor];
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
