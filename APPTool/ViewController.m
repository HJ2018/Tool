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
#import "NSMutableAttributedString+Emoji.h"
#import "EncryptionTools.h"
#import "DES.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width

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
    

//    NSString *str = [[EncryptionTools sharedEncryptionTools]
//                     decryptAES:@"AT7Fwb97kRmp2ARkkADJqYTLYwGyZg1tSvM3UR73EsQuT0pRRsLgkZhBFBi1Fq5R" key:@"000001514840107708661762"];
//                    decryptString:@"AT7Fwb97kRmp2ARkkADJqYTLYwGyZg1tSvM3UR73EsQuT0pRRsLgkZhBFBi1Fq5R" keyString:@"000001514840107708661762" iv:NULL];
//    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:@"AT7Fwb97kRmp2ARkkADJqYTLYwGyZg1tSvM3UR73EsQuT0pRRsLgkZhBFBi1Fq5R" options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSData *data = [DES decryptDataECB:contentData key:@"000001514840107708661762"];
//
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *str = [DES decryptDataECB:@"AT7Fwb97kRmp2ARkkADJqYTLYwGyZg1tSvM3UR73EsQuT0pRRsLgkZhBFBi1Fq5R" key:@"000001514840107708661762"];
    NSLog(@"=====%@",str);
    
//    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(Next)];
    
    /**
     更多用法看代码
     */
    [self.wssVIew setScore:0.5 withAnimation:YES];
    
     [self.AnimationView shakeAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
          [self.AnimationView trans180DegreeAnimation];
       
    });
    
    
    
    CGSize textMaxSize = CGSizeMake(kScreenW - 50, MAXFLOAT);
    CGFloat height = [[NSMutableAttributedString returnKeepingStrWithText:@"Test height" Font:14] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    NSLog(@"%f",height);
    
    
    
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
