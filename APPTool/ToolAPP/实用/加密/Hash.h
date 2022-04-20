//
//  Hash.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hash : NSObject

/// java中的hash算法
+ (int)javaHashCode:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
