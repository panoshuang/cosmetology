//DeviceHelper   create by huangsp on 12-11-5
//************************************
//@文件描述：获取主机设备的型号和系统版本号等
//***********************************


#import <Foundation/Foundation.h>

/**
* ios设备型号
*/
typedef enum _EnumDeviceVersion{
    kDeviceVersionIphone1G,
    kDeviceVersionIphone3G,
    kDeviceVersionIphone4,
    kDeviceVersionIphone4CDMA,
    kDeviceVersionIphone4s,
    kDeviceVersionIphone5,
    kDeviceVersionIpodTouch1G,
    kDeviceVersionIpodTouch2G,
    kDeviceVersionIpodTouch3G,
    kDeviceVersionIpodTouch4G,
    kDeviceVersionIpad,
    kDeviceVersionIpad2Wifi,
    kDeviceVersionIpad2GSM,
    kDeviceVersionIpad2CDMA,
    kDeviceVersionSimulator
}EnumDeviceVersion;


@interface DeviceHelper : NSObject

+(EnumDeviceVersion)getDeviceVersionType;

+ (NSString *)getDeviceVersion;

+ (NSString *)getOSVersion;

+(NSString *)getOSName;

+ (BOOL)isIpad;

+ (BOOL)isIphone;

+ (BOOL)isSimulator;

+ (BOOL)hasCamera;

+(NSString *)phoneName;

//屏幕分辨率
+(NSString *)screenSize;

//判断是否是retina屏幕
+(BOOL)isRetina;

//判断是否越狱
+ (BOOL)isJailbroken;




@end