//
//  MainViewController.m
//  Cosmetology
//
//  Created by mijie on 13-5-23.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    UITableView *listView;
}

@end

@implementation MainViewController

-(void)loadView{
    [super loadView];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor redColor];
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

@end
