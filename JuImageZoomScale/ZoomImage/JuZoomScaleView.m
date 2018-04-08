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
#import <Photos/Photos.h>
@interface JuZoomScaleView()<UIScrollViewDelegate>{
    //记录自己的位置
    CGRect scaleOriginRect;
    //图片的大小
    NSString *imgUrl;
    //缩放前大小
    CGRect ju_originalRect;
    BOOL isFinishLoad;
    dispatch_queue_t ju_queueFullImage;
}
@property  BOOL isAnimate;
@property (nonatomic,strong) JuProgressView *sh_progressView;
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

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(juTouchTap)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
        [gesture requireGestureRecognizerToFail:ju_doubleTap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(juTouchLong:)];
        [self addGestureRecognizer:longPress];

        self.maximumZoomScale               = 2;
        self.bouncesZoom                    = YES;
        self.minimumZoomScale               = 1.0;
        ju_queueFullImage=dispatch_queue_create("queue.getFullImage", DISPATCH_QUEUE_SERIAL);///< 串行队列
        [self shSetImageView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juStatusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

/**
 加载前的状态
 */
-(void)juSetActivity{
    if (!self.juActivity) {
        UIActivityIndicatorView *activityV=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityV.hidesWhenStopped = YES;
        activityV.tag              = 112;
        activityV.center           = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:activityV];
    }
    [self.juActivity startAnimating];
}
-(UIActivityIndicatorView *)juActivity{
    return (id)[self viewWithTag:112];
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
/**
 设置图片
 */
- (void) setImage:(id)imageObject originalRect:(CGRect)originalRect{
    if (!imageObject) return;

    if (originalRect.size.width>0) {
        _isAnimate=YES;
        ju_imgView.frame = originalRect;
        ju_originalRect = originalRect;
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
            scaleOriginRect = (CGRect){JU_Window_Width/2-imgViewWidth/2,0,imgViewWidth,JU_Window_Height};
        }
        else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            self.maximumZoomScale =MAX(2.5, JU_Window_Height/imgViewHeight) ;
            scaleOriginRect = (CGRect){0,JU_Window_Height/2-imgViewHeight/2,JU_Window_Width,imgViewHeight};
        }
        [self juShowAnimation];
        isFinishLoad=YES;
        self.contentSize=ju_imgView.frame.size;
    }
}
- (void) juShowAnimation{
    ju_imgView.transform = CGAffineTransformMakeScale(1, 1);///< 修复图片大小变为0
    [UIView animateWithDuration:_isAnimate?0.3:0 animations:^{
        self.ju_imgView.frame = self->scaleOriginRect;
    }completion:^(BOOL finished) {
        self.ju_imgView.frame =self->scaleOriginRect;
    }];
}
//隐藏动画
- (void) juHiddenAnimation{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:self.zoomScale==1.0?0:0.3 animations:^{
        self.zoomScale=1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            if (self.isAnimate)  {
                self.ju_imgView.frame =self->ju_originalRect;
                self.superview.backgroundColor=[UIColor clearColor];
            }
            else self.superview.alpha=0.0;
        } completion:^(BOOL finished) {
            [self.superview removeFromSuperview];
        }];
    }];
}
//隐藏
-(void)juTouchTap{
    if ([self.ju_delegate respondsToSelector:@selector(juCurrentRect)]) {///< 网络图片看大图
        if (_ju_isAlbum) {
            [self.ju_delegate juCurrentRect];
            return;
        }
        CGRect frame= [self.ju_delegate juCurrentRect];
        if (frame.size.width>0) {
            ju_originalRect=frame;
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
-(void)juTouchLong:(id)sender{
    NSLog(@"长按");
}
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    ju_queueFullImage=nil;
    ju_imgView.image=nil;
    _ju_delegate = nil;
}
@end
