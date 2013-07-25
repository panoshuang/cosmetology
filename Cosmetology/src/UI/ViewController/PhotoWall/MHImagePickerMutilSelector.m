//
//  MHMutilImagePickerViewController.m
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import "MHImagePickerMutilSelector.h"
#import <QuartzCore/QuartzCore.h>

@interface MHImagePickerMutilSelector ()

@end

@implementation MHImagePickerMutilSelector

@synthesize imagePicker;
@synthesize delegate;
@synthesize limit;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        pics=[[NSMutableArray alloc] init];
        //[pics addObject:@""];
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        //if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
        //}
    }
    return self;
}

+(id)standardSelector
{
    return [[MHImagePickerMutilSelector alloc] init];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count>=2) {
        //NSLog(@"%@",viewController.view);
        for (UIView* ii in viewController.view.subviews) {
            // NSLog(@"%@",ii);
        }
        [[viewController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, 480-kTitleBarHeight)];
        
        selectedPan=[[UIView alloc] initWithFrame:CGRectMake(0, 440 - kTitleBarHeight,320, kTitleBarHeight)];
        UIImageView* imv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kTitleBarHeight)];
        [imv setImage:[UIImage imageNamed:@"chat_bottom_bg_black.png"]];
        [selectedPan addSubview:imv];
        [imv release];
        

        
        btn_done=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_done setFrame:CGRectMake(320 - kToolBtnSmallWidth- kCommonSpace, (kTitleBarHeight- kToolBtnSmallWidth)/2, kToolBtnSmallWidth, kToolBtnSmallWidth)];
        [btn_done setImage:[UIImage imageNamed:@"btn_gray_confirm_nomal.png"] forState:UIControlStateNormal];
        [btn_done setImage:[UIImage imageNamed:@"btn_gray_confirm_highted.png"] forState:UIControlStateHighlighted];

        [btn_done addTarget:self action:@selector(doneHandler) forControlEvents:UIControlEventTouchUpInside];

        [selectedPan addSubview:btn_done];
        
        
        tbv=[[UITableView alloc] initWithFrame:CGRectMake(0, kCommonSpace, kTitleBarHeight, 320 - kTitleBarHeight - 2* kCommonSpace) style:UITableViewStylePlain];
        tbv.backgroundColor = [UIColor blackColor];
        tbv.transform=CGAffineTransformMakeRotation(M_PI * -90 / 180);
        tbv.center=CGPointMake((320-btn_done.frame.size.width- kCommonSpace)/2, kTitleBarHeight/2);
        [tbv setRowHeight:kTitleBarHeight];
        [tbv setShowsVerticalScrollIndicator:NO];
        [tbv setPagingEnabled:YES];
        tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbv.separatorColor = [UIColor clearColor];
        
        tbv.dataSource=self;
        tbv.delegate=self;
        
        //[tbv setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        
        [tbv setBackgroundColor:[UIColor clearColor]];
        
        
        [tbv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [selectedPan addSubview:tbv];
        [tbv release];
        
        [viewController.view addSubview:selectedPan];
        [selectedPan release];
    }else{
        [pics removeAllObjects];
        
        
    }
}

-(void)doneHandler
{
    if (delegate && [delegate respondsToSelector:@selector(imagePickerMutilSelectorDidGetImages:)]) {
        [delegate performSelector:@selector(imagePickerMutilSelectorDidGetImages:) withObject:pics];
    }
    [self close];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pics.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger row=indexPath.row;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];

        
        UIView* rotateView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kTitleBarHeight - 5,  kTitleBarHeight - 5)];
        [rotateView setBackgroundColor:[UIColor clearColor]];
        rotateView.transform=CGAffineTransformMakeRotation(M_PI * 90 / 180);
        rotateView.center=CGPointMake(22, 22);
        [cell.contentView addSubview:rotateView];
        [rotateView release];
        
        UIImageView* imv=[[UIImageView alloc] initWithImage:[pics objectAtIndex:row]];
        [imv setFrame:CGRectMake(0, 0, kTitleBarHeight - 5, kTitleBarHeight - 5)];
        [imv setClipsToBounds:YES];
        [imv setContentMode:UIViewContentModeScaleAspectFill];
        
        [imv.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imv.layer setBorderWidth:2.0f];
        
        [rotateView addSubview:imv];
        [imv release];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePicHandler:)];
        [rotateView addGestureRecognizer:gestureRecognizer]  ;
        [gestureRecognizer release];
    }
    
    return cell;
}

-(void)deletePicHandler:(UITapGestureRecognizer*)gestureRecognizer
{
    [pics removeObjectAtIndex:gestureRecognizer.view.tag];
    [self updateTableView];
}

-(void)updateTableView
{
    [tbv reloadData];
    
//    if (pics.count>3) {
//        CGFloat offsetY=tbv.contentSize.height-tbv.frame.size.height-(320-90);
//        [tbv setContentOffset:CGPointMake(0, offsetY) animated:YES];
//    }else{
//        [tbv setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //[btn_addCover.imageView setImage:image forState:UIControlStateNormal];
    
    //[picker dismissModalViewControllerAnimated:YES];
    if (pics.count>=limit) {

        NSString *alertStr = [NSString stringWithFormat:@"最多能选择%d张图片",limit];
        ALERT_MSG(alertStr, nil, @"确定");
        return;
    }
    
    [pics addObject:image];
    if (pics.count == limit){
        btn_done.hidden = NO;
    }
    [self updateTableView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self close];
}

-(void)close
{
    [imagePicker dismissModalViewControllerAnimated:YES];
    [self release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc
{
    DDetailLog(@"1");
    [delegate release],delegate=nil;
    [pics release];
    [imagePicker release],imagePicker=nil;
    DDetailLog(@"2");
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
