//
//  NSMutableAttributedString+Emoji.m
//  WenMingShuo
//
//  Created by Six on 16/3/7.
//  Copyright © 2016年 Six. All rights reserved.
//

#import "NSMutableAttributedString+Emoji.h"
#import <UIKit/UIKit.h>
//#import "TOEmojiTextAttachment.h"
//#import "TOEmojiFaceView.h"

@implementation NSMutableAttributedString (Emoji)

+ (instancetype)returnEmojiStrWithText:(NSString *)text
{
    if (!text)
    {
        return nil;
    }
    
    static dispatch_once_t onceT;
    static NSRegularExpression * regularExpression = nil;
    dispatch_once(&onceT, ^{
        NSString * pattern = @"\\[\\:(\\w+)\\]";
        regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedStr beginEditing];
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedStr addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle , NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(0, [attributedStr length])];
    [attributedStr endEditing];
    return attributedStr;
}
+ (instancetype)returnKeepingStrWithText:(NSString *)text Font:(double)font{
    
    if (!text)
    {
        return nil;
    }
    static dispatch_once_t onceT;
    static NSRegularExpression * regularExpression = nil;
    dispatch_once(&onceT, ^{
        NSString * pattern = @"\\[\\:(\\w+)\\]";
        regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedStr beginEditing];
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedStr addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle , NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(0, [attributedStr length])];
    [attributedStr endEditing];
    return attributedStr;
}


@end
