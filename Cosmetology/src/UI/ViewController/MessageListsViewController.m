//
//  MessageListsViewController.m
//  MessageBoard
//
//  Created by hongji_zhou on 13-6-18.
//  Copyright (c) 2013年 hongji_zhou. All rights reserved.
//

#import "MessageListsViewController.h"
#import "GMGridView.h"
#import "EditMessageViewController.h"
#import "CheckMessageViewController.h"
#import "MessageBoardInfo.h"
#import "MessageBoardManager.h"
#import "ResourceCache.h"
#import "CommonUtil.h"
#import "AutoDismissView.h"
#import "PasswordManager.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "MsgGridViewCell.h"
#import "MsgItem.h"
#import "MainViewController.h"

#define NUMBER_ITEMS_ON_LOAD 250
#define NUMBER_ITEMS_ON_LOAD2 30

#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController (privates methods)
//////////////////////////////////////////////////////////////

@interface MessageListsViewController ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,MessageBoardViewControllerDelegate,CheckMessageViewControllerDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_msgArray;
    NSInteger _lastDeleteItemIndexAsked;
    MessageBoardInfo *messageBoardInfo;
    
    UIImageView *_bgView;//背景图片
    UIPopoverController *_popController;
    
    UITapGestureRecognizer *_editGesture; //开启编辑的手势
    BOOL _bIsEdit;
    
    UIButton *editBgBtn;//修改背景
    
    UILabel *_popularityLabel;//总人气
    int _popularityCount;
}

@end

@implementation MessageListsViewController


@synthesize bIsEdit = _bIsEdit;
@synthesize productId = _productId;

-(id)initWithProductId:(int)aId
{
    if ((self =[super init]))
    {
        _productId = aId;
        _msgArray = [[NSMutableArray alloc] init];
        messageBoardInfo = [[MessageBoardInfo alloc]init];
        [self loadData];
        for (int i = 0; i < _msgArray.count; i++) {
            MessageBoardInfo *msgBoarInfo = [_msgArray objectAtIndex:i];
            _popularityCount = _popularityCount + msgBoarInfo.popularity;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAcclaimArrived:) name:NOTIFY_CHECK_MSG_ACCLAIM object:nil];
    }
    
    return self;
}

-(void)loadData{
    [_msgArray addObjectsFromArray:[[MessageBoardManager instance] allMessageBoardForSubProductID:_productId]];
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated{
   
}

- (void)loadView
{
    [super loadView];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];    
    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;
    _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    //获取背景图片填充
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *bgFilePath = [userDefaults stringForKey:HOME_PAGE_BACKGROUND_IMAGE_FILE_PATH];
    UIImage *bgImage = [[ResourceCache instance] imageForCachePath:bgFilePath];
    if (bgImage) {
        _bgView.image = bgImage;
    }
    _bgView.image = [UIImage imageNamed:@"bgMessageLists.jpg"];
    [self.view addSubview:_bgView];

    //修改背景
    editBgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editBgBtn.frame = CGRectMake(30, 705, 180, 67);
    editBgBtn.hidden = YES;
    [editBgBtn setBackgroundImage:[UIImage imageNamed:@"editBgBtn.png"] forState:UIControlStateNormal];
    [editBgBtn addTarget:self action:@selector(showEditBgView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBgBtn];

    //我也要留言按钮
    UIButton *editMessageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editMessageBtn.frame = CGRectMake(200, 705, 180, 67);
    [editMessageBtn setBackgroundImage:[UIImage imageNamed:@"editMessage.png"] forState:UIControlStateNormal];
    [editMessageBtn addTarget:self action:@selector(toEditMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editMessageBtn];
    
    //主菜单按钮
    UIButton *mainMeunBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mainMeunBtn.frame = CGRectMake(430, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [mainMeunBtn setBackgroundImage:[UIImage imageNamed:@"bgMainMeun.png"] forState:UIControlStateNormal];
    [mainMeunBtn addTarget:self action:@selector(goToMainMeun:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainMeunBtn];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(600, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //总人气统计
    
    
    UIFont *font = [UIFont fontWithName:@"Courier-Oblique" size:24];
    _popularityLabel = [[UILabel alloc]initWithFrame:CGRectMake(750, 705, 250, 60)];
    _popularityLabel.backgroundColor = [UIColor clearColor];
    _popularityLabel.textColor = [UIColor whiteColor];
    _popularityLabel.textAlignment = NSTextAlignmentCenter;
    _popularityLabel.text =[NSString stringWithFormat:@"总人气:%d",_popularityCount];
    [_popularityLabel setFont:font];
    [self.view addSubview:_popularityLabel];
    
    
    //点击三次,启动编辑功能
    _editTapView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100,
                                                                0,
                                                                100,
                                                                kToolBarHeight)];
    _editTapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editTapView];
    _editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureDidTap:)];
    _editGesture.numberOfTapsRequired = 3;
    [_editTapView addGestureRecognizer:_editGesture];
    
    NSInteger spacing = 15;    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width - 50, self.view.bounds.size.height - 100)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    gmGridView.layer.masksToBounds = YES;
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    [_gmGridView reloadData];
}

-(void)goToMainMeun:(UIButton *)btn{
    MainViewController *mainViewController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gmGridView.mainSuperView = self.navigationController.view;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//////////////////////////////////////////////////////////////
#pragma mark 切换背景
//////////////////////////////////////////////////////////////
-(void)showEditBgView:(UIButton *)sender{
    if(![_popController isPopoverVisible])
    {
        if (!_popController)
        {
            _popController = nil;
        }
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.delegate = self;
        _popController=[[UIPopoverController alloc] initWithContentViewController:controller];
        [_popController presentPopoverFromRect:sender.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                      animated:YES];
    }
    else
    {
        [_popController dismissPopoverAnimated:YES];
    }
}

- (void)removeItem
{
    // Example: removing last item
    if ([_msgArray count] > 0)
    {
        NSInteger index = [_msgArray count] - 1;
        
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_msgArray removeObjectAtIndex:index];
    }
}

-(void)toEditMessage:(UIButton *)btn
{
    EditMessageViewController *editMessageViewController = [[EditMessageViewController alloc]init];
    editMessageViewController.subProductID = _productId;
    DDetailLog(@"%d",_productId);
    editMessageViewController.delegate = self;
    editMessageViewController.bIsEdit = _bIsEdit;
    [self.navigationController pushViewController:editMessageViewController animated:YES];
}


-(void)setBIsEdit:(BOOL)bIsEdit {
    _bIsEdit = bIsEdit;
    [_gmGridView setEditing:_bIsEdit];
    [_gmGridView reloadData];
    editBgBtn.hidden = !_bIsEdit;
}

//////////////////////////////////////////////////////////////
#pragma mark 启动编辑功能
//////////////////////////////////////////////////////////////

-(void)editGestureDidTap:(UITapGestureRecognizer *)gesture{
    if (_bIsEdit) {
        [self cancelEdit];
        
    }else{
        //判断是否已经设置了密码,没有的话直接进入编辑模式,有的话要输入密码
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_MAIN_CATALOG];
        if (editPwdStr.length > 0) {
            [self inputPassword];
        }else{
            self.bIsEdit = YES;
        }
    }
}

-(void)cancelEdit{
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        self.bIsEdit = NO;
        [_gmGridView setEditing:NO animated:YES];
        //editBgBtn.hidden = YES;
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    cancelItem.action = ^{
        editBgBtn.hidden = NO;
    };
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要退出编辑模式"
                                                        message:nil
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:confirmItem, nil];
    [alertView show];
}

-(void)inputPassword
{
    UIAlertView *alertView = nil;
    alertView = [[UIAlertView alloc] initWithTitle:@"输入密码"
                                           message:@"\n\n"
                                  cancelButtonItem:nil
                                  otherButtonItems:nil];
    
    UITextField *txt1 = [[UITextField alloc]initWithFrame:CGRectMake(12, 40, 260, 40)];
    txt1.font = [UIFont boldSystemFontOfSize:18];
    txt1.layer.cornerRadius = 6;
    txt1.layer.masksToBounds = YES;
    txt1.secureTextEntry = YES;
    txt1.backgroundColor = [UIColor whiteColor];
    txt1.backgroundColor = [UIColor whiteColor];
    txt1.tag = 1000;
    [alertView addSubview:txt1];
    
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        UITextField *textField = (UITextField *)[alertView viewWithTag:1000];
        DDetailLog(@"textField is %@",textField.text);
        //判断输入的密码是否正确
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_MAIN_CATALOG];
        if([editPwdStr isEqualToString:textField.text]){
            self.bIsEdit = YES;
        }else{
            [[AutoDismissView instance] showInView:self.view
                                             title:@"密码错误"
                                          duration:1];
        }
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    [alertView addButtonItem:cancelItem];
    [alertView addButtonItem:confirmItem];
    [alertView show];
    
}

-(void)onAcclaimClick:(AcclaimButton *)btn{
    if (!_bIsEdit) {
        GMGridViewCell *cell = (GMGridViewCell *)(btn.superview.superview);
        int index = [_gmGridView positionForItemSubview:cell];
        if (index != NSNotFound) {
            MessageBoardInfo *msgInfo = [_msgArray objectAtIndex:index];
            msgInfo.popularity += 1;
            _popularityCount +=1;
            [[MessageBoardManager instance] updateMessageBoard:msgInfo];
            GMGridViewCell *cell = [_gmGridView cellForItemAtIndex:index];
            if (cell) {
                MsgItem *msgItem = (MsgItem *)cell.contentView;
                msgItem.btnAcclaim.lbCount.text = [NSString stringWithFormat:@"%d",msgInfo.popularity];
                _popularityLabel.text = [NSString stringWithFormat:@"总人气:%d",_popularityCount];
            }
            [self showIncrementTipsView];
        }
    }
}

-(void)showIncrementTipsView{
    UILabel *incrementTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100)/2, self.view.bounds.size.height - kBottomBarHeight - 100, 100, 100)];
    incrementTipsLabel.backgroundColor = [UIColor clearColor];
    incrementTipsLabel.text = @"+1";
    incrementTipsLabel.font = [UIFont boldSystemFontOfSize:40];
    incrementTipsLabel.textColor = [UIColor colorWithRed:0xff/255. green:0x2e/255. blue:0x55/255. alpha:1];
    incrementTipsLabel.textAlignment = NSTextAlignmentCenter;
    incrementTipsLabel.shadowOffset = CGSizeMake(5, 5);
    incrementTipsLabel.alpha = 0;
    [self.view addSubview:incrementTipsLabel];
    
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = incrementTipsLabel.frame;
        frame.origin.y = (self.view.bounds.size.height - 100)/2;
        incrementTipsLabel.frame = frame;
        incrementTipsLabel.alpha = 1;
    } completion:^(BOOL complete){
        [incrementTipsLabel removeFromSuperview];
    }];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [_popController dismissPopoverAnimated:YES];
    if (image) {
        //生成图片的uuid,保存到缓存
        NSString *bgUuid = [CommonUtil uuid];
        NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 0.8)
                                                                    relatePath:bgUuid
                                                                  resourceType:kResourceCacheTypeBackgroundImage];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:bgImageFilePath forKey:MSG_PAGE_BACKGROUND_IMAGE_FILE_PATH];
        [userDefaults synchronize];
        _bgView.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }    
}

//////////////////////////////////////////////////////////////
#pragma mark memory management
//////////////////////////////////////////////////////////////

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

//////////////////////////////////////////////////////////////
#pragma mark orientation management
//////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_msgArray count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(282, 263);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        MsgItem *msgItem = [[MsgItem alloc] initWithFrame:CGRectMake(0, 0, 282, 263)];
        cell.contentView = msgItem;
        [msgItem.btnAcclaim addTarget:self action:@selector(onAcclaimClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    MsgItem *contentView = (MsgItem *)cell.contentView;
    MessageBoardInfo *messageBoardinfoTemp = [_msgArray objectAtIndex:index];
    
    UIImage *singeNameImage = [[ResourceCache instance] imageForCachePath:messageBoardinfoTemp.singeName];
    if (!singeNameImage) {
        singeNameImage  = [UIImage imageNamed:@"singe"];
    }
    UIImage *protraitImage = [[ResourceCache instance] imageForCachePath:messageBoardinfoTemp.headPortraits];
    if (!protraitImage) {
        protraitImage  = [UIImage imageNamed:@"pickPhoto"];
    }
    contentView.ivAutograph.image = singeNameImage;
    contentView.headPortraits.image = protraitImage;
    contentView.btnAcclaim.ivBg.image = [UIImage imageNamed:@"bgacclaim.png"];
    contentView.btnAcclaim.lbCount.text = [NSString stringWithFormat:@"%d",messageBoardinfoTemp.popularity];
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; 
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    MessageBoardInfo *msgInfo = [_msgArray objectAtIndex:position];    
    CheckMessageViewController *checkMessageViewController = [[CheckMessageViewController alloc]init];
    checkMessageViewController.messageBoardInfo = msgInfo;
    checkMessageViewController.delegate = self;
    checkMessageViewController.bIsEdit = _bIsEdit;
    [self.navigationController pushViewController:checkMessageViewController animated:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{

    MessageBoardInfo *msgInfo = [_msgArray objectAtIndex:index];
    UIAlertView *alertView = nil;
    alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除选择的项目?"
                                           message:nil
                                  cancelButtonItem:nil
                                  otherButtonItems:nil];
    
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        [[MessageBoardManager instance] deleteMessageBoardForID:msgInfo.messageID];        
        [_msgArray removeObjectAtIndex:index];
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    [alertView addButtonItem:confirmItem];
    [alertView addButtonItem:cancelItem];
    [alertView show];
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [_msgArray removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor clearColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_msgArray objectAtIndex:oldIndex];
    [_msgArray removeObject:object];
    [_msgArray insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_msgArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        return CGSizeMake(700, 530);
    }
    else
    {
        return CGSizeMake(600, 500);
    }
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (INTERFACE_IS_PHONE)
    {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        label.font = [UIFont boldSystemFontOfSize:20];
    }
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}

#pragma mark - MessageBoardViewControllerDelegate

-(void)saveMessage:(MessageBoardInfo *)aMsg forSubProductID:(NSInteger)subProductID{
    [_msgArray insertObject:aMsg atIndex:0];
    [_gmGridView insertObjectAtIndex:0 animated:NO];
}

#pragma mark -  CheckMessageViewControllerDelegate

-(BOOL)checkMessageCanDeleteMessageBoardInfo:(MessageBoardInfo *)msgInfo{
    if ([_msgArray containsObject:msgInfo]) {
        if ([_msgArray lastObject] == msgInfo) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)checkMessageViewControllerDidDeleteMsg:(MessageBoardInfo *)msgInfo{
    [[MessageBoardManager instance] deleteMessageBoardForID:msgInfo.messageID];
    int index = [_msgArray indexOfObject:msgInfo];
    [_msgArray removeObject:msgInfo];
    [_gmGridView removeObjectAtIndex:index animated:NO];
}

-(MessageBoardInfo *)checkMessageViewControllerNextMsg:(MessageBoardInfo *)msgInfo{
    int index = [_msgArray indexOfObject:msgInfo];
    if (index < _msgArray.count - 1) {
        return [_msgArray objectAtIndex:index + 1];
    }else{
        return nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)onAcclaimArrived:(NSNotification *)notification{
    MessageBoardInfo *msgInfo = notification.object;
    if (msgInfo) {
        int index = [_msgArray indexOfObject:msgInfo];
        if (index != NSNotFound) {
            [_gmGridView reloadObjectAtIndex:index animated:NO];
        }
    }
    _popularityCount += 1;
    _popularityLabel.text = [NSString stringWithFormat:@"总人气:%d",_popularityCount];
}



@end
