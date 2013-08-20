//
//  EditSubProductViewController.m
//  Cosmetology
//
//  Created by mijie on 13-7-27.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "EditSubProductViewController.h"
#import "ResourceCache.h"
#import "CommonUtil.h"
#import "SubCatalogManager.h"

#define FONT_SIZE [UIFont systemFontOfSize:18]

@interface EditSubProductViewController (){
    UILabel *_lbName;
    UITextField *_tfName;
    UIButton *_btnPhoto;
    UIImageView *_ivPriview;
    UISwitch *_swEnable;
    UIPopoverController *_popController;
    UIImage *_imagePriview;
        BOOL _bIsProductEnable;
}

@end

@implementation EditSubProductViewController

@synthesize subProductInfo = _subProductInfo;
@synthesize delegate = _delegate;

-(id)initWithSubProductInfo:(SubProductInfo *)aProduct;
{
    self = [super init];
    if (self) {
        self.subProductInfo = aProduct;
    }
    return self;
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
    _tfName.text = _subProductInfo.name;
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
    CGRect swFrame = _swEnable.frame;
    swFrame.origin.x = lbEnableTips.frame.origin.x + lbEnableTips.frame.size.width + kCommonSpace;
    swFrame.origin.y = lbEnableTips.frame.origin.y;
    _swEnable.frame = swFrame;
    [_swEnable setOn:_subProductInfo.enable];
    [_swEnable addTarget:self action:@selector(enableProduct:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_swEnable];

    
    _btnPhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPhoto.frame = CGRectMake(_lbName.frame.origin.x,
                                 _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 ,
                                 120,
                                 30);
    [_btnPhoto setTitle:@"修改背景图片" forState:UIControlStateNormal];
    [_btnPhoto addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPhoto];
    
    UILabel *imgFrame = [[UILabel alloc]initWithFrame:CGRectMake(_lbName.frame.origin.x,
                                                                 _lbName.frame.origin.y + _lbName.frame.size.height + kCommonSpace *2 + 40,
                                                                 120,
                                                                 30)];
    imgFrame.text = @"尺寸:600*1000";
    [self.view addSubview:imgFrame];
    
    _ivPriview = [[UIImageView alloc] initWithFrame:CGRectMake(_btnPhoto.frame.origin.x + _btnPhoto.frame.size.width + 2 *kCommonSpace,
                                                               _btnPhoto.frame.origin.y,
                                                               500,
                                                               500 * (768/1024.0))];
    _ivPriview.image = [[ResourceCache instance] imageForCachePath:_subProductInfo.previewImageFilePath];
    [self.view addSubview:_ivPriview];

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
    _subProductInfo.enable = _swEnable.isOn;
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

-(void)save{

        if (_tfName.text.length == 0) {
            ALERT_MSG(@"名字不能为空",nil , @"确定");
            return;
        }else{
            _subProductInfo.name = _tfName.text;
        }
        if (_imagePriview != nil) {
            [[ResourceCache instance] deleteResourceForPath:_subProductInfo.previewImageFilePath];
            //保存类别预览图片
            NSString *previewUuid = [CommonUtil uuid];
            NSString *previewImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(_imagePriview, 0.8)
                                                                             relatePath:previewUuid
                                                                           resourceType:kResourceCacheTypeSubCatalogPreviewImage];
            
            if (previewImageFilePath.length == 0) {
                ALERT_MSG(@"保存失败", nil, @"确定");
                return;
            }
            _subProductInfo.previewImageFilePath = previewImageFilePath;
        }

        
        [[SubCatalogManager instance] updateSubCatalog:_subProductInfo];
        
        if ([_delegate respondsToSelector:@selector(editSubProductViewControllerDidSave:didUpdateCatalog:)]) {
            [_delegate editSubProductViewControllerDidSave:self didUpdateCatalog:_subProductInfo];
        }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)selectPreviewPhoto:(UIButton *)btn{
    [_popController dismissPopoverAnimated:NO];
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
    _ivPriview.image = image;
    _imagePriview = image;
    
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
