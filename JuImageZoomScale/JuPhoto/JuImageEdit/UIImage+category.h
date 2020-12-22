//
//  UIImage+MUCommon.h
//  BigCalculate
//
//  Created by 罗文琦 on 16/10/27.
//  Copyright © 2016年 罗文琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (category)

-(UIImage *_Nonnull)juFixOrientation;

-(UIImage *_Nonnull)juRotatingOrientation;

@end


@interface UIImageView (category)

- (void)juRotationView;

- (UIImage *_Nullable)juSaveRotationResult;

- (CGRect)juSetImage:(UIImage *_Nullable)image;

-(CGFloat)juSafeBottom;


-(CGFloat)juWindowWidth;

-(CGFloat)juWindowHeight;

@end
