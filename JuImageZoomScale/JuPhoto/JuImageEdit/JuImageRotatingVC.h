//
//  JuImageRotatingView.h
//  图片旋转
//
//  Created by Juvid on 2020/12/22.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^__nullable JuImageResult)(UIImage * _Nullable result);             //下步操作后有跟新数据
NS_ASSUME_NONNULL_BEGIN

@interface JuImageRotatingVC : UIViewController
@property (nonatomic,strong)UIImage *ju_image;
@property (nonatomic,copy) JuImageResult ju_handle;
-(instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
