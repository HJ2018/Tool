//
//  Base64.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "Base64.h"

@implementation Base64
#pragma mark - Base64编码
/// 转为Base64编码的String
+ (NSString *)encodeData:(NSData *)data
{
    NSString *result = [data base64EncodedStringWithOptions:0];
    return result;
}

+ (NSString *)encodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [data base64EncodedStringWithOptions:0];
    return result;
}

/// 转为Base64编码的Data
+ (NSData *)dataFromEncodeData:(NSData *)data
{
    NSData *result = [data base64EncodedDataWithOptions:0];
    return result;
}

+ (NSData *)dataFromEncodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [data base64EncodedDataWithOptions:0];
    return result;
}

#pragma mark - Base64解码
/// 解码为String
+ (NSString *)decodeBase64Data:(NSData *)data
{
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedData:data options:0];
    NSString *result = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return result;
}

+ (NSString *)decodeBase64String:(NSString *)string
{
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *result = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return result;
}

/// 解码为Data
+ (NSData *)dataFromDecodeBase64Data:(NSData *)data
{
    NSData *result = [[NSData alloc] initWithBase64EncodedData:data options:0];
    return result;
}

+ (NSData *)dataFromDecodeBase64String:(NSString *)string
{
    NSData *result = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return result;
}

@end
