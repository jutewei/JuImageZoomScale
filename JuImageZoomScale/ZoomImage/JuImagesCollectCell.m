//
//  JuImagesCollectCell.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagesCollectCell.h"
#import "JuZoomScaleView.h"

@implementation JuImagesCollectCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ju_scaleView=[[JuZoomScaleView alloc]init];
        ju_scaleView.ju_delegate=self;
        [self.contentView addSubview:ju_scaleView];
    }
    return self;
}
-(void)didMoveToWindow{
    [super didMoveToWindow];
    ju_scaleView.frame=self.window.bounds;
}
-(CGRect)juCurrentRect{
    if ([self.ju_delegate respondsToSelector:@selector(juCurrentRect)]) {
        return [self.ju_delegate juCurrentRect];
    }
    return CGRectZero;
}
-(void)juSetImage:(id)imageData originalFrame:(CGRect)frame{
    [ju_scaleView setImage:imageData originalRect:frame];
    ju_scaleView.ju_isAlbum=_ju_isAlbum;
}
@end
