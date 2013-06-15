//
//  SubCatalogManager.h
//  Cosmetology
//
//  Created by hongji_zhou on 13-6-14.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SubProductInfo.h"

@interface SubCatalogManager : NSObject

+(SubCatalogManager *)instance;

-(int)addSubCatalog:(SubProductInfo *)subProductInfo;

-(BOOL)deleteSubCatalogForId:(int)productId;

-(BOOL)updateSubCatalog:(SubProductInfo *)subProductInfo;

-(NSArray *)allSubProductInfo;

-(NSArray *)allEnableProductInfo;

-(NSArray *)allSubProductInfoForMainProductID:(int)mainProductID;

-(NSArray *)allEnableProductInfoForMainProductID:(int)mainProductID;

-(SubProductInfo *)lastSubProductInfo;

//为新增类别获取合适的index排序索引
-(int)indexForNewCatalog;

@end
