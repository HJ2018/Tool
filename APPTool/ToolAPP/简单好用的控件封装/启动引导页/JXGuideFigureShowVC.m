//
//  JXGuideFigureShowVC.m
//  JXLeadImagesTool
//
//  Created by 张明辉 on 16/6/7.
//  Copyright © 2016年 jesse. All rights reserved.
//

#import "JXGuideFigureShowVC.h"
#import "JXGuideFigureTool.h"
#import "UIView+XMGLayout.h"

@interface JXGuideFigureShowVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation JXGuideFigureShowVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置界面
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(self.images.count * SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
//    for (int i = 0; i < self.images.count; i ++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor redColor];
//        btn.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        [btn setBackgroundImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateHighlighted];
//
//        if (i == self.images.count - 1) {
//            [btn addTarget:self action:@selector(clickLastBtn) forControlEvents:UIControlEventTouchUpInside];
//
//        }
    
        
//        [scrollView addSubview:btn];
//    }
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i<self.images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
//        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:self.images[i]];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他内容
        if (i == self.images.count - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    /**
     UIPageControl
     */
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.originY, SCREEN_WIDTH, 20)];
    self.pageControl.enabled = NO;
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    self.pageControl.pageIndicatorTintColor = self.otherPageColor;
    [self.view addSubview:self.pageControl];
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 2.开始微博
    UIButton *startBtn = [[UIButton alloc] init];
//    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
//    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.backgroundColor = [UIColor orangeColor];
    startBtn.width = 200;
    startBtn.height = 45;
    startBtn.centerX = imageView.width * 0.5;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始项目" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

-(void)startClick{
    
    if (self.clickLastPage) {
        self.clickLastPage();
    }
}
//- (void)clickLastBtn
//{
//    if (self.clickLastPage) {
//        self.clickLastPage();
//    }
//}


#pragma mark - scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    self.pageControl.currentPage = page;
}


@end
