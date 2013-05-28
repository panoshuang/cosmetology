//
// Created by mijie on 13-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "MainProductInfo.h"


@interface MainProductInfoDao : NSObject

+(MainProductInfoDao *)instance;

-(BOOL)addMainProductInfo:(MainProductInfo *)mainProductInfo;

- (BOOL)deleteMainProductForID:(int)productID;

- (NSArray *)allEnableMainProductInfo;

- (NSArray *)allMainProductInfo;


@end