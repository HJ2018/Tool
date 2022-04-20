//
//  RSA.h
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// RSA加密、解密填充方式
typedef NS_ENUM(NSUInteger, RSAPaddingType) {
    RSAPaddingType_None,    ///<  kSecPaddingNone  = 0, 不填充，最大数据块为 blockSize
    RSAPaddingType_PKCS1,   ///<  kSecPaddingPKCS1 = 1, 最大数据块为 blockSize -11 （推荐）
    RSAPaddingType_OAEP,    ///<  kSecPaddingOAEP  = 2, 最大数据块为 blockSize -42
};

/// RSA签名、验签填充方式
typedef NS_ENUM(NSUInteger, RSASecPaddingType) {
    RSASecPaddingType_None,         ///<  kSecPaddingNone         签名未Hash加密
    RSASecPaddingType_PKCS1,        ///<  kSecPaddingPKCS1        签名未Hash加密
    RSASecPaddingType_PKCS1SHA1,    ///<  kSecPaddingPKCS1SHA1    签名经过SHA1加密
    RSASecPaddingType_PKCS1SHA224,  ///<  kSecPaddingPKCS1SHA224  签名经过SHA224加密
    RSASecPaddingType_PKCS1SHA256,  ///<  kSecPaddingPKCS1SHA256  签名经过SHA256加密（推荐）
    RSASecPaddingType_PKCS1SHA384,  ///<  kSecPaddingPKCS1SHA384  签名经过SHA384加密
    RSASecPaddingType_PKCS1SHA512,  ///<  kSecPaddingPKCS1SHA512  签名经过SHA512加密
    /*
     SigRaw 暂时不能签名。使用的DSA算法，很少使用
     PKCS1MD2 、PKCS1MD5 被弃用了，所以不使用
     */
};

@interface RSA : NSObject
#pragma mark - SecKey 加载密钥
/*
 推荐使用字符串的方式，提取密钥
 因为将证书文件、密钥文件、pem文件在客户端不安全，所以不推荐使用后两种方式提取密钥
 */

/// 从字符串中提取公钥
+ (SecKeyRef )publicKeyFromString:(NSString *)key API_AVAILABLE(ios(10.0));
/// 从字符串中提取私钥
+ (SecKeyRef )privateKeyFromString:(NSString *)key API_AVAILABLE(ios(10.0));

/// 从pem文件中提取公钥
+ (SecKeyRef )publicKeyFromPem:(NSString *)filePath API_AVAILABLE(ios(10.0));
/// 从pem文件中提取私钥
+ (SecKeyRef )privateKeyFromPem:(NSString *)filePath API_AVAILABLE(ios(10.0));

/// 从证书中读取公钥（cer、der、crt）
+ (SecKeyRef )publicKeyFromCer:(NSString *)filePath;
/// 从p12文件中读取私钥
+ (SecKeyRef )privateKeyFromP12:(NSString *)filePath password:(NSString *)pwd;

#pragma mark - Crypto 加密、解密
/*
 一般情况都是：
 公钥加密，私钥解密
 私钥签名，公钥验签
 */
/// RSA 公钥加密（旧的方法，不推荐） 👌兼容PHP
+ (NSData *)encryptData:(NSData *)data publicKey:(SecKeyRef)keyRef type:(RSAPaddingType)type;
/// RSA 私钥解密（旧的方法，不推荐） 👌兼容PHP
+ (NSData *)decryptData:(NSData *)data privateKey:(SecKeyRef)keyRef type:(RSAPaddingType)type;
/// RSA 公钥加密（iOS 10.0 之后的新方法） 👌兼容PHP
+ (NSData *)encryptedData:(NSData *)data publicKey:(SecKeyRef)keyRef type:(RSAPaddingType)type API_AVAILABLE(ios(10.0));
/// RSA 私钥解密（iOS 10.0 之后的新方法） 👌兼容PHP
+ (NSData *)decryptedData:(NSData *)data privateKey:(SecKeyRef)keyRef type:(RSAPaddingType)type API_AVAILABLE(ios(10.0));


/*
 但是发现私钥签名后还能解密，所以就有了下面的，私钥加密，公钥解密
 其实就是私钥签名后公钥解密，这里签名作为加密，由于只能选择None、PKCS1中一种模式，所以就固定为PKCS1
 */
/// RSA 私钥加密（就是私钥签名，使用PKCS1） 👌兼容PHP
+ (NSData *)encryptData:(NSData *)data privateKey:(SecKeyRef)keyRef;
/// RSA 公钥解密（使用None） 👌兼容PHP
+ (NSData *)decryptData:(NSData *)data publicKey:(SecKeyRef)keyRef;

#pragma mark - Signature 签名、验签
/// 私钥签名（旧的方法，不推荐） 👻PHP不兼容，ios自己用没问题
+ (NSData *)signData:(NSData *)data privateKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType;
/// 公钥验签（旧的方法，不推荐） 👻PHP不兼容，ios自己用没问题
+ (BOOL)verifySign:(NSData *)signData withData:(NSData *)data publicKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType;

/// 私钥签名（iOS 10.0 之后的新方法） 👌兼容PHP
+ (NSData *)signatureData:(NSData *)data privateKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType API_AVAILABLE(ios(10.0));
/// 公钥验签（iOS 10.0 之后的新方法） 👌兼容PHP
+ (BOOL)verifySignature:(NSData *)signature withData:(NSData *)data publicKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType  API_AVAILABLE(ios(10.0));

@end

NS_ASSUME_NONNULL_END

/*
 ios端生成密钥方法（不是很重要了，很多网站都可以直接生成PKCS8密钥对）
 提取密钥的方法，支持提取PKCS1、PKCS8两种格式的密钥对
 PKCS1 在ios中是p12、der、cer格式的文件，文件放程序中有泄漏的风险，所以不太推荐（当然也可以将文件中的二进制作为字符串写到程序中，但还是不方便）
 PKCS8 在ios中是pem文件，不过可以直接将文件中的Base64格式字符串拿出来用，可读性强些，也更通用些
 所以用下面方法中生成的PKCS8格式密钥字符串，或者用网站生成的PKCS8格式密钥字符串都行。（网站如http://www.metools.info/code/c80.html）
 不过用网站生成的密钥不知道安不安全，万一网站每次生成的数据都被黑客存进数据库就不安全了

 x509 通用证书格式
 
 1.生成私钥 （推荐密钥长度2048，可以选512 1024 2048 4096）
 openssl genrsa -out private_key.pem 2048

 2.生成证书请求文件（可全部不填，直接回车）
 openssl req -new -key private_key.pem -out rsaCerReq.csr

 3.生成证书（设置有效时间为10年）
 openssl x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt


 4.生成供iOS使用的公钥文件（将公钥） PKCS1
 openssl x509 -outform der -in rsaCert.crt -out ios_public_key.der

 5.生成供iOS使用的私钥文件 （可以不设导出密码） PKCS1
 openssl pkcs12 -export -out ios_private_key.p12 -inkey private_key.pem -in rsaCert.crt


 6.生成供Java使用的公钥 PKCS8
 openssl rsa -in private_key.pem -out server_public_key.pem -pubout

 7.生成供Java使用的私钥 PKCS8
 openssl pkcs8 -topk8 -in private_key.pem -out server_private_key.pem -nocrypt
 
 上面生成的 PKCS1、PKCS8两套密钥，实际上是一套，只是文件格式不同罢了，他们可以互相转换
 第4步PKCS1私钥 == 第6步PKCS8私钥
 第5步PKCS1公钥 == 第7步PKCS8公钥
*/
