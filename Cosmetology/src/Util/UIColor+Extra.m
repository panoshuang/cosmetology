//${FILENAME}   create by huangsp on 12-10-9
//************************************
//@文件描述：
//***********************************

#import "UIColor+Extra.h"


@implementation UIColor (Extra)

//16进制颜色值生成UIColor
+(UIColor *)colorWithHexColor:(int)hexColor{
    int blueValue = hexColor%0X100;
    int greenValue = (hexColor/0X100)%0x100 ;
    int redValue = (hexColor/0X10000)%0X100;
    UIColor *color = [UIColor colorWithRed:redValue/(CGFloat)0xff green:greenValue/(CGFloat)0xff blue:blueValue/(CGFloat)0xff alpha:1];
    return color;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor redColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor redColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end