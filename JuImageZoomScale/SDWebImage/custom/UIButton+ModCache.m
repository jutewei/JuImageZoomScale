//
//  UIButton+ModCache.m
//  SHBaseProject
//
//  Created by Juvid on 15/12/5.
//  Copyright © 2015年 Juvid(zhutianwei). All rights reserved.
//

#import "UIButton+ModCache.h"

@implementation UIButton (ModCache)
//带默认图片
- (void)setBackImageWithStr:(NSString *)strurl{
    [self setBackImageWithStr:strurl placeholderImage:nil];
    
}
- (void)setBackImageWithStr:(NSString *)strurl placeholderImage:(NSString *)placeholder{
    NSURL *url=[self shGetUrl:strurl];
    [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder?[UIImage imageNamed:placeholder]:nil];
    
}
-(NSURL *)shGetUrl:(NSString *)strurl{
    NSArray *arrStr=[strurl componentsSeparatedByString:@":"];
    NSURL *url;
    if ([arrStr[0]isEqualToString:@"http"]||[arrStr[0]isEqualToString:@"https"]) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",strurl]];
    }
    return url;
}
@end
