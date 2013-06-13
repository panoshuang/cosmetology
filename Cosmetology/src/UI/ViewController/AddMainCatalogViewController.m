//
//  AddMainCatalogViewController.m
//  Cosmetology
//  @文件描述: 添加主产品类别的viewController
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "AddMainCatalogViewController.h"
#import "SelectSubItemBtnBgViewController.h"
#import "CommonUtil.h"
#import "ResourceCache.h"
#import "MainProductInfo.h"
#import "MainCatalogManager.h"

#define TAG_SELECT_BG_IMAGE  10000
#define TAG_SELECT_PREVIEW_IMAGE 10001

@interface AddMainCatalogViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectSubItemBtnBgViewControllerDelegate>{
    UILabel *_lbName;
    UITextField *_tfName;
    UIButton *_btnBgPhoto;
    UIImageView *_ivBg;
    UIButton *_btnPreview; //选择预览图按钮
    UIImageView *_ivPreview;
    UIButton *_btnSubItemBtnBg; //子项目按钮背景图片
    UIImageView *_ivSubItemBtnBg;
    UIPopoverController *_popController;
    UIImage *_imageBg;
    UIImage *_imagePriview;
    UIImage *_imageSubItemBtnBg;
    NSString *_strSubItemBtnBgName;
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
    
    _btnBgPhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnBgPhoto.frame = CGRectMake(_lbName.frame.origin.x,
                                 _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                 120,
                                 30);
    [_btnBgPhoto setTitle:@"添加背景图片" forState:UIControlStateNormal];
    [_btnBgPhoto addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBgPhoto];
    
    _ivBg = [[UIImageView alloc] initWithFrame:CGRectMake(_btnBgPhoto.frame.origin.x,
                                                               _btnBgPhoto.frame.origin.y + _btnBgPhoto.frame.size.height + kCommonSpace,
                                                               200,
                                                               200)];
    [self.view addSubview:_ivBg];
    
    _btnPreview = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPreview.frame = CGRectMake(_ivBg.frame.origin.x + _ivBg.frame.size.width + kCommonSpace * 2,
                                   _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                   120,
                                   30);
    [_btnPreview setTitle:@"添加预览图片" forState:UIControlStateNormal];
    [_btnPreview addTarget:self action:@selector(selectPreviewPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPreview];
    
    _ivPreview = [[UIImageView alloc] initWithFrame:CGRectMake(_btnPreview.frame.origin.x,
                                                          _btnPreview.frame.origin.y + _btnPreview.frame.size.height + kCommonSpace,
                                                          200,
                                                          200)];
    [self.view addSubview:_ivPreview];
    
    _btnSubItemBtnBg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSubItemBtnBg.frame = CGRectMake(_ivPreview.frame.origin.x + _ivPreview.frame.size.width + kCommonSpace * 2,
                                   _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                   120,
                                   30);
    [_btnSubItemBtnBg setTitle:@"添加背景图片" forState:UIControlStateNormal];
    [_btnSubItemBtnBg addTarget:self action:@selector(selectSubItemBgPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSubItemBtnBg];
    
    _ivSubItemBtnBg = [[UIImageView alloc] initWithFrame:CGRectMake(_btnSubItemBtnBg.frame.origin.x,
                                                          _btnSubItemBtnBg.frame.origin.y + _btnSubItemBtnBg.frame.size.height + kCommonSpace,
                                                          200,
                                                          200)];
    [self.view addSubview:_ivSubItemBtnBg];
    
    
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
    if (_imageBg == nil) {
        ALERT_MSG(@"背景图片不能为空", nil, @"确定");
        return;
    }
    if (_imagePriview == nil) {
        ALERT_MSG(@"预览图片不能为空", nil, @"确定");
        return;
    }
    if (_imageSubItemBtnBg == nil) {
        ALERT_MSG(@"子项目按钮图片不能为空", nil, @"确定");
        return;
    }
    //生成图片的uuid,保存到缓存
    NSString *bgUuid = [CommonUtil uuid];
    NSString *bgImageFilePath =[ResourceCache saveResouceData:UIImageJPEGRepresentation(_imageBg, 1)
                                                   relatePath:bgUuid
                                                 resourceType:kResourceCacheTypeBackgroundImage];
    
    if (bgImageFilePath.length == 0) {
        ALERT_MSG(@"保存失败", nil, @"确定");
        return;
    }
    
    //保存类别预览图片
    NSString *previewUuid = [CommonUtil uuid];
    NSString *previewImageFilePath =[ResourceCache saveResouceData:UIImageJPEGRepresentation(_imagePriview, 1)
                                                   relatePath:previewUuid
                                                 resourceType:kResourceCacheTypeMainCatalogPreviewImage];
    
    if (previewImageFilePath.length == 0) {
        ALERT_MSG(@"保存失败", nil, @"确定");
        return;
    }
    
    _mainProductInfo = [[MainProductInfo alloc] init];
    _mainProductInfo.name = _tfName.text;
    _mainProductInfo.enable = YES;
    _mainProductInfo.bgImageFile = bgImageFilePath;
    _mainProductInfo.previewImageFile = previewImageFilePath;
    _mainProductInfo.subItemBtnImageName = _strSubItemBtnBgName;
    //获取合适index
    int index = [[MainCatalogManager instance] indexForNewCatalog];
    _mainProductInfo.index = index;
    [[MainCatalogManager instance] addMainCatalog:_mainProductInfo];
    _mainProductInfo.productID = [[MainCatalogManager instance] lastMainProductInfo].productID;
    
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
    controller.view.tag = TAG_SELECT_BG_IMAGE;
    _popController=[[UIPopoverController alloc] initWithContentViewController:controller];
    [_popController presentPopoverFromRect:_btnBgPhoto.frame inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                  animated:YES];
}

-(void)selectPreviewPhoto:(UIButton *)btn{
    [_popController dismissPopoverAnimated:NO];
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
	controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	controller.allowsEditing = NO;
	controller.delegate = self;
    controller.view.tag = TAG_SELECT_PREVIEW_IMAGE;
    _popController=[[UIPopoverController alloc] initWithContentViewController:controller];
    [_popController presentPopoverFromRect:_btnPreview.frame inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                  animated:YES];
}


-(void)selectSubItemBgPhoto:(UIButton *)btn{
    [_popController dismissPopoverAnimated:NO];
    SelectSubItemBtnBgViewController *controller = [[SelectSubItemBtnBgViewController alloc] init];
    controller.delegate = self;
    _popController=[[UIPopoverController alloc] initWithContentViewController:controller];
    [_popController presentPopoverFromRect:_btnSubItemBtnBg.frame inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                  animated:YES];
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

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [_popController dismissPopoverAnimated:YES];
    if (picker.view.tag == TAG_SELECT_BG_IMAGE) {
        _ivBg.image = image;
        _imageBg= image;
    }else{
        _ivPreview.image = image;
        _imagePriview = image;
    }

}

#pragma mark - SelectSubItemBtnBgViewControllerDelegate

-(void)selectSubItemBtnBgViewController:(SelectSubItemBtnBgViewController *)controller didSelectImageName:(NSString *)imageName{
    DDetailLog(@"imageName : %@",imageName);
    [_popController dismissPopoverAnimated:YES];
    _ivSubItemBtnBg.image = [UIImage imageNamed:imageName];
    _imageSubItemBtnBg = [UIImage imageNamed:imageName];
    _strSubItemBtnBgName = imageName;
}

@end
