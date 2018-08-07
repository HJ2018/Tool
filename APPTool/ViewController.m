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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WSStarRatingView *wssVIew;
@property (weak, nonatomic) IBOutlet UIView *AnimationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.wssVIew setScore:0.5 withAnimation:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.AnimationView shakeAnimation];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
