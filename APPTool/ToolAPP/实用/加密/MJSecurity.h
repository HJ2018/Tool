//
//  MJSecurity.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJSecurity : NSObject

// AES加密 RSA验签

#pragma mark - Base64
/// 转为Base64编码的String
+ (NSString *)Base64String:(NSString *)string;
+ (NSString *)Base64Data:(NSData *)data;
/// 解码Base64为String
+ (NSString *)decodeBase64String:(NSString *)string;
+ (NSData *)dataFromDecodeBase64String:(NSString *)string;

#pragma mark - Java Hash
/// java中的hash算法
+ (int)javaHashCode:(NSString *)str;

#pragma mark - MD5
/// MD5加密
+ (NSString *)MD5String:(NSString *)string;
+ (NSString *)MD5Data:(NSData *)data;
/// 文件MD5
+ (NSString *)fileMD5WithPath:(NSString *)filePath;
/// 更安全的MD5方式，双方共有一个密钥，确保MD5不被破解
+ (NSString *)hmacMD5String:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacMD5Data:(NSData *)data hmacKey:(NSString *)key;

#pragma mark - SHA
/// 默认为 SHA256
/// SHA加密
+ (NSString *)SHAString:(NSString *)string;
+ (NSString *)SHAData:(NSData *)data;
/// 更安全的SHA方式，双方共有一个密钥，确保SHA不被破解（默认SHA256）
+ (NSString *)hmacSHAString:(NSString *)string hmacKey:(NSString *)key;
+ (NSString *)hmacSHAData:(NSData *)data hmacKey:(NSString *)key;

#pragma mark - AES
/// 默认为 AES256 CBC PKCS7Padding(等同于其他平台PKCS5Padding)，多平台通用
/// AES 加密
+ (NSData *)AESEncryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;
/// AES 解密
+ (NSData *)AESDecryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

#pragma mark - RSA
/// 默认为 RSA PKCS1，多平台通用
/// RSA 公钥加密
+ (NSData *)RSAEncryptData:(NSData *)data publicKey:(NSString *)key API_AVAILABLE(ios(10.0));
/// RSA 私钥解密
+ (NSData *)RSADecryptData:(NSData *)data privateKey:(NSString *)key API_AVAILABLE(ios(10.0));

/// 默认为 RSA PKCS1 SHA256，多平台通用
/// 私钥签名
+ (NSData *)RSASignatureData:(NSData *)data privateKey:(NSString *)key API_AVAILABLE(ios(10.0));
/// 公钥验签
+ (BOOL)RSAVerifySignature:(NSData *)signature withData:(NSData *)data publicKey:(NSString *)key API_AVAILABLE(ios(10.0));

@end

NS_ASSUME_NONNULL_END
