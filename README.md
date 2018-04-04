# JuImageZoomScale
图片大图预览，支持双击放大，单击隐藏，长按保存。捏合放大缩小。
支持手机横竖屏自动适配。
支持先加载小图再加载大图
支持相册图片加载
支持图片从小到大的动画

****具体使用方法

JuImagesCollectView *ju_imgCollectView=[[JuImagesCollectView alloc]init];
    [self.view addSubview:ju_imgCollectView];
    ju_imgCollectView.juEdge(UIEdgeInsetsMake(0, 0, 0, 0));
    ju_imgCollectView.ju_handle = ^CGRect(id result) {
        return CGRectMake(100, 150, 100, 100);
    };
    [ju_imgCollectView juSetImages:@[[UIImage imageNamed:@"3.jpg"],
    [UIImage imageNamed:@"1.jpg"],
    @"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/03/16-49-060144-1442918276.jpeg",
    @"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-37-080036-1235239760.jpg",
    @"https://cms.pifubao.com.cn/cms/resource/upload/2018/04/02/15-15-220471701481425.jpg"] 
    currentIndex:0 rect:CGRectMake(100, 200, 100, 100)];
