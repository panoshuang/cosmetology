//
// Created by mijie on 12-7-16.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"


@interface BaseDatabase : NSObject  {
    FMDatabaseQueue *fmDbQueue;
}

@property (nonatomic, strong)  FMDatabaseQueue *fmDbQueue;

+(BaseDatabase *)instance;

//创建同命相连用户关联字表
-(BOOL)createFellowSuffererUserTable:(FMDatabase *)db;

- (BOOL)createSystemMsgInfoTable:(FMDatabase *)db;

- (BOOL)createUserSettingInfoTable:(FMDatabase *)db;

- (BOOL)createBaseNotifyMsgInfoTable:(FMDatabase *)db;

- (BOOL)createTopicVerifyNotifyInfoTable:(FMDatabase *)db;

- (BOOL)createReportNotifyMsgInfoTable:(FMDatabase *)db;

- (BOOL)createFriendNewTopicNotifyMsgInfoTable:(FMDatabase *)db;

- (BOOL)createNewOpinionNotifyMsgInfoTable:(FMDatabase *)db;

- (BOOL)createPrivacyApplyInfoTable:(FMDatabase *)db;

- (BOOL)createCommentAndReplyNotifyInfoTable:(FMDatabase *)db;

- (BOOL)createAddFriendMsgInfoTable:(FMDatabase *)db;

- (BOOL)createRelateTopicInfoTable:(FMDatabase *)db;

//创建智能匹配话题缓存,v106增加
-(BOOL)createMatchTopicInfoTable:(FMDatabase *)db;

- (BOOL)createTopicOptionInfo:(FMDatabase *)db;

//v106增加话题类别表
-(BOOL)createTopicCatalogInfoTable:(FMDatabase *)db;

- (BOOL)createApplyRecordInfoTable:(FMDatabase *)db;

- (BOOL)createNearbyMoodNotifyInfoTable:(FMDatabase *)db;

-(BOOL)createUserOperationRecordTable:(FMDatabase *)db;


@end