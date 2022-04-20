//
//  MD5.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MD5 : NSObject
#pragma mark - MD5
/// MD5摘要
+ (NSString *)MD5String:(NSString *)string;
+ (NSString *)MD5Data:(NSData *)data;

/// 文件MD5
+ (NSString *)fileMD5WithPath:(NSString *)filePath;

/// 注意，如果MD5是用在登录验签上，请使用HMAC-MD5的方式，单纯的MD5并不安全
///
/// MD5破解方法：
/// 1.暴力枚举法、2.字典法(CMD5网站)、3.彩虹表法、4.王小云MD5碰撞法、5.差分攻击、6.分布式计算和分布式存储

#pragma mark - HMAC-MD5 (HMAC 消息认证机制，可以和任何迭代散列算法搭配使用)
/// 更安全的MD5方式，双方共有一个密钥，确保MD5不被破解

/// HMAC-MD5摘要
+ (NSString *)hmacMD5String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacMD5Data:(NSData *)data hmacKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
