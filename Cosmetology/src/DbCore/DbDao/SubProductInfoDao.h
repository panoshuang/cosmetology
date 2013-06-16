//
//  SubProductInfoDao.h
//  Cosmetology
//
//  Created by hongji_zhou on 13-6-14.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubProductInfo.h"

@interface SubProductInfoDao : NSObject

+(SubProductInfoDao *)instance;

-(int)addSubProductInfo:(SubProductInfo *)subProductInfo;

- (BOOL)deleteSubProductForID:(int)productID;

-(BOOL)updateSubProduct:(SubProductInfo *)subProductInfo;

- (NSArray *)allEnableSubProductInfo;

- (NSArray *)allSubProductInfo;

-(NSArray *)allSubProductInfoForMainProductID:(int)mainProductID;

-(NSArray *)allEnableProductInfoForMainProductID:(int)mainProductID;

-(SubProductInfo *)lastCreateCatalog;

@end
