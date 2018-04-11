//
//  CollectionViewCell.h
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/11.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell{
    UIImageView *ju_imageView;
}
-(void)juSetImage:(id)imageData;
@end
