//
// Created by mijie on 13-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainProductInfoDao.h"
#import "Database_define.h"
#import "FMDatabase.h"
#import "BaseDatabase.h"


@implementation MainProductInfoDao {

}

SYNTHESIZE_SINGLETON_FOR_CLASS(MainProductInfoDao)

-(BOOL)addMainProductInfo:(MainProductInfo *)mainProductInfo{
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" ("
                        MAIN_PRODUCT_INFO_TABLE_NAME","
                        MAIN_PRODUCT_INFO_ENABLE","
                        MAIN_PRODUCT_INFO_INDEX","
                        MAIN_PRODUCT_INFO_BG_IMAGE_FILE","
                        MAIN_PRODUCT_INFO_PREVIEW_IMAGE_FILE","
                        MAIN_PRODUCT_INFO_SUB_ITEM_BTN_IMAGE_NAME","
                        MAIN_PRODDUCT_INFO_SUB_ITEM_BTN_COLOR_TYPE","
                        MAIN_PRODUCT_INFO_PRODUCT_TYPE","
                        MAIN_PRODUCT_INFO_CREATE_AT
            ")""VALUES(?,?,?,?,?,?,?,?,?)"

    ];
    NSArray *argArray = [NSArray arrayWithObjects:mainProductInfo.name.length > 0 ? mainProductInfo.name:@"",
                                                  [NSNumber numberWithInt:mainProductInfo.enable],
                                                  [NSNumber numberWithInteger:mainProductInfo.index],
                                                 mainProductInfo.bgImageFile,
                                                 mainProductInfo.previewImageFile,
                                                 mainProductInfo.subItemBtnImageName,
                                                 [NSNumber numberWithInt:mainProductInfo.colorType],
                                                 [NSNumber numberWithInt:mainProductInfo.productType],
                                                 [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],
                                                  nil];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DBErrorCheckLog(db);
    }];
    return isSuccess;
}

-(BOOL)deleteMainProductForID:(int)productID{
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME
            " WHERE "MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID" =?"];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr, [NSNumber numberWithInt:productID]];
        DBErrorCheckLog(db);

    }];
    return isSuccess;
}

-(BOOL)updateMainProduct:(MainProductInfo *)mainProductInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" SET "
                        MAIN_PRODUCT_INFO_TABLE_NAME"=?,"
                        MAIN_PRODUCT_INFO_ENABLE"=?,"
                        MAIN_PRODUCT_INFO_INDEX"=?,"
                        MAIN_PRODUCT_INFO_BG_IMAGE_FILE"=?,"
                        MAIN_PRODUCT_INFO_PREVIEW_IMAGE_FILE"=?,"
                        MAIN_PRODUCT_INFO_SUB_ITEM_BTN_IMAGE_NAME"=?,"
                        MAIN_PRODDUCT_INFO_SUB_ITEM_BTN_COLOR_TYPE"=?,"
                        MAIN_PRODUCT_INFO_PRODUCT_TYPE"=?"
                        " WHERE "MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID"=?"];
    NSArray *argArray = [NSArray arrayWithObjects:mainProductInfo.name,
                         [NSNumber numberWithInteger:mainProductInfo.enable],
                         [NSNumber numberWithInteger:mainProductInfo.index],
                         mainProductInfo.bgImageFile,
                         mainProductInfo.previewImageFile,
                         mainProductInfo.subItemBtnImageName,
                         [NSNumber numberWithInt:mainProductInfo.colorType],
                         [NSNumber numberWithInt:mainProductInfo.productType],
                         [NSNumber numberWithInt:mainProductInfo.productID],nil];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DBErrorCheckLog(db);
    }];
    return isSuccess;
}

-(NSArray *)allEnableMainProductInfo{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME
            " WHERE "MAIN_PRODUCT_INFO_ENABLE" =? ORDER BY "MAIN_PRODUCT_INFO_INDEX" ASC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:1]];
        while ([resultSet next]){
            MainProductInfo *mainProductInfo = [self mainProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:mainProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(NSArray *)allMainProductInfo{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" ORDER BY "MAIN_PRODUCT_INFO_INDEX];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]){
            MainProductInfo *mainProductInfo = [self mainProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:mainProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(MainProductInfo *)experienceCatalog{
    __block MainProductInfo *mainProductInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" WHERE "
                        MAIN_PRODUCT_INFO_TABLE_NAME"=?  AND "MAIN_PRODUCT_INFO_INDEX"=?"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,EXPERIENCE_CATALOG_NAME,[NSNumber numberWithInteger:EXPERIENCE_CATALOG_INDEX]];
        while ([resultSet next]){
            mainProductInfo = [self mainProductInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return mainProductInfo;
}

-(MainProductInfo *)mainCatalogForID:(int)mainProductID{
    __block MainProductInfo *mainProductInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" WHERE "
                        MAIN_PRODUCT_INFO_TABLE_NAME"=?  AND "MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID "=?"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,EXPERIENCE_CATALOG_NAME,[NSNumber numberWithInteger:mainProductID]];
        while ([resultSet next]){
            mainProductInfo = [self mainProductInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return mainProductInfo;
}


-(MainProductInfo *)lastCreateCatalog:(EnumProductType)productType{
    __block MainProductInfo *mainProductInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" WHERE "MAIN_PRODUCT_INFO_PRODUCT_TYPE"=? ORDER BY "MAIN_PRODUCT_INFO_CREATE_AT" DESC LIMIT 1"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:productType]];
        while ([resultSet next]){
            mainProductInfo = [self mainProductInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return mainProductInfo;
}

- (MainProductInfo *)mainProductInfoFromFMResultSet:(FMResultSet *)resultSet {
    MainProductInfo *mainProductInfo = [[MainProductInfo alloc] init];
    mainProductInfo.productID = [resultSet intForColumn:MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID];
    mainProductInfo.name = [resultSet stringForColumn:MAIN_PRODUCT_INFO_TABLE_NAME];
    mainProductInfo.enable = [resultSet boolForColumn:MAIN_PRODUCT_INFO_ENABLE];
    mainProductInfo.index = [resultSet intForColumn:MAIN_PRODUCT_INFO_INDEX];
    mainProductInfo.bgImageFile = [resultSet stringForColumn:MAIN_PRODUCT_INFO_BG_IMAGE_FILE];
    mainProductInfo.previewImageFile = [resultSet stringForColumn:MAIN_PRODUCT_INFO_PREVIEW_IMAGE_FILE];
    mainProductInfo.subItemBtnImageName = [resultSet stringForColumn:MAIN_PRODUCT_INFO_SUB_ITEM_BTN_IMAGE_NAME];
    mainProductInfo.colorType = (EnumSubBtnColorType)[resultSet intForColumn:MAIN_PRODDUCT_INFO_SUB_ITEM_BTN_COLOR_TYPE];
    mainProductInfo.productType = (EnumProductType)[resultSet intForColumn:MAIN_PRODUCT_INFO_PRODUCT_TYPE];
    return mainProductInfo;
}



@end