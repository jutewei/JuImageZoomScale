//
//  JuFullWindow.m
//  JuMoreWindows
//
//  Created by Juvid on 2018/7/20.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuFullWindow.h"

static JuFullWindow *_juFillWindow = nil;
@implementation JuFullWindow

-(instancetype)init{
    self=[super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        self.windowLevel=11;
        self.rootViewController=[UIViewController new];
        [self setBackgroundColor:[UIColor clearColor]];
        [self makeKeyAndVisible];
    }
    return self;
}
+ (instancetype)sharedClient{
    @synchronized(self) {
        if (!_juFillWindow) {
            _juFillWindow = [[JuFullWindow alloc]init];
        }
    }
    return _juFillWindow;
}
-(void)juShowWindow:(UIViewController *)rootVc{
    self.rootViewController=rootVc;
    [self makeKeyAndVisible];
}
-(void)juHideWindow{
    [self resignKeyWindow];
    self.hidden=YES;
    _juFillWindow=nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
