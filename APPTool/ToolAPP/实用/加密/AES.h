//
//  AES.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//  速度更快、更安全

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES : NSObject
/// key为秘钥，iv为初始向量（CBC模式有，ECB模式没有）
///
/// 根据传入的key的长度不同，加密模式也不同
/// AES128 key:128位（字符串16位）iv:128位（字符串16位）
/// AES192 key:192位（字符串24位）iv:128位（字符串16位）
/// AES256 key:256位（字符串32位）iv:128位（字符串16位）
///
/// 可以约定key、iv的hash处理方式，使得任意长度秘钥、初始向量都可以得到统一长度字符串
/// AES128 key:原值MD5,取(5,16)  iv:原值MD5,取(5,16)
/// AES192 key:原值MD5,取(5,24)  iv:原值MD5,取(5,16)
/// AES256 key:原值MD5           iv:原值MD5,取(5,16)
/// MD5是大写
/// 由于Range是从0开始计算的，所以实际是从第6位开始，取16位长度

/// 将任意长度key，转为加密方式指定长度的key
/// AES128 key:原值MD5,取(5,16)，MD5是大写
+ (NSString *)md5AES128key:(NSString *)key;
/// AES192 key:原值MD5,取(5,24)，MD5是大写
+ (NSString *)md5AES192key:(NSString *)key;
/// AES256 key:原值MD5，MD5是大写
+ (NSString *)md5AES256key:(NSString *)key;

/// 将任意长度iv，转为加密方式指定长度的iv
/// iv:原值MD5,取(5,16)，MD5是大写。（其实iv只要是16的倍数即可）
+ (NSString *)md5IV:(NSString *)iv;

#pragma mark - CBC模式，多平台通用，安全性更高
/// AES CBC加密 (key长度必须为16、24、32，iv长度必须为16)
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

/// AES CBC解密 (key长度必须为16、24、32，iv长度必须为16)
+ (NSData *)decryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

#pragma mark - ECB模式，并行计算，加密效率更高，不需要iv，但安全性低于CBC，适合本地存储加密
/// AES ECB加密 (key长度必须为16、24、32，iv长度必须为16)
+ (NSData *)encryptDataECB:(NSData *)data key:(NSString *)key;

/// AES ECB解密 (key长度必须为16、24、32，iv长度必须为16)
+ (NSData *)decryptDataECB:(NSData *)data key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
