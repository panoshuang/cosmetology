//
// Created by mijie on 12-7-17.
//
// @数据库路径，表名定义
//

#define DATABASE_PARENT_PATH       @"Database"
#define DATABASE_PATH              @"Database/Homi.db"
//

#pragma mark - UserAccountInfo 表

#define USER_ACCOUNT_INFO_TABLE_TABLE_NAME   @"UserAccountInfo"    //用户信息表格
//以下字段由UserInfo继承而来
#define USER_ACCOUNT_INFO_TABLE_USER_ID       @"userID" //用户id
#define USER_ACCOUNT_INFO_TABLE_NAME         @"name"
#define USER_ACCOUNT_INFO_TABLE_NICKNAME     @"nickname" //
#define USER_ACCOUNT_INFO_TABLE_EMAIL        @"email"
#define USER_ACCOUNT_INFO_TABLE_EMAIL_VERIFIED      @"emailVerified"
#define USER_ACCOUNT_INFO_TABLE_PORTRAIT_URL        @"portraitURL"
#define USER_ACCOUNT_INFO_TABLE_PORTRAIT_FILE_PATH  @"portraitFilePath"
#define USER_ACCOUNT_INFO_TABLE_LAST_MOOD_ID        @"lastMoodID"   //该账户最后一条心情id,v106增加,用于做是否是最后一条心情的判断
#define USER_ACCOUNT_INFO_TABLE_LAST_MOOD_TYPE      @"lastMoodType"
#define USER_ACCOUNT_INFO_TABLE_LAST_MOOD_CREATE_AT @"lastMoodCreateAt"
#define USER_ACCOUNT_INFO_TABLE_LAST_MOOD_CONTENT   @"lastMoodContent" //该用户最后一条心情描述,v106增加,用来判断是否已经有心情描述
#define USER_ACCOUNT_INFO_TABLE_THIS_MOOD_TYPE      @"thisMoodType"
#define USER_ACCOUNT_INFO_TABLE_THIS_MOOD_CREATE_AT @"thisMoodCreateAt"
#define USER_ACCOUNT_INFO_TABLE_LBSDISTANCE         @"LBSDistance"
#define USER_ACCOUNT_INFO_TABLE_SIGNATURE           @"signature"
#define USER_ACCOUNT_INFO_TABLE_GENDER_TYPE         @"genderType"
#define USER_ACCOUNT_INFO_TABLE_ALBUM_COVER         @"albumCover"
#define USER_ACCOUNT_INFO_TABLE_NATION              @"nation"
#define USER_ACCOUNT_INFO_TABLE_PROVINCE            @"province"
#define USER_ACCOUNT_INFO_TABLE_CITY                @"city"
#define USER_ACCOUNT_INFO_TABLE_DISTRICT            @"district"
#define USER_ACCOUNT_INFO_TABLE_LAST_LOGIN_AT       @"lastLoginAt"
#define USER_ACCOUNT_INFO_TABLE_LONGITUDE           @"longitude"
#define USER_ACCOUNT_INFO_TABLE_LATITUDE            @"latitude"
#define USER_ACCOUNT_INFO_TABLE_PHONE               @"phone"
#define USER_ACCOUNT_INFO_TABLE_IS_VERIFIED         @"isVerified" //是否认证
#define USER_ACCOUNT_INFO_TABLE_BIRTHDAY            @"birthday"
#define USER_ACCOUNT_INFO_TABLE_GRADE                    @"grade"     //等级
#define USER_ACCOUNT_INFO_TABLE_INTEGRAL                 @"integral"  //积分
#define USER_ACCOUNT_INFO_TABLE_NUM_OF_MOOD         @"numOfMood" //心情数量
//以下字段为UserAccountInfo添加
#define USER_ACCOUNT_INFO_TABLE_PASSWORD     @"password" //
#define USER_ACCOUNT_INFO_TABLE_IS_REMEMBER_PASSWORD     @"isRememberPWD"  //
#define USER_ACCOUNT_INFO_TABLE_IS_AUTO_LOGIN            @"isAutoLogin"    //是否自动登陆
#define USER_ACCOUNT_INFO_TABLE_IS_LOGIN     @"isLogin"  //
#define USER_ACCOUNT_INFO_TABLE_STATUS       @"userStatus"//用户状态
#define USER_ACCOUNT_INFO_TABLE_IS_FIRST_TIME_LOGIN_OF_TODAY  @"isFirstTimeLoginOfToday" //该账户是否为当天第一次登陆
#define USER_ACCOUNT_INFO_TABLE_NUM_OF_LOGIN                  @"numOfLogin" //登陆次数
#define USER_ACCOUNT_INFO_TABLE_HAD_RATE                      @"hadRate" // 是否评分过



#pragma mark - SettingInfo 表

#define APPCONFIG_INFO_TABLE_TABLE_NAME       @"AppConfigInfo" //设置表
#define APPCONFIG_INFO_TABLE_SETTING_ID       @"SID"
#define APPCONFIG_INFO_TABLE_KEY              @"keyStr"
#define APPCONFIG_INFO_TABLE_VALUE            @"valueStr"
#define APPCONFIG_INFO_TABLE_USER_ACCOUNT_ID  @"userAccountID"

#pragma mark - UserInfo 表

#define USER_INFO_TABLE_TABLE_NAME          @"UserInfo" //用户表
#define USER_INFO_TABLE_USER_ID             @"userID"   //普通用户id
#define USER_INFO_TABLE_ACCOUNT_ID          @"accountID" //所属的当前账号id
#define USER_INFO_TABLE_NAME                @"name"
#define USER_INFO_TABLE_EMAIL               @"email"
#define USER_INFO_TABLE_NICKNAME            @"nickName"
#define USER_INFO_TABLE_PORTRAIT_URL        @"portraitURL"
#define USER_INFO_TABLE_PORTRAIT_FILE_PATH  @"portraitFilePath"
#define USER_INFO_TABLE_LAST_MOOD_TYPE      @"lastMoodType"                 //最后一次发布的心情
#define USER_INFO_TABLE_LAST_MOOD_CREATE_AT @"lastMoodCreateAt"             //最后一次心情发表时间戳
#define USER_INFO_TABLE_LAST_MOOD_CONTENT   @"lastMoodContent"              //最后一次心情描述
#define USER_INFO_TABLE_LAST_MOOD_IS_PROTECT @"lastMoodIsProtect"           //最后一次心情是否设置了保护
#define USER_INFO_TABLE_LAST_MOOD_MATCH      @"lastMoodMatch"               //最后一次心情的匹配度
#define USER_INFO_TABLE_PENULTIMATE_MOOD_TYPE       @"penultimateMoodType"  //倒数第二次发布的心情类型
#define USER_INFO_TABLE_PENULTIMATE_MOOD_CREATE_AT  @"penultimateMoodCreateAt" //倒数第二次发布的心情时间
#define USER_INFO_TABLE_LAST_CONTACT_MOOD_TYPE      @"lastContactMoodType"  //最后一次交流的心情
#define USER_INFO_TABLE_LAST_CONTACT_MOOD_CREATE_AT @"lastContactMoodCreateAt" //最后一次交流心情的发布时间
#define USER_INFO_TABLE_LAST_CONTACT_MOOD_OF_MINE     @"lastContactMoodOfMine" //最后一次聊天时候"我"当时的心情
#define USER_INFO_TABLE_LBSDISTANCE         @"LBSDistance"
#define USER_INFO_TABLE_SIGNATURE           @"signature"
#define USER_INFO_TABLE_GENDER_TYPE         @"genderType"
#define USER_INFO_TABLE_ALBUM_COVER         @"albumCover"
#define USER_INFO_TABLE_NATION              @"nation"
#define USER_INFO_TABLE_PROVINCE            @"province"
#define USER_INFO_TABLE_CITY                @"city"
#define USER_INFO_TABLE_DISTRICT            @"district"
#define USER_INFO_TABLE_LAST_LOGIN_AT       @"lastLoginAt"
#define USER_INFO_TABLE_LAST_CONTACT_AT     @"lastContactAt"
#define USER_INFO_TABLE_LONGITUDE           @"longitude"
#define USER_INFO_TABLE_LATITUDE            @"latitude"
#define USER_INFO_TABLE_PHONE               @"phone"
#define USER_INFO_TABLE_IS_VERIFIED         @"isVerified" //是否认证
#define USER_INFO_TABLE_IS_BLOCK            @"isBlock"
#define USER_INFO_TABLE_IS_FRIEND           @"isFriend"  //是否为朋友的标示字段
#define USER_INFO_TABLE_BIRTHDAY            @"birthday"
#define USER_INFO_TABLE_GRADE               @"grade"     //等级
#define USER_INFO_TABLE_INTEGRAL            @"integral"  //积分
#define USER_INFO_TABLE_NUM_OF_MOOD         @"numOfMood" //心情数量
#define USER_INFO_TABLE_LAST_UPDATE_AT      @"lastUpdateAt"    //记录插入时间


#pragma mark - SameMoodUser表

#define SAME_MOOD_USER_TABLE_TABLE_NAME     @"SameMoodUser"  //同心情用户关系表
#define SAME_MOOD_USER_TABLE_ACCOUNT_ID     @"accountID"     //当前账户id
#define SAME_MOOD_USER_TABLE_TARGET_USER_ID @"targetUserID"  //同心情用户id
#define SAME_MOOD_USER_TABLE_UPDATE_DATE    @"updateDate"    //更新时间


#pragma mark - MatchMoodUser表

#define MATCH_MOOD_USER_TABLE_TABLE_NAME    @"matchMoodUser" //匹配心情用户表
#define MATCH_MOOD_USER_TABLE_ACCOUNT_ID    @"accountID"  //当前账户id
#define MATCH_MOOD_USER_TABLE_TARGET_USER_ID @"targetUserID" //匹配心情id
#define MATCH_MOOD_USER_TABLE_UPDATE_DATE    @"updateDate"    //更新时间

#pragma mark - FellowSuffererUser表
#define FELLOW_SUFFERER_USER_TABLE_TABLE_NAME @"fellowSuffererUser" 
#define FELLOW_SUFFERER_USER_TABLE_ACCOUNT_ID    @"accountID"  //当前账户id
#define FELLOW_SUFFERER_USER_TABLE_TARGET_USER_ID @"targetUserID" //匹配心情id
#define FELLOW_SUFFERER_USER_TABLE_UPDATE_DATE    @"updateDate"    //更新时间


#pragma mark - UserSettingInfo 表

#define USER_SETTING_INFO_TABLE_TABLE_NAME                              @"UserSettingInfo"  //用户设置表
#define USER_SETTING_INFO_TABLE_ACCOUNT_ID                              @"accountID"           //
#define USER_SETTING_INFO_TABLE_RECEIVE_SYS_MSG                         @"receiveSysMsg"       // 接受系统推送通知
#define USER_SETTING_INFO_TABLE_STARTED_AT_BOOT                         @"startedAtBoot"       //开机启动，ios中无法使用
#define USER_SETTING_INFO_TABLE_TONE_ALERT                              @"toneAlert"           //声音提示
#define USER_SETTING_INFO_TABLE_VIBRATING_ALERT                         @"vibratingAlert"      // 震动提示
#define USER_SETTING_INFO_TABLE_CHAT_RECORD_LIFE_CYCLE                  @"chatRecordLifeCycle" // 回话记录保存天数
#define USER_SETTING_INFO_TABLE_RECEIVE_CHAT_MSG_PUSH                   @"receiveChatMsgPush"               //是否接收离线回话消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_COMMENT_AND_REPLAY_MSG_PUSH     @"receiveCommentAndReplyMsgPush"    //是否接收离线评论回复消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_PRIVACY_APPLY_MSG_PUSH          @"receivePrivacyApplyMsgPush"       //是否接收离线隐私申请消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_APPLY_MSG_PUSH           @"receiveFriendApplyMsgPush"        //是否接收离线好友申请消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_FRIEND_NEW_TOPIC_MSG_PUSH       @"receiveFriendNewTopicMsgPush"     //是否接收离线好友发布问题消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_NEW_OPINION_MSG_PUSH            @"receiveNewOpinionMsgPush"         //是否接收离线新看法消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_TOPIC_VERIFY_MSG_PUSH           @"receiveTopicVerifyMsgPush"     //是否接收离线举报反馈消息推送
#define USER_SETTING_INFO_TABLE_RECEIVE_REPORT_FEED_BACK_MSG_PUSH       @"receiveReportFeedBackMsgPush"     //是否接收离线举报反馈消息推送
#define USER_SETTING_INFO_TABLE_IS_RECEIVE_NEARBY_MOOD                  @"isReceiveNearbyMood"              //是否开启学雷锋功能(接收附近心情)
#define USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_FILTER              @"receiveNearbyMoodFilter"          //学雷锋心情的过滤规则(0:所有,1:男,2:女)
#define USER_SETTING_INFO_TABLE_RECEIVE_NEARBY_MOOD_LIMIT               @"receiveNearbyMoodLimit"           //学雷锋心情的接收数量



#pragma mark - PhotoAlbumInfo表

#define PHOTO_ALBUM_INFO_TABLE_TABLE_NAME                               @"PhotoAlbumInfo"     //专辑表
#define PHOTO_ALBUM_INFO_TABLE_ALBUM_ID                                 @"albumID"            //专辑ID
#define PHOTO_ALBUM_INFO_TABLE_USER_ID                                  @"userID"             //所属用户ID
#define PHOTO_ALBUM_INFO_TABLE_DESCRIBES                                @"describes"               //专辑描述
#define PHOTO_ALBUM_INFO_TABLE_CREATE_AT                                @"createAt"           //创建时间




#pragma mark -PhotoInfo 表

#define PHOTO_INFO_TABLE_TABLE_NAME                                     @"PhotoInfo"         //照片表
#define PHOTO_INFO_TABLE_PHOTO_ID                                       @"photoID"           //照片id
#define PHOTO_INFO_TABLE_PHOTO_ALBUM_ID                                 @"photoAlbumID"        //照片所属的照片盒id
#define PHOTO_INFO_TABLE_USER_ID                                        @"userID"            //用户id
#define PHOTO_INFO_TABLE_URL                                            @"photoUrl"          //照片网络地址
#define PHOTO_INFO_TABLE_FILEPATH                                       @"filePath"          //照片本地地址
#define PHOTO_INFO_TABLE_CREATE_AT                                      @"createAt"          //
#define PHOTO_INFO_TABLE_NUM_OF_COMMENT                                 @"numOfComment"
#define PHOTO_INFO_TABLE_NUM_OF_LIKE                                    @"numOfLike"
#define PHOTO_INFO_TABLE_IS_BLOCK                                       @"isBlock"


#pragma mark -  PhotoCommentInfo 表

#define PHOTO_COMMENT_INFO_TABLE_TABLE_NAME                             @"PhotoCommentInfo"   //照片评论表
#define PHOTO_COMMENT_INFO_TABLE_COMMENT_ID                             @"commentID"   //
#define PHOTO_COMMENT_INFO_TABLE_CREATE_AT                              @"createAt"    //创建的时间戳
#define PHOTO_COMMENT_INFO_TABLE_CONTENT                                @"content"    //评论内容
#define PHOTO_COMMENT_INFO_TABLE_RECEIVER_ID                            @"receiverID"    //接收者id
#define PHOTO_COMMENT_INFO_TABLE_SENDER_ID                              @"senderID"    //发表者id
#define PHOTO_COMMENT_INFO_TABLE_PHOTO_ID                               @"photoID"    //评论的目标照片id
#define PHOTO_COMMENT_INFO_TABLE_IS_BLOCK                               @"isBlock"    //是否被屏蔽

#pragma mark - PhotoCommentReply 表

#define PHOTO_COMMENT_REPLY_INFO_TABLE_TABLE_NAME                       @"PhotoCommentReplyInfo"    //表名
#define PHOTO_COMMENT_REPLY_INFO_TABLE_REPLY_ID                         @"replyID"                  //
#define PHOTO_COMMENT_REPLY_INFO_TABLE_CREATE_AT                        @"createAt"                 //创建时间戳
#define PHOTO_COMMENT_REPLY_INFO_TABLE_CONTENT                          @"content"                  //回复内容
#define PHOTO_COMMENT_REPLY_INFO_TABLE_COMMENT_ID                       @"commentID"                //照片评论id
#define PHOTO_COMMENT_REPLY_INFO_TABLE_RECEIVER_ID                      @"receiverID"               //接收者id
#define PHOTO_COMMENT_REPLY_INFO_TABLE_SENDER_ID                        @"senderID"                 //发表回复者id

#pragma mark - PrivacyInfo 表

#define PRIVACY_INFO_TABLE_TABLE_NAME                                      @"PrivacyInfo"  //隐私表名
#define PRIVACY_INFO_TABLE_ACCOUNT_ID                                         @"userID"
#define PRIVACY_INFO_TABLE_MOOD_CHANGE_PRIVACY_TO_CONTACT          @"moodChangePrivacyToContact" //交流过的好友的心情变化隐私设置
#define PRIVACY_INFO_TABLE_MOOD_CHANGE_PRIVACY_TO_STRANGER         @"moodChangePrivacyToStranger" //陌生人的心情变化隐私设置


#pragma mark - PrivacyApplyInfo 表

//v106版本废除这个表
#define PRIVACY_APPLY_INFO_TABLE_TABLE_NAME                                 @"PrivacyApplyInfo" //隐私申请表名
#define PRIVACY_APPLY_INFO_TABLE_NOTIFY_ID                                  @"notifyID" //通知id
#define PRIVACY_APPLY_INFO_TABLE_MSG_CATEGORY                               @"msgCategory" //通知id
#define PRIVACY_APPLY_INFO_TABLE_APPLICANT_ID                               @"applicantID" //申请者id
#define PRIVACY_APPLY_INFO_TABLE_MODULE                                     @"module" //模块名字
#define PRIVACY_APPLY_INFO_TABLE_CONTENT                                    @"content"  //内容
#define PRIVACY_APPLY_INFO_TABLE_CREATE_AT                                  @"createAt"
#define PRIVACY_APPLY_INFO_TABLE_HANDLE_TYPE                                @"handleType"

#pragma mark - MoodPrivacyNotifyMsgInfo 表
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_TABLE_NAME                       @"MoodPrivacyNotifyMsgInfo"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID                        @"notifyID"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_RELATE_USER_ID                   @"relateUserID"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_MOOD_ID                          @"moodID"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_MSG_CATEGORY                     @"msgCategory"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_MOOD_CONTENT                     @"moodContent"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_CREATE_AT                        @"createAt"
#define MOOD_PRIVACY_NOTIFY_MSG_INFO_TABLE_HANDLE_TYPE                      @"handleType"



#pragma mark - CommentAndReplyInfo表

#define COMMENT_AND_REPLY_INFO_TABLE_TABLE_NAME                             @"CommentAndReplyInfo"
#define COMMENT_AND_REPLY_INFO_TABLE_NOTIFY_ID                              @"notifyID"
#define COMMENT_AND_REPLY_INFO_TABLE_CREATE_AT                              @"createAt"
#define COMMENT_AND_REPLY_INFO_TABLE_CATEGORY                               @"category"
#define COMMENT_AND_REPLY_INFO_TABLE_TARGET_ID                              @"targetID"
#define COMMENT_AND_REPLY_INFO_TABLE_REFER_ID                               @"referID"
#define COMMENT_AND_REPLY_INFO_TABLE_USER_ID                                @"userID" //发布消息者id
#define COMMENT_AND_REPLY_INFO_TABLE_CONTENT                                @"content"

#pragma mark - SystemMsgNotifyInfo表

#define SYSTEM_MSG_NOTIFY_TABLE_TABLE_NAME                                  @"SystemMsgNotifyInfo"
#define SYSTEM_MSG_NOTIFY_TABLE_NOTIFY_ID                                   @"notifyID"
#define SYSTEM_MSG_NOTIFY_TABLE_CREATE_AT                                   @"createAt"
#define SYSTEM_MSG_NOTIFY_TABLE_ID                                          @"msgID"
#define SYSTEM_MSG_NOTIFY_TABLE_TITLE                                       @"title"
#define SYSTEM_MSG_NOTIFY_TABLE_LINK                                        @"link"
#define SYSTEM_MSG_NOTIFY_TABLE_MSG                                         @"msg"

#pragma mark  - BaseNotifyMsgInfo表,消息中心基础实体表
#define BASE_NOTIFY_MSG_INFO_TABLE_TABLE_NAME                               @"baseNotifyMsgInfo"
#define BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID                                @"notifyID"
#define BASE_NOTIFY_MSG_INFO_TABLE_ACCOUNT_ID                               @"accountID"
#define BASE_NOTIFY_MSG_INFO_TABLE_RELATE_USER_ID                           @"relateUserID"
#define BASE_NOTIFY_MSG_INFO_TABLE_NOTIFY_TYPE                              @"notifyType"
#define BASE_NOTIFY_MSG_INFO_TABLE_CREATE_AT                                @"createAt"
#define BASE_NOTIFY_MSG_INFO_TABLE_IS_READED                                @"isReaded"
#define BASE_NOTIFY_MSG_INFO_TABLE_IS_HANDLED                               @"isHandled"

#pragma mark - 话题审核结果消息TopicVerifyNotifyInfo表
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_TABLE_NAME                           @"topicVerifyNotifyInfo"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_NOTIFY_ID                            @"notifyID"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_VERIFY_CATEGORY                      @"verifyCategory"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_CREATE_AT                            @"createAt"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_ID                             @"topicID"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_TITLE                          @"topicTitle"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_TAG                            @"topicTag"
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_TOPIC_OPTIONS                        @"topicOptionsStr"  //多个option之间用"|,|"符号隔开
#define TOPIC_VERIFY_NOTIFY_INFO_TABLE_REASON                               @"reason"

#pragma mark - 举报处理消息ReportNotifyMsgInfo表
#define REPORT_NOTIFY_MSG_INFO_TABLE_TABLE_NAME                             @"ReportNotifyMsgInfo"
#define REPORT_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID                              @"notifyID"
#define REPORT_NOTIFY_MSG_INFO_TABLE_REPORT_CATEGORY                        @"reportCategory"
#define REPORT_NOTIFY_MSG_INFO_TABLE_CREATE_AT                              @"createAt"
#define REPORT_NOTIFY_MSG_INFO_TABLE_CONTENT                                @"content"

#pragma mark - 朋友发布新话题通知消息 FriendNewTopicNotifyMsgInfo表
#define FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_TABLE_NAME                   @"FriendNewTopicNotifyMsgInfo"
#define FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID                    @"notifyID"
#define FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_CREATE_AT                    @"createAt"
#define FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_FRIEND_ID                    @"friendID"
#define FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_TOPIC_ID                     @"topicID"
#define FRIEND_NEW_TOPIC_NOTIFY_MSG_INFO_TABLE_TOPIC_TITLE                  @"topicTitle"

#pragma mark - 新话题看法通知消息NewOpinionNotifyMsgInfo 表
#define NEW_OPINION_NOTIFY_MSG_INFO_TABLE_TABLE_NAME                        @"NewOpinionNotifyMsgInfo"
#define NEW_OPINION_NOTIFY_MSG_INFO_TABLE_NOTIFY_ID                         @"notifyID"
#define NEW_OPINION_NOTIFY_MSG_INFO_TABLE_CREATE_AT                         @"createAt"
#define NEW_OPINION_NOTIFY_MSG_INFO_TABLE_AUTHOR_USER_ID                    @"authorUserID"
#define NEW_OPINION_NOTIFY_MSG_INFO_TABLE_TOPIC_ID                          @"topicID"
#define NEW_OPINION_NOTIFY_MSG_INFO_TABLE_OPINION                           @"opinionStr"

#pragma mark - ChatInfo会话表

#define CHAT_INFO_TABLE_TABLE_NAME                                          @"ChatInfo"
#define CHAT_INFO_TABLE_TARGET_USER_ID                                      @"targetUserID"   //聊天好友ID,同时作为该表的唯一键
#define CHAT_INFO_TABLE_ACCOUNT_ID                                          @"accountID"         //当前账户ID
#define CHAT_INFO_TABLE_LAST_UPDATE_TIME                                    @"lastUpdateTime" //会话的最后消息时间
#define CHAT_INFO_TABLE_LAST_MSG_CONTENT                                    @"lastMsgContent" //会话的最后一条消息内容
#define CHAT_INFO_TABLE_NUM_OF_UNREAD_MSG                                   @"numOfunReadMsg" //未读信息的数量


#pragma mark - ChatMsgInfo单条聊天信息表

#define CHAT_MSG_INFO_TABLE_TABLE_NAME                                      @"ChatMsgInfo"
#define CHAT_MSG_INFO_TABLE_MSG_ID                                          @"msgID"
#define CHAT_MSG_INFO_TABLE_ACCOUNT_ID                                      @"accountID"
#define CHAT_MSG_INFO_TABLE_SENDER_ID                                       @"senderID"
#define CHAT_MSG_INFO_TABLE_RECEIVER_ID                                     @"receiverID"
#define CHAT_MSG_INFO_TABLE_CHAT_INFO_ID                                    @"chatInfoID"
#define CHAT_MSG_INFO_TABLE_MSG_CONTENT                                     @"msgContent"
#define CHAT_MSG_INFO_TABLE_LARGE_IMAGE_URL                                 @"largeImageURL"
#define CHAT_MSG_INFO_TABLE_SMALL_IMAGE_URL                                 @"smallImageURL"
#define CHAT_MSG_INFO_TABLE_LARGE_IMAGE_FILE_NAME                           @"largeImageFileName"
#define CHAT_MSG_INFO_TABLE_AUDIO_URL                                       @"audioURL"  //V1.0.3 增加该字段,存放音频
#define CHAT_MSG_INFO_TABLE_AUDIO_FILE_NAME                                 @"audioFileName"  //V1.0.3 增加该字段,存放音频文件名
#define CHAT_MSG_INFO_TABLE_AUDIO_DURATION                                  @"audioDuration" //v1.0.3 增加该字段,存放音频长度
#define CHAT_MSG_INFO_TABLE_CHAT_MSG_TYPE                                   @"chatMsgType"
#define CHAT_MSG_INFO_TABLE_LONGITUDE                                      @"longtitude"
#define CHAT_MSG_INFO_TABLE_LATITUDE                                        @"latitude"
#define CHAT_MSG_INFO_TABLE_CREATE_AT                                       @"createAt"
#define CHAT_MSG_INFO_TABLE_STATUS                                          @"chatMsgStatus" //消息状态
#define CHAT_MSG_INFO_TABLE_MOOD_TYPE                                       @"moodType" //发送消息时候的心情


#pragma mark - MoodTypeInfo 心情类型表

#define MOOD_TYPE_TABLE_TABLE_NAME                                         @"MoodTypeInfo"  //心情类型
#define MOOD_TYPE_TABLE_MOOD_TYPE                                          @"moodType"  //EnumMoodType
#define MOOD_TYPE_TABLE_MOOD_NAME                                          @"moodName"
#define MOOD_TYPE_TABLE_TIPS_STR                                           @"tipsStr" //提示语
#define MOOD_TYPE_TABLE_MOOD_IMAGE_URL                                     @"moodImageUrl" //心情对应的图标

#pragma mark - AddFriendMsgInfo 添加好友相关的系统通知消息表
#define ADD_FRIEND_MSG_INFO_TABLE_TABLE_NAME                               @"addFriendMsgInfo"
#define ADD_FRIEND_MSG_INFO_TABLE_NOTIFY_ID                                @"notifyID"
#define ADD_FRIEND_MSG_INFO_TABLE_USER_ID                                  @"userID"
#define ADD_FRIEND_MSG_INFO_TABLE_ACCOUNT_ID                               @"accountID"
#define ADD_FRIEND_MSG_INFO_TABLE_MSG_CATEGORY                             @"msgCategory"
#define ADD_FRIEND_MSG_INFO_TABLE_CREATE_AT                                @"createAt"
#define ADD_FRIEND_MSG_INFO_TABLE_HANDLE_TYPE                              @"handleType"

#pragma mark - TopicInfo 话题表
#define RELATE_TOPIC_INFO_TABLE_TABLE_NAME                                         @"relateTopicInfo"
#define RELATE_TOPIC_INFO_TABLE_TOPIC_ID                                           @"topicID"
#define RELATE_TOPIC_INFO_TABLE_USER_ID                                            @"userID"
#define RELATE_TOPIC_INFO_TABLE_ACCOUNT_ID                                         @"accountID"
#define RELATE_TOPIC_INFO_TABLE_TITLE                                              @"title"
#define RELATE_TOPIC_INFO_TABLE_TAGS                                               @"tags"
#define RELATE_TOPIC_INFO_TABLE_CHOICE_OPTION_CONTENT                              @"choiceOptionContent"
#define RELATE_TOPIC_INFO_TABLE_CHOICE_OPTION_ID                                   @"choiceOptionID"
#define RELATE_TOPIC_INFO_TABLE_IS_OWNER                                           @"isOwner"
#define RELATE_TOPIC_INFO_TABLE_IS_BLOCK                                           @"isBlock"
#define RELATE_TOPIC_INFO_TABLE_NUM_OF_OPINION                                     @"numOfOpinion"
#define RELATE_TOPIC_INFO_TABLE_NUM_OF_PARTICIPATE                                 @"numOfParticipate"
#define RELATE_TOPIC_INFO_TABLE_NUM_OF_CONFUSE                                     @"numOfConfuse"
#define RELATE_TOPIC_INFO_TABLE_TOPIC_PARTICIPATE_STATIC_TYPE                      @"topicParticipateStaticType" //参与的状态,(没有参与,正在参与,已经参与)

#pragma mark - MatchTopicInfo 匹配话题表
#define MATCH_TOPIC_INFO_TABLE_TABLE_NAME                                         @"matchTopicInfo"
#define MATCH_TOPIC_INFO_TABLE_TOPIC_ID                                           @"topicID"
#define MATCH_TOPIC_INFO_TABLE_USER_ID                                            @"userID"
#define MATCH_TOPIC_INFO_TABLE_ACCOUNT_ID                                         @"accountID"
#define MATCH_TOPIC_INFO_TABLE_TITLE                                              @"title"
#define MATCH_TOPIC_INFO_TABLE_TAGS                                               @"tags"
#define MATCH_TOPIC_INFO_TABLE_IS_BLOCK                                           @"isBlock"
#define MATCH_TOPIC_INFO_TABLE_NUM_OF_OPINION                                     @"numOfOpinion"
#define MATCH_TOPIC_INFO_TABLE_NUM_OF_PARTICIPATE                                 @"numOfParticipate"
#define MATCH_TOPIC_INFO_TABLE_NUM_OF_CONFUSE                                     @"numOfConfuse"


#pragma mark - TopicOptionInfo 话题选项表
#define TOPIC_OPTION_INFO_TABLE_TABLE_NAME                                  @"topicOptionInfo"
#define TOPIC_OPTION_INFO_TABLE_OPTION_ID                                   @"optionID"
#define TOPIC_OPTION_INFO_TABLE_TOPIC_ID                                    @"topicID"
#define TOPIC_OPTION_INFO_TABLE_CONTENT                                     @"content"
#define TOPIC_OPTION_INFO_TABLE_NUM_OF_CHOICES                              @"numOfChoice"

#pragma mark - TopicCatalogInfo 话题类别表
#define TOPIC_CATALOG_INFO_TABLE_TABLE_NAME                                 @"topicCatalogInfo"
#define TOPIC_CATALOG_INFO_TABLE_ID                                         @"catalogID"
#define TOPIC_CATALOG_INFO_TABLE_ACCOUNT_ID                                 @"accountID"
#define TOPIC_CATALOG_INFO_TABLE_NAME                                       @"name"
#define TOPIC_CATALOG_INFO_TABLE_DESCRIBES                                  @"describes"
#define TOPIC_CATALOG_INFO_TABLE_IMAGE                                      @"image"
#define TOPIC_CATALOG_INFO_TABLE_SUB_IMAGE                                  @"subImage"
#define TOPIC_CATALOG_INFO_TABLE_PREVIEW_TOPIC_TITLES                       @"previewTopicTitle"

#pragma mark - ApplyRecordInfo 申请记录表
#define APPLY_RECORD_INFO_TABLE_TABLE_NAME                                  @"ApplyRecordInfo"
#define APPLY_RECORD_INFO_TABLE_ACCOUNT_ID                                  @"accountID"
#define APPLY_RECORD_INFO_TABLE_TARGET_USER_ID                              @"targetUserID"
#define APPLY_RECORD_INFO_TABLE_APPLY_RECORD_TYPE                           @"applyRecordType"
#define APPLY_RECORD_INFO_TABLE_TARGET_OBJECT_ID                            @"targetObjectID"


#pragma mark - NearbyMoodNotifyInfo 附近心情推送表
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_TABLE_NAME                            @"nearbyMoodNotifyInfo"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_ACCOUNT_ID                            @"accountID"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_USER_ID                               @"userID"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_MOOD_ID                               @"moodID"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_MOOD_TYPE                             @"moodType"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_CONTENT                               @"content"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_CREATE_AT                             @"createAt"
#define NEARBY_MOOD_NOTIFY_INFO_TABLE_IS_READED                             @"isReaded"

#pragma mark - UserOperationRecord 用户操作记录表,用来记录用户对页面操作信息的记录
#define USER_ACCOUNT_OPERATION_RECORD_TABLE_TABLE_NAME                              @"userOperationRecord"
#define USER_ACCOUNT_OPERATION_RECORD_ACCOUNT_ID                                    @"accountID"
#define USER_ACCOUNT_OPERATION_RECORD_KEY                                           @"key"
#define USER_ACCOUNT_OPERATION_RECORD_VALUE                                         @"value"





#pragma mark - 预留字段
//为每张表都统一预留4个保留字段,类型都是TEXT,做后背升级使用
#define RESERVED_COL0                                                      @"reservedCol0"  //预留字段0
#define RESERVED_COL1                                                      @"reservedCol1"  //预留字段1
#define RESERVED_COL2                                                      @"reservedCol2"  //预留字段2
#define RESERVED_COL3                                                      @"reservedCol3"  //预留字段3
