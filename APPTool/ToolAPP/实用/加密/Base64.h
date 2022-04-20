//
//  Base64.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Base64 : NSObject
#pragma mark - Base64编码
/// 转为Base64编码的String
+ (NSString *)encodeString:(NSString *)string;
+ (NSString *)encodeData:(NSData *)data;
/// 转为Base64编码的Data
+ (NSData *)dataFromEncodeString:(NSString *)string;
+ (NSData *)dataFromEncodeData:(NSData *)data;

#pragma mark - Base64解码
/// 解码为String
+ (NSString *)decodeBase64String:(NSString *)string;
+ (NSString *)decodeBase64Data:(NSData *)data;
/// 解码为Data
+ (NSData *)dataFromDecodeBase64String:(NSString *)string;
+ (NSData *)dataFromDecodeBase64Data:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
