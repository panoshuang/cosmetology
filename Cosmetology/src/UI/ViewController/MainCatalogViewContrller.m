//
//  MainCatalogViewContrller.m
//  Cosmetology
//
//  Created by mijie on 13-6-2.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainCatalogViewContrller.h"
#import <QuartzCore/QuartzCore.h>
#import "MainProductInfo.h"
#import "GMGridView.h"
#import "CustomGridViewCell.h"

#define ITEM_SPACE 15

@interface MainCatalogViewContrller () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_catalogArray;
    NSInteger _lastDeleteItemIndexAsked;
}

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)dataSetChange:(UISegmentedControl *)control;

@end


@implementation MainCatalogViewContrller

-(id)init{
    self = [super init];
    if (self) {
        _catalogArray = [[NSMutableArray alloc] init];
        [self loadCatalog];
    }
    return self;
}

-(void)loadCatalog{
    for (int i = 0; i < 20; i++) {
        MainProductInfo *productInfo = [[MainProductInfo alloc] init];
        productInfo.name = [NSString stringWithFormat:@"productInfo%i",i];
        [_catalogArray addObject:productInfo];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, 200, 748);
    
    NSInteger spacing = ITEM_SPACE;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
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
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_catalogArray count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{

   return CGSizeMake(170, 110);

}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    CustomGridViewCell *cell = (CustomGridViewCell *)[gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[CustomGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        //        view.backgroundColor = [UIColor redColor];
        //        view.layer.masksToBounds = NO;
        //        view.layer.cornerRadius = 8;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        btn.titleLabel.textColor = [UIColor redColor];
       
        [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.contentView = btn;
        [cell setEditing:YES animated:NO];
    }
    MainProductInfo *productInfo = [_catalogArray objectAtIndex:index];
//    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIButton *contentBtn = (UIButton *)cell.contentView;
     [contentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    contentBtn.backgroundColor = [UIColor greenColor];
    [contentBtn setTitle:productInfo.name forState:UIControlStateNormal];
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
    
    
    
    return cell;
}

-(void)test:(UIButton *)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"touch"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles: nil];
    [alertView show];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [_catalogArray removeObjectAtIndex:_lastDeleteItemIndexAsked];
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
