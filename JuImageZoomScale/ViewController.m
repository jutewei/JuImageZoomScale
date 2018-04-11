//
//  ViewController.m
//  JuImageZoomScale
//
//  Created by Juvid on 2018/4/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "ViewController.h"
#import "JuAlbumPreviewVC.h"
#import "JuLargeImageVC.h"
#import "CollectionViewCell.h"
@interface ViewController (){
    NSArray *arrList;
}
@property (strong, nonatomic) IBOutlet UICollectionView *ju_collectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrList=@[[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",@"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"];
    [_ju_collectView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//      viewC.ju_ArrList=@[@"3.jpg",@"1.jpg"];
   
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    [cell juSetImage:arrList[indexPath.row]];
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>3) {
        JuAlbumPreviewVC *vc=[[JuAlbumPreviewVC alloc]init];
        [vc juSetImages:arrList currentIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JuLargeImageVC *vc=(id)[self juSetImageVC:indexPath];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(UIViewController *)juSetImageVC:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[_ju_collectView cellForItemAtIndexPath:indexPath];
    CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];
    JuLargeImageVC *vc=[JuLargeImageVC initView:self.navigationController.view endRect:^CGRect(id result) {
        UICollectionViewCell *cell=[self.ju_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[result intValue] inSection:0]];
        CGRect frame= [cell.superview convertRect:cell.frame toView:cell.window];
        return frame;
    }];
    [vc juSetImages:arrList currentIndex:indexPath.row startRect:frame];
    return vc;
}
-(UIViewController *)shPreviewVC:(id <UIViewControllerPreviewing>)previewingContext{
    UICollectionViewCell *cell=(id)[previewingContext sourceView];
    NSIndexPath *indexPath = [_ju_collectView indexPathForCell:cell];
    return [self juSetImageVC:indexPath];
}
//pop（按用点力进入视图）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    return [self shPreviewVC:previewingContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
