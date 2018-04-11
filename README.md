# JuImageZoomScale
![Image text](https://github.com/jutewei/JuImageZoomScale/blob/master/JuImageZoomScale/show.gif)
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
