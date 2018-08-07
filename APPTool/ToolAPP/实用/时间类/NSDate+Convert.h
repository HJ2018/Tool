//
//  NSDate+Convert.h
//  KidBookPhone
//
//  Created by Kyo on 5/15/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

typedef enum
{
    DateTypeYear,
    DateTypeMonth,
    DateTypeDay,
    DateTypeWeek   //当前日期时一个星期中的星期几，1-7
}
DateType;

#import <Foundation/Foundation.h>

@interface NSDate (Convert)

//根据获取类型返回时间的数据
- (NSInteger)dateDataWithDateType:(DateType)dateType;
//返回时间的字典
- (NSMutableDictionary *)dateData;
//根据传入的n天返回一个距离当前n天的NSDate
- (NSDate *)currentIntervalDateWithDay:(NSInteger)intervalDay;
//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21 13:08"
+ (NSDate *)dateFromString:(NSString *)dateString;

@end
