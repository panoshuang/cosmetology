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
#import "iCarousel.h"

#define NUMBER_OF_VISIBLE_ITEMS 50
#define ITEM_SPACING 400.0f
#define INCLUDE_PLACEHOLDERS YES

@interface ExperienceViewController()<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,
iCarouselDelegate>
{
    UIPopoverController *_popController;
    UIImageView *_ivBg;
    UIToolbar *_toolbar;
    iCarousel *_catalogCarousel;
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
    UIImage *image = [[ResourceCache instance] imageForCachePath:self.experienceInfo.bgImageFile];
    if (image) {
        _ivBg.image = image;
    }else{
        _ivBg.image = [UIImage imageNamed:@"bg_exp_product"];
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


    _catalogCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, kToolBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kToolBarHeight)];
    _catalogCarousel.delegate = self;
    _catalogCarousel.dataSource = self;
    _catalogCarousel.type = iCarouselTypeRotary;
//    _catalogCarousel.scrollSpeed = 50;
//    _catalogCarousel.decelerationRate = 10;
    [self.view addSubview:_catalogCarousel];
}

-(void)addSubCatalogItem
{
    DDetailLog(@"");
    AddSubCatalogViewController *addSubCatalogViewController = [[AddSubCatalogViewController alloc] initWithMainCatalogId:_experienceInfo.productID];
    addSubCatalogViewController.delegate = self;
    [_mainDelegate mainPushViewController:addSubCatalogViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)setBIsEdit:(BOOL)bIsEdit {
    _bIsEdit = bIsEdit;
}

-(void)onBgTap:(UITapGestureRecognizer *)gesture{

    [UIView animateWithDuration:2 animations:^{
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0;
    }completion:^(BOOL complete){
        [self.view removeFromSuperview];
    }];
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


#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]];
        view.frame = CGRectMake(0, 0, 300, 500);
        view.backgroundColor = [UIColor redColor];
	}

	
    //set label
	
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed on some carousels if wrapping is disabled
	return  0;
}

//- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
//{
//	UILabel *label = nil;
//	
//	//create new view if no view is available for recycling
//	if (view == nil)
//	{
//		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]];
//		label = [[UILabel alloc] initWithFrame:view.bounds];
//		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = UITextAlignmentCenter;
//		label.font = [label.font fontWithSize:50.0f];
//		[view addSubview:label];
//	}
//	else
//	{
//		label = [[view subviews] lastObject];
//	}
//	
//    //set label
//	label.text = (index == 0)? @"[": @"]";
//	
//	return view;
//}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

//- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
//{
//	//set opacity based on distance from camera
//    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
//}
//
//- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//    //implement 'flip3D' style carousel
//    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
//    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
//}

//- (BOOL)carouselShouldWrap:(iCarousel *)carousel
//{
//    return NO;
//}







@end