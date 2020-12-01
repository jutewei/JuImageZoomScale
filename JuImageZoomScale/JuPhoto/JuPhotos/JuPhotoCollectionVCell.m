//
//  JuPhotoCollectionVCell.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoCollectionVCell.h"
#import "JuLayoutFrame.h"
#import "JuPhotoOverlayView.h"
@interface JuPhotoCollectionVCell (){
    UIImageView *ju_imageView;
    JuPhotoOverlayView *ju_overlayView;
}

@end

@implementation JuPhotoCollectionVCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        ju_imageView=[[UIImageView alloc]init];
        [self.contentView addSubview:ju_imageView];
        [ju_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [ju_imageView setClipsToBounds:YES];
        ju_imageView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));

        ju_overlayView=[[JuPhotoOverlayView alloc]init];
        [self.contentView addSubview:ju_overlayView];
        ju_overlayView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    }

    return self;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    ju_overlayView.isSelect=selected;
}
-(void)setJu_asset:(PHAsset *)ju_asset{
    _ju_asset=ju_asset;
    
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    // 图片原尺寸
    CGSize targetSize = CGSizeMake(200, 200);
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:ju_asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        ju_imageView.image=result;
    }];
}
@end
