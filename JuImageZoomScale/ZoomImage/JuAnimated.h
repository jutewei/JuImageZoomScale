//
//  JuAnimated.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/8.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JuAnimated : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic, getter=isPresented) BOOL presented;
@end
