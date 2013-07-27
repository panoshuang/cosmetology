//
//  SelectSubItemBtnBgViewController.m
//  Cosmetology
//
//  Created by mijie on 13-6-12.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "SelectSubItemBtnBgViewController.h"

@interface SelectSubItemBtnBgViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tvList;
    NSMutableArray *_imageArray;
}

@end

@implementation SelectSubItemBtnBgViewController

@synthesize delegate = _delegate;

-(id)init{
    self = [super init];
    if (self) {
        _imageArray = [[NSMutableArray alloc] init];
        [_imageArray addObject:@"btn_sub_item_0"];
        [_imageArray addObject:@"btn_sub_item_1"];
        [_imageArray addObject:@"btn_sub_item_2"];
        [_imageArray addObject:@"btn_sub_item_3"];
        [_imageArray addObject:@"btn_sub_item_4"];
        [_imageArray addObject:@"btn_sub_item_5"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(250, 500);
    _tvList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 500) style:UITableViewStylePlain];
    _tvList.dataSource = self;
    _tvList.delegate = self;
    [self.view addSubview:_tvList];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"SelectSubItemBtnBg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
        imageView.tag = 1000;
        [cell.contentView addSubview:imageView];
    }
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
    NSString *imageName = [_imageArray objectAtIndex:indexPath.row];
    imageView.image = [UIImage imageNamed:imageName];
    return cell;    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imageName = [_imageArray objectAtIndex:indexPath.row];
    EnumSubBtnColorType colorType;
    if (indexPath.row < 4) {
        colorType = kSubItemBtnColorGold;
    }else if(indexPath.row == 4){
        colorType = kSubItemBtnColorBlack;
    }else {
        colorType = kSubItemBtnColorWhite;
    }
    [_delegate selectSubItemBtnBgViewController:self didSelectImageName:imageName colorType:colorType];
}

@end
