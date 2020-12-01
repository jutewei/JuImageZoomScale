//
//  JuDefine.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#ifndef JuDefine_h
#define JuDefine_h
/// 当前宽高
#define JU_Window_Height [[UIScreen mainScreen] bounds].size.height
#define JU_Window_Width [[UIScreen mainScreen] bounds].size.width

//打印信息设置
typedef void(^JuCompletion)(void);//回调
typedef void(^JuSalceHandle)(CGFloat scale);//回调
typedef void(^JuHandleIndex)(NSInteger index);//回调
typedef void(^JuEditFinish)(NSArray *arrList);//预览完成

typedef CGRect (^JuHandle)(id result);//坐标回调

#define ju_dispatch_get_main_async(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif /* JuDefine_h */
