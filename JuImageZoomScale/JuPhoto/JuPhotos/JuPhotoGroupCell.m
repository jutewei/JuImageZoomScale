//
//  JuPhotoGroupCell.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoGroupCell.h"
#import "JuLayoutFrame.h"

@interface JuPhotoGroupCell (){
    UIImageView *ju_imageView;
    UILabel *ju_title;
    UILabel *ju_subTitle;
}

@end

@implementation JuPhotoGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    ju_imageView=[[UIImageView alloc]init];
    [ju_imageView setClipsToBounds:YES];
    [ju_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:ju_imageView];
    ju_imageView.juLead.equal(5);
    ju_imageView.juCenterY.equal(0);
    ju_imageView.juTop.equal(2);
    ju_imageView.juAspectWH.equal(0);


    ju_title =[[UILabel alloc]init];
    [self.contentView addSubview:ju_title];
    ju_title.font=[UIFont systemFontOfSize:16];
    ju_title.juLeaSpace.toView(ju_imageView).equal(8);
    ju_title.juCenterY.equal(0);

    ju_subTitle =[[UILabel alloc]init];
    [self.contentView addSubview:ju_subTitle];
    ju_subTitle.textColor=[UIColor grayColor];
    ju_subTitle.font=[UIFont systemFontOfSize:16];
    ju_subTitle.juLeaSpace.toView(ju_title).equal(0);
    ju_subTitle.juCenterY.equal(0);

    UIView *viewLine=[[UIView alloc]init];
    viewLine.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
    [self.contentView addSubview:viewLine];

    viewLine.juBottom.equal(0);
    viewLine.juHeight.equal(0.5);
    viewLine.juWidth.equal(0);

    return self;
}
-(void)setJu_PhotoGroup:(PHAssetCollection *)ju_PhotoGroup{
    _ju_PhotoGroup=ju_PhotoGroup;
    ju_title.text=ju_PhotoGroup.localizedTitle;
//    [self transformAblumTitle:ju_PhotoGroup.localizedTitle];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:ju_PhotoGroup options:nil];
    if (assetsFetchResults.count>0) {
        PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
        imageOptions.synchronous = YES;///< 同步
        [[PHImageManager defaultManager] requestImageForAsset:assetsFetchResults.lastObject
                                targetSize:CGSizeMake(80, 80)
                               contentMode:PHImageContentModeAspectFill
                                   options:imageOptions
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (result) {
                                      ju_imageView.image=result;
                                 }
//                                 NSLog(@"%@  %@",ju_PhotoGroup ,result);
                                 // 得到一张 UIImage，展示到界面上
                             }];
    }
    ju_subTitle.text=[NSString stringWithFormat:@"（%lu）",(unsigned long)assetsFetchResults.count];
}

/**
 英文转中文

 @param title 英文标题
 @return 中文标题
 */
- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    }
    else if ([title isEqualToString:@"Hidden"]) {
        return @"隐藏";
    }
    else if ([title isEqualToString:@"Time-lapse"]) {
        return @"延迟";
    }else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    }
    else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景";
    }else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    return title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
