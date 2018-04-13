//
//  JuZoomScaleImageView.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JuZoomScaleView.h"
#import "UIImageView+ModCache.h"
#import "JuImageObject.h"
#import "JuProgressView.h"
#import "UIView+Frame.h"
#import <Photos/Photos.h>
@interface JuZoomScaleView()<UIScrollViewDelegate>{
    //记录自己的位置
    CGRect ju_originRect;
    //缩放前大小
    CGRect ju_smallRect;
    BOOL isFinishLoad;
    dispatch_queue_t ju_queueFullImage;
    BOOL isDruging,isDrugMiss;
    CGRect ju_imgMoveRect;
    CGPoint ju_moveBeginPoint,ju_imgBeginPoint;
}
@property  BOOL isAnimate;
@property (nonatomic,strong) JuProgressView *sh_progressView;
@property (nonatomic,strong) UIImageView *ju_imageMove;
@end

@implementation JuZoomScaleView

@synthesize ju_imgView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.backgroundColor                = [UIColor clearColor];
        self.delegate                       = self;

        UITapGestureRecognizer *ju_doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(juDoubleTap:)];
        ju_doubleTap.numberOfTapsRequired    = 2;
        ju_doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ju_doubleTap];

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(juTouchTapHidder)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
        [gesture requireGestureRecognizerToFail:ju_doubleTap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(juTouchLong:)];
        [self addGestureRecognizer:longPress];
        self.alwaysBounceVertical=YES;
        self.alwaysBounceHorizontal=YES;
        self.maximumZoomScale               = 2;
        self.bouncesZoom                    = YES;
        self.minimumZoomScale               = 1.0;
        ju_queueFullImage=dispatch_queue_create("queue.getFullImage", DISPATCH_QUEUE_SERIAL);///< 串行队列
        [self shSetImageView];
//        屏幕旋转时重新布局
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juStatusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

/**
 加载前的状态
 */
-(UIActivityIndicatorView *)juActivity{
    UIActivityIndicatorView *activity=(id)[self.superview viewWithTag:112];
    if (!activity) {
        activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.hidesWhenStopped = YES;
        activity.tag              = 112;
        activity.center           = self.superview.center;
        [self.superview addSubview:activity];
    }
    [activity startAnimating];
    return activity;
}
//进度条
-(JuProgressView *)sh_progressView{
    if (!_sh_progressView) {
        JuProgressView *view=[[JuProgressView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        view.center=self.center;
        view.ju_progressWidth=4;
        view.ju_backWidth=4;
        view.ju_progressColor=[UIColor whiteColor];
        view.ju_backColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        view.ju_Progress=0;
        _sh_progressView=view;
        [self addSubview:view];
    }
    return _sh_progressView;
}
- (void)juStatusBarOrientationChange:(NSNotification *)notification{
    if (ju_imgView.image) {
        [self setImage:ju_imgView.image];
    }
}
-(void)shSetImageView{
    ju_imgView               = [[UIImageView alloc] init];
    ju_imgView.clipsToBounds = YES;
    ju_imgView.contentMode   = UIViewContentModeScaleAspectFill;
    ju_imgView.tag=918;
    [self addSubview:ju_imgView];
}

/**
 设置图片
 */
- (void) setImage:(id)imageObject originalRect:(CGRect)originalRect{
    if (!imageObject) return;

    if (originalRect.size.width>0) {
        _isAnimate=YES;
        ju_imgView.frame = originalRect;
        ju_smallRect = originalRect;
    }
    if ([imageObject isKindOfClass:[UIImage class]]) {
        [self setImage:imageObject];
    }else if ([imageObject isKindOfClass:[NSString class]]){
        [self juGetNetImage:imageObject];
    }else if ([imageObject isKindOfClass:[JuImageObject class]]){
        JuImageObject *imageM=imageObject;
        if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageM.ju_thumbImageUrl]]) {
            [self juGetNetImage:imageM.ju_thumbImageUrl];
        }
        [self juGetNetImage:imageM.ju_imageUrl];
    }else{
        [self juGetAssetImage:imageObject];
    }
}

//相册图片
-(void)juGetAssetImage:(PHAsset *)asset{
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;///< 同步
    imageOptions.resizeMode=PHImageRequestOptionsResizeModeFast;///< 精准尺寸
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)self targetSize:size contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        ju_dispatch_get_main_async(^{
            [self setImage:result];
        });
    }];
}
//网络图片
-(void)juGetNetImage:(NSString *)imageUrl{
    __weak typeof(self) weakSelf = self;
    [ju_imgView setImageWithStr:imageUrl placeholderImage:nil options:SDWebImageAvoidAutoSetImage  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ju_dispatch_get_main_async(^{///< 进度
            weakSelf.sh_progressView.ju_Progress=MAX((float)receivedSize/(float)expectedSize, 0.01);
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ju_dispatch_get_main_async(^{///< 完成
            [weakSelf.sh_progressView removeFromSuperview];
            weakSelf.sh_progressView=nil;
            [weakSelf setImage:image];
        });
    }];
}
//设置图片展开
- (void) setImage:(UIImage *)image{
    if (image){
        ju_imgView.image=image;
        CGSize imgSize = image.size;
        //判断首先缩放的值
        float scaleX = JU_Window_Width/imgSize.width;
        float scaleY = JU_Window_Height/imgSize.height;
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            self.maximumZoomScale =MAX(2.5, JU_Window_Width/imgViewWidth) ;
            ju_originRect = (CGRect){JU_Window_Width/2-imgViewWidth/2,0,imgViewWidth,JU_Window_Height};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            self.maximumZoomScale =MAX(2.5, JU_Window_Height/imgViewHeight) ;
            ju_originRect = (CGRect){0,JU_Window_Height/2-imgViewHeight/2,JU_Window_Width,imgViewHeight};
        }
        [self juShowAnimation];
        isFinishLoad=YES;
    }
}
- (void) juShowAnimation{
//    ju_imgView.transform = CGAffineTransformMakeScale(1, 1);///< 修复图片大小变为0
//     self.zoomScale=1.0;

    [UIView animateWithDuration:_isAnimate?0.3:0 animations:^{
        self.ju_imgView.frame = self->ju_originRect;
    }completion:^(BOOL finished) {
         self.contentSize=self.ju_imgView.frame.size;
    }];
}
//隐藏
-(void)juTouchTapHidder{

    if (_ju_isAlbum&&[self.ju_delegate respondsToSelector:@selector(juTapHidder)]) {
        [self.ju_delegate juTapHidder];
        return;
    }

    if ([self.ju_delegate respondsToSelector:@selector(juCurrentRect)]) {///< 网络图片看大图
        CGRect frame= [self.ju_delegate juCurrentRect];
        if (frame.size.width>0) {
            ju_smallRect=frame;
            _isAnimate=YES;
        }
        CGRect winFrame=self.window.frame;
        winFrame.origin.y=64;
        winFrame.size.height-=64;
        if (!CGRectIntersectsRect(winFrame, frame)) {
            _isAnimate=NO;
        }
        [self juHiddenAnimation];
    }
}

//恢复到原始zoom
- (void) juHiddenAnimation{
    if (self.isAnimate) {
//        CGRect frame= [self convertRect:self.ju_imgView.frame toView:self.window];
//        self.ju_imageMove.frame=frame;
//        [self.superview addSubview:self.ju_imageMove];
//        self.ju_imgView.hidden=YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset=CGPointMake(0, 0);
            self.contentSize=self->ju_originRect.size;
            self.ju_imgView.frame =self->ju_smallRect;
//             self.ju_imageMove.frame =self->ju_smallRect;
        }completion:^(BOOL finished) {
            self.ju_imgView.frame =self->ju_smallRect;
//            NSLog(@"完成");
//            imaView.frame =self->ju_smallRect;
        }];
    }
    if ([self.ju_delegate respondsToSelector:@selector(juTapHidder)]) {
        [self.ju_delegate juTapHidder];
    }

}

/**
 可实现长安保存图片
 */
-(void)juTouchLong:(id)sender{
    NSLog(@"长按");
}

/**
 双击缩放
 */
-(void)juDoubleTap:(UIGestureRecognizer *)sender{
    if (!isFinishLoad) return;
    UIScrollView *scr=(UIScrollView *)sender.view;
    float newScale=0 ;
    if (scr.zoomScale>1.0) {
        [scr setZoomScale:1.0 animated:YES];
    }
    else{
        newScale=self.maximumZoomScale;
        CGRect zoomRect = [self juZoomRectForScale:newScale withCenter:[sender locationInView:sender.view]];
        [scr zoomToRect:zoomRect animated:YES];
    }
}
//**双击倍数*/
- (CGRect)juZoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (!isFinishLoad) return nil;
    return ju_imgView;
}
//捏合缩放动画
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = ju_imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width){
        centerPoint.x = boundsSize.width/2;
    }
    // center vertically
    if (imgFrame.size.height <= boundsSize.height){
        centerPoint.y = boundsSize.height/2;
    }

    ju_imgView.center = centerPoint;
}
/**判断是否向下拖拽*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat  scrollNewY = scrollView.contentOffset.y;
    if (scrollNewY <0&&self.dragging&&!_ju_isAlbum){
        isDruging=YES;
        ju_imgMoveRect=self.ju_imgView.frame;
    }
    if (isDruging) {
        [self juTouchPan:scrollView.panGestureRecognizer];

    }
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (isDruging) {
        isDruging=NO;
        ju_moveBeginPoint=CGPointMake(0, 0);
        if (isDrugMiss) {///< 达到消失临界值
            self.ju_imgView.frame= self.ju_imageMove.frame;
            self.ju_imgView.hidden=NO;
            [self.ju_imageMove removeFromSuperview];
            self.ju_imageMove=nil;
            [self juTouchTapHidder];
        }else{///< 未达到消失值恢复原始值
            [UIView animateWithDuration:0.4 animations:^{
                self.ju_imgView.frame=self->ju_imgMoveRect;
                self.ju_imageMove.frame=self->ju_imgMoveRect;
            }completion:^(BOOL finished) {
                self.ju_imgView.hidden=NO;
                [self.ju_imageMove removeFromSuperview];
                self.ju_imageMove=nil;
            }];
            if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {
                [self.ju_delegate juChangeSacle:!isDrugMiss];
            }
        }
    }
}
-(UIImageView *)ju_imageMove{
    if (!_ju_imageMove) {
        _ju_imageMove=[[UIImageView alloc]init];
        _ju_imageMove.clipsToBounds = YES;
        _ju_imageMove.contentMode   = UIViewContentModeScaleAspectFill;
        _ju_imageMove.image=self.ju_imgView.image;
    }
    return _ju_imageMove;
}
- (void)juTouchPan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStatePossible||pan.numberOfTouches != 1 ){
        isDruging=NO;
        return;
    }
    if (!self.ju_imageMove.superview) {
        self.ju_imageMove.frame=ju_imgMoveRect;
        [self addSubview:self.ju_imageMove];
    }
    self.ju_imgView.hidden=YES;
    self.ju_imageMove.hidden=NO;
    if (ju_moveBeginPoint.y==0&&ju_moveBeginPoint.x==0) {
        ju_moveBeginPoint=[pan locationInView:self];
        ju_imgBeginPoint=[pan locationInView:_ju_imageMove];
    }

    CGPoint movePoint = [pan locationInView:self];
    CGPoint currentPoint = CGPointMake(movePoint.x-ju_moveBeginPoint.x, movePoint.y-ju_moveBeginPoint.y);
    CGFloat changeScale;

    if (currentPoint.y>0) {
         changeScale=MAX(1-(currentPoint.y)/300.0,0.3);
    }else{
         changeScale=MAX(1+(currentPoint.y)/300.0,0.9);
    }

    _ju_imageMove.transform=CGAffineTransformMakeScale(changeScale,changeScale);
    CGFloat minusScale=1-changeScale;
//    移动坐标由原始坐标和移动坐标已经缩放相对尺寸坐标
    CGFloat moveY=currentPoint.y+ju_imgMoveRect.origin.y+ju_imgBeginPoint.y*minusScale;
    CGFloat moveX=currentPoint.x+ju_imgMoveRect.origin.x+ju_imgBeginPoint.x*minusScale;

    isDrugMiss=moveY>=self.ju_imageMove.originY;
    self.ju_imageMove.originY=moveY;
    self.ju_imageMove.originX=moveX;

    if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {
        [self.ju_delegate juChangeSacle:changeScale];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    ju_queueFullImage=nil;
    ju_imgView.image=nil;
    _ju_delegate = nil;
}
@end
