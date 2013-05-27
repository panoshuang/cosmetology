/*********************************************************************
 *            Copyright (C) 2012, 广州米捷网络科技有限公司
 * @文件描述:对NSDate的一些扩展
 **********************************************************************
 *   Date        Name        Description
 *   2012/07/02  luzj        New
 *********************************************************************/


@implementation NSDate (NDDate_Chinese)


//获取日期的农历表示
- (NSString *)chineseCalendarWithDate
{

//    NSArray *chineseYears = [NSArray arrayWithObjects:
//                       @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
//                       @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
//                       @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
//                       @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
//                       @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
//                       @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];

    NSArray *chineseMonths=[NSArray arrayWithObjects:
                        @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                        @"九月", @"十月", @"冬月", @"腊月", nil];


    NSArray *chineseDays=[NSArray arrayWithObjects:
                      @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                      @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                      @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];


    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];

    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];

    //NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);

    //NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];

    NSString *chineseCal_str =[NSString stringWithFormat: @"%@\n%@",m_str,d_str];

    [localeCalendar release];

    return chineseCal_str;
}

//获取该date与另外一个date之间相差的天数,大于0表示该date比参数date晚的天数,小于0表示该date比参数date早的天数
-(int)intervalDayToOtherDate:(NSDate *)otherDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *paraComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:otherDate];
    NSDateComponents *curDateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self] ;
    [paraComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [curDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *curDate = [calendar dateFromComponents:curDateComponents];
    NSDate *paraDate = [calendar dateFromComponents:paraComponents];

    NSTimeInterval regin = [curDate timeIntervalSinceDate:paraDate];
    int days=((long)regin)/(3600*24);
    return days;
}

+ (NSString *) stringProperFromDate:(NSDate *)date{
	NSString *returnString;
    
    NSString * timeStr = [NSDate stringDateByFormatString:@"HH:mm" withDate:date];
	NSTimeInterval regin = [[NSDate date] timeIntervalSinceDate:date];
	if (regin < 60*60*24) {
		returnString = [NSString stringWithFormat:@"%@ %@",@"今天 ",timeStr];
	}
	else if(regin < 60*60*24*2){
		returnString = [NSString stringWithFormat:@"%@ %@",@"昨天 ",timeStr];
	}
	else if(regin < 60*60*24*3){
		returnString = [NSString stringWithFormat:@"%@ %@",@"三天前 ",timeStr];
	}
    else if(regin < 60*60*24*7){
   		returnString = [NSString stringWithFormat:@"%@",@"一周前 "];
   	}
	else{
        returnString = [NSString stringWithFormat:@"%@",@"一月前 "];
        
	}
	return returnString;
    
}

//NSDate转NSString,今天的时间返回 小时:分钟,其他的返回 月-日
+(NSString *)stringForConversationListTimeFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date];
    NSDateComponents *curDateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]] ;
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [curDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *returnStr = @"";
    if (components.day == curDateComponents.day){
        returnStr = [NSDate stringDateByFormatString:@"HH:mm" withDate:date];
    }
    else{
        returnStr = [NSDate stringDateByFormatString:@"MM-dd" withDate:date];
    }
    return returnStr;
}

//NSDate转NSString,今天的时间返回 小时:分钟,其他的返回 月-日 小时:分钟
+(NSString *)stringForConversationTimeFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date];
    NSDateComponents *curDateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]] ;
    NSString *returnStr = @"";
    if (components.day == curDateComponents.day){
        returnStr = [NSDate stringDateByFormatString:@"HH:mm" withDate:date];
    }
    else{
        returnStr = [NSDate stringDateByFormatString:@"MM-dd HH:mm" withDate:date];
    }
    return returnStr;
}


+ (NSString *)stringProperDayFromDate:(NSDate *)date{
	NSString *returnString;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date];
    NSDateComponents *curDateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]] ;
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [curDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *curDate = [calendar dateFromComponents:curDateComponents];
    NSDate *paraDate = [calendar dateFromComponents:components];
    
	NSTimeInterval regin = [curDate timeIntervalSinceDate:paraDate];
    int days=((long)regin)/(3600*24);
	if (days == 0) {
		returnString = [NSString stringWithFormat:@"%@",@"今天 "];
	}
	else if(days == 1){
		returnString = [NSString stringWithFormat:@"%@",@"昨天 "];
	}
	else if(days < 3){
		returnString = [NSString stringWithFormat:@"%@",@"三天前 "];
	}
    else if(days < 7){
   		returnString = [NSString stringWithFormat:@"%@",@"一周前 "];
   	}
	else{
        returnString = [NSString stringWithFormat:@"%@",@"一月前 "];
        
	}
	return returnString;
    
}

+ (NSString *)stringForHourLevelFromDate:(NSDate *)date
{
    NSString *returnString;
	NSTimeInterval hoursregin = [[NSDate date] timeIntervalSinceDate:date];
    int hours=((int)hoursregin)%(3600*24)/3600;
    if (hours == 0) {
		returnString = @"一小时前";
	}
	else{
        returnString = [NSDate stringDateByFormatString:@"MM月dd HH:mm" withDate:date];
        
	}
	return returnString;
}



//根据时间获取相应的日期字符串(今天,昨天,星期XXX)
+(NSString *)weekStringByUTCDate:(NSDate *)aDate{
    
	NSTimeInterval regin = [[NSDate date] timeIntervalSinceDate:aDate];
	NSMutableString *retStr = [[[NSMutableString alloc] init] autorelease];
    int days=((int)regin)/(3600*24);
	if (days == 0) {//小于一天
		[retStr appendString:@"Today"];
	}
	else if(days < 2){// 大于一天  小于两天
		[retStr appendString:@"Yesterday"];
	}
	else if(days < 7){
		NSCalendar *calendar = [NSCalendar currentCalendar];
		[calendar setFirstWeekday:2];
		NSInteger week = [calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:aDate];
		switch (week) {
			case 1:
				[retStr appendString:@"Mon"];
				break;
			case 2:
				[retStr appendString:@"Tue"];
				break;
			case 3:
				[retStr appendString:@"Wed"];
				break;
			case 4:
				[retStr appendString:@"Thu"];
				break;
			case 5:
				[retStr appendString:@"Fri"];
				break;
			case 6:
				[retStr appendString:@"Sat"];
				break;
			case 7:
				[retStr appendString:@"Sun"];
				break;
			default:
				break;
		}
	}
	else {
		[retStr appendFormat:@"%@",[NSDate stringDateByFormatString:@"yyyy-MM-dd" withDate:aDate]];
	}
	[retStr appendFormat:@" %@",[NSDate stringDateByFormatString:@"HH:mm" withDate:aDate]];
	return retStr;
    
}

+(NSString *)weekStringForDate:(NSDate *)aDate{
    NSString   *weekStr  = @"";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSInteger week = [calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:aDate];
    switch (week)
    {
        case 1:
            weekStr = @"周一";
            break;
        case 2:
            weekStr = @"周二";
            break;
        case 3:
            weekStr = @"周三";
            break;
        case 4:
            weekStr = @"周四";
            break;
        case 5:
            weekStr = @"周五";
            break;
        case 6:
            weekStr = @"周六";
            break;
        case 7:
            weekStr = @"周日";
            break;
        default:
            break;
    }
    return weekStr;
}

//获取系统当前时间的字符串格式 格式例如yyyy-MM-dd HH:mm:ss:SSS
+ (NSString *) stringDateByFormatString:(NSString *) formatString
{
    NSDateFormatter * dateFromatter=[[NSDateFormatter alloc] init];
    //[dateFromatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    if(formatString!=nil)
    {
        [dateFromatter setDateFormat:formatString];
    }
    NSString * strDate=[dateFromatter stringFromDate:[NSDate date]];
    [dateFromatter release];
    return strDate;
}


//根据指定时间的字符串格式和时间 格式例如yyyy-MM-dd HH:mm:ss:SSS
+ (NSString *) stringDateByFormatString:(NSString *) formatString withDate:(NSDate *)date
{
	if (date == nil) {
		return @"";
	}
    NSDateFormatter * dateFromatter=[[NSDateFormatter alloc] init];
    //[dateFromatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    if(formatString!=nil)
    {
        [dateFromatter setDateFormat:formatString];
    }
    NSString * strDate=[dateFromatter stringFromDate:date];
    [dateFromatter release];
    return strDate;
}

//根据时间戳获取NSDate
+(NSDate *)dateFromTimeIntervalSince1970:(NSString *)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]];
    return date;
}


//比较两个时间戳的日期大小，忽略时分秒
+(NSComparisonResult)compareDayWithTimeIntervalStr:(NSString *)timeInterval  otherIntervalStr:(NSString *)otherInterval{
    return [NSDate compareDayWithTimeInterval:[timeInterval doubleValue] otherInterval:[otherInterval doubleValue]];
}

//比较两个时间戳的日期大小，忽略时分秒
+(NSComparisonResult)compareDayWithTimeInterval:(NSTimeInterval)timeInterval  otherInterval:(NSTimeInterval)otherInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *otherDate = [NSDate dateWithTimeIntervalSince1970:otherInterval] ;
    NSString *dayStr = [NSDate stringDateByFormatString:@"yyyyMMdd" withDate:date];
    NSString *otherDayStr = [NSDate stringDateByFormatString:@"yyyyMMdd" withDate:otherDate];
    if ([dayStr intValue] > [otherDayStr intValue]){
        return NSOrderedDescending;
    }else if ([dayStr intValue] == [otherDayStr intValue]){
        return NSOrderedSame;
    }
    else{
        return NSOrderedAscending;
    }
}

//比较参数时间戳跟当前时间戳是否是同一天
+(BOOL)isCurentDay:(NSTimeInterval)timeInterval{
    if ([NSDate compareDayWithTimeInterval:timeInterval otherInterval:[[NSDate date] timeIntervalSince1970]] == NSOrderedSame) {
        return YES;
    }else{
        return NO;
    }
}


@end
