//
//  JuLargeimageVC.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuDefine.h"
@interface JuLargeImageVC : UIViewController<UINavigationControllerDelegate>

+(instancetype)initRect:(JuHandle)handle;
+(instancetype)initRect:(CGRect)frame images:(NSArray *)arrList currentIndex:(NSInteger)index finishHandle:(JuHandle)handle;

@property (nonatomic,copy) JuHandle ju_handle;
-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index startRect:(CGRect)frame;
@end
