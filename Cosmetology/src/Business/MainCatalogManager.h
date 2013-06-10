//
//  MainCatalogManager.h
//  Cosmetology
//
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainProductInfo.h"

@interface MainCatalogManager : NSObject

+(MainCatalogManager *)instance;

-(BOOL)addMainCatalog:(MainProductInfo *)mainProductInfo;

-(BOOL)deleteMainCatalogForId:(int)productId;

-(NSArray *)allMainProductInfo;

@end
