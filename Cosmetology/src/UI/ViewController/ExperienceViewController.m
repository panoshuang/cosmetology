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
#import "FXLabel.h"
#import "MainCatalogItem.h"
#import "EditSubProductViewController.h"

#define NUMBER_OF_VISIBLE_ITEMS 10
#define ITEM_SPACING 500.0f
#define INCLUDE_PLACEHOLDERS YES

@interface ExperienceViewController()<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,iCarouselDataSource,
iCarouselDelegate,EditSubProductViewControllerDelegate>
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

    _ivBg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *image = [[ResourceCache instance] imageForCachePath:self.experienceInfo.bgImageFile];
    if (image) {
        _ivBg.image = image;
    }else{
        _ivBg.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
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
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(deleteCurCatalog)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"修改"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(editCatalog)];
    UIBarButtonItem *editBgItem = [[UIBarButtonItem alloc] initWithTitle:@"修改背景"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(editBg:)];
    UIBarButtonItem *exitEditItem = [[UIBarButtonItem alloc] initWithTitle:@"退出编辑"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(cancelEdit)];
    _toolbar.items = [NSArray arrayWithObjects:addItem,deleteItem,editItem,editBgItem,exitEditItem, nil];
    
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
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake((1024 - 120)/2, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)addSubCatalogItem
{
    DDetailLog(@"");
    AddSubCatalogViewController *addSubCatalogViewController = [[AddSubCatalogViewController alloc] initWithMainCatalogId:_experienceInfo.productID];
    addSubCatalogViewController.delegate = self;
    [_mainDelegate mainPushViewController:addSubCatalogViewController animated:YES];
}

-(void)deleteCurCatalog{
    DDetailLog(@"");

        RIButtonItem *confirmItem = [RIButtonItem item];
        confirmItem.label = @"确定";
        confirmItem.action = ^{
            int index = [_catalogCarousel currentItemIndex];
            SubProductInfo *productInfo = [_catalogArray objectAtIndex:index];
            //删除数据库中的分类
            [[SubCatalogManager instance] deleteSubCatalogForId:productInfo.productID];
            [_catalogArray removeObjectAtIndex:index];
            [_catalogCarousel removeItemAtIndex:index animated:YES];
        }   ;
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = @"取消";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除当前的项目?"
                                                            message:nil
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:confirmItem, nil];
        [alertView show];
}

-(void)editCatalog{
    SubProductInfo *curProduct = [_catalogArray objectAtIndex:_catalogCarousel.currentItemIndex];
    EditSubProductViewController *editCatalogViewController = [[EditSubProductViewController alloc] initWithSubProductInfo:curProduct];
    editCatalogViewController.delegate = self;
    [_mainDelegate mainPushViewController:editCatalogViewController animated:YES];
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
    [_catalogArray removeAllObjects];
    [self loadCatalog];
    [_catalogCarousel reloadData];
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

-(void)back:(UIButton *)btn{
    [UIView animateWithDuration:.5 animations:^{
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0;
    }completion:^(BOOL complete){
        [self.view removeFromSuperview];
    }];
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
        _experienceInfo.bgImageFile = bgImageFilePath;
        [[MainCatalogManager instance] updateMainCatalog:_experienceInfo];
        _ivBg.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }
}


#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _catalogArray.count;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    FXLabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        
        view = [[MainCatalogItem alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 500.0f)];
//        view.backgroundColor = [UIColor blueColor];
        //((MainCatalogItem *)view).ivBg.image = [UIImage imageNamed:@"test2.jpg"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        label = [[FXLabel alloc] initWithFrame:CGRectMake(0, -55, 300.0f, 50.0f)];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeZero;
        label.shadowBlur = 20.0f;
        label.innerShadowColor = [UIColor yellowColor];
        label.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
        label.gradientStartColor = [UIColor redColor];
        label.gradientEndColor = [UIColor yellowColor];
        label.gradientStartPoint = CGPointMake(0.0f, 0.5f);
        label.gradientEndPoint = CGPointMake(1.0f, 0.5f);
        label.oversampling = 2;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (FXLabel *)[view viewWithTag:1];
    }
    
    SubProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    label.text = productInfo.name;
    //获取背景图片填充
    
    UIImage *bgImage = [[ResourceCache instance] imageForCachePath:productInfo.previewImageFilePath];
    if (bgImage == nil) {
        ((MainCatalogItem *)view).ivBg.image = [UIImage imageNamed:@"test2.jpg"];
    }
    else{
        ((MainCatalogItem *)view).ivBg.image = bgImage;
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

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    SubProductInfo *subProductInfo = [_catalogArray objectAtIndex:index];
    
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

#pragma mark - AddSubCatalogViewControllerDelegate

-(void)addSubCatalogViewController:(AddSubCatalogViewController *)addSubCatalogViewController didSaveCatalog:(SubProductInfo *)subProductInfo{
    [_catalogArray addObject:subProductInfo];
    [_catalogCarousel insertItemAtIndex:_catalogArray.count - 1 animated:YES];
}

#pragma mark - EditSubProductViewControllerDelegate 

-(void)editSubProductViewControllerDidSave:(EditSubProductViewController *)editSubProductViewController didUpdateCatalog:(SubProductInfo *)subProduct{
    int index = [_catalogArray indexOfObject:subProduct];
    if(index != NSNotFound){
        [_catalogCarousel reloadItemAtIndex:index animated:YES];
    }
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









@end