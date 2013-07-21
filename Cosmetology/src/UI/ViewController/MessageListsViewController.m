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

#define NUMBER_ITEMS_ON_LOAD 250
#define NUMBER_ITEMS_ON_LOAD2 30

#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController (privates methods)
//////////////////////////////////////////////////////////////

@interface MessageListsViewController ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,MessageBoardViewControllerDelegate>
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
        
    }
    
    return self;
}

-(void)loadData{
    [_msgArray addObjectsFromArray:[[MessageBoardManager instance] allMessageBoardForSubProductID:_productId]];
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

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
    _bgView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:_bgView];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
    [self.view addSubview:_toolBar];
    
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(back:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    space.width = 10;
    
    UIBarButtonItem *bgButton = [[UIBarButtonItem alloc]initWithTitle:@"修改背景"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(showEditBgView:)];
    
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
    space1.width = 10;
    UIBarButtonItem *editMessageBtn = [[UIBarButtonItem alloc]initWithTitle:@"我也要留言"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(toEditMessage:)];
    _toolBar.items = [NSArray arrayWithObjects:back,space1,bgButton, space,editMessageBtn,nil];
    
    
    
    //点击三次,启动编辑功能
    _editTapView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100,
                                                                0,
                                                                100,
                                                                kToolBarHeight)];
    _editTapView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_editTapView];
    _editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureDidTap:)];
    _editGesture.numberOfTapsRequired = 3;
    [_editTapView addGestureRecognizer:_editGesture];
    
    NSInteger spacing = 15;    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width - 50, self.view.bounds.size.height - 90)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
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
    _toolBar.hidden = NO;
}

//////////////////////////////////////////////////////////////
#pragma mark 切换背景
//////////////////////////////////////////////////////////////
-(void)showEditBgView:(UIBarButtonItem *)sender{
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
        UIView *itemView = [sender valueForKey:@"view"];
        [_popController presentPopoverFromRect:itemView.frame
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
    editMessageViewController.delegate = self;
    [self.navigationController pushViewController:editMessageViewController animated:YES];
}


-(void)setBIsEdit:(BOOL)bIsEdit {
    _bIsEdit = bIsEdit;
    [_gmGridView setEditing:_bIsEdit];
    [_gmGridView reloadData];
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
            _toolBar.hidden = NO;
        }
    }
}

-(void)cancelEdit{
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        self.bIsEdit = NO;
        _toolBar.hidden = YES;
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
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
            _bIsEdit = YES;
            _toolBar.hidden = NO;
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


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [_popController dismissPopoverAnimated:YES];
    if (image) {
        //生成图片的uuid,保存到缓存
        NSString *bgUuid = [CommonUtil uuid];
        NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 1)
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


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
    }
    MsgItem *contentView = (MsgItem *)cell.contentView;
    contentView.ivAutograph.image = [UIImage imageNamed:@"bg_autograph"];
    contentView.btnAcclaim.ivBg.image = [UIImage imageNamed:@"bg_acclaim"];
    contentView.btnAcclaim.lbCount.text = @"50";
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
    CheckMessageViewController *checkMessageViewController = [[CheckMessageViewController alloc]init];
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
                         cell.contentView.backgroundColor = [UIColor redColor];
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
    label.textAlignment = UITextAlignmentCenter;
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
    [_msgArray addObject:aMsg];
    [_gmGridView insertObjectAtIndex:_msgArray.count - 1 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
