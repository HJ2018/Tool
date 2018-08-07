//
//  NSDate+Format.h
//  business
//
//  Created by C.Maverick on 15/6/7.
//  Copyright (c) 2015年 C.Maverick. All rights reserved.
//

@import Foundation;

#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

#pragma mark -


/**
 时间格式化
 */
@interface NSDate (Format)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;


/**
 得到当天00:00时间

 @return 00:00时间
 */
- (NSDate*)firstTime;

/**
 得到当天23:59时间

 @return 23:59时间
 */
- (NSDate*)lastTime;

/**
 字符串生成NSDate对象

 @param format 字符串，yy/MM/dd HH:mm格式
 @return NSDate对象
 */
+ (NSDate*)dateWithFormat:(NSString *)format;

/**
 周几

 @return 周几
 */
- (NSString*)weekdayStr;

@end
