//
//  JuPhotoGroupViewController.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoGroupViewController.h"
#import <Photos/Photos.h>
#import "JuLayoutFrame.h"
#import "JuPhotoGroupCell.h"
#import "JuPhotoCollectionVController.h"
//#import "UIViewController+Hud.h"
@interface JuPhotoGroupViewController ()<JuPhotoDelegate>{
    UITableView *ju_TableView;
    NSArray *ju_ArrList;
}
@end

@implementation JuPhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"相册";
    [self juSetTable];
    [self juGetAlbums];

    // Do any additional setup after loading the view.
}
-(void)juSetTable{
    ju_TableView=[[UITableView alloc]init];
    [self.view addSubview:ju_TableView];
    ju_TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    ju_TableView.juFrame(CGRectMake(0, 0, 0, 0));
    ju_TableView.delegate=self;
    ju_TableView.dataSource=self;
    ju_TableView.rowHeight=70;
    [ju_TableView registerClass:[JuPhotoGroupCell class] forCellReuseIdentifier:@"JuPhotoGroupCell"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(juCancel:)];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    self.navigationItem.leftBarButtonItems=nil;
}
-(void)juCancel:(id)sender{
    [self juPhotosDidCancelController:self];
}
- (void)juPhotosDidCancelController:(UIViewController *)pickerController{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidCancelController:)]) {
        [self.juDelegate juPhotosDidCancelController:self];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIViewController *popVc = nil;
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *vc = self.navigationController.viewControllers[i];
            if ([NSStringFromClass([vc class]) isEqualToString:@"JuPhotoGroupViewController"]) {
                [self.navigationController popToViewController:popVc animated:true];
                return;
            }
            popVc=vc;
        }
    }


}
- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList isPreview:(BOOL)ispreview{
    if ([self.juDelegate respondsToSelector:@selector(juPhotosDidFinishController:didSelectAssets:isPreview:)]) {
        [self.juDelegate juPhotosDidFinishController:self didSelectAssets:arrList isPreview:ispreview];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ju_ArrList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JuPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JuPhotoGroupCell" forIndexPath:indexPath];
    cell.ju_PhotoGroup=ju_ArrList[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JuPhotoCollectionVController *vc=[[JuPhotoCollectionVController alloc]init];
    vc.ju_PhotoGroup=ju_ArrList[indexPath.row];
    vc.juDelegate=self;
    vc.ju_maxNumSelection=_ju_maxNumSelection;
    [self.navigationController pushViewController:vc animated:YES];
}
//获取所有相册
-(void)juGetAlbums{
//    [self showHUD:nil];

    /*if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized||status == PHAuthorizationStatusLimited) {
                NSMutableArray *arrAlbums=[NSMutableArray array];
                PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

                [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
                    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if (assetsFetchResults.count) {
                        [arrAlbums addObject:collection];
                    }
                }];
                //用户创建的相册
                PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if (assetsFetchResults.count) {
                        [arrAlbums addObject:collection];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    ju_ArrList=arrAlbums;
                    [ju_TableView reloadData];
                    [self hideHUD];
                });
            }
        }];
    } else {*/
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSMutableArray *arrAlbums=[NSMutableArray array];
                PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

                [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
                    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if (assetsFetchResults.count) {
                        [arrAlbums addObject:collection];
                    }
                }];
                //用户创建的相册
                PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
                [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                    if (assetsFetchResults.count) {
                        [arrAlbums addObject:collection];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    ju_ArrList=arrAlbums;
                    [ju_TableView reloadData];
//                    [self hideHUD];
                });
            }

        }];
        // Fallback on earlier versions
//    }

}
/***==============未使用=================***/
//是否在iCloud
-(BOOL)isExist:(PHAsset *)asset{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.synchronous = YES;
    __block BOOL isInLocalAblum = YES;
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        isInLocalAblum = imageData ? YES : NO;
    }];
    return isInLocalAblum;
}

#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];

    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];

    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];

    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
//        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        [assets addObject:asset];
    }];

    return assets;
}
/***===============================***/
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
