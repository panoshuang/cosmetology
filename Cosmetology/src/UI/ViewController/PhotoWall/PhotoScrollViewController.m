//
//  PhotoScrollViewController.m
//  homi
//   @：照片滑动预览
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "AdPhotoInfo.h"
#import "PhotoBrowserDataSource.h"
#import "UIColor+Extra.h"
#import "MHImagePickerMutilSelector.h"
#import "CommonUtil.h"
#import "ResourceCache.h"
#import "AdPhotoManager.h"
#import "PriceViewController.h"


#define BTN_LIKE_TAG   1001
#define BTN_COMMENT_TAG 1002
#define BTN_REPORT_TAG  1003
#define BTN_DEL_TAG     1004
#define ALERT_VIEW_DEL_TAG 1005


static BOOL isProsecutingPhoto = NO;


@interface PhotoScrollViewController ()

@end


@implementation PhotoScrollViewController

@synthesize delegate = _delegate;


- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index
{
    self = [super initWithDataSource:dataSource andStartWithPhotoAtIndex:index];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{

}


- (void)loadView
{
    [super loadView];

    //把navigatorController的delegate设置为自己,用于在显示本页面时候设置全屏
    // self.navigationController.delegate = self;

    NSMutableArray         *buttonArray = [NSMutableArray array];

    // 设置标题栏
    self.titleBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, kPhotoBrowerTitleBarHight);
    [self.titleBar.btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    // 设置底部工具栏
    self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - kPhotoBrowerToolBarHight, self.view.bounds.size.width, kPhotoBrowerToolBarHight);
    if (_bIsEdit)
    {
        UIButton *priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_nomal.png"] forState:UIControlStateNormal];
        [priceButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_highted.png"] forState:UIControlStateHighlighted];
        [priceButton addTarget:self action:@selector(priceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        priceButton.tag       = BTN_COMMENT_TAG;
        [buttonArray addObject:priceButton];

        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_nomal.png"] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_highted.png"] forState:UIControlStateHighlighted];
        [commentButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        commentButton.tag       = BTN_COMMENT_TAG;
        [buttonArray addObject:commentButton];

        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [delButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_nomal.png"] forState:UIControlStateNormal];
        [delButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_highted.png"] forState:UIControlStateHighlighted];
        [delButton addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        delButton.tag = BTN_DEL_TAG;
        [buttonArray addObject:delButton];
    }
    else
    {
        self.toolbar.hidden = YES;
//        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [likeButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_like_nomal.png"] forState:UIControlStateNormal];
//        [likeButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_like_highted.png"] forState:UIControlStateHighlighted];
//        [likeButton addTarget:self action:@selector(likePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        likeButton.tag = BTN_LIKE_TAG;
//        [buttonArray addObject:likeButton];
//
//        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_comment_nomal.png"] forState:UIControlStateNormal];
//        [commentButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_comment_highted.png"] forState:UIControlStateHighlighted];
//        [commentButton addTarget:self action:@selector(commentPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        commentButton.tag = BTN_COMMENT_TAG;
//        [buttonArray addObject:commentButton];
//
//        UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [reportButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_nomal.png"] forState:UIControlStateNormal];
//        [reportButton setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_del_highted.png"] forState:UIControlStateHighlighted];
//        [reportButton addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        reportButton.tag = BTN_REPORT_TAG;
//        [buttonArray addObject:reportButton];
    }

    self.toolbar.buttonArray = buttonArray;
    [self showChrome];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad
{
    DDetailLog(@"viewDidLoad:%@", self);
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)showIncrementTipsView{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likePhotoBtnClick:(UIButton *)button
{
//    PhotoBrowserDataSource *dataSource = (PhotoBrowserDataSource *)dataSource_;
//    PhotoInfo              *photoInfo  = [[dataSource photoList] objectAtIndex:currentIndex_];
//    if (!photoInfo.isLike){
//        photoInfo.isLike = YES;
//        photoInfo.numOfLike += 1;
//        [self showIncrementTipsView];
//        [[ScreenWaitingView shareScreenWaitingView] updateMessage:@"喜欢该照片..."];
//        [[PhotoAlbumManager instance] likePhotoInfo:photoInfo];
//    }
}

- (void)commentPhotoBtnClick:(UIButton *)button
{

}

- (void)reportBtnClick:(UIButton *)sender
{

}

-(void)addBtnClicked:(UIButton *)sender{

    if(![_popController isPopoverVisible])
    {
        MHImagePickerMutilSelector *imagePickerMutilSelector = [MHImagePickerMutilSelector standardSelector];//自动释放
        imagePickerMutilSelector.delegate = self;//设置代理
        imagePickerMutilSelector.limit = NSIntegerMax;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.contentSizeForViewInPopover = CGSizeMake(320, 480);
        picker.delegate = imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
        [picker setAllowsEditing:NO];
        picker.sourceType                    = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle          = UIModalTransitionStyleCoverVertical;
        picker.navigationController.delegate = imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector

        imagePickerMutilSelector.imagePicker = picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
        if (!_popController)
        {
            _popController = [[UIPopoverController alloc] initWithContentViewController:picker];
        }

        [_popController presentPopoverFromRect:[sender convertRect:sender.bounds toView:self.view]
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                      animated:YES];
    }
    else
    {
        [_popController dismissPopoverAnimated:YES];
    }
}

- (void)deleteBtnClicked:(UIButton *)sender
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除该照片？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    alertView.tag = ALERT_VIEW_DEL_TAG;
//    [alertView show];

    //TODO: 此处该成查看留言列表
}

-(void)priceBtnClicked:(UIButton *)btn{
    PriceViewController *priceViewController = [[PriceViewController alloc] initWithSubProductID:_subProductID];
    [self.navigationController pushViewController:priceViewController animated:YES];
}


#pragma mark - MHImagePickerMutilSelectorDelegate

-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArr {
    for(UIImage *image in imageArr){
        //生成图片的uuid,保存到缓存
        NSString *bgUuid = [CommonUtil uuid];
        NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 1)
                                                                    relatePath:bgUuid
                                                                  resourceType:kResourceCacheTypeAdImage];

        if (bgImageFilePath.length == 0) {
            ALERT_MSG(@"保存失败", nil, @"确定");
            return;
        }
        AdPhotoInfo *adPhotoInfo = [[AdPhotoInfo alloc] init];
        adPhotoInfo.imageFilePath = bgImageFilePath;
        adPhotoInfo.subProductId = _subProductID;
        int index = [[AdPhotoManager instance] indexForNewPhoto];
        adPhotoInfo.index = index;
        int photoId = [[AdPhotoManager instance] addAdPhoto:adPhotoInfo];
        if(photoId == NSNotFound){
            ALERT_MSG(@"保存失败", nil, @"确定");
            return;
        }else{
            adPhotoInfo.photoId = photoId;
            PhotoBrowserDataSource *dataSource = (PhotoBrowserDataSource *)dataSource_;
            [dataSource.photoList addObject:adPhotoInfo];
            [photoViews_ addObject:[NSNull null]];
        }
    }
    photoCount_ += imageArr.count;
    [self setScrollViewContentSize];
    [self setCurrentIndex:currentIndex_];
    [_popController dismissPopoverAnimated:YES];
}

@end
