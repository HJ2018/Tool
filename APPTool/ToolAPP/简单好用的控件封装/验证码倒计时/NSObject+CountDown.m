//
//  UIButton+CountDown.m
//  定时器
//
//  Created by 李忠 on 2016/11/3.
//  Copyright © 2016年 tynDog. All rights reserved.
//

#import "NSObject+CountDown.h"
#import <objc/runtime.h>

@interface NSObject ()

/** 定时器 */
@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation NSObject (CountDown)

- (void)countDownTime:(NSUInteger)time countDownBlock:(TYNCountDownBlock)countDownBlock outTimeBlock:(TYNFinishBlock)finishBlock{
    
    __block NSUInteger second = time;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC, 1.0f * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (countDownBlock != nil) {
                countDownBlock(second);
            }
        });
        
        if ((second--) == 0) {
            dispatch_cancel(self.timer);
            self.timer = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (finishBlock != nil) {
                    finishBlock();
                }
            });
        }
    });
    
    dispatch_resume(self.timer);
}

- (void)setTimer:(dispatch_source_t)timer{
    
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)timer{
    return objc_getAssociatedObject(self, @selector(timer));
}

@end
