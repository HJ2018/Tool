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
#import "Base.h"
#import "NSObject+CountDown.h"
#import "UIViewController+HHTransition.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WSStarRatingView *wssVIew;
@property (weak, nonatomic) IBOutlet UIView *AnimationView;
@property (weak, nonatomic) IBOutlet XRCarouselView *XRCarView;
@property (weak, nonatomic) IBOutlet UIButton *TimeButton;

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
    
     [self.AnimationView shakeAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
          [self.AnimationView trans180DegreeAnimation];
       
    });
    
    
    [self photos];
    
}
- (IBAction)StartTime:(id)sender {
    
    
    
    
    [sender countDownTime:100 countDownBlock:^(NSUInteger timer) {
        
        [self.TimeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.TimeButton setTitle:[NSString stringWithFormat:@"%zd 秒后重新发送", timer] forState:UIControlStateNormal];
         self.TimeButton.enabled = NO;
    } outTimeBlock:^{
        
        [self.TimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.TimeButton setTitle:@"重新发送验证" forState:UIControlStateNormal];
        self.TimeButton.enabled = YES;
        
    }];
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
    
     [self.navigationController hh_pushTiltViewController:[NavController new]];
}


@end
