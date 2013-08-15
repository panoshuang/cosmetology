/*********************************************************************
 *            Copyright (C) 2012, 广州米捷网络科技有限公司
 * @文件描述:其他一些宏定义(如视图宽高等)
 **********************************************************************
 *   Date        Name        Description
 *   2012/06/18  luzj        New
 *********************************************************************/

#define NOTIFY_CHECK_MSG_ACCLAIM   @"NOTIFY_CHECK_MSG_ACCLAIM"

#define kCompileTime               @"2012-09-29 A" // 编译的时间

#define kTabImageSize              30  //Tab图片的大小
#define kTabBarHeight              45  //TabBar的高度
#define CHAT_INPUT_VIEW_HEIGHT     52  //聊天页面的输入栏高度
#define kTitleBarHeight            44  //TitleBar的高度
#define kToolBarHeight             44  //工具栏的高度 
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

#define kFontSystemSize12                     [UIFont systemFontOfSize:12] 
#define kFontSystemSize14                     [UIFont systemFontOfSize:14] 
#define kFontSystemSize16                     [UIFont systemFontOfSize:16] 
#define kFontSystemSize18                     [UIFont systemFontOfSize:18] 



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

#pragma mark - 默认值定义
#define EXPERIENCE_CATALOG_INDEX  10000


#pragma mark - 中文字符串定义

#define EXPERIENCE_CATALOG_NAME @"超值体验"



/*
 *以下是一些功能性宏定义
 */

//用于快速的实现屏幕可任意方向翻转而设置的宏
#define SHOULD_AUTOROTATA_TO_INTERFACE_ORIENTATION \
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation \
{\
return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown); \
}

#define SHOULD_AUTOROTATA_TO_INTERFACE_ORIENTATION_LANDSCAPE \
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation \
{\
return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight ); \
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
[alertDialog show];


#define ALERT_MSG_NETWORK_Error  ALERT_MSG(@"网络连接失败",nil,@"确定")

//用于设置导航view的大小
#define NavigationViewControllerViewFrameFull(navigationController) \
        [(navigationController) view].frame  = CGRectMake(0,0,self.view.frame.size.width,[UIScreen mainScreen].bounds.size.height-20);

#define NavigationViewControllerViewFrameShowTabBar(navigationController) \
        [(navigationController) view].frame  = CGRectMake(0,0,self.view.frame.size.width,[UIScreen mainScreen].bounds.size.height-20 - kTabBarHeight);

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON )
