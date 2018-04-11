# JuImageZoomScale
![Image text](https://github.com/jutewei/JuImageZoomScale/blob/master/JuImageZoomScale/show.gif)
# 图片大图预览，支持双击放大，单击隐藏，长按保存。捏合放大缩小。

支持手机横竖屏自动适配。

支持先加载小图再加载大图

支持相册图片加载

支持图片从小到大的动画

支持向下拖拽变小并隐藏

支持3D-touch显示

# 初始化获取当前小图的坐标
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
