//
//  JuFullWindow.h
//  JuMoreWindows
//
//  Created by Juvid on 2018/7/20.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuFullWindow : UIWindow
+ (instancetype)sharedClient;
-(void)juShowWindow:(UIViewController *)rootVc;
-(void)juHideWindow;
@end
