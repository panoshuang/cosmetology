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
                        MAIN_PRODUCT_INFO_ENABLE""
            ")""VALUES(?,?,?)"

    ];
    NSArray *argArray = [NSArray arrayWithObjects:mainProductInfo.name.length > 0 ? mainProductInfo.name:@"",
                                                  [NSNumber numberWithInt:mainProductInfo.enable],
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

-(NSArray *)allEnableMainProductInfo{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME
            " WHERE "MAIN_PRODUCT_INFO_ENABLE" =?"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:0]];
        while ([resultSet next]){
            MainProductInfo *mainProductInfo = [self mailProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:mainProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(NSArray *)allMainProductInfo{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]){
            MainProductInfo *mainProductInfo = [self mailProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:mainProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

- (MainProductInfo *)mailProductInfoFromFMResultSet:(FMResultSet *)resultSet {
    MainProductInfo *mainProductInfo = [[MainProductInfo alloc] init];
    mainProductInfo.productID = [resultSet intForColumn:MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID];
    mainProductInfo.name = [resultSet stringForColumn:MAIN_PRODUCT_INFO_TABLE_NAME];
    mainProductInfo.enable = [resultSet boolForColumn:MAIN_PRODUCT_INFO_ENABLE];
    return mainProductInfo;
}



@end