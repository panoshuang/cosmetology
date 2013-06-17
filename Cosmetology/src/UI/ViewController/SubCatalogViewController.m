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

#define ITEM_SPACE 30

@interface SubCatalogViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate,
        GMGridViewActionDelegate,MainCatalogGridViewCellDelegate,UIAlertViewDelegate,UITextFieldDelegate,
        AddSubCatalogViewControllerDelegate>
{
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_catalogArray;
    NSInteger _lastDeleteItemIndexAsked;
    NSString *_newProductName;
    NSString *_passWord;
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
        [self loadCatalog];
    }
    return self;
}

- (id)initWithMainProductInfo:(MainProductInfo *)aMainProductInfo {
    self = [super init];
    if (self) {
        _mainProductInfo = aMainProductInfo;
        _catalogArray = [[NSMutableArray alloc] init];
        [self loadCatalog];
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
    self.view.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBgTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    
    NSInteger spacing = ITEM_SPACE;
    
    CGRect gridViewFrame = CGRectMake(118, 218, 300, 461);
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:gridViewFrame];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    [self.view addSubview:_gmGridView];
//    [_gmGridView setEditing:YES animated:NO];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    
    UIButton *updatePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    updatePassword.frame = CGRectMake(self.view.frame.size.width - 40, 0, 80, 30);
    updatePassword.backgroundColor = [UIColor blueColor];
    [updatePassword setTitle:@"输入密码" forState:UIControlStateNormal];
    [updatePassword addTarget:self action:@selector(inputPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updatePassword];
    
    UIButton *addSubcatalogItem = [UIButton buttonWithType:UIButtonTypeCustom];
    addSubcatalogItem.frame = CGRectMake(self.view.frame.size.width - 160, 0, 40, 30);
    addSubcatalogItem.backgroundColor = [UIColor blueColor];
    [addSubcatalogItem setTitle:@"添加" forState:UIControlStateNormal];
    [addSubcatalogItem addTarget:self action:@selector(addSubcatalogItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addSubcatalogItem];
}

-(void)addSubcatalogItem
{
    DDetailLog(@"");
    AddSubCatalogViewController *addSubCatalogViewController = [[AddSubCatalogViewController alloc] initWithMainCatalogId:_mainProductInfo.productID];
    addSubCatalogViewController.delegate = self;
    [_mainDelegate mainPushViewController:addSubCatalogViewController animated:YES];
}

-(void)inputPassword:(UIButton *)btn
{
    UIAlertView *alert1 = [[UIAlertView alloc]
              initWithTitle:NSLocalizedString(@"输入密码", nil)
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

//    [UIView animateWithDuration:2 animations:^{
//        _gmGridView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//        _gmGridView.frame = self.view.bounds;
//    }completion:NULL];
//    
    
    [self.view removeFromSuperview];
//    UIView *testView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:testView];
//    testView.backgroundColor = [UIColor orangeColor];
//    [UIView animateWithDuration:2
//                     animations:^{
//                         testView.frame = self.view.bounds;
//                     }completion:NULL];
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
        return CGSizeMake(184, 80);
    }else{
        return CGSizeMake(184, 52);
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
    alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                           message:@"Are you sure you want to delete this item?"
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

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)dataSetChange:(UISegmentedControl *)control
{    
    [_gmGridView reloadData];
}



@end
