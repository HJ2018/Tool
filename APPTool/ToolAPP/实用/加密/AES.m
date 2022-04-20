//
//  AES.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "AES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation AES
#pragma mark - MD5
/// MD5加密Data（MD5加密方法一）
+ (NSString *)MD5String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    const char *chars = string.UTF8String;
    // 创建摘要数组，存储加密结果
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // 进行MD5加密
    CC_MD5(chars, (CC_LONG)strlen(chars), digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [result copy];
}

#pragma mark - 默认Key、IV处理
/// 将任意长度key，转为加密方式指定长度的key
/// AES128 key:原值MD5,取(5,16)，MD5是大写
+ (NSString *)md5AES128key:(NSString *)key
{
    NSString *result = [[self MD5String:key] substringWithRange:NSMakeRange(5, 16)];
    return result;
}

/// AES192 key:原值MD5,取(5,24)，MD5是大写
+ (NSString *)md5AES192key:(NSString *)key
{
    NSString *result = [[self MD5String:key] substringWithRange:NSMakeRange(5, 24)];
    return result;
}

/// AES256 key:原值MD5，MD5是大写
+ (NSString *)md5AES256key:(NSString *)key
{
    NSString *result = [self MD5String:key];
    return result;
}

/// 将任意长度iv，转为加密方式指定长度的iv
/// iv:原值MD5,取(5,16)，MD5是大写
+ (NSString *)md5IV:(NSString *)iv
{
    NSString *result = [[self MD5String:iv] substringWithRange:NSMakeRange(5, 16)];
    return result;
}

#pragma mark - AES
#pragma mark CBC模式，多平台通用，安全性更高
/// AES CBC加密
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *result = [self aesCBC:kCCEncrypt data:data key:key iv:iv];
    return result;
}

/// AES CBC解密
+ (NSData *)decryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *result = [self aesCBC:kCCDecrypt data:data key:key iv:iv];
    return result;
}

/// AES CBC模式
+ (NSData *)aesCBC:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    if (data == nil || key.length == 0 || iv.length == 0) {
        return nil;
    }

    const char *aesKey = key.UTF8String;
    const char *aesIV = iv.UTF8String;
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          aesKey,
                                          strlen(aesKey),
                                          aesIV,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
    }

    free(buffer);
    return result;
}

#pragma mark - ECB模式，并行计算，加密效率更高，但安全性低于CBC
/// AES ECB加密
+ (NSData *)encryptDataECB:(NSData *)data key:(NSString *)key
{
    NSData *result = [self aesECB:kCCEncrypt data:data key:key];
    return result;
}

/// AES ECB解密
+ (NSData *)decryptDataECB:(NSData *)data key:(NSString *)key
{
    NSData *result = [self aesECB:kCCDecrypt data:data key:key];
    return result;
}

/// AES ECB加密
+ (NSData *)aesECB:(CCOperation)operation data:(NSData *)data key:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    
    const char *aesKey = key.UTF8String;
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          aesKey,
                                          strlen(aesKey),
                                          NULL,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
    }

    free(buffer);
    return result;
}

@end

