//
//  MD5.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MD5
#pragma mark - MD5
/// MD5摘要字符串
+ (NSString *)MD5String:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self MD5Data:data];
    return result;
}

/// MD5摘要Data（MD5摘要方法一）
+ (NSString *)MD5Data:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // 也可以定义一个字节数组来接收计算得到的MD5值
    // Byte digest[CC_MD5_DIGEST_LENGTH];
    // 进行MD5摘要
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [result copy];
}

/// MD5摘要方法二 (暂时不用，可以用来验证下面文件MD5方法的正确性)
+ (NSString *)MD5WithData:(NSData *)data
{
    // 效率上与方法一几乎无差别，10万次摘要，相差0.02s
    if (data == nil) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [result copy];
}

#pragma mark - HMAC-MD5 更安全的MD5方式，双方共有一个密钥
/// HMAC-MD5摘要字符串
+ (NSString *)hmacMD5String:(NSString *)string hmacKey:(NSString *)key
{
    if (string.length == 0) {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [self hmacMD5Data:data hmacKey:key];
    return result;
}

/// HMAC-MD5摘要Data
+ (NSString *)hmacMD5Data:(NSData *)data hmacKey:(NSString *)key
{
    if (data == nil || key.length == 0) {
        return nil;
    }
    const char *keyData = key.UTF8String;
    // 创建摘要数组，存储摘要结果
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // 也可以定义一个字节数组来接收计算得到的MD5值
    // Byte digest[CC_MD5_DIGEST_LENGTH];
    // 进行HMAC-MD5摘要
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), data.bytes, (CC_LONG)data.length, digest);
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [result copy];
}

#pragma mark - 文件MD5
/// 文件MD5
+ (NSString *)fileMD5WithPath:(NSString *)filePath
{
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    
    
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    CC_MD5_CTX hashObject;
    // Initialize the hash object
    CC_MD5_Init(&hashObject);
    
    // 每次读100k
    size_t chunkSizeForReadingData = 1024 * 100;
    
    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    
    NSString *ret = (__bridge_transfer NSString *)result;
    return ret;
}

/// 文件MD5（方案二，暂时不用，比一稍微慢一些，如果设置的每次文件读取数据很小，耗时可能是方案一的3倍）
+ (NSString *)calculateFileMd5WithFilePath:(NSString *)filePath
{
    // 取文件
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle == nil ) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        // 每次读100k
        NSData *fileData = [handle readDataOfLength: 1024 * 100];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if([fileData length] == 0) {
            done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    // 输出为字符串
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return result;
}

@end
