//
//  UIImage+scale.h
//  BangBang
//
//  Created by lottak_mac2 on 16/5/20.
//  Copyright © 2016年 Lottak. All rights reserved.
//

@import UIKit;

/**最大图片大小*/
#define MaXPicSize (200 * 1024)

@interface UIImage (scale)

/**
 颜色生成图片

 @param color 颜色
 @return 图片对象
 */
+ (id)colorImg:(UIColor*)color;

/**
 颜色生成指定大小图片

 @param color 颜色
 @param size 大小
 @return 图片对象
 */
+ (id)colorImg:(UIColor*)color size:(CGSize)size;

/**
 尺寸压缩，质量不变

 @param size 限制的大小
 @return 压缩后的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 质量压缩，尺寸不变，可能压缩不到你要的大小，因为没办法到那么小 这时候你就需要调用尺寸压缩了

 @param bytes 限制的大小
 @return 压缩后的结果
 */
- (NSData *)dataInNoSacleLimitBytes:(NSInteger)bytes;

/**
 裁剪图片 取中上部分

 @param size 图片大小
 @return 剪切后的图片
 */
- (UIImage *)cutToSize:(CGSize)size;

@end
