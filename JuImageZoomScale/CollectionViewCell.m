//
//  CollectionViewCell.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/11.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIView+JuLayout.h"
#import "UIImageView+ModCache.h"
@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ju_imageView=[[UIImageView alloc]init];
        [ju_imageView setContentMode:UIViewContentModeScaleAspectFill];
        ju_imageView.clipsToBounds=YES;
        [self.contentView addSubview:ju_imageView];
        ju_imageView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return self;
}
-(void)juSetImage:(id)imageData {
    if ([imageData isKindOfClass:[UIImage class]]) {
        ju_imageView.image=imageData;
    }else{
        [ju_imageView setImageWithStr:imageData];
    }
}
@end
