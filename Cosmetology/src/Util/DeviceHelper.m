//DeviceHelper   create by huangsp on 12-11-5
//************************************
//@文件描述：
//***********************************


#import "DeviceHelper.h"
#import "sys/utsname.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation DeviceHelper


+ (NSString *)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}


+(EnumDeviceVersion)getDeviceVersionType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone1,1"])    return kDeviceVersionIphone1G;
    if ([deviceString isEqualToString:@"iPhone1,2"])    return kDeviceVersionIphone3G;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return kDeviceVersionIphone3G;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return kDeviceVersionIphone4;
    if ([deviceString isEqualToString:@"iPhone4,1"])    return kDeviceVersionIphone4s;
    if ([deviceString isEqualToString:@"iPhone5,2"])    return kDeviceVersionIphone5;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return kDeviceVersionIphone4CDMA;
    if ([deviceString isEqualToString:@"iPod1,1"])      return kDeviceVersionIpodTouch1G;
    if ([deviceString isEqualToString:@"iPod2,1"])      return kDeviceVersionIpodTouch2G;
    if ([deviceString isEqualToString:@"iPod3,1"])      return kDeviceVersionIpodTouch3G;
    if ([deviceString isEqualToString:@"iPod4,1"])      return kDeviceVersionIpodTouch4G;
    if ([deviceString isEqualToString:@"iPad1,1"])      return kDeviceVersionIpad;
    if ([deviceString isEqualToString:@"iPad2,1"])      return kDeviceVersionIpad2Wifi;
    if ([deviceString isEqualToString:@"iPad2,2"])      return kDeviceVersionIpad2GSM;
    if ([deviceString isEqualToString:@"iPad2,3"])      return kDeviceVersionIpad2CDMA;
    if ([deviceString isEqualToString:@"i386"])         return kDeviceVersionSimulator;
    if ([deviceString isEqualToString:@"x86_64"])       return kDeviceVersionSimulator;
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return kDeviceVersionIphone4;
}


+ (NSString*)getOSVersion
{
    return [[UIDevice currentDevice]systemVersion];
}

+(NSString *)getOSName{
//    return [[UIDevice currentDevice] systemName];
    return @"IOS";
}


+ (BOOL)isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}



+ (BOOL)isIphone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;

}

+ (BOOL)isSimulator{
    EnumDeviceVersion deviceVer = [DeviceHelper getDeviceVersionType];
    if(deviceVer == kDeviceVersionSimulator){
        return YES;
    }
    else{
        return NO;
    }
}


+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+(NSString *)phoneName{
    return [UIDevice currentDevice].name;
}

+ (NSString *)macAddress{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;

    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces

    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }

    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        free(msgBuffer);
        return errorFlag;
    }

    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;

    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);

    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);

    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                                            macAddress[0], macAddress[1], macAddress[2],
                                                            macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);

    // Release the buffer memory
    free(msgBuffer);

    return macAddressString;
}


//屏幕分辨率
+(NSString *)screenSize{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGFloat scale = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%d*%d",(int)(rect_screen.size.width*scale),(int)(rect_screen.size.height * scale)] ;
}

//判断是否是retina屏幕
+(BOOL)isRetina{
    UIScreen *screen = [UIScreen mainScreen];
    if(screen.scale == 2){
        return YES;
    }else{
        return NO;
    }
}

//判断是否越狱
+ (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath   = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
    {
        jailbroken = YES;
    }
    return jailbroken;
}




@end