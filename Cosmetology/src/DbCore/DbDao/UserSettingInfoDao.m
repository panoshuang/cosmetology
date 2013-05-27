//${FILENAME}   create by mijie on 12-7-25
//************************************
//@文件描述：
//***********************************

#import "UserSettingInfoDao.h"
#import "BaseDatabase.h"
#import "Database_define.h"
#import "FMDatabase.h"


@implementation UserSettingInfoDao

SYNTHESIZE_SINGLETON_FOR_CLASS(UserSettingInfoDao)

////增加用户信息
//- (BOOL)addUserSettingInfo:(UserSettingInfo *)userSettingInfo {
//    if (userSettingInfo.accountID.length == 0){
//        return NO;
//    }
//    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO "USER_SETTING_INFO_TABLE_TABLE_NAME" ("
//            USER_SETTING_INFO_TABLE_ACCOUNT_ID","
//            USER_SETTING_INFO_TABLE_RECEIVE_SYS_MSG","
//            USER_SETTING_INFO_TABLE_STARTED_AT_BOOT","
//            USER_SETTING_INFO_TABLE_TONE_ALERT","
//            USER_SETTING_INFO_TABLE_VIBRATING_ALERT","
//            USER_SETTING_INFO_TABLE_CHAT_RECORD_LIFE_CYCLE","
//            USER_SETTING_INFO_TABLE_RECEIVE_CHAT_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_COMMENT_AND_REPLAY_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_PRIVACY_APPLY_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_APPLY_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_NEW_TOPIC_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_NEW_OPINION_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_TOPIC_VERIFY_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_RECEIVE_REPORT_FEED_BACK_MSG_PUSH","
//            USER_SETTING_INFO_TABLE_IS_RECEIVE_NEARBY_MOOD","
//            USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_FILTER","
//            USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_LIMIT""
//            ")""VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
//
//    ];
//    NSArray *argArray = [NSArray arrayWithObjects:userSettingInfo.accountID,
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveSysMsg],
//                                                  [NSNumber numberWithInt:userSettingInfo.startedAtBoot],
//                                                  [NSNumber numberWithInt:userSettingInfo.toneAlert],
//                                                  [NSNumber numberWithInt:userSettingInfo.vibratingAlert],
//                                                  [NSNumber numberWithInt:userSettingInfo.chatRecordLifeCycle],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveChatMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveCommentAndReplyMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receivePrivacyApplyMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveFriendApplyMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveFriendNewTopicMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveNewOpinionMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveTopicVerifyMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveReportFeedBackMsgPush],
//                                                  [NSNumber numberWithInt:userSettingInfo.isReceiveNearbyMood],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveNearbyMoodFilter],
//                                                  [NSNumber numberWithInt:userSettingInfo.receiveNearbyMoodLimit],
//                                                  nil];
//    __block BOOL isSuccess;
//    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
//        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
//        DBErrorCheckLog(db);
//    }];
//    return isSuccess;
//}
//
////通过ID获取用户设置
//- (UserSettingInfo *)userSettingInfoForUID:(NSString *)userID {
//    if (userID.length == 0){
//        return nil;
//    }
//    __block UserSettingInfo *userSettingInfo = nil;
//    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM "USER_SETTING_INFO_TABLE_TABLE_NAME" WHERE "USER_SETTING_INFO_TABLE_ACCOUNT_ID" = ?"];
//    NSArray *argArray = [NSArray arrayWithObject:userID];
//    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
//
//        FMResultSet *resultSet = [db executeQuery:sqlStr withArgumentsInArray:argArray];
//        while ([resultSet next]) {
//            userSettingInfo = [self userSettingInfoFromFMResultSet:resultSet];
//        }
//
//    }];
//    return userSettingInfo;
//}
//
//
////更新用户设置信息
//- (BOOL)updateUserSettingInfo:(UserSettingInfo *)userSettingInfo {
//    if (userSettingInfo.accountID.length == 0){
//        return NO;
//    }
//    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE "USER_SETTING_INFO_TABLE_TABLE_NAME" SET "
//            USER_SETTING_INFO_TABLE_RECEIVE_SYS_MSG"=?,"
//            USER_SETTING_INFO_TABLE_STARTED_AT_BOOT"=?,"
//            USER_SETTING_INFO_TABLE_TONE_ALERT"=?,"
//            USER_SETTING_INFO_TABLE_VIBRATING_ALERT"=?,"
//            USER_SETTING_INFO_TABLE_CHAT_RECORD_LIFE_CYCLE"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_CHAT_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_COMMENT_AND_REPLAY_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_PRIVACY_APPLY_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_APPLY_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_NEW_TOPIC_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_NEW_OPINION_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_TOPIC_VERIFY_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_REPORT_FEED_BACK_MSG_PUSH"=?,"
//            USER_SETTING_INFO_TABLE_IS_RECEIVE_NEARBY_MOOD"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_FILTER"=?,"
//            USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_LIMIT"=?"
//            " WHERE "USER_SETTING_INFO_TABLE_ACCOUNT_ID"=?"
//
//    ];
//    NSArray *argArray = [NSArray arrayWithObjects:
//            [NSNumber numberWithInt:userSettingInfo.receiveSysMsg],
//            [NSNumber numberWithInt:userSettingInfo.startedAtBoot],
//            [NSNumber numberWithInt:userSettingInfo.toneAlert],
//            [NSNumber numberWithInt:userSettingInfo.vibratingAlert],
//            [NSNumber numberWithInt:userSettingInfo.chatRecordLifeCycle],
//            [NSNumber numberWithInt:userSettingInfo.receiveChatMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receiveCommentAndReplyMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receivePrivacyApplyMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receiveFriendApplyMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receiveFriendNewTopicMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receiveNewOpinionMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receiveTopicVerifyMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.receiveReportFeedBackMsgPush],
//            [NSNumber numberWithInt:userSettingInfo.isReceiveNearbyMood],
//            [NSNumber numberWithInt:userSettingInfo.receiveNearbyMoodFilter],
//            [NSNumber numberWithInt:userSettingInfo.receiveNearbyMoodLimit],
//            userSettingInfo.accountID,
//            nil];
//    __block BOOL isSuccess;
//    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
//
//        isSuccess = [db executeUpdate:sqlStr withArgumentsInArray:argArray];
//        DBErrorCheckLog(db);
//
//
//    }];
//    return isSuccess;
//}
//
////删除指定ID的账号
//- (BOOL)deleteUserSettingInfoForUID:(NSString *)userID {
//    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM "USER_SETTING_INFO_TABLE_TABLE_NAME
//            " WHERE "USER_SETTING_INFO_TABLE_ACCOUNT_ID" =?"];
//    __block BOOL isSuccess;
//    [[[BaseDatabase instance] fmDbQueue] inDatabase:^(FMDatabase *db) {
//
//        isSuccess = [db executeUpdate:sqlStr, userID];
//        DBErrorCheckLog(db);
//
//    }];
//    return isSuccess;
//}
//
//- (UserSettingInfo *)userSettingInfoFromFMResultSet:(FMResultSet *)resultSet {
//    UserSettingInfo *userSettingInfo = [[[UserSettingInfo alloc] init] autorelease];
//    userSettingInfo.accountID = [resultSet stringForColumn:USER_SETTING_INFO_TABLE_ACCOUNT_ID];
//    userSettingInfo.receiveSysMsg = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_SYS_MSG];
//    userSettingInfo.startedAtBoot = [resultSet intForColumn:USER_SETTING_INFO_TABLE_STARTED_AT_BOOT];
//    userSettingInfo.toneAlert = [resultSet intForColumn:USER_SETTING_INFO_TABLE_TONE_ALERT];
//    userSettingInfo.vibratingAlert = [resultSet intForColumn:USER_SETTING_INFO_TABLE_VIBRATING_ALERT];
//    userSettingInfo.chatRecordLifeCycle = (EnumChatRecordLifeCycle) [resultSet intForColumn:USER_SETTING_INFO_TABLE_CHAT_RECORD_LIFE_CYCLE];
//    userSettingInfo.receiveChatMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_CHAT_MSG_PUSH] ;
//    userSettingInfo.receiveCommentAndReplyMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_COMMENT_AND_REPLAY_MSG_PUSH] ;
//    userSettingInfo.receivePrivacyApplyMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_PRIVACY_APPLY_MSG_PUSH] ;
//    userSettingInfo.receiveFriendApplyMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_APPLY_MSG_PUSH] ;
//    userSettingInfo.receiveFriendNewTopicMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_NEW_TOPIC_MSG_PUSH] ;
//    userSettingInfo.receiveNewOpinionMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_NEW_OPINION_MSG_PUSH] ;
//    userSettingInfo.receiveTopicVerifyMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_TOPIC_VERIFY_MSG_PUSH] ;
//    userSettingInfo.receiveReportFeedBackMsgPush = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_REPORT_FEED_BACK_MSG_PUSH] ;
//    userSettingInfo.isReceiveNearbyMood = [resultSet boolForColumn:USER_SETTING_INFO_TABLE_IS_RECEIVE_NEARBY_MOOD] ;
//    userSettingInfo.receiveNearbyMoodFilter = (EnumSexType)[resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_FILTER] ;
//    userSettingInfo.receiveNearbyMoodLimit = [resultSet intForColumn:USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_LIMIT] ;
//    return userSettingInfo;
//}

@end