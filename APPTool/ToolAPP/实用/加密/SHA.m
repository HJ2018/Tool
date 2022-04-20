//
//  SHA.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "SHA.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation SHA
#pragma mark - SHA
/// SHA1
+ (NSString *)SHA1String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self SHA1Data:data];
    return result;
}

+ (NSString *)SHA1Data:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    // 进行SHA摘要
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// SHA224
+ (NSString *)SHA224String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self SHA224Data:data];
    return result;
}

+ (NSString *)SHA224Data:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA224_DIGEST_LENGTH];
    // 进行SHA摘要
    CC_SHA224(data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// SHA256
+ (NSString *)SHA256String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self SHA256Data:data];
    return result;
}

+ (NSString *)SHA256Data:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    // 进行SHA摘要
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// SHA384
+ (NSString *)SHA384String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self SHA384Data:data];
    return result;
}

+ (NSString *)SHA384Data:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA384_DIGEST_LENGTH];
    // 进行SHA摘要
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// SHA512
+ (NSString *)SHA512String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self SHA512Data:data];
    return result;
}

+ (NSString *)SHA512Data:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    // 进行SHA摘要
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

#pragma mark HMAC-SHA (HMAC 消息认证机制，可以和任何迭代散列算法搭配使用)
/// HMAC-SHA1
+ (NSString *)hmacSHA1String:(NSString *)string hmacKey:(NSString *)key
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self hmacSHA1Data:data hmacKey:key];
    return result;
}

+ (NSString *)hmacSHA1Data:(NSData *)data hmacKey:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    const char *keyData = key.UTF8String;
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    // 进行HMAC-SHA摘要
    CCHmac(kCCHmacAlgSHA1, keyData, (CC_LONG)strlen(keyData), data.bytes, data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}


/// HMAC-SHA224
+ (NSString *)hmacSHA224String:(NSString *)string hmacKey:(NSString *)key
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self hmacSHA224Data:data hmacKey:key];
    return result;
}

+ (NSString *)hmacSHA224Data:(NSData *)data hmacKey:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    const char *keyData = key.UTF8String;
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA224_DIGEST_LENGTH];
    // 进行HMAC-SHA摘要
    CCHmac(kCCHmacAlgSHA224, keyData, (CC_LONG)strlen(keyData), data.bytes, data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// HMAC-SHA256
+ (NSString *)hmacSHA256String:(NSString *)string hmacKey:(NSString *)key
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self hmacSHA256Data:data hmacKey:key];
    return result;
}

+ (NSString *)hmacSHA256Data:(NSData *)data hmacKey:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    const char *keyData = key.UTF8String;
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    // 进行HMAC-SHA摘要
    CCHmac(kCCHmacAlgSHA256, keyData, (CC_LONG)strlen(keyData), data.bytes, data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// HMAC-SHA384
+ (NSString *)hmacSHA384String:(NSString *)string hmacKey:(NSString *)key
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self hmacSHA384Data:data hmacKey:key];
    return result;
}

+ (NSString *)hmacSHA384Data:(NSData *)data hmacKey:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    const char *keyData = key.UTF8String;
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA384_DIGEST_LENGTH];
    // 进行HMAC-SHA摘要
    CCHmac(kCCHmacAlgSHA384, keyData, (CC_LONG)strlen(keyData), data.bytes, data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

/// HMAC-SHA512
+ (NSString *)hmacSHA512String:(NSString *)string hmacKey:(NSString *)key
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self hmacSHA512Data:data hmacKey:key];
    return result;
}

+ (NSString *)hmacSHA512Data:(NSData *)data hmacKey:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    const char *keyData = key.UTF8String;
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    // 进行HMAC-SHA摘要
    CCHmac(kCCHmacAlgSHA512, keyData, (CC_LONG)strlen(keyData), data.bytes, data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写SHA，大写X表示输出的是大写SHA
    }
    return [result copy];
}

@end
