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
        
        //处理应用升级时候数据库升级处理
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *dbFileVersion = [userDefaults stringForKey:DATABASE_FILE_VERSION];
//        NSString *appVersion = [HomiUtil getAppBuildVersion];
        /**
        * 数据库升级逻辑:数据库升级按照版本迭代分步执行升级,版本匹配规则按照build version的最后一段数字,build version目前定义的有点问题,刚开始定义
        * 成了1.0.2,所以后续需要保持最后一段数字递增
        */
        //判断数据库的版本信息,如果没有获取到则表示是1.0.2版本的或者是新安装的app,做建表处理,该版本没有做升级处理,
        // 有则获取目前的版本信息跟app的版本信息进行匹配,如果相同就表示已经升级过了,不一致就表示需要升级处理
//        if (dbFileVersion.length != 0) {
//            if(![dbFileVersion isEqualToString:appVersion]){
//                //删除软件升级提示
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults removeObjectForKey:APP_LAST_UPDATE_TIPS_TIME];
//                
//                //更新数据库
//                int dbVersion = [[[dbFileVersion componentsSeparatedByString:@"."] lastObject] intValue];
//                int newVersion = [[[appVersion componentsSeparatedByString:@"."] lastObject] intValue];
//                for (int version = dbVersion + 1; version <= newVersion; version++) {
//                    NSString *databaseUpdateClassName = [NSString stringWithFormat:@"DatabaseUpdate%d",version];
//                    Class updateClass =  NSClassFromString(databaseUpdateClassName);
//                    if (updateClass){
//                        BaseDatabaseUpdate *databaseUpdate =  (BaseDatabaseUpdate *)[[updateClass alloc] init];
//                        [databaseUpdate updateDatabase];
//                        [databaseUpdate release];
//                    }
//                }
//                //更新数据库版本信息
//                [userDefaults setObject:appVersion forKey:DATABASE_FILE_VERSION];
//            }
//        }else{
//            //设置数据库版本信息
//            [userDefaults setObject:appVersion forKey:DATABASE_FILE_VERSION];
//            //判断是否已经存在数据表了,存在则更新表结构(这种情况只有在1.0.2版本存在),不存在则创建所有的表
//            if ([self isExitTableAtDbFile]){
//                //删除软件升级提示
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults removeObjectForKey:APP_LAST_UPDATE_TIPS_TIME];
//                
//                int dbVersion = [[[dbFileVersion componentsSeparatedByString:@"."] lastObject] intValue];
//                int newVersion = [[[appVersion componentsSeparatedByString:@"."] lastObject] intValue];
//                for (int version = dbVersion + 1; version <= newVersion; version++) {
//                    NSString *databaseUpdateClassName = [NSString stringWithFormat:@"DatabaseUpdate%d",version];
//                    Class updateClass =  NSClassFromString(databaseUpdateClassName);
//                    if (updateClass){
//                        BaseDatabaseUpdate *databaseUpdate =  (BaseDatabaseUpdate *)[[updateClass alloc] init];
//                        [databaseUpdate updateDatabase];
//                        [databaseUpdate release];
//                    }
//                }
//            }else{
//                //创建所有的数据表
//                [self createAllTable];
//            }
//        }
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
        [self createUserAccountInfoTable:db] ;
        [self createAppConfigInfoTable:db];
        [self createUserInfoTable:db];
        //V106取消同心情匹配心情逻辑
//        [self createSameMoodUserTable:db];
//        [self createMatchMoodUserTable:db];
        //v106增加同命相连逻辑
        [self createFellowSuffererUserTable:db];
        [self createUserSettingInfoTable:db];
        [self createPrivacyInfoTable:db];
        //          [self createPhotoAlbumInfoTable:db];
        //          [self createPhotoInfoTable:db];
        //          [self createPhotoCommentInfoTable:db];
        //          [self createPhotoCommentReplyInfoTable:db];
        [self createBaseNotifyMsgInfoTable:db];
        [self createTopicVerifyNotifyInfoTable:db];
        [self createReportNotifyMsgInfoTable:db];
        [self createFriendNewTopicNotifyMsgInfoTable:db];
        [self createNewOpinionNotifyMsgInfoTable:db];
        [self createSystemMsgInfoTable:db];
        [self createPrivacyApplyInfoTable:db];
        [self createCommentAndReplyNotifyInfoTable:db];
        [self createChatInfoTable:db];
        [self createChatMsgInfoTable:db];
        [self createMoodTypeInfoTable:db];
        [self createAddFriendMsgInfoTable:db];
        [self createRelateTopicInfoTable:db];
        [self createMatchTopicInfoTable:db];
        [self createTopicOptionInfo:db];
        [self createApplyRecordInfoTable:db];
        [self createNearbyMoodNotifyInfoTable:db];
        //v106增加用户操作表
        [self createUserOperationRecordTable:db];
        //v106增加话题分类
        [self createTopicCatalogInfoTable:db];
    }];
    return isError;
}


-(BOOL)createUserAccountInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS "USER_ACCOUNT_INFO_TABLE_TABLE_NAME
            "("USER_ACCOUNT_INFO_TABLE_USER_ID" TEXT PRIMARY KEY,"
            USER_ACCOUNT_INFO_TABLE_NAME" TEXT,"
            USER_ACCOUNT_INFO_TABLE_NICKNAME" TEXT, "
            USER_ACCOUNT_INFO_TABLE_EMAIL" TEXT, "
            USER_ACCOUNT_INFO_TABLE_EMAIL_VERIFIED" INTEGER, "
            USER_ACCOUNT_INFO_TABLE_PORTRAIT_URL" TEXT,"
            USER_ACCOUNT_INFO_TABLE_PORTRAIT_FILE_PATH" TEXT,"
            USER_ACCOUNT_INFO_TABLE_LAST_MOOD_ID" INTEGER,"          
            USER_ACCOUNT_INFO_TABLE_LAST_MOOD_TYPE" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_LAST_MOOD_CREATE_AT" REAL,"
            USER_ACCOUNT_INFO_TABLE_LAST_MOOD_CONTENT" TEXT,"
            USER_ACCOUNT_INFO_TABLE_THIS_MOOD_TYPE" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_THIS_MOOD_CREATE_AT" REAL,"
            USER_ACCOUNT_INFO_TABLE_LBSDISTANCE" REAL,"
            USER_ACCOUNT_INFO_TABLE_SIGNATURE" TEXT,"
            USER_ACCOUNT_INFO_TABLE_GENDER_TYPE" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_ALBUM_COVER" TEXT,"
            USER_ACCOUNT_INFO_TABLE_NATION" TEXT,"
            USER_ACCOUNT_INFO_TABLE_PROVINCE" TEXT,"
            USER_ACCOUNT_INFO_TABLE_CITY" TEXT,"
            USER_ACCOUNT_INFO_TABLE_DISTRICT" TEXT,"
            USER_ACCOUNT_INFO_TABLE_LAST_LOGIN_AT" REAL,"
            USER_ACCOUNT_INFO_TABLE_LONGITUDE" REAL,"
            USER_ACCOUNT_INFO_TABLE_LATITUDE" REAL,"
            USER_ACCOUNT_INFO_TABLE_PHONE" TEXT,"
            USER_ACCOUNT_INFO_TABLE_IS_VERIFIED" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_BIRTHDAY" TEXT,"
            USER_ACCOUNT_INFO_TABLE_GRADE" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_INTEGRAL" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_NUM_OF_MOOD" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_PASSWORD" TEXT,"
            USER_ACCOUNT_INFO_TABLE_IS_REMEMBER_PASSWORD" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_IS_AUTO_LOGIN" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_IS_LOGIN" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_STATUS" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_IS_FIRST_TIME_LOGIN_OF_TODAY" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_NUM_OF_LOGIN" INTEGER,"
            USER_ACCOUNT_INFO_TABLE_HAD_RATE" INTEGER"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createAppConfigInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "APPCONFIG_INFO_TABLE_TABLE_NAME
                      "("
                      APPCONFIG_INFO_TABLE_SETTING_ID" INTEGER PRIMARY KEY AUTOINCREMENT,"
                      APPCONFIG_INFO_TABLE_KEY" TEXT NOT NULL,"
                      APPCONFIG_INFO_TABLE_VALUE" TEXT, "
                      APPCONFIG_INFO_TABLE_USER_ACCOUNT_ID" TEXT,"
                      RESERVED_COL0" TEXT," //保留字段
                      RESERVED_COL1" TEXT,"
                      RESERVED_COL2" TEXT,"
                      RESERVED_COL3" TEXT"
                      ")"
                      ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createUserInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "USER_INFO_TABLE_TABLE_NAME
                      "("USER_INFO_TABLE_USER_ID" TEXT ,"
                      USER_INFO_TABLE_ACCOUNT_ID" TEXT,"
                      USER_INFO_TABLE_NAME" TEXT,"
                      USER_INFO_TABLE_NICKNAME" TEXT, "
                      USER_INFO_TABLE_EMAIL" TEXT, "
                      USER_INFO_TABLE_PORTRAIT_URL" TEXT,"
                      USER_INFO_TABLE_PORTRAIT_FILE_PATH" TEXT,"
                      USER_INFO_TABLE_LAST_MOOD_TYPE" INTEGER,"
                      USER_INFO_TABLE_LAST_MOOD_CREATE_AT "  REAL,"
                      USER_INFO_TABLE_LAST_MOOD_CONTENT "  TEXT,"
                      USER_INFO_TABLE_LAST_MOOD_IS_PROTECT "  INTEGER,"
                      USER_INFO_TABLE_LAST_MOOD_MATCH "  INTEGER,"
                      USER_INFO_TABLE_PENULTIMATE_MOOD_TYPE" INTEGER,"
                      USER_INFO_TABLE_PENULTIMATE_MOOD_CREATE_AT" REAL,"
                      USER_INFO_TABLE_LAST_CONTACT_MOOD_TYPE" INTEGER,"
                      USER_INFO_TABLE_LAST_CONTACT_MOOD_CREATE_AT "  REAL,"
                      USER_INFO_TABLE_LAST_CONTACT_MOOD_OF_MINE" REAL,"
                      USER_INFO_TABLE_LBSDISTANCE" REAL,"
                      USER_INFO_TABLE_SIGNATURE" TEXT,"
                      USER_INFO_TABLE_GENDER_TYPE" INTEGER,"
                      USER_INFO_TABLE_ALBUM_COVER" TEXT,"
                      USER_INFO_TABLE_NATION" TEXT,"
                      USER_INFO_TABLE_PROVINCE" TEXT,"
                      USER_INFO_TABLE_CITY" INTEGER,"
                      USER_INFO_TABLE_DISTRICT" TEXT,"
                      USER_INFO_TABLE_LAST_LOGIN_AT" REAL,"
                      USER_INFO_TABLE_LAST_CONTACT_AT" REAL,"
                      USER_INFO_TABLE_LONGITUDE" REAL,"
                      USER_INFO_TABLE_LATITUDE" REAL,"
                      USER_INFO_TABLE_PHONE" TEXT,"
                      USER_INFO_TABLE_IS_VERIFIED" INTEGER,"
                      USER_INFO_TABLE_IS_BLOCK" INTEGER,"
                      USER_INFO_TABLE_IS_FRIEND" INTEGER,"
                      USER_INFO_TABLE_BIRTHDAY" TEXT,"
                      USER_INFO_TABLE_GRADE" INTEGER,"
                      USER_INFO_TABLE_INTEGRAL" INTEGER,"
                      USER_INFO_TABLE_NUM_OF_MOOD" INTEGER,"
                      USER_INFO_TABLE_LAST_UPDATE_AT" REAL,"
                      RESERVED_COL0" TEXT," //保留字段
                      RESERVED_COL1" TEXT,"
                      RESERVED_COL2" TEXT,"
                      RESERVED_COL3" TEXT,"
                      "PRIMARY KEY("USER_INFO_TABLE_USER_ID","USER_INFO_TABLE_ACCOUNT_ID")"
                      ")"
                      ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createSameMoodUserTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "SAME_MOOD_USER_TABLE_TABLE_NAME
                       "("SAME_MOOD_USER_TABLE_ACCOUNT_ID" TEXT,"
                       SAME_MOOD_USER_TABLE_TARGET_USER_ID" TEXT,"
                       SAME_MOOD_USER_TABLE_UPDATE_DATE" REAL,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT,"
                       "PRIMARY KEY("SAME_MOOD_USER_TABLE_ACCOUNT_ID","SAME_MOOD_USER_TABLE_TARGET_USER_ID")"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createMatchMoodUserTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "MATCH_MOOD_USER_TABLE_TABLE_NAME
                       "("MATCH_MOOD_USER_TABLE_ACCOUNT_ID" TEXT,"
                       MATCH_MOOD_USER_TABLE_TARGET_USER_ID" TEXT,"
                       MATCH_MOOD_USER_TABLE_UPDATE_DATE" REAL,"
                       "PRIMARY KEY("MATCH_MOOD_USER_TABLE_ACCOUNT_ID","MATCH_MOOD_USER_TABLE_TARGET_USER_ID")"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//创建同命相连用户关联字表
-(BOOL)createFellowSuffererUserTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "FELLOW_SUFFERER_USER_TABLE_TABLE_NAME
                       "("FELLOW_SUFFERER_USER_TABLE_ACCOUNT_ID" TEXT,"
                       FELLOW_SUFFERER_USER_TABLE_TARGET_USER_ID" TEXT,"
                       FELLOW_SUFFERER_USER_TABLE_UPDATE_DATE" REAL,"
                       "PRIMARY KEY("FELLOW_SUFFERER_USER_TABLE_ACCOUNT_ID","FELLOW_SUFFERER_USER_TABLE_TARGET_USER_ID")"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createUserSettingInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "USER_SETTING_INFO_TABLE_TABLE_NAME
                       "("USER_SETTING_INFO_TABLE_ACCOUNT_ID" TEXT PRIMARY KEY,"
                       USER_SETTING_INFO_TABLE_RECEIVE_SYS_MSG" INTEGER, "
                       USER_SETTING_INFO_TABLE_STARTED_AT_BOOT" INTEGER,"
                       USER_SETTING_INFO_TABLE_TONE_ALERT" INTEGER,"
                       USER_SETTING_INFO_TABLE_VIBRATING_ALERT "  INTEGER,"
                       USER_SETTING_INFO_TABLE_CHAT_RECORD_LIFE_CYCLE" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_CHAT_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_COMMENT_AND_REPLAY_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_PRIVACY_APPLY_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_APPLY_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_NEW_TOPIC_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_NEW_OPINION_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_TOPIC_VERIFY_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_REPORT_FEED_BACK_MSG_PUSH" INTEGER,"
                       USER_SETTING_INFO_TABLE_IS_RECEIVE_NEARBY_MOOD" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_FILTER" INTEGER,"
                       USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_LIMIT" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createPrivacyInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "PRIVACY_INFO_TABLE_TABLE_NAME
                       "("PRIVACY_INFO_TABLE_ACCOUNT_ID" TEXT PRIMARY KEY,"
                       PRIVACY_INFO_TABLE_MOOD_CHANGE_PRIVACY_TO_CONTACT" INTEGER,"
                       PRIVACY_INFO_TABLE_MOOD_CHANGE_PRIVACY_TO_STRANGER" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//暂时不做照片表的缓存,不调用该方法
-(BOOL)createPhotoAlbumInfoTable:(FMDatabase *)db{
    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "PHOTO_ALBUM_INFO_TABLE_TABLE_NAME
                      "("PHOTO_ALBUM_INFO_TABLE_ALBUM_ID" INTEGER PRIMARY KEY,"
                      PHOTO_ALBUM_INFO_TABLE_USER_ID" TEXT,"
                      PHOTO_ALBUM_INFO_TABLE_DESCRIBES" TEXT, "
                      PHOTO_ALBUM_INFO_TABLE_CREATE_AT" REAL,"
                      RESERVED_COL0" TEXT," //保留字段
                      RESERVED_COL1" TEXT,"
                      RESERVED_COL2" TEXT,"
                      RESERVED_COL3" TEXT"
                      ")"
                      ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//暂时不做照片表的缓存,不调用该方法
-(BOOL)createPhotoInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "PHOTO_INFO_TABLE_TABLE_NAME
                       "("PHOTO_INFO_TABLE_PHOTO_ID" TEXT PRIMARY KEY,"
                       PHOTO_INFO_TABLE_PHOTO_ALBUM_ID" INTEGER,"
                       PHOTO_INFO_TABLE_USER_ID" TEXT, "
                       PHOTO_INFO_TABLE_URL" TEXT,"
                       PHOTO_INFO_TABLE_FILEPATH" TEXT,"
                       PHOTO_INFO_TABLE_CREATE_AT" REAL,"
                       PHOTO_INFO_TABLE_NUM_OF_COMMENT" INTEGER,"
                       PHOTO_INFO_TABLE_NUM_OF_LIKE" INTEGER,"
                       PHOTO_INFO_TABLE_IS_BLOCK" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//暂时不做照片表的缓存,不调用该方法
-(BOOL)createPhotoCommentInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "PHOTO_COMMENT_INFO_TABLE_TABLE_NAME
                       "("PHOTO_COMMENT_INFO_TABLE_COMMENT_ID" INTEGER PRIMARY KEY,"
                       PHOTO_COMMENT_INFO_TABLE_CREATE_AT" REAL,"
                       PHOTO_COMMENT_INFO_TABLE_CONTENT" TEXT, "
                       PHOTO_COMMENT_INFO_TABLE_RECEIVER_ID" TEXT,"
                       PHOTO_COMMENT_INFO_TABLE_SENDER_ID" TEXT,"
                       PHOTO_COMMENT_INFO_TABLE_PHOTO_ID" TEXT,"
                       PHOTO_COMMENT_INFO_TABLE_IS_BLOCK" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//暂时不做照片表的缓存,不调用该方法
-(BOOL)createPhotoCommentReplyInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "PHOTO_COMMENT_REPLY_INFO_TABLE_TABLE_NAME
                       "("PHOTO_COMMENT_REPLY_INFO_TABLE_REPLY_ID" INTEGER PRIMARY KEY,"
                       PHOTO_COMMENT_REPLY_INFO_TABLE_CREATE_AT" REAL,"
                       PHOTO_COMMENT_REPLY_INFO_TABLE_CONTENT" TEXT, "
                       PHOTO_COMMENT_REPLY_INFO_TABLE_COMMENT_ID" TEXT,"
                       PHOTO_COMMENT_REPLY_INFO_TABLE_RECEIVER_ID" TEXT,"
                       PHOTO_COMMENT_REPLY_INFO_TABLE_SENDER_ID" TEXT,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createBaseNotifyMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME
            "("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
            BASE_NOTIFY_MSG_INFO_TABLE_ACCOUNT_ID" TEXT,"
            BASE_NOTIFY_MSG_INFO_TABLE_RELATE_USER_ID" TEXT,"
            BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_TYPE" INTEGER,"
            BASE_NOTIFY_MSG_INFO_TABLE_CREATE_AT" REAL,"
            BASE_NOTIFY_MSG_INFO_TABLE_IS_READED" INTEGER,"
            BASE_NOTIFY_MSG_INFO_TABLE_IS_HANDLED" INTEGER,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createSystemMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "SYSTEM_MSG_NOTIFY_TABLE_TABLE_NAME
            "("SYSTEM_MSG_NOTIFY_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
            SYSTEM_MSG_NOTIFY_TABLE_CREATE_AT" REAL,"
            SYSTEM_MSG_NOTIFY_TABLE_ID" INTEGER, "
            SYSTEM_MSG_NOTIFY_TABLE_TITLE" TEXT,"
            SYSTEM_MSG_NOTIFY_TABLE_LINK" TEXT,"
            SYSTEM_MSG_NOTIFY_TABLE_MSG" TEXT,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT,"
            " FOREIGN KEY ("SYSTEM_MSG_NOTIFY_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createTopicVerifyNotifyInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "TOPIC_VERIFY_NOTIFY_INFO_TABLE_TABLE_NAME
            "("TOPIC_VERIFY_NOTIFY_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY ,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_VERIFY_CATEGORY" INTEGER,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_CREATE_AT" REAL,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_ID" INTEGER,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_TITLE" TEXT,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_TAG" TEXT,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_OPTIONS" TEXT,"
            TOPIC_VERIFY_NOTIFY_INFO_TABLE_REASON" TEXT,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT,"
            " FOREIGN KEY ("TOPIC_VERIFY_NOTIFY_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createReportNotifyMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "REPORT_NOTIFY_MSG_INFO_TABLE_TABLE_NAME
            "("REPORT_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
            REPORT_NOTIFY_MSG_INFO_TABLE_REPORT_CATEGORY" INTEGER,"
            REPORT_NOTIFY_MSG_INFO_TABLE_CREATE_AT" REAL,"
            REPORT_NOTIFY_MSG_INFO_TABLE_CONTENT" TEXT,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT,"
            " FOREIGN KEY ("REPORT_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createFriendNewTopicNotifyMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_TABLE_NAME
            "("FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
            FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_CREATE_AT" REAL,"
            FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_FRIEND_ID" TEXT, "
            FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_TOPIC_ID" INTEGER,"
            FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_TOPIC_TITLE" TEXT,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT,"
            " FOREIGN KEY ("FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createNewOpinionNotifyMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "NEW_OPINION_NOTIFY_MSG_INFO_TABLE_TABLE_NAME
            "("NEW_OPINION_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
            NEW_OPINION_NOTIFY_MSG_INFO_TABLE_CREATE_AT" REAL,"
            NEW_OPINION_NOTIFY_MSG_INFO_TABLE_AUTHOR_USER_ID" TEXT, "
            NEW_OPINION_NOTIFY_MSG_INFO_TABLE_TOPIC_ID" INTEGER,"
            NEW_OPINION_NOTIFY_MSG_INFO_TABLE_OPINION" TEXT,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT,"
            " FOREIGN KEY ("NEW_OPINION_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createPrivacyApplyInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "PRIVACY_APPLY_INFO_TABLE_TABLE_NAME
                       "("PRIVACY_APPLY_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
                       PRIVACY_APPLY_INFO_TABLE_APPLICANT_ID" TEXT,"
                       PRIVACY_APPLY_INFO_TABLE_MSG_CATEGORY" INTEGER,"
                       PRIVACY_APPLY_INFO_TABLE_MODULE" TEXT,"
                       PRIVACY_APPLY_INFO_TABLE_CONTENT" TEXT,"
                       PRIVACY_APPLY_INFO_TABLE_CREATE_AT" REAL,"
                       PRIVACY_APPLY_INFO_TABLE_HANDLE_TYPE" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT,"
                       " FOREIGN KEY ("PRIVACY_APPLY_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createCommentAndReplyNotifyInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "COMMENT_AND_REPLY_INFO_TABLE_TABLE_NAME
                       "("COMMENT_AND_REPLY_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
                       COMMENT_AND_REPLY_INFO_TABLE_CREATE_AT" REAL, "
                       COMMENT_AND_REPLY_INFO_TABLE_CATEGORY" INTEGER,"
                       COMMENT_AND_REPLY_INFO_TABLE_TARGET_ID" INTEGER,"
                       COMMENT_AND_REPLY_INFO_TABLE_REFER_ID" INTEGER,"
                       COMMENT_AND_REPLY_INFO_TABLE_USER_ID" TEXT,"
                       COMMENT_AND_REPLY_INFO_TABLE_CONTENT" TEXT,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT,"
                       " FOREIGN KEY ("COMMENT_AND_REPLY_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//创建添加好友相关的socket消息表
-(BOOL)createAddFriendMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "ADD_FRIEND_MSG_INFO_TABLE_TABLE_NAME
            "("
            ADD_FRIEND_MSG_INFO_TABLE_NOTIFY_ID" TEXT PRIMARY KEY,"
            ADD_FRIEND_MSG_INFO_TABLE_USER_ID" TEXT,"
            ADD_FRIEND_MSG_INFO_TABLE_ACCOUNT_ID" TEXT,"
            ADD_FRIEND_MSG_INFO_TABLE_MSG_CATEGORY" INTEGER,"
            ADD_FRIEND_MSG_INFO_TABLE_CREATE_AT" REAL,"
            ADD_FRIEND_MSG_INFO_TABLE_HANDLE_TYPE" INTEGER,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT,"
            " FOREIGN KEY ("ADD_FRIEND_MSG_INFO_TABLE_NOTIFY_ID") REFERENCES "BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME" ("BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID") ON DELETE CASCADE"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}


-(BOOL)createChatInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "CHAT_INFO_TABLE_TABLE_NAME
                       "("CHAT_INFO_TABLE_TARGET_USER_ID" TEXT,"
                       CHAT_INFO_TABLE_ACCOUNT_ID" TEXT,"
                       CHAT_INFO_TABLE_LAST_UPDATE_TIME" REAL, "
                       CHAT_INFO_TABLE_LAST_MSG_CONTENT" TEXT,"
                       CHAT_INFO_TABLE_NUM_OF_UNREAD_MSG" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT,"
                       "PRIMARY KEY("CHAT_INFO_TABLE_TARGET_USER_ID","CHAT_INFO_TABLE_ACCOUNT_ID")"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}


-(BOOL)createChatMsgInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "CHAT_MSG_INFO_TABLE_TABLE_NAME
                       "("CHAT_MSG_INFO_TABLE_MSG_ID" TEXT PRIMARY KEY,"
                       CHAT_MSG_INFO_TABLE_ACCOUNT_ID" TEXT,"
                       CHAT_MSG_INFO_TABLE_SENDER_ID" TEXT, "
                       CHAT_MSG_INFO_TABLE_RECEIVER_ID" TEXT,"
                       CHAT_MSG_INFO_TABLE_CHAT_INFO_ID" TEXT,"
                       CHAT_MSG_INFO_TABLE_MSG_CONTENT" TEXT, "
                       CHAT_MSG_INFO_TABLE_LARGE_IMAGE_URL" TEXT,"
                       CHAT_MSG_INFO_TABLE_SMALL_IMAGE_URL" TEXT,"
                       CHAT_MSG_INFO_TABLE_LARGE_IMAGE_FILE_NAME" TEXT,"
                       CHAT_MSG_INFO_TABLE_AUDIO_URL" TEXT,"
                       CHAT_MSG_INFO_TABLE_AUDIO_FILE_NAME" TEXT,"
                       CHAT_MSG_INFO_TABLE_AUDIO_DURATION" INTEGER,"
                       CHAT_MSG_INFO_TABLE_CHAT_MSG_TYPE" INTEGER,"
                       CHAT_MSG_INFO_TABLE_LONGITUDE" REAL,"
                       CHAT_MSG_INFO_TABLE_LATITUDE" REAL, "
                       CHAT_MSG_INFO_TABLE_CREATE_AT" REAL,"
                       CHAT_MSG_INFO_TABLE_STATUS" INTEGER,"
                       CHAT_MSG_INFO_TABLE_MOOD_TYPE" INTEGER,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//创建服务器上的心情类别信息表
-(BOOL)createMoodTypeInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "MOOD_TYPE_TABLE_TABLE_NAME
                       "("MOOD_TYPE_TABLE_MOOD_TYPE" INTEGER PRIMARY KEY,"
                       MOOD_TYPE_TABLE_MOOD_NAME" TEXT,"
                       MOOD_TYPE_TABLE_TIPS_STR" TEXT, "
                       MOOD_TYPE_TABLE_MOOD_IMAGE_URL" TEXT,"
                       RESERVED_COL0" TEXT," //保留字段
                       RESERVED_COL1" TEXT,"
                       RESERVED_COL2" TEXT,"
                       RESERVED_COL3" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createRelateTopicInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "RELATE_TOPIC_INFO_TABLE_TABLE_NAME
            "("
            RELATE_TOPIC_INFO_TABLE_TOPIC_ID" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_USER_ID" TEXT,"
            RELATE_TOPIC_INFO_TABLE_ACCOUNT_ID" TEXT,"
            RELATE_TOPIC_INFO_TABLE_TITLE" TEXT, "
            RELATE_TOPIC_INFO_TABLE_TAGS" TEXT,"
            RELATE_TOPIC_INFO_TABLE_CHOICE_OPTION_CONTENT" TEXT,"
            RELATE_TOPIC_INFO_TABLE_CHOICE_OPTION_ID" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_IS_OWNER" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_IS_BLOCK" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_NUM_OF_OPINION" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_NUM_OF_PARTICIPATE" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_NUM_OF_CONFUSE" INTEGER,"
            RELATE_TOPIC_INFO_TABLE_TOPIC_PARTICIPATE_STATIC_TYPE" INTEGER,"
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//创建智能匹配话题缓存,v106增加
-(BOOL)createMatchTopicInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "MATCH_TOPIC_INFO_TABLE_TABLE_NAME
                       "("
                       MATCH_TOPIC_INFO_TABLE_TOPIC_ID" INTEGER,"
                       MATCH_TOPIC_INFO_TABLE_USER_ID" TEXT,"
                       MATCH_TOPIC_INFO_TABLE_ACCOUNT_ID" TEXT,"
                       MATCH_TOPIC_INFO_TABLE_TITLE" TEXT, "
                       MATCH_TOPIC_INFO_TABLE_TAGS" TEXT,"
                       MATCH_TOPIC_INFO_TABLE_IS_BLOCK" INTEGER,"
                       MATCH_TOPIC_INFO_TABLE_NUM_OF_OPINION" INTEGER,"
                       MATCH_TOPIC_INFO_TABLE_NUM_OF_PARTICIPATE" INTEGER,"
                       MATCH_TOPIC_INFO_TABLE_NUM_OF_CONFUSE" INTEGER"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

-(BOOL)createTopicOptionInfo:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "TOPIC_OPTION_INFO_TABLE_TABLE_NAME
            "("
            TOPIC_OPTION_INFO_TABLE_OPTION_ID" INTEGER,"
            TOPIC_OPTION_INFO_TABLE_TOPIC_ID" INTEGER,"
            TOPIC_OPTION_INFO_TABLE_CONTENT" TEXT,"
            TOPIC_OPTION_INFO_TABLE_NUM_OF_CHOICES" INTEGER, "
            RESERVED_COL0" TEXT," //保留字段
            RESERVED_COL1" TEXT,"
            RESERVED_COL2" TEXT,"
            RESERVED_COL3" TEXT"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}


//v106增加话题类别表
-(BOOL)createTopicCatalogInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "TOPIC_CATALOG_INFO_TABLE_TABLE_NAME
                       "("
                       TOPIC_CATALOG_INFO_TABLE_ID" INTEGER,"
                       TOPIC_CATALOG_INFO_TABLE_ACCOUNT_ID" TEXT,"
                       TOPIC_CATALOG_INFO_TABLE_NAME" TEXT,"
                       TOPIC_CATALOG_INFO_TABLE_DESCRIBES" TEXT,"
                       TOPIC_CATALOG_INFO_TABLE_IMAGE" TEXT,"
                       TOPIC_CATALOG_INFO_TABLE_SUB_IMAGE" TEXT,"
                       TOPIC_CATALOG_INFO_TABLE_PREVIEW_TOPIC_TITLES" TEXT"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}


//v106增加APPLY_RECORD_INFO_TABLE_TARGET_OBJECT_ID字段保存具体事物的id,eg:心情id
-(BOOL)createApplyRecordInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "APPLY_RECORD_INFO_TABLE_TABLE_NAME
            "("
            APPLY_RECORD_INFO_TABLE_ACCOUNT_ID" TEXT,"
            APPLY_RECORD_INFO_TABLE_TARGET_USER_ID" TEXT,"
            APPLY_RECORD_INFO_TABLE_APPLY_RECORD_TYPE" INTEGER,"
            APPLY_RECORD_INFO_TABLE_TARGET_OBJECT_ID" TEXT"
            ")"
    ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//创建附近心情推送信息表
- (BOOL)createNearbyMoodNotifyInfoTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "NEARBY_MOOD_NOTIFY_INFO_TABLE_TABLE_NAME
                       "("
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_ACCOUNT_ID" TEXT,"
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_USER_ID" TEXT,"
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_MOOD_ID" INTEGER,"
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_MOOD_TYPE" INTEGER,"
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_CONTENT" TEXT,"
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_CREATE_AT" REAL,"
                       NEARBY_MOOD_NOTIFY_INFO_TABLE_IS_READED" INTEGER"
                       ")"
                       ];
    DBErrorCheckLog(db);
    return isSuccess;
}

//v106增加,创建用户操作记录表
-(BOOL)createUserOperationRecordTable:(FMDatabase *)db{
    BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS "USER_ACCOUNT_OPERATION_RECORD_TABLE_TABLE_NAME
                       "("
                       USER_ACCOUNT_OPERATION_RECORD_ACCOUNT_ID" TEXT,"
                       USER_ACCOUNT_OPERATION_RECORD_KEY" TEXT,"
                       USER_ACCOUNT_OPERATION_RECORD_VALUE" TEXT,"
                       "PRIMARY KEY ("USER_ACCOUNT_OPERATION_RECORD_ACCOUNT_ID","USER_ACCOUNT_OPERATION_RECORD_KEY")"
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