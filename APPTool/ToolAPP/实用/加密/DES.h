//
//  DES.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//  适合大量数据加密，在特定硬件下可能比AES快 安全性不如AES。推荐使用AES

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DES : NSObject

/// DES 对key、iv的长度没有限制

#pragma mark - DES 安全性较差，推荐使用3DES
#pragma mark CBC模式，安全性更高
/// DES CBC加密
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;
/// DES CBC解密
+ (NSData *)decryptData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

#pragma mark - ECB模式，并行计算，加密效率更高，但安全性低于CBC
/// DES ECB加密
+ (NSString *)encryptDataECB:(NSString *)string key:(NSString *)key;
/// DES ECB解密
+ (NSString *)decryptDataECB:(NSString *)string key:(NSString *)key;


#pragma mark - 3DES
#pragma mark CBC模式，安全性更高
/// 3DES CBC加密
+ (NSData *)encrypt3DESData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;
/// 3DES CBC解密
+ (NSData *)decrypt3DESData:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

#pragma mark - ECB模式，并行计算，加密效率更高，但安全性低于CBC
/// 3DES ECB加密
+ (NSData *)encrypt3DESDataECB:(NSData *)data key:(NSString *)key;
/// 3DES ECB解密
+ (NSData *)decrypt3DESDataECB:(NSData *)data key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
