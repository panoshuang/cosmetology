//
//  MainViewController.m
//  Cosmetology
//
//  Created by mijie on 13-5-23.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainViewController.h"
#import "SubCatalogViewController.h"
#import "PasswordManagerViewController.h"
#import "PasswordManager.h"
#import "iCarousel.h"
#import "MainProductInfo.h"
#import "MainCatalogItem.h"
#import "GMGridView.h"
#import "AddMainCatalogViewController.h"
#import "MainCatalogManager.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "ExperienceViewController.h"
#import "MessageListsViewController.h"
#import "AutoDismissView.h"
#import "CommonUtil.h"
#import "ResourceCache.h"

@interface MainViewController ()<SubCatalogViewControllerDelegate,iCarouselDataSource,
        iCarouselDelegate,AddMainCatalogViewControllerDelegate, ExperienceViewControllerDelegate,
        UIImagePickerControllerDelegate>{
    UIImageView *_bgView;
    SubCatalogViewController *_subCatalogViewController;
    UIPopoverController *_popController;
    PasswordManagerViewController *_passwordManagerViewController;
    ExperienceViewController *_experienceViewController;
    UIToolbar *_toolBar;
    iCarousel *_catalogCarousel;
    UITapGestureRecognizer *_editGesture; //开启编辑的手势
    BOOL _bIsEdit;
    BOOL _bIsWrap;
    NSMutableArray *_catalogArray;
    
    
}



@end

@implementation MainViewController

//@synthesize item;

-(id)init{
    self = [super init];
    if (self) {
        //注册背景的userDefaults的值
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
        NSMutableDictionary *defaultDic = [NSMutableDictionary dictionary] ;
        [defaultDic setObject:@"" forKey:HOME_PAGE_BACKGROUND_IMAGE_FILE_PATH];
        [userDefaults registerDefaults:defaultDic];
        
        _bIsWrap = YES;
        _catalogArray = [[NSMutableArray alloc] initWithCapacity:10];
        [_catalogArray addObjectsFromArray:[[MainCatalogManager instance] allEnableProductInfo]];
        
        
        
    }
    return self;
}




-(void)loadView{
    [super loadView];
    self.navigationController.navigationBarHidden = YES;
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
    
    
    _catalogCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, kToolBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kToolBarHeight)];
    _catalogCarousel.delegate = self;
    _catalogCarousel.dataSource = self;
    _catalogCarousel.type = iCarouselTypeCoverFlow2;
    [self.view addSubview:_catalogCarousel];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:_toolBar];
    _toolBar.hidden = YES;
    
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100,
                                                                0,
                                                                100,
                                                                kToolBarHeight)];
    editView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:editView];
    _editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureDidTap:)];
    _editGesture.numberOfTapsRequired = 3;
    [editView addGestureRecognizer:_editGesture];
    
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(deleteCurCatalog)];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(addCatalog)];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"修改"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(editMainCatalog)];


    UIBarButtonItem *pwdItem = [[UIBarButtonItem alloc] initWithTitle:@"修改密码"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(showEditView:)];
    
    UIBarButtonItem *editBgItem = [[UIBarButtonItem alloc] initWithTitle:@"修改背景"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(showEditBgView:)];
    
    UIBarButtonItem *exitEditItem = [[UIBarButtonItem alloc] initWithTitle:@"退出编辑"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(cancelEdit)];
    
   _toolBar.items = [NSArray arrayWithObjects:deleteItem,addItem,editItem,pwdItem,editBgItem,exitEditItem,nil];
    
    
    _passwordManagerViewController = [[PasswordManagerViewController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editMainCatalog{
    MainProductInfo *curProduct = [_catalogArray objectAtIndex:_catalogCarousel.currentItemIndex];
    AddMainCatalogViewController *addMainCatalogViewController = [[AddMainCatalogViewController alloc] initWithProductInfo:curProduct];
    addMainCatalogViewController.bIsEdit = YES;
    addMainCatalogViewController.delegate = self;
    [self.navigationController pushViewController:addMainCatalogViewController animated:YES];
}

-(void)addCatalog{
    DDetailLog(@"");
    AddMainCatalogViewController *addMainCatalogViewController = [[AddMainCatalogViewController alloc] init];
    addMainCatalogViewController.delegate = self;
    [self.navigationController pushViewController:addMainCatalogViewController animated:YES];
    
}

-(void)deleteCurCatalog{
    DDetailLog(@"");
    //判断是否是超值体验项目,超值体验项目不能删除的
    if([_catalogCarousel currentItemIndex] == _catalogArray.count - 1){
        ALERT_MSG(@"不能删除超值体验项目", nil, @"确定");
    }else{
        RIButtonItem *confirmItem = [RIButtonItem item];
        confirmItem.label = @"确定";
        confirmItem.action = ^{
            int index = [_catalogCarousel currentItemIndex];
            MainProductInfo *productInfo = [_catalogArray objectAtIndex:index];
            //删除数据库中的分类
            [[MainCatalogManager instance] deleteMainCatalogForId:productInfo.productID];
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
}

-(void)showEditView:(UIBarButtonItem *)sender{
    if(![_popController isPopoverVisible])
    {
        if (!_popController)
        {
            _popController = nil;
        }
        UINavigationController *passwordNavigationController = [[UINavigationController alloc] initWithRootViewController:_passwordManagerViewController];
        passwordNavigationController.contentSizeForViewInPopover = CGSizeMake(300, 400);
        _popController = [[UIPopoverController alloc] initWithContentViewController:passwordNavigationController];

        UIView *itemView = [sender valueForKey:@"view"];
        [_popController presentPopoverFromRect:itemView.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    }
    else
    {
        [_popController dismissPopoverAnimated:YES];
    }
}

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

-(void)editGestureDidTap:(UITapGestureRecognizer *)gesture{
    if (_bIsEdit) {
        [self cancelEdit];
    }else{
        //判断是否已经设置了密码,没有的话直接进入编辑模式,有的话要输入密码
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_MAIN_CATALOG];
        if (editPwdStr.length > 0) {
            [self inputPassword];
        }else{
            _bIsEdit = YES;
            _toolBar.hidden = NO;
        }
    }
}

-(void)cancelEdit{
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        _bIsEdit = NO;
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

-(void)mainPushViewController:(UIViewController *)viewController animated:(BOOL)animate{
    [self.navigationController pushViewController:viewController animated:animate];
}

#pragma mark - SubCatalogViewControllerDelegate

-(void)subCatalogViewController:(SubCatalogViewController *)maiCatalogViewController didSelectCatalogID:(int)catalogID{
    
}

#pragma mark  - ExperienceViewControllerDelegate
-(void)experienceViewController:(ExperienceViewController *)experienceViewController didSelectSubCatalog:(SubProductInfo *)subProductInfo{

}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_catalogArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        
        view = [[MainCatalogItem alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 300.0f)];
        view.backgroundColor = [UIColor blueColor];
        ((MainCatalogItem *)view).ivBg.image = [UIImage imageNamed:@"test.png"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    MainProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    label.text = productInfo.name;
    
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 400.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
//        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0f];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 4.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _catalogCarousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return _bIsWrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (_catalogCarousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    DDetailLog(@"");
    //显示二级项目
    //检查是否是超值体验项目
    MainProductInfo *productInfo = [_catalogArray objectAtIndex:index];
    UIViewController *viewController = nil;
    if(index == _catalogArray.count - 1){
        _experienceViewController = [[ExperienceViewController alloc] init];
        _experienceViewController.delegate = self;
        _experienceViewController.mainDelegate = self;
        viewController = _experienceViewController;


    }else{
        _subCatalogViewController = [[SubCatalogViewController alloc] initWithMainProductInfo:productInfo];
        _subCatalogViewController.delegate = self;
        _subCatalogViewController.mainDelegate = self;
        viewController = _subCatalogViewController;
    }

    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
    viewController.view.alpha = 0;
    viewController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [UIView animateWithDuration:.5
                     animations:^{
                         viewController.view.alpha = 1;
                     }completion:^(BOOL complete){
                          
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:bgImageFilePath forKey:HOME_PAGE_BACKGROUND_IMAGE_FILE_PATH];        
        _bgView.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }

}

#pragma mark - AddMainCatalogViewControllerDelegate
-(void)addMainCatalogViewController:(AddMainCatalogViewController *)addMainCatalogViewController didAddCatalog:(MainProductInfo *)mainProductInfo{
    int count = _catalogArray.count;
    int index = 0;
    if (count <= 1) {
        index = 0;
    }else{
        index = count - 2;
    }
    [_catalogArray insertObject:mainProductInfo atIndex:index];
    [_catalogCarousel insertItemAtIndex:index animated:YES];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}



-(void)addMainCatalogViewController:(AddMainCatalogViewController *)addMainCatalogViewController didUpdateCatalog:(MainProductInfo *)mainProductInfo;
{
   int index = [_catalogArray indexOfObject:mainProductInfo];
    if(index != NSNotFound){
        [_catalogCarousel reloadItemAtIndex:index animated:YES];
    }
}


@end
