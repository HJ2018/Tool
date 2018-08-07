//
//  NSDate+Convert.m
//  KidBookPhone
//
//  Created by Kyo on 5/15/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

#import "NSDate+Convert.h"

@implementation NSDate (Convert)

//根据获取类型返回传入的时间的数据
- (NSInteger)dateDataWithDateType:(DateType)dateType
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    static NSCalendar *calendar;
    static NSDateComponents *comps;
    static NSInteger unitFlags;
    dispatch_once(&onceToken, ^{
        formatter =[[NSDateFormatter alloc] init];
        //NSDate *date_ = [NSDate date];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps = [[NSDateComponents alloc] init];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
    });
    
    
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:self];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //This sets the label with the updated time.
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
//    KBDebug(@"week%d",week);
//    KBDebug(@"year%d",year);
//    KBDebug(@"month%d",month);
//    KBDebug(@"day%d",day);
//    KBDebug(@"hour%d",hour);
//    KBDebug(@"min%d",min);
//    KBDebug(@"sec%d",sec);
    
    switch (dateType)
    {
        case DateTypeYear:
        {
            return year;
            break;
        }
        case DateTypeDay:
        {
            return day;
            break;
        }
        case DateTypeMonth:
        {
            return month;
            break;
        }
        case DateTypeWeek:
        {
            week = week - 1;
            if (week == 0)  //根据上面的 1是星期天 7是星期六 所以 －1后等于0的是星期天
            {
                week = 7;
            }
            return week;
            break;
        }
        default:
            break;
    }
}

//返回时间的字典
- (NSMutableDictionary *)dateData
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    static NSCalendar *calendar;
    static NSDateComponents *comps;
    static NSInteger unitFlags;
    dispatch_once(&onceToken, ^{
        formatter =[[NSDateFormatter alloc] init];
        //NSDate *date_ = [NSDate date];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps = [[NSDateComponents alloc] init];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
    });
    
    
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:self];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //This sets the label with the updated time.
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
//    KBDebug(@"week%d",week);
//    KBDebug(@"year%d",year);
//    KBDebug(@"month%d",month);
//    KBDebug(@"day%d",day);
//    KBDebug(@"hour%d",hour);
//    KBDebug(@"min%d",min);
//    KBDebug(@"sec%d",sec);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:7];
    [dict setObject:@(year) forKey:@"year"];
    [dict setObject:@(month) forKey:@"month"];
    [dict setObject:@(day) forKey:@"day"];
    [dict setObject:@(week) forKey:@"week"];
    [dict setObject:@(hour) forKey:@"hour"];
    [dict setObject:@(min) forKey:@"min"];
    [dict setObject:@(sec) forKey:@"sec"];
    
    return dict;
}

//根据传入的n天返回一个距离当前n天的NSDate
- (NSDate *)currentIntervalDateWithDay:(NSInteger)intervalDay
{
//    NSDate *currentDate = [NSDate date];
    NSInteger interval = intervalDay * 60 * 60 * 24;
    return [self dateByAddingTimeInterval:interval];
}

//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21 13:08"
+ (NSDate *)dateFromString:(NSString *)dateString
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    });
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//nsdate转换为字符串日期，传出的日期为 1992-05-21
+ (NSString *)stringFromDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

@end
