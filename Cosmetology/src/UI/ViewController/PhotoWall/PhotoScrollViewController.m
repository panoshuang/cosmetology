//
//  PhotoScrollViewController.m
//  homi
//   @：照片滑动预览
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "PhotoInfo.h"
#import "PhotoBrowserDataSource.h"
#import "PhotoCommentListViewController.h"
#import "PhotoAlbumManager.h"
#import "CustomNotifyData.h"
#import "UserAccountManager.h"
#import "ReportManager.h"
#import "ScreenWaitingView.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "AutoDismissView.h"
#import "UIActionSheet+Blocks.h"
#import "UserInfoManager.h"
#import "UIColor+Extra.h"


#define BTN_LIKE_TAG   1001
#define BTN_COMMENT_TAG 1002
#define BTN_REPORT_TAG  1003
#define BTN_DEL_TAG     1004
#define ALERT_VIEW_DEL_TAG 1005


static BOOL isProsecutingPhoto = NO;


@interface PhotoScrollViewController ()

@end


@implementation PhotoScrollViewController

@synthesize userID;
@synthesize delegate;


- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index
{
    self = [super initWithDataSource:dataSource andStartWithPhotoAtIndex:index];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    

    self.userID = nil;

    [super dealloc];
}

- (void)addObserverToNotificationCenter
{
    DDetailLog(@"addObserverToNotificationCenter");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLikeAlbumPhotoArrived:) name:NOTIFY_ALBUM_LIKE_PHOTO_UI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteAlbumPhotoArrived:) name:NOTIFY_ALBUM_DELETE_PHOTO_UI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProsecuteArrived:) name:NOTIFY_REPORT_PROSECUTE_UI object:nil];
    
    //监听被迫下线通知,来消失actionSheet
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onForcedOffline:) name:NOTIFY_MSG_CENTER_FORCED_OFFLINE_MSG_RECEIVED_UI object:nil];
}

- (void)loadView
{
    [super loadView];

    //把navigatorController的delegate设置为自己,用于在显示本页面时候设置全屏
    // self.navigationController.delegate = self;

    UserAccountInfo        *accountInfo = [[UserAccountManager instance] curUserAccount];
    PhotoBrowserDataSource *dataSource  = (PhotoBrowserDataSource *)dataSource_;
    NSMutableArray         *buttonArray = [NSMutableArray array];
    PhotoInfo              *photoInfo   = [[dataSource photoList] lastObject];

    // 设置标题栏
    self.titleBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, kPhotoBrowerTitleBarHight);
    [self.titleBar.btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    // 设置底部工具栏
    self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - kPhotoBrowerToolBarHight, self.view.bounds.size.width, kPhotoBrowerToolBarHight);
    if ([accountInfo.userID isEqualToString:photoInfo.userID])
    {
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_comment_nomal.png"] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_comment_highted.png"] forState:UIControlStateHighlighted];
        [commentButton addTarget:self action:@selector(commentPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        commentButton.tag       = BTN_COMMENT_TAG;
        [buttonArray addObject:commentButton];

        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [delButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_nomal.png"] forState:UIControlStateNormal];
        [delButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_highted.png"] forState:UIControlStateHighlighted];
        [delButton addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        delButton.tag = BTN_DEL_TAG;
        [buttonArray addObject:delButton];
    }
    else
    {
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_like_nomal.png"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_like_highted.png"] forState:UIControlStateHighlighted];
        [likeButton addTarget:self action:@selector(likePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        likeButton.tag = BTN_LIKE_TAG;
        [buttonArray addObject:likeButton];

        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_comment_nomal.png"] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_comment_highted.png"] forState:UIControlStateHighlighted];
        [commentButton addTarget:self action:@selector(commentPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        commentButton.tag = BTN_COMMENT_TAG;
        [buttonArray addObject:commentButton];

        UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_nomal.png"] forState:UIControlStateNormal];
        [reportButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_highted.png"] forState:UIControlStateHighlighted];
        [reportButton addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        reportButton.tag = BTN_REPORT_TAG;
        [buttonArray addObject:reportButton];
    }

    self.toolbar.buttonArray = buttonArray;
}

- (void)viewDidLoad
{
    DDetailLog(@"viewDidLoad:%@", self);
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addObserverToNotificationCenter];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    //设置全屏预览
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.mainViewController.wantsFullScreenLayout = YES;
//    self.navigationController.wantsFullScreenLayout      = YES;
//    self.wantsFullScreenLayout                           = YES;
//    [UIApplication sharedApplication].statusBarHidden    = YES;
//    [UIApplication sharedApplication].statusBarStyle     = UIStatusBarStyleBlackTranslucent;
//    appDelegate.mainViewController.view.frame            = [UIScreen mainScreen].bounds;
//    self.navigationController.view.frame                 = [UIScreen mainScreen].bounds;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    //取消全屏
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.mainViewController.wantsFullScreenLayout = NO;
//    self.navigationController.wantsFullScreenLayout      = NO;
//    self.wantsFullScreenLayout                           = NO;
//    [UIApplication sharedApplication].statusBarHidden    = NO;
//    [UIApplication sharedApplication].statusBarStyle     = UIStatusBarStyleBlackOpaque;
//
//    appDelegate.mainViewController.view.frame = CGRectMake(0, 20, 320, [UIScreen mainScreen].applicationFrame.size.height);
//    [self.navigationController.view setNeedsLayout];
//    [appDelegate.mainViewController.view setNeedsLayout];
}

-(void)showIncrementTipsView{
    UILabel *incrementTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100)/2, self.view.bounds.size.height - kBottomBarHeight - 100, 100, 100)];
    incrementTipsLabel.backgroundColor = [UIColor clearColor];
    incrementTipsLabel.text = @"+1";
    incrementTipsLabel.font = [UIFont boldSystemFontOfSize:40];
    incrementTipsLabel.textColor = [UIColor colorWithHexColor:0xff2e55];
    incrementTipsLabel.textAlignment = UITextAlignmentCenter;
    incrementTipsLabel.shadowOffset = CGSizeMake(5, 5);
    incrementTipsLabel.alpha = 0;
    [self.view addSubview:incrementTipsLabel];
    [incrementTipsLabel release];
    
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = incrementTipsLabel.frame;
        frame.origin.y = (self.view.bounds.size.height - 100)/2;
        incrementTipsLabel.frame = frame;
        incrementTipsLabel.alpha = 1;
    } completion:^(BOOL complete){
        [incrementTipsLabel removeFromSuperview];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likePhotoBtnClick:(UIButton *)button
{
    PhotoBrowserDataSource *dataSource = (PhotoBrowserDataSource *)dataSource_;
    PhotoInfo              *photoInfo  = [[dataSource photoList] objectAtIndex:currentIndex_];
    if (!photoInfo.isLike){
        photoInfo.isLike = YES;
        photoInfo.numOfLike += 1;
        [self showIncrementTipsView];
        [[ScreenWaitingView shareScreenWaitingView] updateMessage:@"喜欢该照片..."];
        [[PhotoAlbumManager instance] likePhotoInfo:photoInfo];
    }
}

- (void)commentPhotoBtnClick:(UIButton *)button
{
    PhotoBrowserDataSource         *dataSource                = (PhotoBrowserDataSource *)dataSource_;
    PhotoInfo                      *photoInfo                 = [[dataSource photoList] objectAtIndex:currentIndex_];
    PhotoCommentListViewController *commentListViewController = [[PhotoCommentListViewController alloc] initWithPhotoInfo:photoInfo];
    [self.navigationController pushViewController:commentListViewController animated:YES];
    [commentListViewController release];
}

- (void)reportBtnClick:(UIButton *)sender
{
    RIButtonItem *cancelBtn = [[RIButtonItem alloc] init];
    cancelBtn.label = @"取消";
    RIButtonItem *sexPhotoBtn = [[RIButtonItem alloc] init];
    sexPhotoBtn.label         = @"色情照片";
    sexPhotoBtn.action        = ^
    {
        [[ScreenWaitingView shareScreenWaitingView] updateMessage:@"举报照片..."];
        [[ScreenWaitingView shareScreenWaitingView] show];
        PhotoBrowserDataSource *dataSource = (PhotoBrowserDataSource *)dataSource_;
        PhotoInfo              *photoInfo  = [[dataSource photoList] objectAtIndex:currentIndex_];
        [[ReportManager instance] prosecuteToDefendant:photoInfo.userID
                                              moduleID:kModuleTypePhoto
                                          targetLongID:photoInfo.photoID
                                                reason:sexPhotoBtn.label];
        isProsecutingPhoto = YES;
    };
    RIButtonItem *violenceBtn = [[RIButtonItem alloc] init];
    violenceBtn.label  = @"暴力血腥照片";
    violenceBtn.action = ^
    {
        [[ScreenWaitingView shareScreenWaitingView] updateMessage:@"举报照片..."];
        [[ScreenWaitingView shareScreenWaitingView] show];
        PhotoBrowserDataSource *dataSource = (PhotoBrowserDataSource *)dataSource_;
        PhotoInfo              *photoInfo  = [[dataSource photoList] objectAtIndex:currentIndex_];
        [[ReportManager instance] prosecuteToDefendant:photoInfo.userID
                                              moduleID:kModuleTypePhoto
                                          targetLongID:photoInfo.photoID
                                                reason:sexPhotoBtn.label];
        isProsecutingPhoto = YES;
    };

    actionSheet = [[UIActionSheet alloc] initWithTitle:@"举报"
                                                     cancelButtonItem:cancelBtn
                                                destructiveButtonItem:nil otherButtonItems:sexPhotoBtn, violenceBtn, nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    [cancelBtn release];
    [sexPhotoBtn release];
    [violenceBtn release];
}

- (void)deleteBtnClicked:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除该照片？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = ALERT_VIEW_DEL_TAG;
    [alertView show];
    [alertView release];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        PhotoBrowserDataSource *dataSource = (PhotoBrowserDataSource *)dataSource_;
        PhotoInfo              *photoInfo  = [[dataSource photoList] objectAtIndex:currentIndex_];
        if (alertView.tag == ALERT_VIEW_DEL_TAG)
        {
            //删除照片
            [[ScreenWaitingView shareScreenWaitingView] updateMessage:@"删除照片..."];
            [[ScreenWaitingView shareScreenWaitingView] show];
            [[PhotoAlbumManager instance] deletePhotoInfoForID:photoInfo.photoID];
        }
    }
}

#pragma mark - UINavigatorControllerDelegate

#pragma mark - NSNotification Handle

- (void)onLikeAlbumPhotoArrived:(NSNotification *)notification
{
//    [[ScreenWaitingView shareScreenWaitingView] hide];
//    CustomNotifyData *notifyData = notification.object;
//    if (notifyData.dwStatusCode == STATUS_NETWORK_OK)
//    {
//        NSNumber *code = [notifyData otherInfoForKey:@"code"];
//        if (code && [code integerValue] == STATUS_REQUEST_STATUS_OK)
//        {
//
//        }
//        else
//        {
//            ALERT_MSG(@"喜欢照片失败", nil, @"确定");
//        }
//    }
//    else
//    {
//        [[NetWorkErrorHandleUI instance] netWorkErrorHandleUI:(uint16)notifyData.dwStatusCode];
//    }
}

- (void)onDeleteAlbumPhotoArrived:(NSNotification *)notification
{
    [[ScreenWaitingView shareScreenWaitingView] hide];
    CustomNotifyData *notifyData = notification.object;
    DDetailLog(@"notification.object:%@", notification.object);
    if (notifyData.dwStatusCode == STATUS_NETWORK_OK)
    {
        NSNumber *code = [notifyData otherInfoForKey:@"code"];
        if (code && [code integerValue] == STATUS_REQUEST_STATUS_OK)
        {
            if ([delegate respondsToSelector:@selector(photoScrollViewController:didDeletePhotoIndex:)])
            {

                [delegate photoScrollViewController:self
                                didDeletePhotoIndex:currentIndex_];
            }
            [self deleteCurrentPhoto];
            
            [[AutoDismissView instance] showInView:self.view
                                             title:@"删除成功"
                                          duration:1];
            
            UserAccountInfo *curAccount = [UserAccountManager instance].curUserAccount;
            [[UserInfoManager instance] getUserInfoProfileFromServer:curAccount.userID];
        }
        else
        {
            ALERT_MSG(@"删除照片失败", nil, @"确定");
        }
    }
    else
    {
        [[NetWorkErrorHandleUI instance] netWorkErrorHandleUI:(uint16)notifyData.dwStatusCode];
    }
}

- (void)onProsecuteArrived:(NSNotification *)notification
{
    //判断是否为当前页面发起的举报，不是的时候忽略该通知
    if (!isProsecutingPhoto)
    {
        return;
    }
    [[ScreenWaitingView shareScreenWaitingView] hide];
    CustomNotifyData *notifyData = notification.object;
    if (notifyData.dwStatusCode == STATUS_NETWORK_OK)
    {
        NSNumber *code = [notifyData otherInfoForKey:@"code"];
        if (code && [code integerValue] == STATUS_REQUEST_STATUS_OK)
        {
            [[AutoDismissView instance] showInView:self.view
                                             title:@"举报成功"
                                          duration:.5];
        }
        else
        {
            ALERT_MSG(@"举报照片失败", nil, @"确定");
        }
    }
    else
    {
        [[NetWorkErrorHandleUI instance] netWorkErrorHandleUI:(uint16)notifyData.dwStatusCode];
    }
}

-(void)onForcedOffline:(NSNotification *)notification{
    if (actionSheet) {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    }
}

@end
