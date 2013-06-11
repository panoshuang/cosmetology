//
//  MainViewController.m
//  Cosmetology
//
//  Created by mijie on 13-5-23.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainViewController.h"
#import "SubCatalogViewContrller.h"
#import "PasswordManagerViewController.h"
#import "PasswordManager.h"
#import "iCarousel.h"
#import "MainProductInfo.h"
#import "MainCatalogItem.h"
#import "GMGridView.h"
#import "AddMainCatalogViewController.h"

@interface MainViewController ()<SubCatalogViewControllerDelegate,iCarouselDataSource, iCarouselDelegate>{
    SubCatalogViewContrller *_subCatalogViewController;
    UIPopoverController *_popController;
    PasswordManagerViewController *_passwordManagerViewController;
    iCarousel *_catalogCarousel;
    UIButton *_deleteBtn;
    UIButton *_editBtn;
    UIButton *_editPasswordBtn;
    BOOL _bIsEdit;
    BOOL _bIsWrap;
    NSMutableArray *_catalogArray;
}



@end

@implementation MainViewController

-(id)init{
    self = [super init];
    if (self) {
        _bIsWrap = YES;
        _catalogArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i = 0; i < 10; i++) {
            MainProductInfo *productInfo = [[MainProductInfo alloc] init];
            productInfo.name = [NSString stringWithFormat:@"productInfo%i",i];
            productInfo.enable = YES;
            [_catalogArray addObject:productInfo];
        }
    }
    return self;
}


-(void)loadView{
    [super loadView];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,20,1024,768)];
    
    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;
    self.navigationController.navigationBarHidden = YES;
    
    _catalogCarousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _catalogCarousel.delegate = self;
    _catalogCarousel.dataSource = self;
    _catalogCarousel.type = iCarouselTypeCoverFlow2;
    [self.view addSubview:_catalogCarousel];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:toolBar];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.backgroundColor = [UIColor redColor];
    _deleteBtn.frame = CGRectMake(0, 0, 100, 50);
    [_deleteBtn addTarget:self action:@selector(deleteCurCatalog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] init];
    deleteItem.customView = _deleteBtn;
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"添加" forState:UIControlStateNormal];
    _editBtn.backgroundColor = [UIColor redColor];
    _editBtn.frame = CGRectMake(0, 0, 100, 50);
    [_editBtn addTarget:self action:@selector(addCatalog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    editItem.customView = _editBtn;
    
    

    _editPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editPasswordBtn.frame =  CGRectMake(0, 0, 100, 50);
    _editPasswordBtn.backgroundColor = [UIColor redColor];
    [_editPasswordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [_editPasswordBtn addTarget:self action:@selector(showEditView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pwdItem = [[UIBarButtonItem alloc] init];
    pwdItem.customView = _editPasswordBtn;
    
    toolBar.items = [NSArray arrayWithObjects:deleteItem,editItem,pwdItem,nil];
    
    
    _passwordManagerViewController = [[PasswordManagerViewController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editMainCatalog:(UIButton *)sender{
    _bIsEdit = !_bIsEdit;
    _subCatalogViewController.bIsEdit = _bIsEdit;
}

-(void)addCatalog{
    DDetailLog(@"");
    AddMainCatalogViewController *addMainCatalogViewController = [[AddMainCatalogViewController alloc] init];
    [self.navigationController pushViewController:addMainCatalogViewController animated:YES];
    
}

-(void)deleteCurCatalog{
    DDetailLog(@"");
    int index = [_catalogCarousel currentItemIndex];
    [_catalogArray removeObjectAtIndex:index];
    [_catalogCarousel removeItemAtIndex:index animated:YES];
}

-(void)showEditView:(UIButton *)sender{
    if(![_popController isPopoverVisible])
    {
        if (!_popController)
        {
        _popController = [[UIPopoverController alloc] initWithContentViewController:_passwordManagerViewController];
        }

        [_popController presentPopoverFromRect:_editBtn.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    }
    else
    {
        [_popController dismissPopoverAnimated:YES];
    }
}

-(void)mainPushViewController:(UIViewController *)viewController animated:(BOOL)animate{
    [self.navigationController pushViewController:viewController animated:animate];
}

#pragma mark - MainCatalogViewControllerDelegate

-(void)subCatalogViewController:(SubCatalogViewContrller *)maiCatalogViewController didSelectCatalogID:(int)catalogID{
    
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
        
        view = [[MainCatalogItem alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 600.0f)];
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
    _subCatalogViewController = [[SubCatalogViewContrller alloc] init];
    _subCatalogViewController.view.frame = self.view.bounds;
    _subCatalogViewController.delegate = self;
    _subCatalogViewController.mainDelegate = self;
    [self.view addSubview:_subCatalogViewController.view];
    _subCatalogViewController.view.alpha = 0;
    _subCatalogViewController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [UIView animateWithDuration:.5
                     animations:^{
                         _subCatalogViewController.view.alpha = 1;
                     }completion:^(BOOL complete){
                          
                     }];
}

@end
