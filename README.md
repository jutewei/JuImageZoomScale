# JuImageZoomScale
![Image text](https://github.com/jutewei/JuImageZoomScale/blob/master/JuImageZoomScale/show.gif)<br> 
 图片大图预览，支持双击放大，单击隐藏，长按保存。捏合放大缩小。
==
支持手机横竖屏自动适配。

支持先加载小图再加载大图

支持相册图片加载

支持图片从小到大的动画

支持向下拖拽变小并隐藏

支持3D-touch显示

初始化获取当前小图的坐标
==
-(UIViewController *)juSetImageVC:(NSIndexPath *)indexPath{<br> 
    UICollectionViewCell *cell=[_ju_collectView cellForItemAtIndexPath:indexPath];<br> 
    CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];<br> 
    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) {<br> 
    //隐藏时获取当前隐藏小图的坐标<br> 
        UICollectionViewCell *cell=[self.ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[result intValue] inSection:0]];<br> 
        CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];<br> 
        return frame;<br> 
    }];<br> 
    [vc juSetImages:arrList currentIndex:indexPath.row startRect:frame];<br> 
    return vc;<br> 
}<br> 

## 添加双击放大手势
 UITapGestureRecognizer *ju_doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(juDoubleTap:)];<br>
        ju_doubleTap.numberOfTapsRequired    = 2;<br>
        ju_doubleTap.numberOfTouchesRequired = 1;<br>
        [self addGestureRecognizer:ju_doubleTap];<br>
### 实现    <br>     
-(void)juDoubleTap:(UIGestureRecognizer *)sender{<br>
    if (!isFinishLoad) return;<br>
    UIScrollView *scr=(UIScrollView *)sender.view;<br>
    float newScale=0 ;<br>
    if (scr.zoomScale>1.0) {<br>
 ####    双击后变成原始尺寸及坐标<br>
        [scr setZoomScale:1.0 animated:YES];<br>
    }
    else{<br>
     ####    双击区域实现放大<br>
       newScale=self.maximumZoomScale;<br>
        CGRect zoomRect = [self juZoomRectForScale:newScale withCenter:[sender locationInView:sender.view]];<br>
        [scr zoomToRect:zoomRect animated:YES];<br>
    }
}
//**双击倍数*/<br>
- (CGRect)juZoomRectForScale:(float)scale withCenter:(CGPoint)center{<br>
    CGRect zoomRect;<br>
    zoomRect.size.height = self.frame.size.height / scale;<br>
    zoomRect.size.width  = self.frame.size.width  / scale;<br>
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);<br>
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);<br>
    return zoomRect;<br>
}<br>

## 难点：如何在下拉时移动并变小
### 判断是否向下滑动，并且是拖拽情况下，_ju_isAlbum为相册选取模式，不支持动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{<br> 
    CGFloat  scrollNewY = scrollView.contentOffset.y;<br> 
    if (scrollNewY <0&&self.dragging&&!_ju_isAlbum){<br> 
        isDruging=YES;<br> 
        ju_imgMoveRect=self.ju_imgView.frame;<br> 
    }<br> 
    if (isDruging) {<br> 
        [self juTouchPan:scrollView.panGestureRecognizer];<br> 

    }<br> 
}<br> 

### 主要控制移动视图的X,Y坐标，以及尺寸的缩放比
- (void)juTouchPan:(UIPanGestureRecognizer *)pan{<br> 
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStatePossible){<br> 
        isDruging=NO;<br> 
        return;<br> 
    }<br> 
    if (!self.ju_imageMove) {<br> 
    //复制一个相同的视图为移动时使用<br> 
      self.ju_imageMove=[[UIImageView alloc]init];<br> 
        self.ju_imageMove.frame=ju_imgMoveRect;<br> 
        self.ju_imageMove.image=self.ju_imgView.image;<br> 
        [self addSubview:self.ju_imageMove];<br> 
    }<br> 
    self.ju_imgView.hidden=YES;<br> 
    self.ju_imageMove.hidden=NO;<br> 
    if (ju_moveBeginPoint.y==0&&ju_moveBeginPoint.x==0) {<br> 
        ju_moveBeginPoint=[pan locationInView:self];//记录开始实现下拉时坐标<br> 
        ju_imgBeginPoint=[pan locationInView:_ju_imageMove];<br> 
    }<br> 

    CGPoint movePoint = [pan locationInView:self];<br> 
    CGPoint currentPoint = CGPointMake(movePoint.x-ju_moveBeginPoint.x, movePoint.y-ju_moveBeginPoint.y);<br> 
    CGFloat changeScale;<br> 

    if (currentPoint.y>0) {<br> 
         changeScale=MAX(1-(currentPoint.y)/300.0,0.3);<br> 
    }else{<br> 
         changeScale=MAX(1+(currentPoint.y)/300.0,0.9);<br> 
    }<br> 
    isDrugMiss=changeScale<0.9;<br> 
    _ju_imageMove.transform=CGAffineTransformMakeScale(changeScale,changeScale);<br> 
    CGFloat minusScale=1-changeScale;<br> 
//    (ju_imgMoveRect.size.width-_ju_imageMove.sizeW)/ju_imgMoveRect.size.width;<br> 
#### 计算xy坐标
   CGFloat moveY=currentPoint.y+ju_imgMoveRect.origin.y+ju_imgBeginPoint.y*minusScale;<br> 
    CGFloat moveX=currentPoint.x+ju_imgMoveRect.origin.x+ju_imgBeginPoint.x*minusScale;<br> 
//    NSLog(@"坐标X:%f y:%f 减少的宽 w:%f h:%f",moveX,moveY,minusScale,minusScale);
    self.ju_imageMove.originY=moveY;<br> 
    self.ju_imageMove.originX=moveX;<br> 

    if ([self.ju_delegate respondsToSelector:@selector(juChangeSacle:)]) {<br> 
        [self.ju_delegate juChangeSacle:changeScale];<br> 
    }<br> 
}
