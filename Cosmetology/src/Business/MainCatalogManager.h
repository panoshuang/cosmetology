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

//初始化超值体验项目
-(BOOL)initExperienceCatalog;

-(BOOL)addMainCatalog:(MainProductInfo *)mainProductInfo;

-(BOOL)deleteMainCatalogForId:(int)productId;

-(BOOL)updateMainCatalog:(MainProductInfo *)mainProductInfo;

-(NSArray *)allMainProductInfo;

@end
