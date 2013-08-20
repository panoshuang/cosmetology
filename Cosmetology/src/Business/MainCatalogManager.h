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
//-(BOOL)initExperienceCatalog;

-(MainProductInfo *)experienceCatalog;

-(MainProductInfo *)mainCatalogForID:(int)mainProductID;

-(BOOL)addMainCatalog:(MainProductInfo *)mainProductInfo;

-(BOOL)deleteMainCatalogForId:(int)productId;

-(BOOL)updateMainCatalog:(MainProductInfo *)mainProductInfo;

-(NSArray *)allMainProductInfo;

-(NSArray *)allEnableProductInfo;

-(MainProductInfo *)lastMainProductInfo:(EnumProductType )productType;

//为新增类别获取合适的index排序索引
-(int)indexForNewCatalog:(EnumProductType)productType;

@end
