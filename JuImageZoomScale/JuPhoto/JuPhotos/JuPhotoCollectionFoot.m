//
//  JuPhotoCollectionFoot.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoCollectionFoot.h"
#import "JuLayoutFrame.h"

@interface JuPhotoCollectionFoot (){
    UILabel *ju_textLabel;
}

@end

@implementation JuPhotoCollectionFoot
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Create a label
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:17];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        textLabel.juCenterY.equal(0);
        textLabel.juCenterX.equal(0);
        ju_textLabel = textLabel;
    }

    return self;
}
-(void)setJu_strText:(NSString *)ju_strText{
    _ju_strText=ju_strText;
    ju_textLabel.text=ju_strText;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
