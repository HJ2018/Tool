//
//  ViewController.m
//  APPTool
//
//  Created by jie.huang on 7/8/18.
//  Copyright © 2018年 JIE. All rights reserved.
//

#import "ViewController.h"
#import "WSStarRatingView.h"
#import "UIView+Category.h"
#import "XRCarouselView.h"
#import "NavController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WSStarRatingView *wssVIew;
@property (weak, nonatomic) IBOutlet UIView *AnimationView;
@property (weak, nonatomic) IBOutlet XRCarouselView *XRCarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Next)];
    
    /**
     更多用法看代码
     */
    [self.wssVIew setScore:0.5 withAnimation:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.AnimationView shakeAnimation];
    });
    
    
    [self photos];
    
}

-(void)photos{
    /**
     更多用法看代码
     */
    //本地图片
    NSArray *arr1 = @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"], [UIImage imageNamed:@"3.jpg"]];
    self.XRCarView.imageArray = arr1;
    self.XRCarView.time = 2;
}

-(void)Next
{
    [self.navigationController pushViewController:[NavController new] animated:YES];
}


@end
