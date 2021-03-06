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

///**
//	初始化超值体验产品分类
// */
//-(BOOL)initExperienceCatalog{
//    //判断是否已经存在超值体验分类
//    if ([[MainProductInfoDao instance] experienceCatalog] == nil) {
//        MainProductInfo *productInfo = [[MainProductInfo alloc] init];
//        productInfo.name = EXPERIENCE_CATALOG_NAME;;
//        productInfo.enable = YES;
//        productInfo.index = EXPERIENCE_CATALOG_INDEX;
//        productInfo.productType = kExperienceType;
//        BOOL result = [[MainProductInfoDao instance] addMainProductInfo:productInfo];
//        return result;
//    }else{
//        return YES;
//    }
//}

-(MainProductInfo *)mainCatalogForID:(int)mainProductID{
    return [[MainProductInfoDao instance] mainCatalogForID:mainProductID];
}

-(MainProductInfo *)experienceCatalog{
    return [[MainProductInfoDao instance] experienceCatalog];
}

-(BOOL)addMainCatalog:(MainProductInfo *)mainProductInfo{
    return [[MainProductInfoDao instance] addMainProductInfo:mainProductInfo];
}

-(BOOL)deleteMainCatalogForId:(int)productId{
    return [[MainProductInfoDao instance] deleteMainProductForID:productId];
}

-(BOOL)updateMainCatalog:(MainProductInfo *)mainProductInfo{
    return [[MainProductInfoDao instance] updateMainProduct:mainProductInfo];
}

-(NSArray *)allMainProductInfo{
    return [[MainProductInfoDao instance] allMainProductInfo];
}

-(NSArray *)allEnableProductInfo{
    return [[MainProductInfoDao instance] allEnableMainProductInfo];
}

-(MainProductInfo *)lastMainProductInfo:(EnumProductType )productType{
    return [[MainProductInfoDao instance] lastCreateCatalog:productType];
}

//为新增类别获取合适的index排序索引
-(int)indexForNewCatalog:(EnumProductType)productType{
    //获取最后插入的一条类别
    MainProductInfo *productInfo = [[MainProductInfoDao instance] lastCreateCatalog:productType];
    if (productInfo == nil) {
        int newIndex = 0;
        if (productType == kExperienceType) {
            newIndex = EXPERIENCE_CATALOG_INDEX;
        }else{
            newIndex = 0;
        }
        return newIndex;
    }
    else{
        int newIndex = productInfo.index + 1;
        return newIndex;
    }
}

@end
