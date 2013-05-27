/*********************************************************************
 *            Copyright (C) 2012, 广州米捷网络科技有限公司
 * @文件描述:对NSDate的一些扩展
 **********************************************************************
 *   Date        Name        Description
 *   2012/07/02  luzj        New
 *********************************************************************/


#import <Foundation/Foundation.h>


@interface NSDate (NDDate_Chinese)

//获取日期的农历表示
- (NSString *)chineseCalendarWithDate;

//获取该date与另外一个date之间相差的天数,大于0表示该date比参数date晚的天数,小于0表示该date比参数date早的天数
-(int)intervalDayToOtherDate:(NSDate *)otherDate;

//根据时间获取相应的日期字符串(今天,昨天,星期XXX)
+(NSString *)weekStringByUTCDate:(NSDate *)aDate;

//根据时间获取相应的日期字符串(星期XXX)
+(NSString *)weekStringForDate:(NSDate *)aDate;

//获取系统当前时间的字符串格式 格式例如yyyy-MM-dd HH:mm:ss:SSS
+ (NSString *) stringDateByFormatString:(NSString *) formatString;

//根据指定时间的字符串格式和时间 格式例如yyyy-MM-dd HH:mm:ss:SSS
+ (NSString *) stringDateByFormatString:(NSString *) formatString withDate:(NSDate *)date;

//根据指定日期，返回适当的字符串
+ (NSString *) stringProperFromDate:(NSDate *)date;

//NSDate转NSString,今天的时间返回 小时:分钟,其他的返回 月-日
+(NSString *)stringForConversationListTimeFromDate:(NSDate *)date;

//NSDate转NSString,今天的时间返回 小时:分钟,其他的返回 月-日 小时:分钟
+(NSString *)stringForConversationTimeFromDate:(NSDate *)date;

+ (NSString *)stringProperDayFromDate:(NSDate *)date;

//根据指定时间戳,当一个小时内就显示一个小时前,大于一个小时则显示为MM月dd日 hh:mm
+(NSString *)stringForHourLevelFromDate:(NSDate *)date;

//根据时间戳获取NSDate
+(NSDate *)dateFromTimeIntervalSince1970:(NSString *)timeInterval;

//比较两个时间戳的日期大小，忽略时分秒
+(NSComparisonResult)compareDayWithTimeIntervalStr:(NSString *)timeInterval  otherIntervalStr:(NSString *)otherInterval;

//比较两个时间戳的日期大小，忽略时分秒
+(NSComparisonResult)compareDayWithTimeInterval:(NSTimeInterval)timeInterval  otherInterval:(NSTimeInterval)otherInterval;

//比较参数时间戳跟当前时间戳是否是同一天
+(BOOL)isCurentDay:(NSTimeInterval)timeInterval;

@end
