//
//  AddSubCatalogViewController.m
//  Cosmetology
//  @文件描述：添加子产品类别的ViewController
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "AddSubCatalogViewController.h"
#import "SubProductInfo.h"
#import "SubCatalogManager.h"
#import "ResourceCache.h"
#import "CommonUtil.h"


@interface AddSubCatalogViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel *_lbName;
    UITextField *_tfName;
    UIButton *_btnPhoto;
    UIImageView *_ivPriview;
    UIPopoverController *_popController;
    UIImage *_imagePriview;
    SubProductInfo *_subProductInfo;
}

@end

@implementation AddSubCatalogViewController

@synthesize delegate = _delegate;


@synthesize mainCatalogId = _mainCatalogId;

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithMainCatalogId:(int)aMainCatalogId {
    self = [super init];
    if (self) {
        self.mainCatalogId = aMainCatalogId;
    }

    return self;
}

+ (id)controllerWithMainCatalogId:(int)aMainCatalogId {
    return [[self alloc] initWithMainCatalogId:aMainCatalogId];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
    self.view = mainView;
    self.view.backgroundColor = [UIColor colorWithRed:0xf9/(CGFloat)0xff
                                                green:0xf9/(CGFloat)0xff
                                                 blue:0xf9/(CGFloat)0xff
                                                alpha:1];
    self.navigationController.navigationBarHidden =NO;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleDone
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
    _lbName.font = kFontSystemSize18;
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
    
    UILabel *imgFrame = [[UILabel alloc]initWithFrame:CGRectMake(_lbName.frame.origin.x,
                                                                 _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 + 40,
                                                                 120,
                                                                 30)];
    imgFrame.text = @"尺寸:600*1000";
    imgFrame.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imgFrame];

    
    _ivPriview = [[UIImageView alloc] initWithFrame:CGRectMake(_btnPhoto.frame.origin.x + _btnPhoto.frame.size.width + 2 *kCommonSpace,
                                                               _btnPhoto.frame.origin.y,
                                                               500,
                                                               500 * (768/1024.0))];
    [self.view addSubview:_ivPriview];
    
       

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save
{
    if (_tfName.text.length == 0) {
        ALERT_MSG(@"名字不能为空", nil, @"确定");
        return;
    }

    _subProductInfo = [[SubProductInfo alloc] init];
    _subProductInfo.mainProductID = self.mainCatalogId;
    _subProductInfo.name = _tfName.text;
    int index = [SubCatalogManager instance].indexForNewCatalog;
    _subProductInfo.index = index;
    _subProductInfo.enable = YES;
    if (_imagePriview != nil) {
        //保存类别预览图片
        NSString *previewUuid = [CommonUtil uuid];
        NSString *previewImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(_imagePriview, 1)
                                                                         relatePath:previewUuid
                                                                       resourceType:kResourceCacheTypeSubCatalogPreviewImage];
        
        if (previewImageFilePath.length == 0) {
            ALERT_MSG(@"保存失败", nil, @"确定");
            return;
        }
        _subProductInfo.previewImageFilePath = previewImageFilePath;
    }
     _subProductInfo.productID = [[SubCatalogManager instance] addSubCatalog:_subProductInfo];

    if ([_delegate respondsToSelector:@selector(addSubCatalogViewController:didSaveCatalog:)]) {
        [_delegate addSubCatalogViewController:self didSaveCatalog:_subProductInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectPhoto:(UIButton *)btn{
    [_tfName resignFirstResponder];
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
