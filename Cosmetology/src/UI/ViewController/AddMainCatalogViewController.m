//
//  AddMainCatalogViewController.m
//  Cosmetology
//  @文件描述: 添加主产品类别的viewController
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "AddMainCatalogViewController.h"
#import "SelectSubItemBtnBgViewController.h"
#import "CommonUtil.h"
#import "ResourceCache.h"
#import "MainProductInfo.h"
#import "MainCatalogManager.h"
#import "UIImageExtras.h"

#define FONT_SIZE [UIFont systemFontOfSize:18]

#define TAG_SELECT_BG_IMAGE  10000
#define TAG_SELECT_PREVIEW_IMAGE 10001

@interface AddMainCatalogViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectSubItemBtnBgViewControllerDelegate>{
    UILabel *_lbName;
    UITextField *_tfName;
    UISwitch *_swEnable;
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
    BOOL _bIsEdit;
    BOOL _bIsProductEnable;
    EnumSubBtnColorType _colorType;
}

@end

@implementation AddMainCatalogViewController {
@private

}

@synthesize delegate = _delegate;

@synthesize mainProductInfo = _mainProductInfo;

@synthesize bIsEdit = _bIsEdit;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _bIsProductEnable = YES;
        _bIsEdit = NO;
    }
    return self;
}

- (id)initWithProductInfo:(MainProductInfo *)aProductInfo {
    self = [super init];
    if (self) {
        self.mainProductInfo = aProductInfo;
        _bIsEdit = YES;
        _bIsProductEnable = _mainProductInfo.enable;
    }

    return self;
}

+ (id)controllerWithProductInfo:(MainProductInfo *)aProductInfo {
    return [[self alloc] initWithProductInfo:aProductInfo];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0xf9/(CGFloat)0xff
                                                green:0xf9/(CGFloat)0xff
                                                 blue:0xf9/(CGFloat)0xff
                                                alpha:1];
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
    _lbName.backgroundColor = [UIColor clearColor];
    _lbName.font = FONT_SIZE;
    
    [self.view addSubview:_lbName];
    
    _tfName = [[UITextField alloc] initWithFrame:CGRectMake(_lbName.frame.origin.x + _lbName.frame.size.width + kCommonSpace,
                                                            _lbName.frame.origin.y,
                                                            400,
                                                            _lbName.frame.size.height)];
    _tfName.borderStyle = UITextBorderStyleRoundedRect;
    _tfName.font = FONT_SIZE;
    [self.view addSubview:_tfName];

    UILabel *lbEnableTips = [[UILabel alloc] initWithFrame:CGRectMake(_tfName.frame.origin.x + _tfName.frame.size.width + kCommonSpace,
            _lbName.frame.origin.y,
            100,
            _lbName.frame.size.height)] ;
    lbEnableTips.text = @"启/禁产品";
    lbEnableTips.backgroundColor = [UIColor clearColor];
    lbEnableTips.font = FONT_SIZE;
    [self.view addSubview:lbEnableTips];

    _swEnable = [[UISwitch alloc] init];
    [_swEnable setOn:_bIsProductEnable];
    CGRect swFrame = _swEnable.frame;
    swFrame.origin.x = lbEnableTips.frame.origin.x + lbEnableTips.frame.size.width + kCommonSpace;
    swFrame.origin.y = lbEnableTips.frame.origin.y;
    _swEnable.frame = swFrame;
    [_swEnable addTarget:self action:@selector(enableProduct:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_swEnable];

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
    
    UILabel *imgFrame = [[UILabel alloc]initWithFrame:CGRectMake(_btnBgPhoto.frame.origin.x + 130,
                                                                _btnBgPhoto.frame.origin.y,
                                                                150,
                                                                 30)];
    imgFrame.text = @"尺寸:2048*1536";
    imgFrame.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imgFrame];
    
    _btnPreview = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPreview.frame = CGRectMake(_ivBg.frame.origin.x + _ivBg.frame.size.width + kCommonSpaceBig * 2 + 50,
                                   _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                   120,
                                   30);
    [_btnPreview setTitle:@"添加预览图片" forState:UIControlStateNormal];
    [_btnPreview addTarget:self action:@selector(selectPreviewPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPreview];
    
    UILabel *preViewImgFrame = [[UILabel alloc]initWithFrame:CGRectMake(_ivBg.frame.origin.x + _ivBg.frame.size.width + kCommonSpaceBig * 2 + 180,
                                                                 _btnBgPhoto.frame.origin.y,
                                                                 150,
                                                                 30)];
    preViewImgFrame.text = @"尺寸:600*1060";
    preViewImgFrame.backgroundColor = [UIColor clearColor];
    [self.view addSubview:preViewImgFrame];
    
    _ivPreview = [[UIImageView alloc] initWithFrame:CGRectMake(_btnPreview.frame.origin.x,
                                                          _btnPreview.frame.origin.y + _btnPreview.frame.size.height + kCommonSpace,
                                                          200,
                                                          200)];
    [self.view addSubview:_ivPreview];
    
    _btnSubItemBtnBg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSubItemBtnBg.frame = CGRectMake(_ivPreview.frame.origin.x + _ivPreview.frame.size.width + kCommonSpaceBig * 2 + 30,
                                   _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                   120,
                                   30);
    [_btnSubItemBtnBg setTitle:@"添加按钮图片" forState:UIControlStateNormal];
    [_btnSubItemBtnBg addTarget:self action:@selector(selectSubItemBgPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSubItemBtnBg];
    
    _ivSubItemBtnBg = [[UIImageView alloc] initWithFrame:CGRectMake(_btnSubItemBtnBg.frame.origin.x,
                                                          _btnSubItemBtnBg.frame.origin.y + _btnSubItemBtnBg.frame.size.height + kCommonSpaceBig,
                                                          200,
                                                          200)];
    _ivSubItemBtnBg.contentMode = UIViewContentModeLeft;
    [self.view addSubview:_ivSubItemBtnBg];

    if(_bIsEdit){
        _tfName.text = _mainProductInfo.name;
        _ivBg.image = [[ResourceCache instance] imageForCachePath:_mainProductInfo.bgImageFile];
        _ivPreview.image = [[ResourceCache instance]imageForCachePath:_mainProductInfo.previewImageFile];
        _ivSubItemBtnBg.image = [UIImage imageNamed:_mainProductInfo.subItemBtnImageName];
        [_swEnable setOn:_mainProductInfo.enable animated:NO];
    }
    
    
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

-(void)enableProduct:(UISwitch *)sw{
    _bIsProductEnable = _swEnable.isOn;
}

-(void)save{
    //判断是否是编辑模式
    if(!_bIsEdit){
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
        NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(_imageBg, 1)
                                                         relatePath:bgUuid
                                                       resourceType:kResourceCacheTypeBackgroundImage];

        if (bgImageFilePath.length == 0) {
            ALERT_MSG(@"保存失败", nil, @"确定");
            return;
        }

        //保存类别预览图片
        NSString *previewUuid = [CommonUtil uuid];
        NSString *previewImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(_imagePriview, 1)
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
        _mainProductInfo.colorType = _colorType;
        //获取合适index
        int index = [[MainCatalogManager instance] indexForNewCatalog];
        _mainProductInfo.index = index;
        [[MainCatalogManager instance] addMainCatalog:_mainProductInfo];
        _mainProductInfo.productID = [[MainCatalogManager instance] lastMainProductInfo].productID;

        if ([_delegate respondsToSelector:@selector(addMainCatalogViewController:didAddCatalog:)]) {
            [_delegate addMainCatalogViewController:self didAddCatalog:_mainProductInfo];
        }
    }else{
        if (_tfName.text.length == 0) {
            ALERT_MSG(@"名字不能为空",nil , @"确定");
            return;
        }else{
            _mainProductInfo.name = _tfName.text;
        }
        if (_imageBg != nil) {
            //替换背景图片
            [[ResourceCache instance] deleteResourceForPath:_mainProductInfo.bgImageFile];
            //生成图片的uuid,保存到缓存
            NSString *bgUuid = [CommonUtil uuid];
            NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(_imageBg, 1)
                                                             relatePath:bgUuid
                                                           resourceType:kResourceCacheTypeBackgroundImage];

            if (bgImageFilePath.length == 0) {
                ALERT_MSG(@"保存失败", nil, @"确定");
                return;
            }
            _mainProductInfo.bgImageFile = bgImageFilePath;

        }
        if (_imagePriview != nil) {
            [[ResourceCache instance] deleteResourceForPath:_mainProductInfo.previewImageFile];
            //保存类别预览图片
            NSString *previewUuid = [CommonUtil uuid];
            NSString *previewImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(_imagePriview, 1)
                                                                  relatePath:previewUuid
                                                                resourceType:kResourceCacheTypeMainCatalogPreviewImage];

            if (previewImageFilePath.length == 0) {
                ALERT_MSG(@"保存失败", nil, @"确定");
                return;
            }
            _mainProductInfo.previewImageFile = previewImageFilePath;
        }
        if (_imageSubItemBtnBg != nil) {
            _mainProductInfo.subItemBtnImageName = _strSubItemBtnBgName;
        }
        _mainProductInfo.enable = _bIsProductEnable;
        [[MainCatalogManager instance] updateMainCatalog:_mainProductInfo];

        if ([_delegate respondsToSelector:@selector(addMainCatalogViewController:didUpdateCatalog:)]) {
            [_delegate addMainCatalogViewController:self didUpdateCatalog:_mainProductInfo];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectPhoto:(UIButton *)btn{
    [_tfName resignFirstResponder];
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
    [_tfName resignFirstResponder];
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
    [_tfName resignFirstResponder];
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
    return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
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

-(void)selectSubItemBtnBgViewController:(SelectSubItemBtnBgViewController *)controller didSelectImageName:(NSString *)imageName colorType:(EnumSubBtnColorType)colorType{
    DDetailLog(@"imageName : %@",imageName);
    [_popController dismissPopoverAnimated:YES];
    _ivSubItemBtnBg.image = [UIImage imageNamed:imageName];
    _imageSubItemBtnBg = [UIImage imageNamed:imageName];
    _strSubItemBtnBgName = imageName;
    _colorType = colorType;
}

@end
