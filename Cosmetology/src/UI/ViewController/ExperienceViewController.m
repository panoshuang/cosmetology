//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ExperienceViewController.h"
#import "SubProductInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "MainProductInfo.h"
#import "GMGridView.h"
#import "MainCatalogGridViewCell.h"
#import "SubCatalogItem.h"
#import "global_define.h"
#import "AddSubCatalogViewController.h"
#import "MainCatalogManager.h"
#import "SubCatalogManager.h"
#import "PhotoScrollViewController.h"
#import "PhotoBrowserDataSource.h"
#import "AdPhotoManager.h"
#import "UIAlertView+Blocks.h"
#import "PasswordManager.h"
#import "AutoDismissView.h"
#import "CommonUtil.h"
#import "ResourceCache.h"

#define ITEM_SPACE 30

@interface ExperienceViewController()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,MainCatalogGridViewCellDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
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

@implementation ExperienceViewController {

}

@synthesize experienceInfo = _experienceInfo;

-(id)init{
    self = [super init];
    if (self) {
        _catalogArray = [[NSMutableArray alloc] init];
        self.experienceInfo = [[MainCatalogManager instance] experienceCatalog];
        [self loadCatalog];
    }
    return self;
}

-(void)loadCatalog{
    if(_bIsEdit){
        [_catalogArray addObjectsFromArray:[[SubCatalogManager instance] allSubProductInfoForMainProductID:self.experienceInfo.productID]];
    }else{
        [_catalogArray addObjectsFromArray:[[SubCatalogManager instance] allEnableProductInfoForMainProductID:self.experienceInfo.productID]];
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBgTap:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];

    _ivBg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _ivBg.image = [[ResourceCache instance] imageForCachePath:self.experienceInfo.bgImageFile];
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
                                                               action:@selector(addSubCatalogItem)];
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
    CGRect gridViewFrame = CGRectMake(98, 240, 785, 370);
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:gridViewFrame];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.layer.masksToBounds = YES;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(25, 25, 0, 0);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    [self.view addSubview:_gmGridView];
}

-(void)addSubCatalogItem
{
    DDetailLog(@"");
    AddSubCatalogViewController *addSubCatalogViewController = [[AddSubCatalogViewController alloc] initWithMainCatalogId:_experienceInfo.productID];
    addSubCatalogViewController.delegate = self;
    [_mainDelegate mainPushViewController:addSubCatalogViewController animated:YES];
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

}

-(void)setBIsEdit:(BOOL)bIsEdit {
    _bIsEdit = bIsEdit;
    [_gmGridView setEditing:_bIsEdit];
    [_gmGridView reloadData];
}

-(void)onBgTap:(UITapGestureRecognizer *)gesture{

    [UIView animateWithDuration:2 animations:^{
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0;
    }completion:^(BOOL complete){
        [self.view removeFromSuperview];
    }];
//
    
    
//    UIView *testView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:testView];
//    testView.backgroundColor = [UIColor orangeColor];
//    [UIView animateWithDuration:2
//                     animations:^{
//                         testView.frame = self.view.bounds;
//                     }completion:NULL];
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
        return CGSizeMake(230, 80);
    }else{
        return CGSizeMake(230, 52);
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
        cell.contentView = mainCatalogItem;

    }
    MainProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    SubCatalogItem *contentItem = (SubCatalogItem *)cell.contentView;
    contentItem.lbName.text = productInfo.name;
    [contentItem setEdit:_bIsEdit];
    [contentItem.swEdit setSelected:productInfo.enable];

//    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    UIButton *contentBtn = (UIButton *)cell.contentView;
//     [contentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    contentBtn.backgroundColor = [UIColor greenColor];
//    [contentBtn setTitle:productInfo.name forState:UIControlStateNormal];
//    NSLog(@"%@",productInfo.name);
//    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    label.text = productInfo.name;
//    label.textAlignment = UITextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor blackColor];
//    label.highlightedTextColor = [UIColor whiteColor];
//    label.font = [UIFont boldSystemFontOfSize:20];
//    [cell.contentView addSubview:label];

//    [cell setEditing:YES animated:NO];

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
    //重新提交

    SubProductInfo *subProductInfo = [_catalogArray objectAtIndex:position];
    
    //跳转到广告页面
    PhotoBrowserDataSource *dataSource = [[PhotoBrowserDataSource alloc] init];
    NSMutableArray *adPhotoArray = [NSMutableArray arrayWithArray:[[AdPhotoManager instance] allAdPhotoInfoForSubProductID:subProductInfo.productID]];
    [dataSource setPhotoList:adPhotoArray];
    PhotoScrollViewController *photoScrollViewController = [[PhotoScrollViewController alloc]
            initWithDataSource:dataSource
      andStartWithPhotoAtIndex:0];
    //TODO:把编辑设置是,以后需要修改
    photoScrollViewController.bIsEdit = YES;
    photoScrollViewController.subProductID = subProductInfo.productID;
    [self.mainDelegate mainPushViewController:photoScrollViewController animated:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

    [alert show];

    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _passWord = [[NSString alloc]init];
    _newProductName = [[NSString alloc]init];
    if (buttonIndex == 1)
    {
        [_catalogArray removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
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
    label.textAlignment = UITextAlignmentCenter;
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
                         cell.contentView.backgroundColor = [UIColor clearColor];
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
                         cell.contentView.backgroundColor = [UIColor clearColor];
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
    DDetailLog(@"indxe : %d",index);
}

- (void)subCatalogGridViewCellDidEditName:(MainCatalogGridViewCell *)cell {
    DDetailLog(@"delegate call...");
    UIAlertView *alert1 = [[UIAlertView alloc]
            initWithTitle:NSLocalizedString(@"输入新项目名", nil)
                  message:NSLocalizedString(@"\n", nil)
                 delegate:self
        cancelButtonTitle:@"取消"
        otherButtonTitles:@"确认",
                          nil];
    alert1.delegate = self;
    UITextField *txt1 = [[UITextField alloc]initWithFrame:CGRectMake(12, 40, 260, 40)];
    txt1.font = [UIFont boldSystemFontOfSize:18];
    txt1.layer.cornerRadius = 6;
    txt1.layer.masksToBounds = YES;
    txt1.secureTextEntry = YES;
    txt1.delegate = self;
    txt1.backgroundColor = [UIColor whiteColor];
    [alert1 addSubview:txt1];
    [alert1 show];
}

#pragma mark -  AddSubCatalogViewControllerDelegate

-(void)addSubCatalogViewController:(AddSubCatalogViewController *)addSubCatalogViewController didSaveCatalog:(SubProductInfo *)subProductInfo{
    [_catalogArray addObject:subProductInfo];
    [_gmGridView insertObjectAtIndex:_catalogArray.count - 1 animated:YES];
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
        self.experienceInfo.bgImageFile = bgImageFilePath;
        [[MainCatalogManager instance] updateMainCatalog:self.experienceInfo];
        _ivBg.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }
    
}

//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)addMoreItem
{
    // Example: adding object at the last position
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];

    [_catalogArray addObject:newItem];
    [_gmGridView insertObjectAtIndex:[_catalogArray count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    // Example: removing last item
    if ([_catalogArray count] > 0)
    {
        NSInteger index = [_catalogArray count] - 1;

        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_catalogArray removeObjectAtIndex:index];
    }
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_catalogArray count] > 0)
    {
        int index = [_catalogArray count] - 1;

        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];

        [_catalogArray replaceObjectAtIndex:index withObject:newMessage];
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}



@end