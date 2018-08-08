//
//  UIButton+CountDown.h
//  定时器
//
//  Created by 李忠 on 2016/11/3.
//  Copyright © 2016年 tynDog. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^TYNCountDownBlock)(NSUInteger timer);
typedef void(^TYNFinishBlock)();

@interface NSObject (CountDown)

/**
 按钮倒计时

 @param time 倒计时总时间
 @param countDownBlock 每秒倒计时会执行的block
 @param finishBlock 倒计时完成会执行的block
 */
- (void)countDownTime:(NSUInteger)time countDownBlock:(TYNCountDownBlock)countDownBlock outTimeBlock:(TYNFinishBlock)finishBlock;

@end
