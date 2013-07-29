//
//  PasswordManagerViewController.m
//  Cosmetology
//
//  Created by mijie on 13-6-2.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "PasswordManagerViewController.h"
#import "PasswordEditViewController.h"

@interface PasswordManagerViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tvList;
    NSArray *_titleArray;
}

@end

@implementation PasswordManagerViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _titleArray = [[NSArray alloc] initWithObjects:@"主页密码",
                       @"产品子项目密码",
                       @"留言密码",nil];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.contentSizeForViewInPopover = CGSizeMake(200, 400);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tvList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tvList.dataSource = self;
    _tvList.delegate = self;
    [self.view addSubview:_tvList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifyStr = @"passwordManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifyStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifyStr];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EnumPasswordType passwordType;
    switch (indexPath.row) {
        case 0:
            passwordType = kPasswordTypeHome;
            break;
        case 1:
            passwordType = kPasswordTypeSubProduct;
            break;
        case 2:
            passwordType = kPasswordTypeMsg;
            break;
        default:
            break;
    }
    PasswordEditViewController *editPasswordViewController = [[PasswordEditViewController alloc] initWithPasswordType:passwordType];
    [self.navigationController pushViewController:editPasswordViewController animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
