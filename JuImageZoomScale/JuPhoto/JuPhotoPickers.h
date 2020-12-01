//
//  SHGetPhotos.h
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import "SHPhotoAlbumPreViewVC.h"
#import "JuAlbumPreviewVC.h"
#import "JuPhotoGroupViewController.h"
typedef void(^__nullable JuImageHandle)(id __nullable result);             //下步操作后有跟新数据
@protocol SHChoosePhotoDelegate;
//PreviewPhotoDelegate
@interface JuPhotoPickers : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
}

//-(instancetype _Nullable )initWitDelegate:(id<SHChoosePhotoDelegate>_Nullable)delegete;


/** 以下是新方法***/
+ (instancetype _Nullable ) sharedInstance;

@property (nonatomic, weak) UIViewController * _Nullable presentController;
/**
 选择相册

 @param allowsEdit 是否可用编辑图片
 @param handle 图片回调
 */
-(void)juSelectSinglePhoto:(BOOL)allowsEdit finishHandle:(JuImageHandle)handle;

/// 选择照片或者相册
/// @param type 0相册，1拍照
/// @param presentController presentController
/// @param handle 回调
-(void)juSelectWithType:(NSInteger)type presentVC:(UIViewController *)presentController finishHandle:(JuImageHandle)handle;
/**
 相册选

 @param maxNum 最大数量
 @param arrList 已选图片
 @param handle 回调
 */
-(void)juSelectMutlePhotos:(NSInteger)maxNum selectImages:(NSMutableArray * _Nullable )arrList handle:(JuImageHandle)handle;


/**
 是否预览完直接上传图片
 */
@property BOOL isUpLoad;

@end


@protocol SHChoosePhotoDelegate <NSObject>
/**
 *获取照片回调
 */
@optional
-(void)fbFinishImage:(id _Nullable )imageData;

@end
