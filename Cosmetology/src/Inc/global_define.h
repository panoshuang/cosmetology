/*********************************************************************
 *            Copyright (C) 2012, 广州米捷网络科技有限公司
 * @文件描述:其他一些宏定义(如视图宽高等)
 **********************************************************************
 *   Date        Name        Description
 *   2012/06/18  luzj        New
 *********************************************************************/


#define kCompileTime               @"2012-09-29 A" // 编译的时间

#define kTabImageSize              30  //Tab图片的大小
#define kTabBarHeight              45  //TabBar的高度
#define CHAT_INPUT_VIEW_HEIGHT     52  //聊天页面的输入栏高度
#define kTitleBarHeight            44  //TitleBar的高度
#define kUserHeadSize              34  //用户头像的尺寸
#define kUserHeadSizeMid           50  //profile头像大小
#define kUserHeadSizeBig           75
#define kThumbImageSize            50  //普通小图大小
#define kCommonSpaceBig             20
#define kCommonSpace               10  //通用的空闲空间
#define kCommonSpaceSmall          5
#define kSpaceWidthBig             15  //元素间x轴的大间隔
#define kSpaceWidthMid             10  //元素间x轴的间隔
#define kSpaceWidthSmall            2  //元素相对于父元素上面空隙的大小
#define kEmptyTipsTopSpace         40  //空提示y轴的空隙

#define kLabelHightDefaul          14  //默认单行label高度
#define kLabelHightSmall           12  //小字体高度
#define kLabelHightMid             16
#define kLabelHightBig             18

#define kDefaulTimeLabelWidth      100 //默认显示时间的label的宽度
#define kTipsImageSize             20
#define kFaceViewHeight            210  //表情控件的高度
#define kCommonMoodImageSize       32   //心情图片的狂度
#define kMoodListCellWidth         250  //时间轴的宽度

#define kRoundMoodImageSize        20  //圆形的心情图标高度


#define kCommonLineHeight          19  //对于一般有多行的视图,每行的高度
#define kCommonBtnSize             28  //通用的按钮大小
#define kToolBtnSmallWidth         50  //顶部工具栏长方形按钮的宽度
#define kToolBtnSmallHeight        30  //顶部工具栏长方形按钮的高度
#define kToolBtnBigWidth           58  //顶部工具栏长方形按钮的宽度(大)
#define kToolBtnBigHeight          30  //顶部工具栏长方形按钮的高度(大)
#define kToolBtnBackWidth          58  //顶部工具栏回退按钮的宽度
#define kToolBtnBackHeight         30  //顶部工具栏回退按钮的高度

#define kBubbleSize                18  //气泡数量提示的大小
#define kTimeTypeMoodSize          30  //倾诉页面的时间类似上的表情大小
#define kTimeTypeBtnWidth          60  //倾诉页面的时间类似上的表情大小
#define kTimeTypeBtnHeight         36  //倾诉页面的时间类似上的表情大小

#define KCommonTextViewHeight       150 //一般的textview高度

#define kCellBtnWidhtSmall          20  //列表中小的删除或添加按钮
#define kCellSmallImageWidth        15  //列表中提示的小图片宽度
#define kCellSmallImageHeight       10  //列表中提示的小图片的高度
#define kPhotoBrowerToolBarHight    46  //照片预览的工具栏高度
#define kPhotoBrowerTitleBarHight    46  //照片预览的工具栏高度

#define kCommonNumOfCommentTipsImageWidth  13.5
#define kCommonNumOfCommentTipsImageHeight 12.5

#define kCommonFontSizeSmall               12

#define kChatMsgLargeImageWidth               700   //回话的大图最大宽度
#define kChatMsgSmallImageWidth               120   //聊天列表的缩略图宽度

#define kBottomBarHeight                      46    //评论回复页面等的底部工具栏高度

#define NOTIFY_CENTER_CELL_HEAD_VIEW_HEIGHT 33
#define NOTIFY_CENTER_CELL_HEAD_LABEL_HEIGHT 17
#define NOTIFY_CENTER_CELL_HEAD_LABEL_FONT [UIFont boldSystemFontOfSize:16]
#define NOTIFY_CENTER_CELL_MID_LABEL_FONT  [UIFont systemFontOfSize:14]
#define NOTIFY_CENTER_CELL_FOOTER_LABEL_FONT  [UIFont systemFontOfSize:14]
#define NOTIFY_CENTER_CELL_MAIN_VIEW_BORDER_COLOR [UIColor colorWithHexColor:0xcccccc].CGColor
#define NOTIFY_CENTER_CELL_SEPARATE_BORDER_COLOR  [UIColor colorWithHexColor:0xcdcdcd].CGColor
#define NOTIFY_CENTER_CELL_TIME_LABEL_HEIGHT 10
#define NOTIFY_CENTER_CELL_TIME_LABEL_FONT [UIFont systemFontOfSize:10]
#define NOTIFY_CENTER_CELL_MAX_TITLE_CONTENT_WIDTH 244
#define NOTIFY_CENTER_CELL_MAX_FOOTER_CONTENT_WIDTH  270
#define NOTIFY_CENTER_CELL_NICKNAME_VIEW_HEIGHT 15
#define NOTIFY_CENTER_CELL_NICKNAME_LABEL_HEIGHT [UIFont boldSystemFontForSize:14]








//灰色的标题栏
#define GRAY_TITLE_COLOR \
[UIColor colorWithRed:0xbf/ 255.0 green:0xbf/ 255.0 blue:0xbf/255.0 alpha:1]

//灰色的提示语
#define GRAY_TIP_COLOR \
[UIColor colorWithRed:0x7d/255.0 green:0x7d/255.0 blue:0x7d/255.0 alpha:1]

//黑色线条颜色
#define BLACK_LINE_COLOR \
[UIColor colorWithRed:0x14/255.0 green:0x14/255.0 blue:0x14/255.0 alpha:1]

//通用的文字颜色(橙色)
#define ORANGE_TEXT_COLOR \
[UIColor colorWithRed:234/255.0 green:119/255.0 blue:0 alpha:1]

//通用的文字颜色(红褐色)
#define RED_BROWN_TEXT_COLOR \
[UIColor colorWithRed:.148 green:.047 blue:0 alpha:1]

//组合框的文字颜色(红色)
#define RED_TEXT_COLOR \
[UIColor colorWithRed:.359 green:.176 blue:.09 alpha:1]

//非法内容的的颜色
#define ILLEGAL_CONTENT_TEXT_COLOR \
[UIColor grayColor]

//手机联系人列表cell的电话号码的文字颜色(蓝色)
#define BLUE_PHONE_CELL_TEXT_COLOR \
[UIColor colorWithRed:4/255.0 green:57/255.0 blue:122/255.0 alpha:1]

//拨打电话视图中具体内容的信息的文字颜色(蓝色)
#define BLUE_PHONE_CALL_TEXT_COLOR \
[UIColor colorWithRed:67/255.0 green:95/255.0 blue:129/255.0 alpha:1]

//拨打电话视图中快速拨打内容的信息的文字颜色(蓝色)
#define BLUE_QUICK_PHONE_CALL_TEXT_COLOR \
[UIColor colorWithRed:34/255.0 green:147/255.0 blue:218/255.0 alpha:1]

//通用的粗体
#define COMMON_BOLD_FONT @"Helvetica-Bold"

#define TREE_NODE_INDENT            15  //节点默认的缩进大小

//最小缩放比例
#define MinimumZoomScale 0.3

//最大缩放比例
#define MaximumZoomScale 9.0


//无效的无符号值
#define NO_NEED_INT_VALUE 999999

//对视图中元素的尺寸的定义
#define TITLE_BAR_HEIGHT            28


#define TOP_TAB_ITEM_HEIGHT         26
#define TOOL_BAR_HEIGHT             36
#define CELL_SETTING_ITEM_HEIGHT    44
#define CELL_BTN_HEIGHT             35
#define CELL_ORG_TITLE_HEIGHT       34
#define CELL_ORG_TITLE_HEAD_SIZE    26
#define CELL_TITLE_HEIGHT           34
#define CELL_TITLE_FRIEND_HEIGHT    30
#define CELL_ARROW_SIZE             30
#define CELL_BTN_SIZE               25
#define CHECKBOX_SIZE               25
#define INFO_ROW_HEIGHT             20

#define IMAGE_STATUS_SIZE           15  //状态的图标大小

#define TAB_SELECT_LINE_HEIGHT      3   //Tab被选中时候选择线的高度
#define UITEXTFIELD_HEIGHT          31  //单行输入框的高度
#define FLOWVIEW_HEIGHT             100 //流量面板的高度

#define CHAT_PIC_MAX_WIDTH          90 //聊天界面图片最大的宽度
#define CHAT_PIC_MAX_HEIGHT         60 //聊天界面图片最大的宽度

#define DEFAULT_INPUT_LIMIT         50  //默认输入框允许的最大字符数量
#define SIGN_INPUT_LIMIT            70 //签名输入框允许的最大字符数量
#define NOTE_INPUT_LIMIT            40  //备注输入框允许的最大字符数量
#define SMS_INPUT_LIMIT             300 //短信输入框允许的最大字符数量
#define TAG_INPUT_LIMIT             10  //分组命名输入框允许的最大字符数量


#define HTTP_TIMEOUT                60  //HTTP连接的超时时间
#define HEART_TIME_INTERVAL         30  //心跳包的时间间隔
#define ACK_TIME_INTERVAL           0.8 //未ack消息定时器的时间间隔
#define SHAKE_TIME_INTERVAL         0.8 //图片闪动的时间间隔
#define RENEW_SID_TIME_INTERVAL     60*3//sid刷新的时间
#define RECENT_LIST_SHOW_NUM        15  //最近联系列表的记录数量
#define CHAT_HISTORY_PAGE_NUM       15  //聊天记录每页的记录数
#define COOOKIE_SESSION_TIME        60*60*48    //cookie会话的有效时间

//其他宏定义
#define RES_SYS_DB_NAME        @"sys.db"            //存储系统信息的原始库文件名
#define RES_USER_DB_NAME       @"user.db"           //存储用户信息的原始库文件名
#define RES_SMILEY_NAME        @"Smiley.plist"      //表情的对照表
#define SAVE_PASSWORD          @"pnd91und91und91u"  //保存密码后,在输入框显示的串

//HTTP ACTION
#define HTTP_METHOD_GET         @"GET"
#define HTTP_METHOD_POST        @"POST"
#define HTTP_METHOD_PUT         @"PUT"
#define HTTP_METHOD_DELETE      @"DELETE"

//HTTP or HTTPS PreHeader
#define HEADER_HTTPS            @"http://"
#define HEADER_HTTP             @"http://"

//服务器地址


//#define SERVER_CLIENT_HTTP_URL       @"121.14.195.83:8282"
//#define SERVER__CLIENT_SOCKET_URL    @"121.14.195.83"
//#define SERVER_CLIENT_SOCKET_PORT    9997
//#define SERVER_CLIENT_HTTP_RESOURCE_URL @"http://121.14.195.83:8282/res/"

//外网
//#define SERVER_CLIENT_HTTP_URL       @"121.14.195.83:8282"
//#define SERVER__CLIENT_SOCKET_URL    @"121.14.195.83"
//#define SERVER_CLIENT_SOCKET_PORT    9997

//外网映射   http://api.51homi.com:8282
//#define SERVER_CLIENT_HTTP_URL       @"api.51homi.com:8282"
//#define SERVER__CLIENT_SOCKET_URL    @"ns.51homi.com"
//#define SERVER_CLIENT_SOCKET_PORT    9997

//内网
//#define SERVER_CLIENT_HTTP_URL       @"192.168.0.166:8282"
//#define SERVER__CLIENT_SOCKET_URL    @"192.168.0.166"
//#define SERVER_CLIENT_SOCKET_PORT    9997

//内网映射
#define SERVER_CLIENT_HTTP_URL       @"mijietest.f3322.org:8282"
#define SERVER__CLIENT_SOCKET_URL    @"mijietest.f3322.org"
#define SERVER_CLIENT_SOCKET_PORT    9997

//顺德服务器
//#define SERVER_CLIENT_HTTP_URL       @"113.105.247.221:8282"
//#define SERVER__CLIENT_SOCKET_URL    @"113.105.247.221"
//#define SERVER_CLIENT_SOCKET_PORT    9997


//本地
//#define SERVER_CLIENT_HTTP_URL       @"192.168.0.130:8080"
//#define SERVER__CLIENT_SOCKET_URL    @"192.168.0.130"
//#define SERVER_CLIENT_SOCKET_PORT    9997

//系统客户id
#define SYSTEM_CUSTOMER_SERVER_ID   @"10000"
#define LOCAL_RESOURCE_URL_PREFIX   @"http://local"  //本地资源url前缀
#define PHOTOS_CACHE_PATH     @"photos" //图片下载缓存目录,这个目录的图片每次启动都清除2周前的图片
#define PERSISTENT_PHOTOS_CACHE_PATH  @"persistentPhotos"  //不进行自动清理的缓存图片,例如聊天的图片
#define AUDIO_CACHE_PATH      @"audio"  //音频下载缓存目录

#define USER_TOPIC_TAGS_FILE_NAME @"topicTags.plist"

#define DEFAULT_LIMIT      20  //默认的列表分页数量
#define DEFAULT_LIMIT_FOR_IPHONE5 24 //IPHONE5 默认的分页数量
#define LIMIT_MID          50
#define LIMIT_USER_GRID    30
#define DEFAULT_ALL_LIMIT  200
#define LIMIT_5            5 //5条分页

#define TIME_BEGIN_YEAR    2012//时间轴的起始年份
#define TIME_GEGIN_MONTH   7   //时间轴的起始月份

#define NETWORK_REQUEST_TIMEOUT     20
#define MAX_SHARE_CONTENT_LENGTH 140

//隐私申请的module定义
#define PRIVACY_MODULE_LEAVE_MSG   @"leaveMsg"  //留言权限
#define PRIVACY_MODULE_MOOD_LOCUS_VISIBLE  @"moodLocusVisible"  //心情历史权限
#define PRIVACY_MODULE_ALBUM_VISIBLE       @"albumVisible" //相册权限

#define BIRTHDY_SYSTEM_FORMAT              @"yyyy-MM-dd" //生日的时间格式

#define BLOCK_TIPS_STRING                 @"此条内容违规已被删除，有疑问请联系客服。"

#define DELETE_TIPS_STRING                @"此条内容已被删除."
#define MOOD_PROTECT_TIPS_STR              @"我的心情事迹做了隐私保护，看不到啦"
#define MOOD_NO_DESCRIPTION_TIPS_STR       @"HOHO,没描述,看不到心情境遇类似度"


#define HTTP_UPLOAD_FILE_INFO_DIC_KEY     @"httpUploadFileInfoDicKey"   //用于在传递上传文件到网络核心层时候的字典key
#define HTTP_UPLOAD_FILE_INFO_ARRAY_DIC_KEY     @"httpUploadFileInfoArrayDicKey"   //用于在传递上传文件到网络核心层时候的字典key

#define TOPIC_MATCH_TOPIC_CATALOG_ID   0 //智能匹配话题类别id
#define TOPIC_MATCH_TOPIC_CATALOG_NAME @"你可能遇到的问题" //智能匹配话题类别的名称



#define HTTP_UPDA

//ho米的appstore 的id
#define HOMI_APP_STORE_ID 578167281

//appStore 链接前缀
#define APP_URL_PREFIX @"itms-apps://"

#define TOPIC_OPTION_STRING_SEPARATOR_COMPONENT  @"|,|"  //话题多个答案之间的分隔符



//头像的尺寸big,middle,small,tiny
#define IMAGE_SIZE_BIG          @"big"
#define IMAGE_SIZE_MIDDLE       @"middle"
#define IMAGE_SIZE_SMALL        @"small"
#define IMAGE_SIZE_TINY         @"tiny"


//一些常用的键值对的键
#define KEY_TAGS        @"tags"
#define KEY_DATA        @"data"
#define KEY_TAG_ID      @"tagid"
#define KEY_TAG_NAME    @"tagname"
#define KEY_FRIENDS     @"friends"
#define KEY_UID         @"uid"
#define KEY_UAP_UID     @"uap_uid"
#define KEY_USERNAME    @"username"
#define KEY_NICKNAME    @"nickname"
#define KEY_NOTENAME    @"note"
#define KEY_SIGNATURE   @"signature"
#define KEY_STATUS      @"status"
#define KEY_EXDATA      @"ExData"

#define KEY_SEND1       @"send1"
#define KEY_SEND2       @"send2"
#define KEY_RECV1       @"recv1"
#define KEY_RECV2       @"recv2"

#define KEY_SMS_TIME    @"sms_time"
#define KEY_SMS_MSG     @"sms_msg"
#define KEY_SMS_COUNT   @"sms_count"

//修改用户信息的时候使用的KEY
#define KEY_EDIT_ID     @"info_edit_id"
#define KEY_EDIT_INFO   @"info_edit_content"


#pragma mark - 以下为setting表的Key值
//设置是否为第一次运行软件的key值
#define IS_FIRST_RUN    @"isFirstRun"


#pragma mark -  setting表的Key值结束

//其他一些字符串的宏定义
#define KEY_BUS_PROCESSOR  @"processor"
#define KEY_BUS_CMD  @"cmd"
#define KEY_BUS_NOTIFY  @"notify"

//用于统计的事件名
#define EVENT_LOGIN  @"event_login"
#define EVENT_CHANGEROLE  @"event_changerole"
#define EVENT_RELOGIN  @"event_relogin"
#define EVENT_SENDSMS  @"event_sendsms"
#define EVENT_SEARCH_NET_FRIEND  @"event_search_net_friend"
#define EVENT_SEARCH_LOCAL_FRIEND  @"event_search_local_friend"
#define EVENT_SEND_PERSON_MSG  @"event_sendmsg_person"
#define EVENT_SEND_GROUP_MSG  @"event_sendmsg_group"



#define EDIT_INFO_FAX_TAG       500 //修改传真信息的Tag
#define EDIT_INFO_MAIL_TAG      501 //修改邮箱信息的Tag
#define EDIT_INFO_ADDR_TAG      502 //修改地址信息的Tag
#define EDIT_INFO_CODE_TAG      503 //修改邮编信息的Tag
#define EDIT_INFO_SIGN_TAG      504 //修改签名信息的Tag
#define EDIT_INFO_SEX_TAG       505 //修改性别信息的Tag
#define EDIT_INFO_BLOOD_TAG     506 //修改血型信息的Tag
#define EDIT_INFO_BIR_TAG       507 //修改生日信息的Tag
#define EDIT_INFO_SITE_TAG      508 //修改主页信息的Tag
#define EDIT_INFO_DESC_TAG      509 //修改说明信息的Tag
#define EDIT_INFO_PHONE_TAG     510 //修改常用电话信息的Tag

#define CID_PERSON_GROUP 1      //个人群的群分类ID
#define CID_DEPT_GROUP 2       //部门群的群分类ID
#define CID_OTHER_GROUP 3       //其他群的群分类ID

#define GTYPE_PERSON_GROUP 2 //个人的群
#define GTYPE_DEPT_GROUP 10  //部门群的类型编号
#define GTYPE_CLASS_GROUP 11  //班级群
#define GTYPE_CLASS_MASTER_GROUP 12  //班级老师群
#define GTYPE_CLASS_STUDENT_GROUP 13  //班级学生群
#define GTYPE_CLASS_GUARDIAN_GROUP 14  //班级家长群

/*
 *以下是一些功能性宏定义
 */

//用于快速的实现屏幕可任意方向翻转而设置的宏
#define SHOULD_AUTOROTATA_TO_INTERFACE_ORIENTATION \
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation \
{\
return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown); \
}

//用于释放指针所指向的空间
#define FREE_MEM(pData) \
if (pData != NULL) \
{\
free(pData);\
pData = NULL;\
}

//用于快速的实现弹出警告窗口
#define ALERT_MSG(title, msg, btnmsg)\
UIAlertView *alertDialog;\
alertDialog = [[UIAlertView alloc] initWithTitle: title message:msg delegate: nil cancelButtonTitle: btnmsg otherButtonTitles: nil];\
[alertDialog show];\
[alertDialog release];

#define ALERT_MSG_NETWORK_Error  ALERT_MSG(@"网络连接失败",nil,@"确定")

//用于设置导航view的大小
#define NavigationViewControllerViewFrameFull(navigationController) \
        [(navigationController) view].frame  = CGRectMake(0,0,self.view.frame.size.width,[UIScreen mainScreen].bounds.size.height-20);

#define NavigationViewControllerViewFrameShowTabBar(navigationController) \
        [(navigationController) view].frame  = CGRectMake(0,0,self.view.frame.size.width,[UIScreen mainScreen].bounds.size.height-20 - kTabBarHeight);

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON )
