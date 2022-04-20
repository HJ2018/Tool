//
//  Hash.m
//  
//
//  Created by 刘鹏i on 2020/7/23.
//  Copyright © 2020 liu. All rights reserved.
//

#import "Hash.h"

@implementation Hash

/// java中的hash算法
+ (int)javaHashCode:(NSString *)str {
    int hash = 0;
    for (int i = 0; i<[str length]; i++) {
        NSString *s = [str substringWithRange:NSMakeRange(i, 1)];
        char *unicode = (char *)[s cStringUsingEncoding:NSUnicodeStringEncoding];
        int charactorUnicode = 0;
        size_t length = strlen(unicode);
        for (int n = 0; n < length; n ++) {
            charactorUnicode += (int)((unicode[n] & 0xff) << (n * sizeof(char) * 8));
        }
        hash = hash * 31 + charactorUnicode;
    }
    
    return hash;
}

@end
