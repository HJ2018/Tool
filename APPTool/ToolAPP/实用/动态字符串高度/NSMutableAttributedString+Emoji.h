//
//  NSMutableAttributedString+Emoji.h
//  WenMingShuo
//
//  Created by Six on 16/3/7.
//  Copyright © 2016年 Six. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Emoji)

+ (instancetype)returnEmojiStrWithText:(NSString *)text;


+ (instancetype)returnKeepingStrWithText:(NSString *)text Font:(double)font;


@end
