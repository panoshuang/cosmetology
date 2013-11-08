//
//  MessageBoardInfoDao.m
//  Cosmetology
//
//  Created by mijie on 13-6-18.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MessageBoardInfoDao.h"
#import "BaseDatabase.h"
#import "Database_define.h"
#import "FMDatabase.h"

@implementation MessageBoardInfoDao{
    
}

SYNTHESIZE_SINGLETON_FOR_CLASS(MessageBoardInfoDao)

-(int)addMessageBoardInfo:(MessageBoardInfo *)messageBoardInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO "MESSAGE_BOARD_INFO_TABLE_TABLE_NAME" ("
                        MESSAGE_BOARD_INFO_TABLE_MESSAGE_CONTENT","
                        MESSAGE_BOARD_INFO_TABLE_MESSAGE_RECORD","
                        MESSAGE_BOARD_INFO_TABLE_HEAD_PORTRAITS","
                        MESSAGE_BOARD_INFO_TABLE_SINGE_NAME","
                        MESSAGE_BOARD_INFO_TABLE_POPULARITY","
                        MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID","
                        MESSAGE_BOARD_INFO_TABLE_CREATE_AT""
                        ")""VALUES(?,?,?,?,?,?,?)"
                        
                        ];
    NSArray *argArray = [NSArray arrayWithObjects:
                         messageBoardInfo.messageContent,
                         messageBoardInfo.messageRecord.length>0?messageBoardInfo.messageRecord:@"",
                         messageBoardInfo.headPortraits,
                         messageBoardInfo.singeName,
                         [NSNumber numberWithInteger:messageBoardInfo.popularity],
                         [NSNumber numberWithInteger:messageBoardInfo.subProductID],
                         [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],
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

- (BOOL)deleteMessageBoardForID:(int)messageID{
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM "MESSAGE_BOARD_INFO_TABLE_TABLE_NAME
                        " WHERE "MESSAGE_BOARD_INFO_TABLE_MESSAGE_ID" =?"];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr, [NSNumber numberWithInt:messageID]];
        DBErrorCheckLog(db);
        
    }];
    return isSuccess;
}

-(BOOL)updateMessageBoard:(MessageBoardInfo *)messageBoardInfo{
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE "MESSAGE_BOARD_INFO_TABLE_TABLE_NAME" SET "
                        MESSAGE_BOARD_INFO_TABLE_MESSAGE_CONTENT"=?,"
                        MESSAGE_BOARD_INFO_TABLE_MESSAGE_RECORD"=?,"
                        MESSAGE_BOARD_INFO_TABLE_HEAD_PORTRAITS"=?,"
                        MESSAGE_BOARD_INFO_TABLE_SINGE_NAME"=?,"
                        MESSAGE_BOARD_INFO_TABLE_POPULARITY"=?,"
                        MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID"=?"
                        " WHERE "MESSAGE_BOARD_INFO_TABLE_MESSAGE_ID"=?"];
    NSArray *argArray = [NSArray arrayWithObjects:
                         messageBoardInfo.messageContent,
                         messageBoardInfo.messageRecord,
                         messageBoardInfo.headPortraits,
                         messageBoardInfo.singeName,
                         [NSNumber numberWithInteger:messageBoardInfo.popularity],
                         [NSNumber numberWithInteger:messageBoardInfo.subProductID],
                         [NSNumber numberWithInt:messageBoardInfo.messageID],
                         nil];
    __block BOOL isSuccess;
    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
        DBErrorCheckLog(db);
    }];
    return isSuccess;
}

-(NSArray *)allMessageBoardForSubProductID:(int)subProductID
{
    __block NSMutableArray *resultArray = [NSMutableArray array] ;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MESSAGE_BOARD_INFO_TABLE_TABLE_NAME
                        " WHERE "MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID" =? "
                        " ORDER BY "MESSAGE_BOARD_INFO_TABLE_CREATE_AT" DESC"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr,[NSNumber numberWithInt:subProductID]];
        while ([resultSet next]){
            MessageBoardInfo *messageBoardInfo = [self messageBoardInfoFromFMResultSet:resultSet];
            [resultArray addObject:messageBoardInfo];
        }
        DBErrorCheckLog(db);
    }];
    return resultArray;
}

-(MessageBoardInfo *)lastMessageBoard{
    __block MessageBoardInfo *messageBoardInfo = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from "MESSAGE_BOARD_INFO_TABLE_TABLE_NAME
                        " ORDER BY "MESSAGE_BOARD_INFO_TABLE_CREATE_AT" DESC LIMIT 1"];
    [[BaseDatabase instance].fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]){
            messageBoardInfo = [self messageBoardInfoFromFMResultSet:resultSet];
        }
        DBErrorCheckLog(db);
    }];
    return messageBoardInfo;
}

- (MessageBoardInfo *)messageBoardInfoFromFMResultSet:(FMResultSet *)resultSet {
    MessageBoardInfo *messageBoardInfo = [[MessageBoardInfo alloc]
                                          init];
    messageBoardInfo.messageID = [resultSet intForColumn:MESSAGE_BOARD_INFO_TABLE_MESSAGE_ID];
    messageBoardInfo.messageContent = [resultSet stringForColumn:MESSAGE_BOARD_INFO_TABLE_MESSAGE_CONTENT];
    messageBoardInfo.messageRecord = [resultSet stringForColumn:MESSAGE_BOARD_INFO_TABLE_MESSAGE_RECORD];
    messageBoardInfo.headPortraits = [resultSet stringForColumn:MESSAGE_BOARD_INFO_TABLE_HEAD_PORTRAITS];
    messageBoardInfo.singeName = [resultSet stringForColumn:MESSAGE_BOARD_INFO_TABLE_SINGE_NAME];
    messageBoardInfo.popularity = [resultSet intForColumn:MESSAGE_BOARD_INFO_TABLE_POPULARITY];
    messageBoardInfo.subProductID = [resultSet intForColumn:MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID];
    return messageBoardInfo;
}


@end
