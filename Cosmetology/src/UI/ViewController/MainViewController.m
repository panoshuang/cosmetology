//
//  MainViewController.m
//  Cosmetology
//
//  Created by mijie on 13-5-23.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainViewController.h"
#import "MainCatalogViewContrller.h"
#import "PasswordManagerViewController.h"
#import "PasswordManager.h"

@interface MainViewController ()<MainCatalogViewControllerDelegate>{
    MainCatalogViewContrller *_mainCatalogViewController;
    UIPopoverController *_popController;
    PasswordManagerViewController *_passwordManagerViewController;
    UIButton *_editBtn;
    UIButton *_editPasswordBtn;
    BOOL _bIsEdit;
}



@end

@implementation MainViewController


-(void)loadView{
    [super loadView];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,20,1024,768)];
    
    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;
    self.navigationController.navigationBarHidden = YES;
    
    _mainCatalogViewController = [[MainCatalogViewContrller alloc] init];
    _mainCatalogViewController.view.frame = CGRectMake(0, 0, 200, 748);
    _mainCatalogViewController.delegate = self;
    [self.view addSubview:_mainCatalogViewController.view];
    
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.backgroundColor = [UIColor redColor];
    _editBtn.frame = CGRectMake(1024 - 200, 0, 100, 50);
    [_editBtn addTarget:self action:@selector(editMainCatalog:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editBtn];

    _editPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editPasswordBtn.frame =  CGRectMake(1024 - 100, 0, 100, 50);
    _editPasswordBtn.backgroundColor = [UIColor redColor];
    [_editPasswordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [_editPasswordBtn addTarget:self action:@selector(showEditView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editPasswordBtn];
    
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
    _mainCatalogViewController.bIsEdit = _bIsEdit;
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

-(void)mainCatalogViewController:(MainCatalogViewContrller *)maiCatalogViewController didSelectCatalogID:(int)catalogID{
    
}

@end
