//
//  JuPresentationController.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/8.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) void(^hidssView)(void);
@end
