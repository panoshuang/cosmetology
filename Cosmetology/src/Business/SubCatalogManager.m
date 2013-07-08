//
//  SubCatalogManager.m
//  Cosmetology
//
//  Created by hongji_zhou on 13-6-14.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "SubCatalogManager.h"
#import "SubProductInfoDao.h"

@implementation SubCatalogManager

SYNTHESIZE_SINGLETON_FOR_CLASS(SubCatalogManager)

-(int)addSubCatalog:(SubProductInfo *)subProductInfo{
    return [[SubProductInfoDao instance] addSubProductInfo:subProductInfo];
}

-(BOOL)deleteSubCatalogForId:(int)productId{
    return [[SubProductInfoDao instance] deleteSubProductForID:productId];
}

-(BOOL)updateSubCatalog:(SubProductInfo *)subProductInfo{
    return [[SubProductInfoDao instance] updateSubProduct:subProductInfo];
}

-(NSArray *)allSubProductInfo{
    return [[SubProductInfoDao instance] allSubProductInfo];
}

-(NSArray *)allEnableProductInfo{
    return [[SubProductInfoDao instance] allEnableSubProductInfo];
}

-(SubProductInfo *)lastSubProductInfo{
    return [[SubProductInfoDao instance] lastCreateCatalog];
}

-(SubProductInfo *)subProductInfoForProductID:(int)productId{
    return [[SubProductInfoDao instance] subProductInfoForProductID:productId];
}

-(NSArray *)allSubProductInfoForMainProductID:(int)mainProductID{
    return [[SubProductInfoDao instance] allSubProductInfoForMainProductID:mainProductID];
}

-(NSArray *)allEnableProductInfoForMainProductID:(int)mainProductID{
    return [[SubProductInfoDao instance] allEnableProductInfoForMainProductID:mainProductID];
}

//为新增类别获取合适的index排序索引
-(int)indexForNewCatalog{
    //获取最后插入的一条类别
    SubProductInfo *productInfo = [[SubProductInfoDao instance] lastCreateCatalog];
    if(!productInfo) {
        int newIndex = 0;
        return newIndex;
    } else{
        int newIndex = productInfo.index + 1;
        return newIndex;
    }


}

@end
