//
//  JuImagesCollectView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagesCollectView.h"
#import "JuLayoutFrame.h"
#import "JuImagesCollectCell.h"
#import "JuZoomScaleView.h"
#import "JuImageObject.h"
@interface JuImagesCollectView()<JuImagesCollectCellDelegate>{
    NSInteger  ju_currentIndex;
    CGFloat ju_itemWidth;
    CGRect ju_originalFrame;
    NSInteger ju_startIndex;
    BOOL isHidderCell;
}

@end

@implementation JuImagesCollectView
-(instancetype)init{
    self =[super init];
    if (self) {
        [self juSetCollectView];
    }
    return self;
}

-(void)juSetCollectView{
    UICollectionView *collectView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.juSetCollectLayout];
    collectView.dataSource = self;
    collectView.delegate=self;
    collectView.showsHorizontalScrollIndicator=NO;
    collectView.showsVerticalScrollIndicator=NO;
    collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    collectView.pagingEnabled=YES;
    [collectView registerClass:[JuImagesCollectCell class] forCellWithReuseIdentifier:@"JuImagesCollectCell"];
    [self addSubview:collectView];
    collectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    collectView.ju_Trail.constant=-20;
    _ju_collectView=collectView;
    [self layoutIfNeeded];
}
// 屏幕转动，改变cell的frame
- (void)changeFrame:(id )sender{
    NSMutableArray *arrCell=[NSMutableArray array];
    for (NSIndexPath *indexPath in self.ju_collectView.indexPathsForVisibleItems) {
        JuImagesCollectCell *cell=(id)[_ju_collectView cellForItemAtIndexPath:indexPath];
        [cell juSetContentHidden:indexPath.row!=ju_currentIndex];
        [arrCell addObject:cell];
    }
//
    if (!([[[UIDevice currentDevice]systemVersion] floatValue]>=11)||[[[UIDevice currentDevice]systemVersion] floatValue]>13) {
        [_ju_collectView.collectionViewLayout invalidateLayout];
    }
//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (JuImagesCollectCell *cell in arrCell) {
            [cell juSetContentHidden:NO];
        }
    });

}
-(UICollectionViewFlowLayout *)juSetCollectLayout{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    return layout;
}
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index rect:(CGRect)frame{
    ju_currentIndex=index;
    ju_startIndex=index;
    ju_originalFrame=frame;
    self.ju_ArrList=arrList;
}
-(void)setJu_ArrList:(NSArray *)ju_ArrList{
    _ju_ArrList=ju_ArrList;
    [_ju_collectView reloadData];
    [_ju_collectView setContentOffset:CGPointMake(ju_currentIndex*(JU_Window_Width+20), 0)];
    [UIView animateWithDuration:0.3 animations:^{
        self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ju_ArrList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JuImagesCollectCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"JuImagesCollectCell" forIndexPath:indexPath];
    cell.ju_delegate=self;
    cell.ju_isAlbum=_ju_isAlbum;
    CGRect frame=CGRectZero;
    if (ju_startIndex==indexPath.row) {
        frame=ju_originalFrame;
        ju_originalFrame=CGRectZero;
    }
    [cell juSetImage:_ju_ArrList[indexPath.row] originalFrame:frame];
//    [cell juSetContentHidden:ju_currentIndex!=indexPath.row];
    return cell;
}
-(CGRect)juCurrentCellRect{
    if (self.ju_handle) {
        return  self.ju_handle(@(ju_currentIndex));
    }
    return CGRectZero;
}
-(void)juTapCellHidder{
    if (_ju_isAlbum) {
        if (self.ju_completion) {
            self.ju_completion();
        }
        return;
    }
    self.ju_scaleHandle(0);
    [self juHideOtherView:YES];

    [UIView animateWithDuration:0.35 animations:^{
        self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        if (self.ju_completion) {
            self.ju_completion();
        }
    }];
}
-(void)juHideOtherView:(BOOL)isHidder{
    for (UIView *view in self.superview.subviews) {
        if (![view isEqual:self]) {
            view.hidden=isHidder;
        }
    }
}
-(void)juChangeCellSacle:(CGFloat)scale{

    BOOL enable=scale==1;
    [self juHideOtherView:!enable];
    
    if (scale==1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
        }completion:^(BOOL finished) {
//            [self juSetHidder:hidder];
        }];
    }else{
        self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:scale];
    }
    if (!enable) {
        [self.ju_collectView setContentOffset:CGPointMake(ju_currentIndex*(JU_Window_Width+20), 0)];
    }
    self.ju_collectView.scrollEnabled=enable;

    if (self.ju_scaleHandle) {
        self.ju_scaleHandle(scale);
    }
}

#pragma mark 拖动时赋值
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollViewX=scrollView.contentOffset.x+JU_Window_Width/3;
    ju_currentIndex=scrollViewX/CGRectGetWidth(scrollView.frame);
    if (self.ju_handelIndex) {
        self.ju_handelIndex(ju_currentIndex);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

//    if (  ju_itemWidth!=JU_Window_Width+20) {
    ju_itemWidth=JU_Window_Width+20;
     [_ju_collectView setContentOffset:CGPointMake(ju_currentIndex*ju_itemWidth, 0)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_ju_collectView setContentOffset:CGPointMake(ju_currentIndex*ju_itemWidth, 0)];
        });
//    }
//      [self.superview layoutIfNeeded];

    return CGSizeMake(ju_itemWidth, JU_Window_Height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
