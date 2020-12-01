//
//  JuPhotoCollectionVController.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoCollectionVController.h"
#import "JuLayoutFrame.h"
#import "JuPhotoCollectionVCell.h"
#import "JuPhotoCollectionFoot.h"
@interface JuPhotoCollectionVController (){
    UICollectionView *ju_CollectionView;
    PHFetchResult *ju_fetchResult;
    NSMutableArray *ju_MArrSelects;
    UIButton *ju_previewItem;
    UIButton *ju_doneItem;
    NSInteger isDidLoad;
}

@end

@implementation JuPhotoCollectionVController

- (void)viewDidLoad {
    [super viewDidLoad];
    ju_MArrSelects=[NSMutableArray array];
    [self juSetCollect];
    [self juSetTabbarItem];
    // Do any additional setup after loading the view.
}
-(void )juSetCollect{
    CGFloat screen_Width =  [[UIScreen mainScreen] bounds].size.width;    //屏幕宽
    CGFloat itemW=(screen_Width-8)/4;
    ju_fetchResult = [PHAsset fetchAssetsInAssetCollection:_ju_PhotoGroup options:nil];
    self.title=_ju_PhotoGroup.localizedTitle;
    UICollectionViewFlowLayout* ju_layout = [UICollectionViewFlowLayout new];
    ju_layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    ju_layout.itemSize =CGSizeMake(itemW, itemW);;
    ju_layout.sectionInset=UIEdgeInsetsMake(1, 1, 1, 1);
    ju_layout.footerReferenceSize=CGSizeMake(screen_Width, 46);
    ju_layout.minimumLineSpacing=2;//   行间距
    ju_layout.minimumInteritemSpacing=2;//    内部cell间距
    ju_CollectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:ju_layout];
    ju_CollectionView.backgroundColor=[UIColor whiteColor];
    ju_CollectionView.allowsMultipleSelection = YES;
    ju_CollectionView.alwaysBounceVertical=YES;
    ju_CollectionView.delegate=self;
    ju_CollectionView.dataSource=self;
    [ju_CollectionView registerClass:[JuPhotoCollectionVCell class]  forCellWithReuseIdentifier:@"JuPhotoCollectionVCell"];
    [ju_CollectionView registerClass:[JuPhotoCollectionFoot class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"JuPhotoCollectionFoot"];
    [self.view addSubview:ju_CollectionView];
    ju_CollectionView.juFrame(CGRectMake(0, 0, 0, 0));
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(juCancel:)];
    [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
}
-(void)shScrollEnd{
    if (isDidLoad<2) {
        CGFloat topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (ju_CollectionView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
        CGFloat offsizeY=ju_CollectionView.collectionViewLayout.collectionViewContentSize.height - ju_CollectionView.frame.size.height + topInset;
        if(offsizeY>0)
            [ju_CollectionView setContentOffset:CGPointMake(0, offsizeY) animated:NO];

    }
    isDidLoad++;
}
-(void)juCancel:(id)sender{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidCancelController:)]) {
        [self.juDelegate juPhotosDidCancelController:self];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self shScrollEnd];
    [self performSelector:@selector(shScrollEnd) withObject:nil afterDelay:0.1];
    [self.navigationController setToolbarHidden:NO animated: YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden: YES animated: YES];
}
-(void)juSetTabbarItem{
    [self.navigationController setToolbarHidden: NO animated: YES];
    if (!ju_previewItem) {
        ju_previewItem = [UIButton buttonWithType: UIButtonTypeCustom];
        ju_previewItem.frame = CGRectMake(0, 0, 40, 40);
        ju_previewItem.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [ju_previewItem setTitle: @"预览" forState: UIControlStateNormal];
        [ju_previewItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [ju_previewItem setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [ju_previewItem addTarget:self action:@selector(juPreview:) forControlEvents:UIControlEventTouchUpInside];

        ju_doneItem = [UIButton buttonWithType: UIButtonTypeCustom];
        ju_doneItem.frame = CGRectMake(0, 0, 100, 40);
        ju_doneItem.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [ju_doneItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

        [ju_doneItem setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];

        [ju_doneItem addTarget:self action:@selector(juFinish:) forControlEvents:UIControlEventTouchUpInside];
        {
            UIBarButtonItem* previewItem = [[UIBarButtonItem alloc] initWithCustomView: ju_previewItem];
            UIBarButtonItem* sendItem = [[UIBarButtonItem alloc] initWithCustomView: ju_doneItem];
            UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
            self.toolbarItems = @[previewItem,spaceItem, sendItem];
        }

    }
    [self juSetButtonTitel];
}
-(void)juSetButtonTitel{
    if (_ju_maxNumSelection>50) {
            [ju_doneItem setTitle:@"完成" forState: UIControlStateNormal];
    }else{
        [ju_doneItem setTitle:[NSString stringWithFormat:@"(%zi/%ld) 完成",ju_MArrSelects.count,_ju_maxNumSelection] forState: UIControlStateNormal];
    }
    ju_doneItem.enabled=ju_MArrSelects.count;
    ju_previewItem.enabled=ju_MArrSelects.count;
    if (ju_doneItem.enabled) {
        ju_doneItem.alpha=1;
        ju_previewItem.alpha=1;
    }else{
        ju_doneItem.alpha=0.5;
        ju_previewItem.alpha=0.5;
    }
}
-(void)juFinish:(UIButton *)sender{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidFinishController:didSelectAssets:isPreview:)]) {
        [self.juDelegate juPhotosDidFinishController:self didSelectAssets:ju_MArrSelects isPreview:NO];
    }
 }
-(void)juPreview:(UIButton *)sender{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidFinishController:didSelectAssets:isPreview:)]) {
        [self.juDelegate juPhotosDidFinishController:self didSelectAssets:ju_MArrSelects isPreview:YES];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ju_fetchResult.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JuPhotoCollectionVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JuPhotoCollectionVCell" forIndexPath:indexPath];
    cell.ju_asset=ju_fetchResult[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        JuPhotoCollectionFoot *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JuPhotoCollectionFoot" forIndexPath:indexPath];
        footerView.ju_strText=[NSString stringWithFormat:@"共 %ld 张照片",ju_fetchResult.count];
        return footerView;
    }

    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [ju_MArrSelects addObject:ju_fetchResult[indexPath.row]];
    [self juSetButtonTitel];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return ju_MArrSelects.count<_ju_maxNumSelection;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [ju_MArrSelects removeObject:ju_fetchResult[indexPath.row]];
    [self juSetButtonTitel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
