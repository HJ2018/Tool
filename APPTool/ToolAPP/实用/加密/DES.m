//
//  DES.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "DES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation DES
#pragma mark - DES
#pragma mark CBC模式，安全性更高
/// DES CBC加密
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *result = [self desCrypt:kCCEncrypt algorithm:kCCAlgorithmDES mode:kCCOptionPKCS7Padding data:data key:key iv:iv];
    return result;
}

/// DES CBC解密
+ (NSData *)decryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *result = [self desCrypt:kCCDecrypt algorithm:kCCAlgorithmDES mode:kCCOptionPKCS7Padding data:data key:key iv:iv];
    return result;
}

#pragma mark - ECB模式，并行计算，加密效率更高，但安全性低于CBC
/// DES ECB加密
+ (NSString *)encryptDataECB:(NSString *)string key:(NSString *)key;
{
    NSData *contentData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self desCrypt:kCCEncrypt algorithm:kCCAlgorithmDES mode:kCCOptionPKCS7Padding|kCCOptionECBMode data:contentData key:key iv:NULL];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];;
}

/// DES ECB解密
+ (NSString *)decryptDataECB:(NSString *)string key:(NSString *)key
{
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *result = [self desCrypt:kCCDecrypt algorithm:kCCAlgorithmDES mode:kCCOptionPKCS7Padding|kCCOptionECBMode data:contentData key:key iv:NULL];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}


#pragma mark - 3DES
#pragma mark CBC模式，安全性更高
/// 3DES CBC加密
+ (NSData *)encrypt3DESData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *result = [self desCrypt:kCCEncrypt algorithm:kCCAlgorithm3DES mode:kCCOptionPKCS7Padding data:data key:key iv:iv];
    return result;
}

/// 3DES CBC解密
+ (NSData *)decrypt3DESData:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    NSData *result = [self desCrypt:kCCDecrypt algorithm:kCCAlgorithm3DES mode:kCCOptionPKCS7Padding data:data key:key iv:iv];
    return result;
}

#pragma mark - ECB模式，并行计算，加密效率更高，但安全性低于CBC
/// 3DES ECB加密
+ (NSData *)encrypt3DESDataECB:(NSData *)data key:(NSString *)key
{
    NSData *result = [self desCrypt:kCCEncrypt algorithm:kCCAlgorithm3DES mode:kCCOptionPKCS7Padding|kCCOptionECBMode data:data key:key iv:NULL];
    return result;
}

/// 3DES ECB解密
+ (NSData *)decrypt3DESDataECB:(NSData *)data key:(NSString *)key
{
    NSData *result = [self desCrypt:kCCDecrypt algorithm:kCCAlgorithm3DES mode:kCCOptionPKCS7Padding|kCCOptionECBMode data:data key:key iv:NULL];
    return result;
}



/// DES
+ (NSData *)desCrypt:(CCOperation)operation algorithm:(CCAlgorithm)algorithm mode:(CCOptions)mode data:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    
    if (!(mode & kCCOptionECBMode)) {
        if (iv.length == 0) {
            return nil;
        }
    }
    
    const char *aesKey = key.UTF8String;
    const char *aesIV = iv.UTF8String;
    if (mode & kCCOptionECBMode) {
        aesIV = NULL;
    }
    
    size_t keySize = algorithm == kCCAlgorithm3DES? kCCKeySize3DES: kCCKeySizeDES;
    size_t blockSize = algorithm == kCCAlgorithm3DES? kCCBlockSize3DES: kCCBlockSizeDES;
    size_t bufferSize = [data length] +  blockSize;
    void *buffer = malloc(bufferSize);
    
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          algorithm,
                                          mode,
                                          aesKey,
                                          keySize,
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
@end
