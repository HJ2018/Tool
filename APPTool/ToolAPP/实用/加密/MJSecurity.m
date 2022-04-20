//
//  MJSecurity.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "MJSecurity.h"
#import "Base64.h"
#import "Hash.h"
#import "MD5.h"
#import "SHA.h"
#import "AES.h"
#import "RSA.h"

@implementation MJSecurity

#pragma mark - Base64
/// 转为Base64编码的String
+ (NSString *)Base64String:(NSString *)string
{
    return [Base64 encodeString:string];
}

+ (NSString *)Base64Data:(NSData *)data
{
    return [Base64 encodeData:data];
}

/// 解码Base64为String
+ (NSString *)decodeBase64String:(NSString *)string
{
    return [Base64 decodeBase64String:string];
}

+ (NSData *)dataFromDecodeBase64String:(NSString *)string
{
    return [Base64 dataFromDecodeBase64String:string];
}

#pragma mark - Java Hash
/// java中的hash算法
+ (int)javaHashCode:(NSString *)str
{
    return [Hash javaHashCode:str];
}

#pragma mark - MD5
/// MD5加密
+ (NSString *)MD5String:(NSString *)string
{
    return [MD5 MD5String:string];
}

+ (NSString *)MD5Data:(NSData *)data
{
    return [MD5 MD5Data:data];
}

/// 文件MD5
+ (NSString *)fileMD5WithPath:(NSString *)filePath
{
    return [MD5 fileMD5WithPath:filePath];
}

/// 更安全的MD5方式，双方共有一个密钥，确保MD5不被破解
+ (NSString *)hmacMD5String:(NSString *)string hmacKey:(NSString *)key
{
    return [MD5 hmacMD5String:string hmacKey:key];
}

+ (NSString *)hmacMD5Data:(NSData *)data hmacKey:(NSString *)key
{
    return [MD5 hmacMD5Data:data hmacKey:key];
}

#pragma mark - SHA
/// SHA加密，默认SHA256
+ (NSString *)SHAString:(NSString *)string
{
    return [SHA SHA256String:string];
}

+ (NSString *)SHAData:(NSData *)data
{
    return [SHA SHA256Data:data];
}

/// HMAC-SHA加密，默认HMAC-SHA256
+ (NSString *)hmacSHAString:(NSString *)string hmacKey:(NSString *)key
{
    return [SHA hmacSHA256String:string hmacKey:key];
}

+ (NSString *)hmacSHAData:(NSData *)data hmacKey:(NSString *)key
{
    return [SHA hmacSHA256Data:data hmacKey:key];
}

#pragma mark - AES
/// 默认为 AES256 CBC PKCS7Padding(等同于其他平台PKCS5Padding)，多平台通用
/// AES256 CBC加密
+ (NSData *)AESEncryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    return [AES encryptData:data key:[AES md5AES256key:key] iv:[AES md5IV:iv]];
}

/// AES256 CBC解密
+ (NSData *)AESDecryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    return [AES decryptData:data key:[AES md5AES256key:key] iv:[AES md5IV:iv]];
}

#pragma mark - RSA
/// RSA 公钥加密
+ (NSData *)RSAEncryptData:(NSData *)data publicKey:(NSString *)key API_AVAILABLE(ios(10.0))
{
    SecKeyRef keyRef = [RSA publicKeyFromString:key];
    NSData *enData = [RSA encryptedData:data publicKey:keyRef type:RSAPaddingType_PKCS1];
    return enData;
}

/// RSA 私钥解密
+ (NSData *)RSADecryptData:(NSData *)data privateKey:(NSString *)key API_AVAILABLE(ios(10.0))
{
    SecKeyRef keyRef = [RSA privateKeyFromString:key];
    NSData *deData = [RSA decryptedData:data privateKey:keyRef type:RSAPaddingType_PKCS1];
    return deData;
}

/// 私钥签名
+ (NSData *)RSASignatureData:(NSData *)data privateKey:(NSString *)key API_AVAILABLE(ios(10.0))
{
    SecKeyRef keyRef = [RSA privateKeyFromString:key];
    NSData *signature = [RSA signatureData:data privateKey:keyRef secType:RSASecPaddingType_PKCS1SHA256];
    return signature;
}

/// 公钥验签
+ (BOOL)RSAVerifySignature:(NSData *)signature withData:(NSData *)data publicKey:(NSString *)key API_AVAILABLE(ios(10.0))
{
    SecKeyRef keyRef = [RSA publicKeyFromString:key];
    BOOL verified = [RSA verifySignature:signature withData:data publicKey:keyRef secType:RSASecPaddingType_PKCS1SHA256];
    return verified;
}

@end
