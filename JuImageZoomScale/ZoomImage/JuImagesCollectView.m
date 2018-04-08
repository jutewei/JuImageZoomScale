//
//  JuImagesCollectView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuImagesCollectView.h"
#import "UIView+JuLayout.h"
#import "JuImagesCollectCell.h"
#import "JuZoomScaleView.h"

@interface JuImagesCollectView()<JuImageZoomScaleDelegate>{
    NSInteger  ju_currentIndex;
    CGFloat ju_itemWidth;
    CGRect ju_originalFrame;
}
@property (nonatomic,readonly)UICollectionView *ju_collectView;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self layoutIfNeeded];
}
// 屏幕转动，改变cell的frame
- (void)changeFrame:(NSNotification *)notification{
//    if (  ju_itemWidth!=JU_Window_Width+20) {
    if (  ju_itemWidth!=JU_Window_Width+20) {
        [_ju_collectView setContentOffset:CGPointMake(ju_currentIndex*(JU_Window_Width+20), 0)];
    }
    ju_itemWidth=JU_Window_Width+20;
    UICollectionViewFlowLayout *layout=(id)_ju_collectView.collectionViewLayout;
    layout.itemSize =CGSizeMake(ju_itemWidth, JU_Window_Height);
    _ju_collectView.collectionViewLayout = layout;
    [_ju_collectView.collectionViewLayout invalidateLayout];
//    }
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
    [cell juSetImage:_ju_ArrList[indexPath.row] originalFrame:ju_originalFrame];
    return cell;
}
-(CGRect)juCurrentRect{
    if (_ju_isAlbum) {
        return CGRectZero;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.ju_collectView.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.ju_completion) {
            self.ju_completion();
        }
    }];
    if (self.ju_handle) {
        return  self.ju_handle(nil);
    }
    return CGRectZero;
}
#pragma mark 拖动时赋值
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollViewX=scrollView.contentOffset.x;
    ju_currentIndex=scrollViewX/CGRectGetWidth(scrollView.frame);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (  ju_itemWidth!=JU_Window_Width+20) {
        [_ju_collectView setContentOffset:CGPointMake(ju_currentIndex*(JU_Window_Width+20), 0)];
    }
    ju_itemWidth=JU_Window_Width+20;
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
