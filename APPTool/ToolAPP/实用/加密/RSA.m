//
//  RSA.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "RSA.h"
#import <Security/Security.h>

@implementation RSA
#pragma mark - Private
/// 转为系统的RSA加密、解密填充方式 （旧的）
+ (SecPadding)cryptoPaddingType:(RSAPaddingType)type
{
    SecPadding sysType;
    switch (type) {
        case RSAPaddingType_None:
            sysType = kSecPaddingNone;
            break;
        case RSAPaddingType_PKCS1:
            sysType = kSecPaddingPKCS1;
            break;
        case RSAPaddingType_OAEP:
            sysType = kSecPaddingOAEP;
            break;
        default:
            sysType = kSecPaddingPKCS1;
            break;
    }
    return sysType;
}

/// 转为系统的RSA签名、验签填充方式 （旧的）
+ (SecPadding)signaturePaddingType:(RSASecPaddingType)type
{
    SecPadding sysType;
    switch (type) {
        case RSASecPaddingType_None:
            sysType = kSecPaddingNone;
            break;
        case RSASecPaddingType_PKCS1:
            sysType = kSecPaddingPKCS1;
            break;
        case RSASecPaddingType_PKCS1SHA1:
            sysType = kSecPaddingPKCS1SHA1;
            break;
        case RSASecPaddingType_PKCS1SHA224:
            sysType = kSecPaddingPKCS1SHA224;
            break;
        case RSASecPaddingType_PKCS1SHA256:
            sysType = kSecPaddingPKCS1SHA256;
            break;
        case RSASecPaddingType_PKCS1SHA384:
            sysType = kSecPaddingPKCS1SHA384;
            break;
        case RSASecPaddingType_PKCS1SHA512:
            sysType = kSecPaddingPKCS1SHA512;
            break;
        default:
            sysType = kSecPaddingPKCS1;
            break;
    }
    return sysType;
}

/// 转为系统的RSA加密、解密填充方式 （新的）
+ (SecKeyAlgorithm)cryptoAlgorithmType:(RSAPaddingType)type
{
    SecKeyAlgorithm sysType;
    switch (type) {
        case RSAPaddingType_None:
            sysType = kSecKeyAlgorithmRSAEncryptionRaw;
            break;
        case RSAPaddingType_PKCS1:
            sysType = kSecKeyAlgorithmRSAEncryptionPKCS1;
            break;
        case RSAPaddingType_OAEP: // OAEP还有很多选择SHA1、SHA224、SHA256、SHA384、SHA512
            sysType = kSecKeyAlgorithmRSAEncryptionOAEPSHA1;
            break;
        default:
            sysType = kSecKeyAlgorithmRSAEncryptionPKCS1;
            break;
    }
    return sysType;
}

/// 转为系统的RSA签名、验签填充方式 （新的）
+ (SecKeyAlgorithm)signatureAlgorithmType:(RSASecPaddingType)type
{
    /*
     对应的类型还有kSecKeyAlgorithmRSASignatureDigestPKCS1v15SHA1等
     区别就是：
     SignatureDigest：需要传入自己Hash好的值
     SignatureMessage：系统自动会Hash
     */
    SecKeyAlgorithm sysType;
    switch (type) {
        case RSASecPaddingType_None:
            sysType = kSecKeyAlgorithmRSASignatureRaw;
            break;
        case RSASecPaddingType_PKCS1:
            sysType = kSecKeyAlgorithmRSASignatureDigestPKCS1v15Raw;
            break;
        case RSASecPaddingType_PKCS1SHA1:
            sysType = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA1;
            break;
        case RSASecPaddingType_PKCS1SHA224:
            sysType = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA224;
            break;
        case RSASecPaddingType_PKCS1SHA256:
            sysType = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA256;
            break;
        case RSASecPaddingType_PKCS1SHA384:
            sysType = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA384;
            break;
        case RSASecPaddingType_PKCS1SHA512:
            sysType = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA512;
            break;
        default:
            sysType = kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA1;
            break;
    }
    return sysType;
}

#pragma mark - SecKey 加载密钥
/*
 将密钥、证书、pem文件放在客户端不安全
 所以最好使用宏定义来存储pem中的字符串，来保存私钥、公钥
 
 网上有种提取密钥的方法，用到了keychain(SecItemCopyMatching)，但是对于越狱机来说keychain里面的值都能看到，所以不安全
 */

/// 从字符串中提取公钥
+ (SecKeyRef )publicKeyFromString:(NSString *)key API_AVAILABLE(ios(10.0))
{
    if (key.length == 0) {
        return nil;
    }
    
    NSArray *arrReplace = @[@"-----BEGIN PUBLIC KEY-----", @"-----END PUBLIC KEY-----", @"\n", @"\r", @"\t", @" "];
    for (NSString *str in arrReplace) {
        key = [key stringByReplacingOccurrencesOfString:str withString:@""];
    }
    
    NSData *dataKey = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSDictionary *dicKey = @{(__bridge id)kSecAttrKeyType        : (__bridge id)kSecAttrKeyTypeRSA,
                             (__bridge id)kSecAttrKeyClass       : (__bridge id)kSecAttrKeyClassPublic,
                            };
    CFErrorRef error = nil;
    SecKeyRef keyRef = SecKeyCreateWithData((__bridge CFDataRef)dataKey, (__bridge CFDictionaryRef)dicKey, &error);
    if (error) {
        NSLog(@"公钥加载错误");
    }
    return keyRef;
}

/// 从字符串中提取私钥
+ (SecKeyRef )privateKeyFromString:(NSString *)key API_AVAILABLE(ios(10.0))
{
    if (key.length == 0) {
        return nil;
    }
    
    // 是否为PKCS8格式密钥
    BOOL isPKCS8 = [key containsString:@"-----BEGIN PRIVATE KEY-----"];
    
    NSArray *arrReplace = @[@"-----BEGIN RSA PRIVATE KEY-----", @"-----END RSA PRIVATE KEY-----", @"-----BEGIN PRIVATE KEY-----", @"-----END PRIVATE KEY-----", @"\n", @"\r", @"\t", @" "];
    for (NSString *str in arrReplace) {
        key = [key stringByReplacingOccurrencesOfString:str withString:@""];
    }
    
    NSData *dataKey = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    if (isPKCS8) {
        // 剥离私钥头部
        dataKey = [self stripPrivateKeyHeader:dataKey];
        if(!dataKey){
            return nil;
        }
    }
    
    NSDictionary *dicKey = @{(__bridge id)kSecAttrKeyType        : (__bridge id)kSecAttrKeyTypeRSA,
                             (__bridge id)kSecAttrKeyClass       : (__bridge id)kSecAttrKeyClassPrivate,
//                             (__bridge id)kSecAttrKeySizeInBits  : @((size_t)1024)  // 如果是PKCS1格式的，可能需要这一行，1024可能与创建证书时的密钥长度有关
                            };
    CFErrorRef error = nil;
    SecKeyRef keyRef = SecKeyCreateWithData((__bridge CFDataRef)dataKey, (__bridge CFDictionaryRef)dicKey, &error);
    if (error) {
        NSLog(@"私钥加载错误");
        // PKCS1失败，尝试再用PKCS8解一遍
        if (isPKCS8 == NO) {
            dataKey = [self stripPrivateKeyHeader:dataKey];
            if(!dataKey){
                return nil;
            }
            keyRef = SecKeyCreateWithData((__bridge CFDataRef)dataKey, (__bridge CFDictionaryRef)dicKey, &error);
        }
    }
    return keyRef;
}

/// 从pem文件中提取公钥
+ (SecKeyRef )publicKeyFromPem:(NSString *)filePath API_AVAILABLE(ios(10.0))
{
    if (filePath.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSString *strPem = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&error];
    if (error) {
        NSLog(@"pem文件加载失败");
        return nil;
    }
    SecKeyRef keyRef = [self publicKeyFromString:strPem];
    return keyRef;
}

/// 从pem文件中提取公钥
+ (SecKeyRef )privateKeyFromPem:(NSString *)filePath API_AVAILABLE(ios(10.0))
{
    if (filePath.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSString *strPem = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:&error];
    if (error) {
        NSLog(@"pem文件加载失败");
        return nil;
    }
    SecKeyRef keyRef = [self privateKeyFromString:strPem];
    return keyRef;
}

/// 从证书中读取公钥（cer、der、crt）
+ (SecKeyRef )publicKeyFromCer:(NSString *)filePath
{
    if (filePath.length == 0) {
        return nil;
    }
    
    OSStatus            err;
    NSData *            certData;
    SecCertificateRef   cert;
    SecPolicyRef        policy;
    SecTrustRef         trust;
    SecTrustResultType  trustResult;
    SecKeyRef           publicKeyRef;
    
    certData = [NSData dataWithContentsOfFile:filePath];
    cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
    policy = SecPolicyCreateBasicX509();
    err = SecTrustCreateWithCertificates(cert, policy, &trust);
    if (err != errSecSuccess) {
        NSLog(@"证书加载失败");
        return nil;
    }
    err = SecTrustEvaluate(trust, &trustResult);
    if (err != errSecSuccess) {
        NSLog(@"公钥加载失败");
        return nil;
    }
    publicKeyRef = SecTrustCopyPublicKey(trust);
    
    CFRelease(policy);
    CFRelease(cert);
    return publicKeyRef;
}

/// 从p12文件中读取私钥
+ (SecKeyRef )privateKeyFromP12:(NSString *)filePath password:(NSString *)pwd
{
    if (filePath.length == 0) {
        return nil;
    }
    
    NSData *            pkcs12Data;
    CFArrayRef          imported;
    NSDictionary *      importedItem;
    SecIdentityRef      identity;
    OSStatus            err;
    SecKeyRef           privateKeyRef;

    pkcs12Data = [NSData dataWithContentsOfFile:filePath];
    err = SecPKCS12Import((__bridge CFDataRef)pkcs12Data,(__bridge CFDictionaryRef) @{(__bridge NSString *)kSecImportExportPassphrase:pwd}, &imported);
    if (err != errSecSuccess) {
        NSLog(@"p12加载失败");
        return nil;
    }
    importedItem = (__bridge NSDictionary *)CFArrayGetValueAtIndex(imported, 0);
    identity = (__bridge SecIdentityRef) importedItem[(__bridge NSString *)kSecImportItemIdentity];
    
    err = SecIdentityCopyPrivateKey(identity, &privateKeyRef);
    if (err != errSecSuccess) {
        NSLog(@"私钥加载失败");
        return nil;
    }
    CFRelease(imported);
    return privateKeyRef;
}

/// PKCS8格式私钥，需要跳过头部数据读取
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);

    unsigned long len = [d_key length];
    if (!len) return(nil);

    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22

    if (0x04 != c_key[idx++]) return nil;

    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }

    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

#pragma mark - Crypto 加密、解密
/// RSA 公钥加密（旧的方法，不推荐） 👌兼容PHP
+ (NSData *)encryptData:(NSData *)data publicKey:(SecKeyRef)keyRef type:(RSAPaddingType)type
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    size_t blockSize = SecKeyGetBlockSize(keyRef);
    uint8_t *encData = malloc(blockSize);
    bzero(encData, blockSize);
    SecPadding ptype = [self cryptoPaddingType:type];
    
    OSStatus ret = SecKeyEncrypt(keyRef, ptype, data.bytes, data.length, encData, &blockSize);
    NSData *retData = nil;
    if (ret == errSecSuccess) {
        retData = [NSData dataWithBytes:encData length:blockSize];
    }
    
    free(encData);
    encData = NULL;
    return retData;
}

/// RSA 私钥解密（旧的方法，不推荐） 👌兼容PHP
+ (NSData *)decryptData:(NSData *)data privateKey:(SecKeyRef)keyRef type:(RSAPaddingType)type
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    size_t blockSize = SecKeyGetBlockSize(keyRef);
    uint8_t *decData = malloc(blockSize);
    bzero(decData, blockSize);
    SecPadding ptype = [self cryptoPaddingType:type];
    
    OSStatus ret = SecKeyDecrypt(keyRef, ptype, data.bytes, data.length, decData, &blockSize);
    NSData *retData = nil;
    if (ret == errSecSuccess) {
        retData = [NSData dataWithBytes:decData length:blockSize];
    }
    
    free(decData);
    decData = NULL;
    return retData;
}

/// RSA 公钥加密（iOS 10.0 之后的新方法） 👌兼容PHP
+ (NSData *)encryptedData:(NSData *)data publicKey:(SecKeyRef)keyRef type:(RSAPaddingType)type API_AVAILABLE(ios(10.0))
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    SecKeyAlgorithm algorithm = [self cryptoAlgorithmType:type];
    CFErrorRef error = nil;
    CFDataRef dataRef = SecKeyCreateEncryptedData(keyRef, algorithm, (__bridge CFDataRef)data, &error);
    if (error) {
        return nil;
    }
    return (__bridge NSData *)dataRef;
}

/// RSA 私钥解密（iOS 10.0 之后的新方法） 👌兼容PHP
+ (NSData *)decryptedData:(NSData *)data privateKey:(SecKeyRef)keyRef type:(RSAPaddingType)type API_AVAILABLE(ios(10.0))
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    SecKeyAlgorithm algorithm = [self cryptoAlgorithmType:type];
    CFErrorRef error = nil;
    CFDataRef dataRef = SecKeyCreateDecryptedData(keyRef, algorithm, (__bridge CFDataRef)data, &error);
    if (error) {
        return nil;
    }
    NSData *retData = (__bridge NSData *)dataRef;
    
    // 去除数据中的前导0
    if (algorithm == kSecKeyAlgorithmRSAEncryptionRaw) {
        retData = [self removePerfixZero:retData];
    }
    return retData;
}


/// 去除数据中的前导0
+ (NSData *)removePerfixZero:(NSData *)data
{
    NSData *result = data;
    NSInteger index = NSNotFound;
    
    for (NSInteger i = 0; i < data.length; i++) {
        Byte byte = ((Byte *)data.bytes)[i];
        if (byte == 0) {
            index = i;
        } else {
            break;
        }
    }
    
    if (index != NSNotFound) {
        result = [data subdataWithRange:NSMakeRange(index + 1, data.length - index - 1)];
    }
    return result;
}

/// RSA 私钥加密（就是私钥签名，使用PKCS1） 👌兼容PHP
+ (NSData *)encryptData:(NSData *)data privateKey:(SecKeyRef)keyRef
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)data.bytes;
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = SecKeyRawSign(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != noErr) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/// RSA 公钥解密（使用None） 👌兼容PHP
+ (NSData *)decryptData:(NSData *)data publicKey:(SecKeyRef)keyRef
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != noErr) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

#pragma mark - Signature 签名、验签
/*
 签名：报文Hash + 用私钥加密 = 数字签名
 验签：数字签名 + 用公钥解密 = 报文Hash  然后接收方自己使用报文 + Hash = 算出的报文Hash  对比两个Hash
 */

/// 私钥签名（旧的方法，不推荐） 👻PHP不兼容，ios自己用没问题
+ (NSData *)signData:(NSData *)data privateKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    size_t blockSize = SecKeyGetBlockSize(keyRef);
    uint8_t *signData = malloc(blockSize);
    bzero(signData, blockSize);
    SecPadding type = [self signaturePaddingType:secType];

    OSStatus ret = SecKeyRawSign(keyRef, type, data.bytes, data.length, signData, &blockSize);
    NSData *retData = nil;
    if (ret == errSecSuccess) {
        retData = [NSData dataWithBytes:signData length:blockSize];
    }

    free(signData);
    signData = NULL;
    return retData;
}

/// 公钥验签（旧的方法，不推荐） 👻PHP不兼容，ios自己用没问题
+ (BOOL)verifySign:(NSData *)signData withData:(NSData *)data publicKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType
{
    if (signData == nil || keyRef == nil) {
        return nil;
    }
    
    SecPadding type = [self signaturePaddingType:secType];
    OSStatus ret = SecKeyRawVerify(keyRef, type, data.bytes, data.length,signData.bytes, signData.length);
    BOOL retStatus = NO;
    if (ret == errSecSuccess) {
        retStatus = YES;
    }
    return retStatus;
}

/// 私钥签名（iOS 10.0 之后的新方法） 👌兼容PHP
+ (NSData *)signatureData:(NSData *)data privateKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType API_AVAILABLE(ios(10.0))
{
    if (data == nil || keyRef == nil) {
        return nil;
    }
    
    SecKeyAlgorithm type = [self signatureAlgorithmType:secType];
    CFErrorRef error = nil;
    CFDataRef dataRef = SecKeyCreateSignature(keyRef, type, (__bridge CFDataRef)data, &error);
    if (error) {
        return nil;
    }
    return (__bridge NSData *)dataRef;
}

/// 公钥验签（iOS 10.0 之后的新方法） 👌兼容PHP
+ (BOOL)verifySignature:(NSData *)signature withData:(NSData *)data publicKey:(SecKeyRef)keyRef secType:(RSASecPaddingType)secType API_AVAILABLE(ios(10.0))
{
    if (signature == nil || keyRef == nil) {
        return nil;
    }
    
    SecKeyAlgorithm type = [self signatureAlgorithmType:secType];
    CFErrorRef error = nil;
    BOOL pass = SecKeyVerifySignature(keyRef, type, (__bridge CFDataRef)data, (__bridge CFDataRef)signature, &error);
    if (error) {
        return nil;
    }
    return pass;
}

@end

