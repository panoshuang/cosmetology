//
// Created by mijie on 13-6-17.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "PriceViewController.h"


@implementation PriceViewController {

}

@synthesize ivPrice = _ivPrice;
@synthesize bIsEdit = _bIsEdit;
@synthesize subProductID = _subProductID;

- (id)initWithSubProductID:(int)aSubProductID {
    self = [super init];
    if (self) {
        self.subProductID = aSubProductID;
    }

    return self;
}

+ (id)controllerWithSubProductID:(int)aSubProductID {
    return [[self alloc] initWithSubProductID:aSubProductID];
}

-(void)loadView {
    [super loadView];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];

    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;

}

-(void)viewDidLoad {
    [super viewDidLoad];

    _ivPrice = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _ivPrice.image = [UIImage imageNamed:@"bg_experience.jpg"];
    _ivPrice.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_ivPrice];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
            self.view.bounds.size.height - 44,
            self.view.bounds.size.width,
            44)];

    UIBarButtonItem *backToMainViewItem = [[UIBarButtonItem alloc] initWithTitle:@"主菜单"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(backToMainItemClicked:)];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(backItemClicked:)];
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithTitle:@"留言榜"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(msgItemClicked:)];
    toolbar.items = [NSArray arrayWithObjects:backToMainViewItem,backItem,msgItem, nil];
    [self.view addSubview:toolbar];

}

-(void)backToMainItemClicked:(UIBarButtonItem *)item{

}

-(void)backItemClicked:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)msgItemClicked:(UIBarButtonItem *)item{

}

SHOULD_AUTOROTATA_TO_INTERFACE_ORIENTATION_LANDSCAPE

@end