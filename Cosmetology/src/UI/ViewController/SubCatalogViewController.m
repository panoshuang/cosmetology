//
//  MainCatalogViewContrller.m
//  Cosmetology
//
//  Created by mijie on 13-6-2.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "SubCatalogViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainProductInfo.h"
#import "GMGridView.h"
#import "MainCatalogGridViewCell.h"
#import "SubCatalogItem.h"
#import "global_define.h"
#import "AddSubCatalogViewController.h"
#import "UIAlertView+Blocks.h"
#import "SUbProductInfo.h"
#import "SubCatalogManager.h"
#import "ResourceCache.h"
#import "AutoDismissView.h"
#import "CommonUtil.h"
#import "PhotoScrollViewController.h"
#import "PhotoBrowserDataSource.h"
#import "AdPhotoManager.h"
#import "UIAlertView+Blocks.h"
#import "PasswordManager.h"
#import "SubProductInfo.h"
#import "MainCatalogManager.h"


#define ITEM_SPACE 30

@interface SubCatalogViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate,
        GMGridViewActionDelegate,MainCatalogGridViewCellDelegate,UIAlertViewDelegate,UITextFieldDelegate,
        AddSubCatalogViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UINavigationController *_optionsNav;
    UIPopoverController *_popController;
    UIImageView *_ivBg;
    UIToolbar *_toolbar;
    NSMutableArray *_catalogArray;
    NSInteger _lastDeleteItemIndexAsked;
    NSString *_newProductName;
    NSString *_passWord;
    UIView *_editTapView ;
    UITapGestureRecognizer *_editGesture; //开启编辑的手势

}

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)dataSetChange:(UISegmentedControl *)control;

@end


@implementation SubCatalogViewController

@synthesize delegate = _delegate;
@synthesize bIsEdit = _bIsEdit;
@synthesize gmGridView = _gmGridView;
@synthesize mainProductInfo = _mainProductInfo;


-(id)init{
    self = [super init];
    if (self) {
        _catalogArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithMainProductInfo:(MainProductInfo *)aMainProductInfo {
    self = [super init];
    if (self) {
        _mainProductInfo = aMainProductInfo;
        _catalogArray = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (id)objectWithMainProductInfo:(MainProductInfo *)aMainProductInfo {
    return [[SubCatalogViewController alloc] initWithMainProductInfo:aMainProductInfo];
}


-(void)loadCatalog{
    if(_bIsEdit){
        [_catalogArray addObjectsFromArray:[[SubCatalogManager instance] allSubProductInfoForMainProductID:_mainProductInfo.productID]];
    }else{
        [_catalogArray addObjectsFromArray:[[SubCatalogManager instance] allEnableProductInfoForMainProductID:_mainProductInfo.productID]];
    }
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
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBgTap:)];
//    tapGesture.numberOfTapsRequired = 2;
//    tapGesture.delegate = self;
//    [self.view addGestureRecognizer:tapGesture];
    
    
    _ivBg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *image = [[ResourceCache instance] imageForCachePath:self.mainProductInfo.bgImageFile];
    if (image) {
        _ivBg.image = image;
    }else{
        _ivBg.image = [UIImage imageNamed:@"bg_sub_product"];
    }
    [self.view addSubview:_ivBg];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kToolBarHeight)];
    if (_bIsEdit) {
        _toolbar.hidden = NO;
    }else{
        _toolbar.hidden = YES;
    }
    [self.view addSubview:_toolbar];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(addSubcatalogItem)];
    UIBarButtonItem *editBgItem = [[UIBarButtonItem alloc] initWithTitle:@"修改背景"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(editBg:)];
    _toolbar.items = [NSArray arrayWithObjects:addItem,editBgItem, nil];
    
    _editTapView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100,
                                                            0,
                                                            100,
                                                            kToolBarHeight)];
    _editTapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editTapView];
    _editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureDidTap:)];
    _editGesture.numberOfTapsRequired = 3;
    [_editTapView addGestureRecognizer:_editGesture];
    
    NSInteger spacing = ITEM_SPACE;
    CGRect gridViewFrame = CGRectMake((1024 - 420)/2, 240, 420, 370);
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:gridViewFrame];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    
    _gmGridView = gmGridView;
    _gmGridView.layer.masksToBounds = YES;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(10, 15, 0, 0);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    [self.view addSubview:_gmGridView];
//    [_gmGridView setEditing:YES animated:NO];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake((1024 - 120)/2, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == _editGesture) {
        return YES;
    }else{
        CGPoint point = [gestureRecognizer locationInView:_editTapView];
        if (CGRectContainsPoint(_editTapView.bounds, point)) {
            DDetailLog(@"in _editTapView");
            return NO;
        }else{
            DDetailLog(@"in bgView");
            return YES;
        }
    }
}



//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        DDetailLog(@"111111")
//    }
//    if (buttonIndex == 0) {
//        DDetailLog(@"00000");
//    }
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_bIsEdit) {
        [_gmGridView setEditing:_bIsEdit];
        [_gmGridView reloadData];
    }

}

-(void)setBIsEdit:(BOOL)bIsEdit {
    _bIsEdit = bIsEdit;
    [_catalogArray removeAllObjects];
    [self loadCatalog];
    [_gmGridView setEditing:_bIsEdit];
    [_gmGridView reloadData];
}

-(void)editGestureDidTap:(UITapGestureRecognizer *)gesture{
    if (_bIsEdit) {
        [self cancelEdit];
    }else{
        //判断是否已经设置了密码,没有的话直接进入编辑模式,有的话要输入密码
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_SUB_CATALOG];
        if (editPwdStr.length > 0) {
            [self inputPassword];
        }else{
            self.bIsEdit  = YES;
            _toolbar.hidden = NO;
        }
    }
}

-(void)cancelEdit{
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        self.bIsEdit = NO;
        _toolbar.hidden = YES;
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要退出编辑模式"
                                                        message:nil
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:confirmItem, nil];
    [alertView show];
}




-(void)addSubcatalogItem
{
    DDetailLog(@"");
    AddSubCatalogViewController *addSubCatalogViewController = [[AddSubCatalogViewController alloc] initWithMainCatalogId:_mainProductInfo.productID];
    addSubCatalogViewController.delegate = self;
    [_mainDelegate mainPushViewController:addSubCatalogViewController animated:YES];
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
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_SUB_CATALOG];
        if([editPwdStr isEqualToString:textField.text]){
            self.bIsEdit = YES;
            _toolbar.hidden = NO;
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

-(void)editBg:(UIBarButtonItem *)sender{
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

-(void)onBgTap:(UITapGestureRecognizer *)gesture{
    [UIView animateWithDuration:2 animations:^{
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0;
    }completion:^(BOOL complete){
        [self.view removeFromSuperview];
    }];
}

-(void)back:(UIButton *)btn{
    [UIView animateWithDuration:.5 animations:^{
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0;
    }completion:^(BOOL complete){
        [self.view removeFromSuperview];
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
        NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 1)
                                                                    relatePath:bgUuid
                                                                  resourceType:kResourceCacheTypeBackgroundImage];
        _mainProductInfo.bgImageFile = bgImageFilePath;
        [[MainCatalogManager instance] updateMainCatalog:_mainProductInfo];
        _ivBg.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_catalogArray count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (_bIsEdit) {
        return CGSizeMake(400, 97);
    }else{
        return CGSizeMake(400, 67);
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];


    MainCatalogGridViewCell *cell = (MainCatalogGridViewCell *)[gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[MainCatalogGridViewCell alloc] init];
        cell.delegate = self;
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        SubCatalogItem *mainCatalogItem = [[SubCatalogItem alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        mainCatalogItem.delegate = cell;
        mainCatalogItem.ivBg.image = [UIImage imageNamed:self.mainProductInfo.subItemBtnImageName];
        cell.contentView = mainCatalogItem;
        
    }
    SubProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    SubCatalogItem *contentItem = (SubCatalogItem *)cell.contentView;
    contentItem.lbName.text = productInfo.name;
    //设置名字颜色
    if (_mainProductInfo.colorType == kSubItemBtnColorGold) {
        contentItem.lbName.shadowColor = [UIColor blackColor];
        contentItem.lbName.shadowOffset = CGSizeZero;
        contentItem.lbName.shadowBlur = 20.0f;
        contentItem.lbName.innerShadowColor = [UIColor yellowColor];
        contentItem.lbName.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
        contentItem.lbName.gradientStartColor = [UIColor redColor];
        contentItem.lbName.gradientEndColor = [UIColor yellowColor];
        contentItem.lbName.gradientStartPoint = CGPointMake(0.0f, 0.5f);
        contentItem.lbName.gradientEndPoint = CGPointMake(1.0f, 0.5f);
        contentItem.lbName.oversampling = 2;
        contentItem.lbName.backgroundColor = [UIColor clearColor];
        contentItem.lbName.textAlignment = NSTextAlignmentCenter;

    }else if (_mainProductInfo.colorType == kSubItemBtnColorBlack){
        contentItem.lbName.shadowColor = [UIColor blackColor];
        contentItem.lbName.shadowOffset = CGSizeZero;
        contentItem.lbName.shadowBlur = 20.0f;
        contentItem.lbName.innerShadowColor = [UIColor blackColor];
        contentItem.lbName.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
        contentItem.lbName.gradientStartColor = [UIColor blackColor];
        contentItem.lbName.gradientEndColor = [UIColor purpleColor];
        contentItem.lbName.gradientStartPoint = CGPointMake(0.0f, 0.5f);
        contentItem.lbName.gradientEndPoint = CGPointMake(1.0f, 0.5f);
        contentItem.lbName.oversampling = 2;
        contentItem.lbName.backgroundColor = [UIColor clearColor];
        contentItem.lbName.textAlignment = NSTextAlignmentCenter;
    }else{
        contentItem.lbName.shadowColor = [UIColor blackColor];
        contentItem.lbName.shadowOffset = CGSizeZero;
        contentItem.lbName.shadowBlur = 20.0f;
        contentItem.lbName.innerShadowColor = [UIColor yellowColor];
        contentItem.lbName.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
        contentItem.lbName.gradientStartColor = [UIColor whiteColor];
        contentItem.lbName.gradientEndColor = [UIColor yellowColor];
        contentItem.lbName.gradientStartPoint = CGPointMake(0.0f, 0.5f);
        contentItem.lbName.gradientEndPoint = CGPointMake(1.0f, 0.5f);
        contentItem.lbName.oversampling = 2;
        contentItem.lbName.backgroundColor = [UIColor clearColor];
        contentItem.lbName.textAlignment = NSTextAlignmentCenter;
    }
    [contentItem setEdit:_bIsEdit];
    [contentItem.swEdit setOn:productInfo.enable];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);    
    SubProductInfo *subProductInfo = [_catalogArray objectAtIndex:position];
    
    //跳转到广告页面
    PhotoBrowserDataSource *dataSource = [[PhotoBrowserDataSource alloc] init];
    NSMutableArray *adPhotoArray = [NSMutableArray arrayWithArray:[[AdPhotoManager instance] allAdPhotoInfoForSubProductID:subProductInfo.productID]];
    [dataSource setPhotoList:adPhotoArray];
    PhotoScrollViewController *photoScrollViewController = [[PhotoScrollViewController alloc]
                                                            initWithDataSource:dataSource
                                                            andStartWithPhotoAtIndex:0];
    photoScrollViewController.bIsEdit = _bIsEdit;
    photoScrollViewController.subProductID = subProductInfo.productID;
    if (adPhotoArray.count == 0 && _bIsEdit == NO) {
        photoScrollViewController.isShowChromeAlways = YES;
    }
    [self.mainDelegate mainPushViewController:photoScrollViewController animated:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
//
//    [alert show];
//
//    _lastDeleteItemIndexAsked = index;
    SubProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    UIAlertView *alertView = nil;
    alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除选择的项目?"
                                           message:nil
                                  cancelButtonItem:nil
                                  otherButtonItems:nil];

    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        [[SubCatalogManager instance] deleteSubCatalogForId:productInfo.productID];

        [_catalogArray removeObjectAtIndex:index];
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    [alertView addButtonItem:confirmItem];
    [alertView addButtonItem:cancelItem];
    [alertView show];
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _passWord = [[NSString alloc]init];
    _newProductName = [[NSString alloc]init];
    if (buttonIndex == 1)
    {
//        [_catalogArray removeObjectAtIndex:_lastDeleteItemIndexAsked];
//        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
        DDetailLog(@"111111");
        if (!_bIsEdit) {
            _bIsEdit = YES;
            _gmGridView.editing = YES;
        }
        DDetailLog(@"%@",_newProductName);
        DDetailLog(@"%@",_passWord);
    }
    if (buttonIndex == 0) {
        DDetailLog(@"00000");
    }
    [_gmGridView reloadData];
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
                         cell.contentView.layer.cornerRadius = 4;
                         cell.contentView.layer.masksToBounds = YES;
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
                         cell.contentView.layer.cornerRadius = 0;
                         cell.contentView.layer.masksToBounds = NO;
                         cell.contentView.backgroundColor = [UIColor clearColor];
                         cell.contentView.layer.shadowOpacity = 0;
                         cell.highlighted = NO;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return NO;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_catalogArray objectAtIndex:oldIndex];
    [_catalogArray removeObject:object];
    [_catalogArray insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_catalogArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
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
    

    label.font = [UIFont boldSystemFontOfSize:20];
    
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


#pragma mark -  MainCatalogGridViewCellDelegate 

-(void)mainCatalogGridViewCellDidSwitch:(MainCatalogGridViewCell *)cell value:(BOOL)isOpen{
    DDetailLog(@"");
    int index = [_gmGridView positionForItemSubview:cell];
    SubProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    productInfo.enable = isOpen;
    [[SubCatalogManager instance] updateSubCatalog:productInfo];
    DDetailLog(@"indxe : %d",index);
}

- (void)subCatalogGridViewCellDidEditName:(MainCatalogGridViewCell *)cell {
    DDetailLog(@"delegate call...");
    int index = [_gmGridView positionForItemSubview:cell];
    SubProductInfo *productInfo = [_catalogArray objectAtIndex:index];

    UIAlertView *alertView = nil;
    alertView = [[UIAlertView alloc] initWithTitle:@"修改名字"
                                                        message:@"\n\n"
                                               cancelButtonItem:nil
                                               otherButtonItems:nil];
    
    UITextField *txt1 = [[UITextField alloc]initWithFrame:CGRectMake(12, 40, 260, 40)];
    txt1.font = [UIFont boldSystemFontOfSize:18];
    txt1.layer.cornerRadius = 6;
    txt1.layer.masksToBounds = YES;
    txt1.tag = 1000;
    txt1.text = productInfo.name;
    txt1.delegate = self;
    txt1.backgroundColor = [UIColor whiteColor];
    [alertView addSubview:txt1];
    
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        UITextField *textField = (UITextField *)[alertView viewWithTag:1000];
        DDetailLog(@"textField is %@",textField.text);
        productInfo.name = textField.text;
        [[SubCatalogManager instance] updateSubCatalog:productInfo];
        [_gmGridView reloadObjectAtIndex:index animated:YES];
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    [alertView addButtonItem:confirmItem];
    [alertView addButtonItem:cancelItem];
    [alertView show];
}

#pragma mark -  AddSubCatalogViewControllerDelegate

-(void)addSubCatalogViewController:(AddSubCatalogViewController *)addSubCatalogViewController didSaveCatalog:(SubProductInfo *)subProductInfo{
    [_catalogArray addObject:subProductInfo];
    [_gmGridView insertObjectAtIndex:_catalogArray.count - 1 animated:YES];
}




@end
