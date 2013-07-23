//
//  SubProductInfoDao.m
//  Cosmetology
//
//  Created by hongji_zhou on 13-6-14.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "SubProductInfoDao.h"
#import "BaseDatabase.h"
#import "Database_define.h"
#import "FMDatabase.h"

@implementation SubProductInfoDao

SYNTHESIZE_SINGLETON_FOR_CLASS(SubProductInfoDao)

-(int)addSubProductInfo:(SubProductInfo *)subProductInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" ("
            SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID","
            SUB_PRODUCT_INFO_TABLE_NAME","
            SUB_PRODUCT_INFO_TABLE_ENABLE","
            SUB_PRODUCT_INFO_TABLE_INDEX","
            SUB_PRODUCT_INFO_TABLE_VEDIO""
            ")""VALUES(?,?,?,?,?)"

    ];
    NSArray *argArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:subProductInfo.mainProductID],
                                                  subProductInfo.name,
                                                  [NSNumber numberWithInteger:subProductInfo.enable],
                                                  [NSNumber numberWithInt:subProductInfo.index],
                                                  subProductInfo.vedioURL,
                                                  nil];
    __block int productID = NSNotFound;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        BOOL  isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DDetailLog(@"add row")
        DBErrorCheckLog(db);
        if(isSuccess){
            productID =  (int)[db lastInsertRowId];
            DDetailLog(@"get row id")
            DBErrorCheckLog(db);
        }

    }];
    return productID;
}

-(BOOL)deleteSubProductForID:(int)productID{
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM "SUB_PRODUCT_INFO_TABLE_TABLE_NAME
                                                  " WHERE "SUB_PRODUCT_INFO_TABLE_PRODUCT_ID" =?"];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr, [NSNumber numberWithInt:productID]];
        DBErrorCheckLog(db);

    }];
    return isSuccess;
}

-(BOOL)updateSubProduct:(SubProductInfo *)subProductInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" SET "
            SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID"=?,"
            SUB_PRODUCT_INFO_TABLE_NAME"=?,"
            SUB_PRODUCT_INFO_TABLE_ENABLE"=?,"
            SUB_PRODUCT_INFO_TABLE_INDEX"=?,"
            SUB_PRODUCT_INFO_TABLE_VEDIO"=?"
            " WHERE "SUB_PRODUCT_INFO_TABLE_PRODUCT_ID"=?"];
    NSArray *argArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:subProductInfo.mainProductID],
                                                  subProductInfo.name,
                                                  [NSNumber numberWithInteger:subProductInfo.enable],
                                                  [NSNumber numberWithInt:subProductInfo.index],
                                                  subProductInfo.vedioURL,
                                                  [NSNumber numberWithInt:subProductInfo.productID],nil];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DBErrorCheckLog(db);
    }];
    return isSuccess;
}

-(NSArray *)allEnableSubProductInfo{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "SUB_PRODUCT_INFO_TABLE_TABLE_NAME
                                                  " WHERE "SUB_PRODUCT_INFO_TABLE_ENABLE" =? ORDER BY "SUB_PRODUCT_INFO_TABLE_INDEX" ASC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:1]];
        while ([resultSet next]){
            SubProductInfo *subProductInfo = [self subProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:subProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(NSArray *)allSubProductInfo{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" ORDER BY "SUB_PRODUCT_INFO_TABLE_INDEX" ASC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]){
            SubProductInfo *subProductInfo = [self subProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:subProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(NSArray *)allSubProductInfoForMainProductID:(int)mainProductID{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "SUB_PRODUCT_INFO_TABLE_TABLE_NAME
            " WHERE "SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID"=? AND" SUB_PRODUCT_INFO_TABLE_ENABLE
            " =? ORDER BY "SUB_PRODUCT_INFO_TABLE_INDEX" ASC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:mainProductID],[NSNumber numberWithInt:1]];
        while ([resultSet next]){
            SubProductInfo *subProductInfo = [self subProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:subProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(NSArray *)allEnableProductInfoForMainProductID:(int)mainProductID{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "SUB_PRODUCT_INFO_TABLE_TABLE_NAME
            " WHERE "SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID"=? "
            "  ORDER BY "SUB_PRODUCT_INFO_TABLE_INDEX" ASC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:mainProductID]];
        while ([resultSet next]){
            SubProductInfo *subProductInfo = [self subProductInfoFromFMResultSet:resultSet];
            [resultArray addObject:subProductInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}


-(SubProductInfo *)lastCreateCatalog{
    __block SubProductInfo *subProductInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" ORDER BY "SUB_PRODUCT_INFO_TABLE_INDEX" DESC LIMIT 1"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]){
            subProductInfo = [self subProductInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return subProductInfo;
}

-(SubProductInfo *)subProductInfoForProductID:(int)productId{
    __block SubProductInfo *subProductInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" WHERE "SUB_PRODUCT_INFO_TABLE_PRODUCT_ID" =?"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:productId]];
        while ([resultSet next]){
            subProductInfo = [self subProductInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return subProductInfo;
}

- (SubProductInfo *)subProductInfoFromFMResultSet:(FMResultSet *)resultSet {
    SubProductInfo *subProductInfo = [[SubProductInfo alloc] init];
    subProductInfo.productID = [resultSet intForColumn:SUB_PRODUCT_INFO_TABLE_PRODUCT_ID];
    subProductInfo.mainProductID = [resultSet intForColumn:SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID];
    subProductInfo.name = [resultSet stringForColumn:SUB_PRODUCT_INFO_TABLE_NAME];
    subProductInfo.enable = [resultSet boolForColumn:MAIN_PRODUCT_INFO_ENABLE];
    subProductInfo.index = [resultSet intForColumn:MAIN_PRODUCT_INFO_INDEX];
    subProductInfo.vedioURL = [resultSet stringForColumn:SUB_PRODUCT_INFO_TABLE_VEDIO];
    return subProductInfo;
}

@end
