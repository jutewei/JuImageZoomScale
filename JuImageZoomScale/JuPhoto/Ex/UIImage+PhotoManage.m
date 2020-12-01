//
//  NSObject+PhotoManage.m
//  MTSkinPublic
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "UIImage+PhotoManage.h"
//#import "UIImage+mbCropping.h"
#import "RHAssetsLibrary.h"
//#import "JuAlertView.h"
static NSString * const JuCollectionName = @"有颜";
@implementation NSObject (PhotoManage)
-(void)juGetThumbnail:(void(^)(UIImage *image))imageHandle{
    if ([self isKindOfClass:[ALAsset class]]) {
        ALAsset *asset=(ALAsset *)self;
        imageHandle([UIImage imageWithCGImage:asset.thumbnail]);
    }else if([self isKindOfClass:[PHAsset class]]){
        // 请求图片
        [self shImageRequestSize:CGSizeMake(80, 80) handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
//    return nil;
}
//**略缩图*/
-(void)juGetRatioThumbnail:(void(^)(UIImage *image))imageHandle{
    if ([self isKindOfClass:[ALAsset class]]) {
        ALAsset *asset=(ALAsset *)self;
        imageHandle([UIImage imageWithCGImage:asset.aspectRatioThumbnail]);
    }else if([self isKindOfClass:[PHAsset class]]){
        [self shImageRequestSize:CGSizeMake(150, 150) handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
}
//**原图上传使用*/
-(void)juGetfullScreenImage:(void(^)(UIImage *image))imageHandle{
    if ([self isKindOfClass:[ALAsset class]]) {
        ALAsset *asset=(ALAsset *)self;
        imageHandle ([UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]);
    }else if([self isKindOfClass:[PHAsset class]]){
        PHAsset *asset=(PHAsset *)self;
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        CGFloat maxPix=size.height*size.width;
        [self shImageRequestSize:size handle:imageHandle];
    }else if([self isKindOfClass:[UIImage class]]){
        imageHandle((UIImage *)self);
    }
}
/**
 获取图片

 @param targetSize 图片尺寸
 @param imageHandle 返回图片
 */
-(void)shImageRequestSize:(CGSize)targetSize handle:(void(^)(UIImage *image))imageHandle {
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;///< 同步
    imageOptions.networkAccessAllowed = YES;
    imageOptions.resizeMode=PHImageRequestOptionsResizeModeFast;///< 精准尺寸
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)self targetSize:targetSize contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageHandle(result);
        });
    }];
}
@end

@implementation UIImage (imageSave)

-(void)juSaveAssetPhoto:(void(^)(ALAsset *asset))imageHandle{

    ALAssetsLibrary *assetsLibrary = [RHAssetsLibrary rh_getShareAssetsLibrary];
    [assetsLibrary writeImageToSavedPhotosAlbum:[self CGImage] orientation:(ALAssetOrientation)self.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
//                [JuAlertView shAlertTitle:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
                //            NSLog(@"无法使用iPhone相册");
            }else{
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    imageHandle(asset);
                } failureBlock:^(NSError *error) {
//                    [JuAlertView shAlertTitle:@"" message:@"照片选取失败，请重试！"];
                    //                NSLog(@"照片选取失败，请重试！");
                }];
            }
        });
    }];
}



-(void)juSaveRHAssetPhoto:(void(^)(PHAsset * Asset))imageHandle{

    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            if (status==PHAuthorizationStatusDenied||status==PHAuthorizationStatusRestricted) {
                [self shShowArlert:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            }
//             imageHandle(nil);
            return;
        }
//        [MBProgressHUD juShowWindowHUD:1989];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        // 保存相片到相机胶卷
        __block PHObjectPlaceholder *createdAsset = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset;
        } error:&error];
        
//        [MBProgressHUD juShowHideHUD:1989];
        
        if (error) {
//            [self shShowArlert:@"" message:@"照片选取失败，请重试！"];
//             imageHandle(nil);
            return;
        }
        // 拿到自定义的相册对象
        PHAssetCollection *collection = [self collection];
        if (collection == nil||createdAsset==nil) {
//            [self shShowArlert:@"照片读取失败" message:@"您可尝试选择相册中的图片"];
//             imageHandle(nil);
            return;
        }
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHFetchResult *fetchCollectionResult=[PHAsset fetchAssetsWithLocalIdentifiers:@[createdAsset.localIdentifier] options:nil];
            [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageHandle(fetchCollectionResult.lastObject);
            });
        } error:&error];
        
        if (error) {
//            [self shShowArlert:@"" message:@"照片选取失败，请重试！"];
//             imageHandle(nil);
        } else {
            NSLog(@"保存成功");
        }
        //        });
    }];
}
-(void)shShowArlert:(NSString *)title message:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
//         [JuAlertView shAlertTitle:title message:message];
     });
}
-(PHAssetCollection *)collection
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:JuCollectionName]) {
            return collection;
        }
    }

    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:JuCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (error) {
        NSLog(@"获取相册【%@】失败", JuCollectionName);
        return nil;
    }

    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}
@end

