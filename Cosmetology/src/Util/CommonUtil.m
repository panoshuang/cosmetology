//
//  CommonUtil.m
//  Cosmetology
//  @文件说明: 普通功能工具类
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "CommonUtil.h"
#import <Foundation/Foundation.h>

@implementation CommonUtil


//生成uuid
+(NSString*) uuid {
    CFUUIDRef uuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, uuid );
    NSString * resultStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(uuid);
    CFRelease(uuidString);
    return resultStr;
}
@end
