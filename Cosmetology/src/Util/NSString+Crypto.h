/* @文件描述:对NSString的加密解密
**********************************************************************
*   Date        Name        Description
*********************************************************************/

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSString (Crypto)

- (NSString *)md5;
+ (NSString *)encodeBase64WithString:(NSString *)strData;
+ (NSString *)encodeBase64WithData:(NSData *)objData;
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;
- (NSString*)sha1;
- (NSString*)base64;
- (NSString *)decodeBase64;

@end
