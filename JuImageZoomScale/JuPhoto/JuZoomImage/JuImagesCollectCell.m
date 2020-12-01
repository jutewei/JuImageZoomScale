//
//  JuImagesCollectCell.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagesCollectCell.h"
#import "JuZoomScaleView.h"
#import "JuLayoutFrame.h"
@implementation JuImagesCollectCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ju_scaleView=[[JuZoomScaleView alloc]init];
        ju_scaleView.ju_delegate=self;
        [self.contentView addSubview:ju_scaleView];
        ju_scaleView.juEdge(UIEdgeInsetsMake(0, 0, 0, 20));
        [self.contentView layoutIfNeeded];
    }
    return self;
}

-(CGRect)juCurrentRect{
    if ([self.ju_delegate respondsToSelector:@selector(juCurrentCellRect)]) {
        return [self.ju_delegate juCurrentCellRect];
    }
    return CGRectZero;
}
-(void)juTapHidder{
    if ([self.ju_delegate respondsToSelector:@selector(juTapCellHidder)]) {
        return [self.ju_delegate juTapCellHidder];
    }
}
-(void)juChangeSacle:(CGFloat)scale{
    if ([self.ju_delegate respondsToSelector:@selector(juChangeCellSacle:)]) {
        return [self.ju_delegate juChangeCellSacle:scale];
    }
}

-(void)juSetContentHidden:(BOOL)isHidden{
    ju_scaleView.hidden=isHidden;
}
-(void)juSetImage:(id)imageData originalFrame:(CGRect)frame{
    ju_scaleView.hidden=NO;
    [ju_scaleView setItemImage:imageData originalRect:frame];
    ju_scaleView.ju_isAlbum=_ju_isAlbum;
}
@end
