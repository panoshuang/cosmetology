//
// Created by mijie on 12-7-16.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaseDatabase.h"
#import "FileUtil.h"
#import "FMDatabase.h"
#import "Database_define.h"



@implementation BaseDatabase

@synthesize fmDbQueue;

SYNTHESIZE_SINGLETON_FOR_CLASS(BaseDatabase )

-(id)init{
    self = [super init];
    if (self){
        [FileUtil createPathWithRelativeToDocFilePath:DATABASE_PARENT_PATH];
        self.fmDbQueue = [FMDatabaseQueue databaseQueueWithPath:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:DATABASE_PATH]] ;
        DDetailLog(@"数据库的路径是：%@",[FileUtil getDocumentDirectory]);
        //判断是否已经建表，没有的话调用建表方法
        if(![self isExitTableAtDbFile]){
            [self createAllTable];
        }
    }
    //打开外键约束功能
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        // enable foreign_key
        NSString *sql = @"PRAGMA foreign_keys = ON;";
        [db executeUpdate:sql];
    }];
    
    return self;
}


-(BOOL)createAllTable{
    __block BOOL isError = NO;
    [[[BaseDatabase instance] fmDbQueue] inTransaction:^(FMDatabase *db,BOOL *rollback){
        if (![self createMainProductInfoTable:db]){
            *rollback = isError;
            return;
        }
        if(![self createSubProductInfoTable:db]){
            *rollback = isError;
            return;
        }
        if(![self createAdPhotoInfoTable:db]){
            *rollback = isError;
            return;
        }
        if (![self creatMessageBoardInfoTable:db]) {
            *rollback = isError;
            return;
        }
        

    }];
    return isError;
}

-(BOOL)createMainProductInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME
            "("
            MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID" INTEGER PRIMARY KEY AUTOINCREMENT,"
            MAIN_PRODUCT_INFO_TABLE_NAME" TEXT NOT NULL,"
            MAIN_PRODUCT_INFO_ENABLE" TEXT,"
            MAIN_PRODUCT_INFO_INDEX" INTEGER,"
            MAIN_PRODUCT_INFO_BG_IMAGE_FILE" TEXT,"
            MAIN_PRODUCT_INFO_PREVIEW_IMAGE_FILE" TEXT,"
            MAIN_PRODUCT_INFO_SUB_ITEM_BTN_IMAGE_NAME" TEXT,"
            MAIN_PRODDUCT_INFO_SUB_ITEM_BTN_COLOR_TYPE" INTEGER,"
            MAIN_PRODUCT_INFO_CREATE_AT" REAL"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createSubProductInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "SUB_PRODUCT_INFO_TABLE_TABLE_NAME
            "("
            SUB_PRODUCT_INFO_TABLE_PRODUCT_ID" INTEGER PRIMARY KEY AUTOINCREMENT,"
            SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID" INTEGER ,"
            SUB_PRODUCT_INFO_TABLE_NAME" TEXT NOT NULL,"
            SUB_PRODUCT_INFO_TABLE_ENABLE" INTEGER,"
            SUB_PRODUCT_INFO_TABLE_INDEX" INTEGER,"
            SUB_PRODUCT_INFO_TABLE_PRICE_IMAGE_FILE" TEXT ,"
            SUB_PRODUCT_INFO_TABLE_PREVIEW_FILE" TEXT ,"
            " FOREIGN KEY  ("SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID") REFERENCES "MAIN_PRODUCT_INFO_TABLE_TABLE_NAME" ("MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createAdPhotoInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "AD_PHOTO_INFO_TABLE_TABLE_NAME
            "("
            AD_PHOTO_INFO_TABLE_PHOTO_ID" INTEGER PRIMARY KEY AUTOINCREMENT,"
            AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID" INTEGER ,"
            AD_PHOTO_INFO_TABLE_INDEX" INTEGER,"
            AD_PHOTO_INFO_TABLE_IMAGE_FILE_PATH" TEXT NOT NULL,"
            AD_PHOTO_INFO_TABLE_HAD_VEDIO" INTEGER,"
            AD_PHOTO_INFO_TABLE_VIDIO_FILE_PATH" TEXT ,"
            " FOREIGN KEY  ("AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID") REFERENCES "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" ("SUB_PRODUCT_INFO_TABLE_PRODUCT_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)creatMessageBoardInfoTable:(FMDatabase *)db
{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "MESSAGE_BOARD_INFO_TABLE_TABLE_NAME
                      "("
                      MESSAGE_BOARD_INFO_TABLE_MESSAGE_ID" INTEGER PRIMARY KEY AUTOINCREMENT,"
                      MESSAGE_BOARD_INFO_TABLE_MESSAGE_CONTENT" TEXT,"
                      MESSAGE_BOARD_INFO_TABLE_MESSAGE_RECORD" TEXT,"
                      MESSAGE_BOARD_INFO_TABLE_HEAD_PORTRAITS" TEXT,"
                      MESSAGE_BOARD_INFO_TABLE_SINGE_NAME" TEXT,"
                      MESSAGE_BOARD_INFO_TABLE_POPULARITY" INTEGER ,"
                      MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID" INTEGER ,"
                      MESSAGE_BOARD_INFO_TABLE_CREATE_AT" REAL,"
                      " FOREIGN KEY  ("MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID") REFERENCES "SUB_PRODUCT_INFO_TABLE_TABLE_NAME" ("SUB_PRODUCT_INFO_TABLE_PRODUCT_ID") ON DELETE CASCADE"
                      ")"
                      ];
    DBErrorCheckLog(db);
    return isSuccess;
}

#pragma mark - 检查数据库是否已经创建过表
- (BOOL)isExitTableAtDbFile{
    __block BOOL isExitTables = NO;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase * db){
        FMResultSet *resultSet = [db executeQuery:@"SELECT count(*) FROM sqlite_master WHERE type='table'"];
        if ([resultSet next]){
            isExitTables = [resultSet intForColumn:@"count(*)"]>0? YES:NO;
        }else{
            isExitTables = NO;
        }
        [resultSet close];
        DBErrorCheckLog(db);
    }];
    return isExitTables;
}



@end