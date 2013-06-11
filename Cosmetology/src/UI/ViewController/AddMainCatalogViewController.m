//
//  AddMainCatalogViewController.m
//  Cosmetology
//  @文件描述: 添加主产品类别的viewController
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "AddMainCatalogViewController.h"

@interface AddMainCatalogViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UILabel *_lbName;
    UITextField *_tfName;
    UIButton *_btnPhoto;
    UIImageView *_ivPriview;
    UIPopoverController *_popController;
    UIImage *_imagePriview;
    MainProductInfo *_mainProductInfo;
}

@end

@implementation AddMainCatalogViewController

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectMake(kCommonSpace * 2, kCommonSpace, 100, 30)];
    _lbName.text = @"产品名字: ";
    [self.view addSubview:_lbName];
    
    _tfName = [[UITextField alloc] initWithFrame:CGRectMake(_lbName.frame.origin.x + _lbName.frame.size.width + kCommonSpace,
                                                            _lbName.frame.origin.y,
                                                            400,
                                                            _lbName.frame.size.height)];
    _tfName.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_tfName];
    
    _btnPhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPhoto.frame = CGRectMake(_lbName.frame.origin.x,
                                 _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                 120,
                                 30);
    [_btnPhoto setTitle:@"添加背景图片" forState:UIControlStateNormal];
    [_btnPhoto addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPhoto];
    
    _ivPriview = [[UIImageView alloc] initWithFrame:CGRectMake(_tfName.frame.origin.x,
                                                               _btnPhoto.frame.origin.y,
                                                               500,
                                                               500)];
    [self.view addSubview:_ivPriview];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    if (_tfName.text.length == 0) {
        ALERT_MSG(@"名字不能为空",nil , @"确定");
        return;
    }
    if (_imagePriview == nil) {
        ALERT_MSG(@"图片不能为空", nil, @"确定");
        return;
    }
    //TODO: 插入到数据库中    
    if ([_delegate respondsToSelector:@selector(addMainCatalogViewController:didSaveCatalog:)]) {
        [_delegate addMainCatalogViewController:self didSaveCatalog:_mainProductInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectPhoto:(UIButton *)btn{
	UIImagePickerController *controller = [[UIImagePickerController alloc] init];
	controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	controller.allowsEditing = NO;
	controller.delegate = self;
    _popController=[[UIPopoverController alloc] initWithContentViewController:controller];
    [_popController presentPopoverFromRect:_btnPhoto.frame inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                  animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [_popController dismissPopoverAnimated:YES];
    //TODO:生成图片名字,保存到图片文件中
    _ivPriview.image = image;
    _imagePriview = image;
}

@end
