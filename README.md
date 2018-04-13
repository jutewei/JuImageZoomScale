# JuImageZoomScale
![Image text](https://github.com/jutewei/JuImageZoomScale/blob/master/JuImageZoomScale/show.gif)<br> 
 图片大图预览，支持双击放大，单击隐藏，长按保存。捏合放大缩小。
==
 #### 支持手机横竖屏自动适配。

 #### 支持先加载小图再加载大图

 #### 支持相册图片加载

 #### 支持图片从小到大的动画

 #### 支持向下拖拽变小并隐藏

 #### 支持3D-touch显示


### JuImagesCollectView类为左右滑动容器
### JuZoomScaleView 单子图片容器，实现图片放大
### JuAnimated 实现转场动画
### JuProgressView 网络图片加载进度显示

调用方法：初始化并获取当前小图的坐标
==
```
-(UIViewController *)juSetImageVC:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[_ju_collectView cellForItemAtIndexPath:indexPath];
    CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];
    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) { 
    //隐藏时获取当前隐藏小图的坐标 
        UICollectionViewCell *cell=[self.ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[result intValue] inSection:0]];
        CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];
        return frame;
    }]; 
    [vc juSetImages:arrList currentIndex:indexPath.row startRect:frame];
    return vc;
}
```
## 添加双击放大手势
```
  UITapGestureRecognizer *ju_doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(juDoubleTap:)];
  ju_doubleTap.numberOfTapsRequired    = 2;
  ju_doubleTap.numberOfTouchesRequired = 1;
  [self addGestureRecognizer:ju_doubleTap];
```
### 实现        
```
-(void)juDoubleTap:(UIGestureRecognizer *)sender{
    if (!isFinishLoad) return;
    UIScrollView *scr=(UIScrollView *)sender.view;
    float newScale=0 ;
    if (scr.zoomScale>1.0) {
 //   双击后变成原始尺寸及坐标
        [scr setZoomScale:1.0 animated:YES];
    }
    else{<br>
     ####    双击区域实现放大
       newScale=self.maximumZoomScale;
        CGRect zoomRect = [self juZoomRectForScale:newScale withCenter:[sender locationInView:sender.view]];
        [scr zoomToRect:zoomRect animated:YES];
    }
}
```
### 双击倍数
```
- (CGRect)juZoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
```
## 难点：如何在下拉时移动并变小
### 判断是否向下滑动，并且是拖拽情况下，_ju_isAlbum为相册选取模式，不支持动画
```
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
```
### 主要控制移动视图的X,Y坐标，以及尺寸的缩放比
```
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
```
//结束拖拽
```
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
```
