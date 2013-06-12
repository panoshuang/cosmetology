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
            MAIN_PRODUCT_INFO_CREATE_AT" REAL"
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