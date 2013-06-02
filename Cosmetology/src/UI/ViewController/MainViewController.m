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

@interface MainViewController (){
    MainCatalogViewContrller *_mainCatalogViewController;
    UIPopoverController *_popoverController;
    PasswordManagerViewController *_passwordManagerViewController;
    UIButton *_editBtn;
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
    [self.view addSubview:_mainCatalogViewController.view];
    
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _editBtn.frame = CGRectMake(1024 - 100, 0, 100, 50);
    [_editBtn addTarget:self action:@selector(showEditView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editBtn];
    
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

-(void)showEditView:(UIButton *)sender{
    if(![_popoverController isPopoverVisible])
    {
        if (!_popoverController)
        {
            _popoverController = [[UIPopoverController alloc] initWithContentViewController:_passwordManagerViewController];
        }

        [_popoverController presentPopoverFromRect:_editBtn.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
    }
    else
    {
        [_popoverController dismissPopoverAnimated:YES];
    }
}

@end
