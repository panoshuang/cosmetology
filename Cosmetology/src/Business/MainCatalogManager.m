//
//  MainCatalogManager.m
//  Cosmetology
//
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainCatalogManager.h"
#import "MainProductInfoDao.h"

@implementation MainCatalogManager

SYNTHESIZE_SINGLETON_FOR_CLASS(MainCatalogManager)

-(BOOL)addMainCatalog:(MainProductInfo *)mainProductInfo{
    return [[MainProductInfoDao instance] addMainProductInfo:mainProductInfo];
}

-(BOOL)deleteMainCatalogForId:(int)productId{
    return [[MainProductInfoDao instance] deleteMainProductForID:productId];
}

-(NSArray *)allMainProductInfo{
    return [[MainProductInfoDao instance] allMainProductInfo];
}

@end
