//
//  SHA.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHA : NSObject
#pragma mark - SHA
/// SHA1（不推荐，将要淘汰）
+ (NSString *)SHA1String:(NSString *)string;
+ (NSString *)SHA1Data:(NSData *)data;
/// SHA224
+ (NSString *)SHA224String:(NSString *)string;
+ (NSString *)SHA224Data:(NSData *)data;
/// SHA256
+ (NSString *)SHA256String:(NSString *)string;
+ (NSString *)SHA256Data:(NSData *)data;
/// SHA384
+ (NSString *)SHA384String:(NSString *)string;
+ (NSString *)SHA384Data:(NSData *)data;
/// SHA512
+ (NSString *)SHA512String:(NSString *)string;
+ (NSString *)SHA512Data:(NSData *)data;

#pragma mark HMAC-SHA (HMAC 消息认证机制，可以和任何迭代散列算法搭配使用)
/// 更安全的SHA方式，双方共有一个密钥，确保SHA不被破解

/// HMAC-SHA1（不推荐，将要淘汰）
+ (NSString *)hmacSHA1String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacSHA1Data:(NSData *)data hmacKey:(NSString *)key;
/// HMAC-SHA224 (SHA224是正确的，但HMAC-SHA224结果与js不同，慎用)
+ (NSString *)hmacSHA224String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacSHA224Data:(NSData *)data hmacKey:(NSString *)key;
/// HMAC-SHA256
+ (NSString *)hmacSHA256String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacSHA256Data:(NSData *)data hmacKey:(NSString *)key;
/// HMAC-SHA384 (SHA384是正确的，但HMAC-SHA384结果与js不同，慎用)
+ (NSString *)hmacSHA384String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacSHA384Data:(NSData *)data hmacKey:(NSString *)key;
/// HMAC-SHA512
+ (NSString *)hmacSHA512String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacSHA512Data:(NSData *)data hmacKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
