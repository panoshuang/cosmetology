//
// Created by mijie on 13-6-17.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "PriceViewController.h"
#import "RIButtonItem.h"
#import "PasswordManager.h"
#import "UIAlertView+Blocks.h"
#import <QuartzCore/QuartzCore.h>
#import "AutoDismissView.h"
#import "ResourceCache.h"
#import "CommonUtil.h"
#import "SubCatalogManager.h"
#import "SubProductInfo.h"
#import "MessageListsViewController.h"
#import "MainViewController.h"
#import "MessageListsViewController.h"


@implementation PriceViewController {
    UIPopoverController *_popController;
    UIView *_editTapView ;
    UITapGestureRecognizer *_editGesture; //开启编辑的手势
    
    UIToolbar *_editToolbar;
    SubProductInfo *_subProductInfo;

}

@synthesize ivPrice = _ivPrice;
@synthesize bIsEdit = _bIsEdit;
@synthesize subProductID = _subProductID;

- (id)initWithSubProductID:(int)aSubProductID {
    self = [super init];
    if (self) {
        self.subProductID = aSubProductID;
        _subProductInfo = [[SubCatalogManager instance] subProductInfoForProductID:_subProductID];
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
    
    _editToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kToolBarHeight)];
    if (_bIsEdit) {
        _editToolbar.hidden = NO;
    }else{
        _editToolbar.hidden = YES;
    }
    [self.view addSubview:_editToolbar];
    UIBarButtonItem *editBgItem = [[UIBarButtonItem alloc] initWithTitle:@"修改报价"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(editBg:)];
    UIBarButtonItem *cancelEditItem = [[UIBarButtonItem alloc] initWithTitle:@"取消编辑"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(cancelEdit)];
    _editToolbar.items = [NSArray arrayWithObjects:editBgItem, cancelEditItem,nil];
    _editTapView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100,
                                                            0,
                                                            100,
                                                            kToolBarHeight)];
    _editTapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editTapView];
    _editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureDidTap:)];
    _editGesture.numberOfTapsRequired = 3;
    [_editTapView addGestureRecognizer:_editGesture];
    
    //留言簿按钮
    UIButton *editMessageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editMessageBtn.frame = CGRectMake(250, 705, 180, 67);
    [editMessageBtn setBackgroundImage:[UIImage imageNamed:@"bgMessageListBtn@2x.png"] forState:UIControlStateNormal];
    [editMessageBtn addTarget:self action:@selector(goToMessageList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editMessageBtn];
    
    //主菜单按钮
    UIButton *mainMeunBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mainMeunBtn.frame = CGRectMake(500, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [mainMeunBtn setBackgroundImage:[UIImage imageNamed:@"bgMainMeun.png"] forState:UIControlStateNormal];
    [mainMeunBtn addTarget:self action:@selector(goToMainMeun:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainMeunBtn];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(700, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)goToMessageList:(UIButton *)btn{
    MessageListsViewController *messageListsViewController = [[MessageListsViewController alloc]init];
    [self.navigationController pushViewController:messageListsViewController animated:YES];
}

-(void)goToMainMeun:(UIButton *)btn{
    MainViewController *mainViewController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
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
            _editToolbar.hidden = NO;
        }
    }
}

-(void)cancelEdit{
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        self.bIsEdit = NO;
        _editToolbar.hidden = YES;
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
            _editToolbar.hidden = NO;
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
                                                                  resourceType:kResourceCacheTypePriceImage];
        _subProductInfo.priceImageFilePath = bgImageFilePath;
        [[SubCatalogManager instance] updateSubCatalog:_subProductInfo];
        _ivPrice.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }    
}


SHOULD_AUTOROTATA_TO_INTERFACE_ORIENTATION_LANDSCAPE

@end