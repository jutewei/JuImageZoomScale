//
//  SHGetPhotos.m
//  SHBaseProject
//
//  Created by Juvid on 15/11/4.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoPickers.h"
#import "RHAssetsLibrary.h"
#import "UIImage+mbCropping.h"
//#import "JuAlertView+actiont.h"
//#import "SHUserShare.h"
#import "UIImage+PhotoManage.h"
//#import <AssetsLibrary/AssetsLibrary.h>

@interface JuPhotoPickers ()<JuPhotoDelegate,UINavigationControllerDelegate>{
    NSMutableArray *sh_MArrAsset;
}

@property(nonatomic,copy)JuImageHandle ju_imageHandle;
@property (weak,nonatomic) id<SHChoosePhotoDelegate> _Nullable shDelegate;

@property (nonatomic, assign) BOOL allowsMultipleSelection;//允许多选
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;//最多张数
@property (nonatomic,strong) NSMutableArray* _Nullable ju_Assets;
@property BOOL allowsEditing;//允许编辑
@property BOOL fastSelect; //不弹框选择
@end

@implementation JuPhotoPickers

+ (instancetype) sharedInstance{

    static JuPhotoPickers *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self=[super init];
    if (self) {
        _maximumNumberOfSelection=8;
        sh_MArrAsset=[NSMutableArray array];
    }
    return self;
}

-(instancetype)initWitDelegate:(id<SHChoosePhotoDelegate>)delegete{
    self=[self init];
    self.shDelegate=delegete;
    return self;
}

-(void)juSelectSinglePhoto:(BOOL)allowsEdit finishHandle:(JuImageHandle)handle{
    [self juSelectMutlePhotos:0 selectImages:nil handle:handle];
    self.allowsEditing=allowsEdit;
}
-(void)juSelectMutlePhotos:(NSInteger)maxNum selectImages:(NSMutableArray *)arrList handle:(JuImageHandle)handle{
    _ju_imageHandle=handle;
    self.allowsEditing=NO;
    self.isUpLoad=NO;
    self.maximumNumberOfSelection=maxNum;
//    self.presentController=Ju_Share.topViewcontrol;
    self.ju_Assets=arrList;
    if (!self.fastSelect) {
        [self shSelectPhoto];
    }
}

-(void)juSelectWithType:(NSInteger)type presentVC:(UIViewController *)presentController finishHandle:(JuImageHandle)handle{
    self.fastSelect=YES;
    [self juSelectMutlePhotos:0 selectImages:nil handle:handle];
    self.presentController=presentController;
    if (type==0) {
        [self shSelectAction:@"从手机相册选择"];
    }else{
        [self shSelectAction:@"拍照"];
    }
}

-(void)shSelectPhoto{
    if (_allowsMultipleSelection) {
        if (_maximumNumberOfSelection>0&&[self shImageCount]>=_maximumNumberOfSelection) {
            [self juAlertControllerTitle:nil message:[NSString stringWithFormat:@"最多选择%lu张照片,请先删除部分照片再重新选择！",(unsigned long)_maximumNumberOfSelection] actionItems:@[@"确定"] preferredStyle:UIAlertControllerStyleAlert handler:^(UIAlertAction *action) {
            }];
            return;
        }
    }
    [self juAlertControllerTitle:nil message:nil actionItems:@[@"取消",@"拍照",@"从手机相册选择"] preferredStyle:UIAlertControllerStyleActionSheet handler:^(UIAlertAction *action) {
        [self shSelectAction:action.title];
    }];

}

-(void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection{
    _maximumNumberOfSelection=maximumNumberOfSelection;
    self.allowsMultipleSelection=maximumNumberOfSelection>0;
}
-(void)setJu_Assets:(NSMutableArray *)leAssets{
    [sh_MArrAsset removeAllObjects];
    if (leAssets) {
        _ju_Assets=leAssets;
    }else{
        _ju_Assets =[NSMutableArray array];
    }
}

#pragma mark 选择照片方式
-(void)shSelectAction:(NSString *)buttonTitle{
    if ([buttonTitle isEqual:@"从手机相册选择"]) {
        if ([self isPhotoLibraryAvailable]&&[self canUserPickPhotosFromPhotoLibrary]){
            if (_allowsMultipleSelection) {
                JuPhotoGroupViewController *vc=[[JuPhotoGroupViewController alloc]init];
                vc.ju_maxNumSelection=_maximumNumberOfSelection-[self shImageCount];
                vc.juDelegate=self;
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                nav.modalPresentationStyle=UIModalPresentationFullScreen;
                if (self.presentController) {
                     [self juPresentViewController:nav supV:self.presentController];
                }else if(self.shDelegate){
                    UIViewController *pareVc=(UIViewController *)self.shDelegate;

                     [self juPresentViewController:nav supV:pareVc];
                }
            }
            else {
                UIImagePickerController *controller=[self juSetImagePick:UIImagePickerControllerSourceTypePhotoLibrary];
                 controller.modalPresentationStyle=UIModalPresentationFullScreen;
                if (self.presentController) {
                    [self juPresentViewController:controller supV:self.presentController];
                }
                else if(self.shDelegate){
                      [self juPresentViewController:controller supV:(UIViewController *)self.shDelegate];
                }
            }
        }
    }
    else if([buttonTitle isEqual:@"拍照"]){
        if ([self isCameraAvailable] &&[self doesCameraSupportTakingPhotos]){
            UIImagePickerController *controller=[self juSetImagePick:UIImagePickerControllerSourceTypeCamera];
            if (self.presentController) {
                [self juPresentViewController:controller supV:self.presentController];
            } else if(self.shDelegate){
                 [self juPresentViewController:controller supV:(UIViewController *)self.shDelegate];
            }
        }
    }
}
-(void)juPresentViewController:(UIViewController *)vc supV:(UIViewController *)supVc{
    dispatch_async(dispatch_get_main_queue(), ^{
           [supVc presentViewController:vc animated:YES completion:nil];
       });
}
-(UIImagePickerController *)juSetImagePick:(UIImagePickerControllerSourceType )sourceType{
    UIImagePickerController *controller =[[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = sourceType;
    controller.mediaTypes = [[NSArray alloc]
                             initWithObjects:( NSString *)kUTTypeImage, nil];
//    if (sourceType==UIImagePickerControllerSourceTypeCamera) {
//        controller.videoQuality = UIImagePickerControllerQualityTypeMedium;
//    }
    controller.allowsEditing = _allowsEditing;
    return controller;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString    *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        UIImage *theImage=nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {//拍照存图片
            if (_allowsMultipleSelection) {
                [self shSaveAssetPhoto:theImage];//允许多选写路径
                return;
            }
            else {//直接存
//                [NSThread detachNewThreadSelector:@selector(UseImage:) toTarget:self withObject:theImage];
                theImage=[theImage juSetHeadTailoring];
                UIImageWriteToSavedPhotosAlbum(theImage, self,NULL, NULL);
                
            }
        }
       [self fbFinishImage:theImage];
    }
}
#pragma mark 获取Asset图片
-(void)shSaveAssetPhoto:(UIImage *)images{

    UIImage *croppImage=[images juSetHeadTailoring];
    [self shFinishSelectImage:@[croppImage]];
    
    [images juSaveRHAssetPhoto:^(PHAsset *Asset) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (Asset) {
//                [self shFinishSelectImage:@[Asset]];
            }
        });
    }];
}
#pragma mark PreviewDelegate 完成预览
-(void)shFinishSelectImage:(id)arrImg{
    NSMutableArray *arrResult=[NSMutableArray array];
    [arrResult addObjectsFromArray:_ju_Assets];
    [arrResult addObjectsFromArray:arrImg];
    [self fbFinishImage:arrResult];
}

-(void)fbFinishImage:(id)images{
    if([self.shDelegate respondsToSelector:@selector(fbFinishImage:)]){
        [self.shDelegate fbFinishImage:images];
        return;
    }

    if (self.ju_imageHandle) {
        self.ju_imageHandle(images);
        self.ju_imageHandle = nil;
    }
}
-(NSInteger)shImageCount{
    return sh_MArrAsset.count+_ju_Assets.count;
}
#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark JuPhotoDelegate delegate
- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList isPreview:(BOOL)ispreview{
    if(!ispreview){
        [self shFinishSelectImage:arrList];
        [pickerController dismissViewControllerAnimated:YES completion:nil];
    }else {
        __weak typeof(self)     weakSelf = self;
        JuAlbumPreviewVC *vc=[[JuAlbumPreviewVC alloc]init];
        [vc juSetImages:arrList currentIndex:0 finish:^(NSArray *arrList) {
            [weakSelf shFinishSelectImage:arrList];
        }];
//        SHPhotoAlbumPreViewVC *vc=[[SHPhotoAlbumPreViewVC alloc]init];
//        vc.isUnLoad=self.isUpLoad;
//        vc.sh_ImageItems=[arrList mutableCopy];
//        vc.isPreviewCurrent=YES;
//        vc.delegate=self;
        [pickerController.navigationController pushViewController:vc animated:YES];
    }
}
- (void)juPhotosDidCancelController:(UIViewController *)pickerController{

}

//拍照
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypeCamera];
}
//照片库
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

//判断是否支持多媒体
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType
                  sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
//        [JuAlertView shAlertTitle:@"警告" message:@"没有可用媒体" ];
        return NO;
    }
    if (paramSourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus ==ALAuthorizationStatusDenied || authStatus==ALAuthorizationStatusRestricted) {
//            [JuAlertView shAlertTitle:@"无法使用iPhone相册" message:@"请在iPhone的“设置-隐私-照片”中允许访问相册"];
            return NO;
        }
    }
    else{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted){
//            [JuAlertView shAlertTitle:@"无法使用iPhone相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机"];
            return NO;
        }
    }
    //判断iOS7的宏，没有就自己写个，下边的方法是iOS7新加的，7以下调用会报错
    
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType]){
             result = YES;
             *stop= YES;
         }
     }];
    return result;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")])
    {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
             if (obj.frame.size.width < 42)
             {
                 [viewController.view sendSubviewToBack:obj];
                 *stop = YES;
             }
         }];
    }
}


-(UIAlertController *)juAlertControllerTitle:(NSString *)title
                                     message:(NSString *)message
                                 actionItems:(NSArray *)items
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                     handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *alertControll=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    NSInteger allCount=items.count;
    for (int i=0; i<allCount; i++) {
        //        NSInteger cancleNum=allCount-2;///< 多个按钮第一个为取消
        NSString *itemTitle=items[i];
        UIAlertAction *alertCancle=[UIAlertAction actionWithTitle:itemTitle style:[itemTitle isEqual:@"取消"]?UIAlertActionStyleCancel:([itemTitle isEqual:@"删除"]?UIAlertActionStyleDestructive:UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (handler)handler(action);
        }];
        [alertControll addAction:alertCancle];
    }
    UIPopoverPresentationController *popover=alertControll.popoverPresentationController;
    if (popover) {
        popover.sourceView=self.presentController.view;
//        popover.sourceRect=CGRectMake(Screen_Width/2-100,Screen_Height/2-100, 200, 200);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.presentController presentViewController:alertControll animated:YES completion:nil];
    });

    return alertControll;
}

@end
