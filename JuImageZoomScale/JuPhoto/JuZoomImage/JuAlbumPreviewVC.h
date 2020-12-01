//
//  JuAlbumPreviewVC.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuDefine.h"
//#import "JuBaseViewController.h"

@interface JuAlbumPreviewVC : UIViewController

-(void)juSetImages:(NSArray *)arrList currentIndex:(NSInteger)index finish:(JuEditFinish)finishHaldle;

@end
