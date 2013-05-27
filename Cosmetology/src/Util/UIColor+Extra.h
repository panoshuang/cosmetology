//
// Created by huangsp on 12-10-9.
// @文件描述:颜色拓展
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface UIColor (Extra)

//16进制颜色值生成UIColor
+(UIColor *)colorWithHexColor:(int)hexColor;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end