//
//  JuImagesCollectCell.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuZoomScaleView.h"

@interface JuImagesCollectCell : UICollectionViewCell<JuImageZoomScaleDelegate>{
    JuZoomScaleView *ju_scaleView;
}
@property(nonatomic,assign) BOOL  ju_isAlbum;///< 相册
@property (nonatomic,assign) id<JuImageZoomScaleDelegate> ju_delegate;
-(void)juSetImage:(id)imageData originalFrame:(CGRect)frame;
@end
