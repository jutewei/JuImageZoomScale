//
//  JuNaviTransitioning.h
//  JuPresent
//
//  Created by Juvid on 2018/4/20.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JuNaviTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic, getter=isPush) BOOL push;
+(JuNaviTransitioning *)juTransitionType:(UINavigationControllerOperation)operation;
@end
