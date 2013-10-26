//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AdPhotoInfoDao.h"
#import "BaseDatabase.h"
#import "Database_define.h"
#import "FMDatabase.h"


@implementation AdPhotoInfoDao {

}

SYNTHESIZE_SINGLETON_FOR_CLASS(AdPhotoInfoDao)

-(int)addAdPhotoInfo:(AdPhotoInfo *)adPhotoInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO "AD_PHOTO_INFO_TABLE_TABLE_NAME" ("
            AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID","
            AD_PHOTO_INFO_TABLE_INDEX","
            AD_PHOTO_INFO_TABLE_IMAGE_FILE_PATH","
            AD_PHOTO_INFO_TABLE_HAD_VEDIO","
            AD_PHOTO_INFO_TABLE_VIDIO_FILE_PATH""
            ")""VALUES(?,?,?,?,?)"

    ];
    NSArray *argArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:adPhotoInfo.subProductId],
                                                  [NSNumber numberWithInteger:adPhotoInfo.index],
                                                  adPhotoInfo.imageFilePath,
                                                  [NSNumber numberWithInt:adPhotoInfo.hadVedio],
                                                  adPhotoInfo.vedioFilePath,
                                                  nil];
    __block int productID = NSNotFound;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        BOOL  isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DDetailLog(@"add row")
        DBErrorCheckLog(db);
        if(isSuccess){
            productID =  (int)[db lastInsertRowId];
            DDetailLog(@"get row id :%d",productID);
            DBErrorCheckLog(db);
        }

    }];
    return productID;
}

- (BOOL)deleteAdPhotoForID:(int)adPhotoInfoID{
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM "AD_PHOTO_INFO_TABLE_TABLE_NAME
                                                  " WHERE "AD_PHOTO_INFO_TABLE_PHOTO_ID" =?"];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr,@(adPhotoInfoID)];
        DBErrorCheckLog(db);

    }];
    return isSuccess;
}

-(BOOL)updateAdPhoto:(AdPhotoInfo *)adPhotoInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE "AD_PHOTO_INFO_TABLE_TABLE_NAME" SET "
            AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID"=?,"
            AD_PHOTO_INFO_TABLE_INDEX"=?,"
            AD_PHOTO_INFO_TABLE_IMAGE_FILE_PATH"=?,"
            AD_PHOTO_INFO_TABLE_HAD_VEDIO"=?,"
            AD_PHOTO_INFO_TABLE_VIDIO_FILE_PATH"=?"
            " WHERE "AD_PHOTO_INFO_TABLE_PHOTO_ID"=?"];
    NSArray *argArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:adPhotoInfo.subProductId],
                                                  [NSNumber numberWithInteger:adPhotoInfo.index],
                                                  adPhotoInfo.imageFilePath,
                                                  [NSNumber numberWithInt:adPhotoInfo.hadVedio],
                                                  adPhotoInfo.vedioFilePath,
                                                  [NSNumber numberWithInt:adPhotoInfo.photoId],
                         nil];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DBErrorCheckLog(db);
    }];
    return isSuccess;
}

-(NSArray *)allAdPhotoInfoForSubProductID:(int)subProductID {
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "AD_PHOTO_INFO_TABLE_TABLE_NAME
                                                  " WHERE "AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID" =? "
                                                  " ORDER BY "AD_PHOTO_INFO_TABLE_INDEX" ASC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:subProductID]];
        while ([resultSet next]){
            AdPhotoInfo *adPhotoInfo = [self adPhotoInfoFromFMResultSet:resultSet];
            [resultArray addObject:adPhotoInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(AdPhotoInfo *)lastAdPhotoInfo{
    __block AdPhotoInfo *adPhotoInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "AD_PHOTO_INFO_TABLE_TABLE_NAME
            " ORDER BY "AD_PHOTO_INFO_TABLE_INDEX" DESC LIMIT 1"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]){
            adPhotoInfo = [self adPhotoInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return adPhotoInfo;
}

- (AdPhotoInfo *)adPhotoInfoFromFMResultSet:(FMResultSet *)resultSet {
    AdPhotoInfo *adPhotoInfo = [[AdPhotoInfo alloc] init];
    adPhotoInfo.photoId = [resultSet intForColumn:AD_PHOTO_INFO_TABLE_PHOTO_ID];
    adPhotoInfo.subProductId = [resultSet intForColumn:AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID];
    adPhotoInfo.imageFilePath = [resultSet stringForColumn:AD_PHOTO_INFO_TABLE_IMAGE_FILE_PATH];
    adPhotoInfo.index = [resultSet intForColumn:AD_PHOTO_INFO_TABLE_INDEX];
    adPhotoInfo.hadVedio = [resultSet boolForColumn:AD_PHOTO_INFO_TABLE_HAD_VEDIO];
    adPhotoInfo.vedioFilePath = [resultSet stringForColumn:AD_PHOTO_INFO_TABLE_VIDIO_FILE_PATH];
    return adPhotoInfo;
}
@end