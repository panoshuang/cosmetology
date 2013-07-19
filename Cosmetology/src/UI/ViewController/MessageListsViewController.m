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

#define NUMBER_ITEMS_ON_LOAD 250
#define NUMBER_ITEMS_ON_LOAD2 30

#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController (privates methods)
//////////////////////////////////////////////////////////////

@interface MessageListsViewController ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
    __gm_weak NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    MessageBoardInfo *messageBoardInfo;
}

@end

@implementation MessageListsViewController

- (id)init
{
    if ((self =[super init]))
    {
        self.title = @"留言列表";
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
        [self.view addSubview:_toolBar];
        _toolBar.hidden = NO;
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = 875;
        
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addMoreItem)];
//        UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        space2.width = 10;
//        
//        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(removeItem)];
//        
//        UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        space3.width = 10;
//        
//        UIBarButtonItem *space4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        space4.width = 10;
//        
//        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshItem)];
        UIBarButtonItem *editMessageBtn = [[UIBarButtonItem alloc]initWithTitle:@"我也要留言" style:UIBarButtonItemStyleDone target:self action:@selector(toEditMessage:)];
        _toolBar.items = [NSArray arrayWithObjects:back,space,editMessageBtn,nil];
//        if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
//            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, space, removeButton, space2, refreshButton, nil];
//        }else {
//            self.navigationItem.leftBarButtonItem = addButton;
//        }
        
       
        
        
//        _data = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD; i ++)
//        {
//            [_data addObject:[NSString stringWithFormat:@"A %d", i]];
//        }
//        
//        _data2 = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD2; i ++)
//        {
//            [_data2 addObject:[NSString stringWithFormat:@"B %d", i]];
//        }
//
//        _currentData = _data;
        messageBoardInfo = [[MessageBoardInfo alloc]init];
        NSArray *messageBoardInfoArray = [[MessageBoardManager instance] allMessageBoardForSubProductID:2];
        _data = [[NSMutableArray alloc]init];
        for (int i = 0; i < [messageBoardInfoArray count]; i ++) {
            messageBoardInfo = [messageBoardInfoArray objectAtIndex:i];
            [_data addObject:messageBoardInfo.messageContent];

        }
        _currentData = _data;
        [_gmGridView reloadData];
        
    }
    
    return self;
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 15;
    
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
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:infoButton];
    
    UISegmentedControl *dataSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"DataSet 1", @"DataSet 2", nil]];
    [dataSegmentedControl sizeToFit];
    dataSegmentedControl.frame = CGRectMake(5,
                                            self.view.bounds.size.height - dataSegmentedControl.bounds.size.height - 5,
                                            dataSegmentedControl.bounds.size.width,
                                            dataSegmentedControl.bounds.size.height);
    dataSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    dataSegmentedControl.tintColor = [UIColor greenColor];
    dataSegmentedControl.selectedSegmentIndex = 0;
    [dataSegmentedControl addTarget:self action:@selector(dataSetChange:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:dataSegmentedControl];
    
    
    
//    OptionsViewController *optionsController = [[OptionsViewController alloc] init];
//    optionsController.gridView = gmGridView;
//    optionsController.contentSizeForViewInPopover = CGSizeMake(400, 500);
//    
//    _optionsNav = [[UINavigationController alloc] initWithRootViewController:optionsController];
//    
//    if (INTERFACE_IS_PHONE)
//    {
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(optionsDoneAction)];
//        optionsController.navigationItem.rightBarButtonItem = doneButton;
//    }
}

-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gmGridView.mainSuperView = self.navigationController.view;
    //[UIApplication sharedApplication].keyWindow.rootViewController.view;
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
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(170, 135);
        }
        else
        {
            return CGSizeMake(140, 110);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor redColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
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
    CheckMessageViewController *checkMessageViewController = [[CheckMessageViewController alloc]init];
    [self.navigationController pushViewController:checkMessageViewController animated:YES];
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
    if (buttonIndex == 1)
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
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
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(320, 210);
        }
        else
        {
            return CGSizeMake(300, 310);
        }
    }
    else
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


//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)addMoreItem
{
    // Example: adding object at the last position
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
    
    [_currentData addObject:newItem];
    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    // Example: removing last item
    if ([_currentData count] > 0)
    {
        NSInteger index = [_currentData count] - 1;
        
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_currentData count] > 0)
    {
        int index = [_currentData count] - 1;
        
        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
        
        [_currentData replaceObjectAtIndex:index withObject:newMessage];
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

//- (void)dataSetChange:(UISegmentedControl *)control
//{
//    _currentData = ([control selectedSegmentIndex] == 0) ? _data : _data2;
//    
//    [_gmGridView reloadData];
//}

-(void)toEditMessage:(UIButton *)btn
{
    EditMessageViewController *editMessageViewController = [[EditMessageViewController alloc]init];
    [self.navigationController pushViewController:editMessageViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
