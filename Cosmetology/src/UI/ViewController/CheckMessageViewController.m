//
//  CheckMessageViewController.m
//  MessageBoard
//
//  Created by mijie on 13-6-16.
//  Copyright (c) 2013年 mijie. All rights reserved.
//

#import "CheckMessageViewController.h"
#import "MessageBoardInfo.h"
#import "MessageBoardManager.h"
#import "AcclaimButton.h"
#import "ResourceCache.h"
#import "EditMessageViewController.h"
#import "AutoDismissView.h"
#import "RIButtonItem.h"
#import "PasswordManager.h"
#import "UIAlertView+Blocks.h"
#import "CommonUtil.h"
#import "VoiceHandle.h"
#import "MessageListsViewController.h"
#import "FileUtil.h"

@interface CheckMessageViewController ()
{
    
    UIImageView *headPortraits;//头像
    UITextView *messageTextView;//留言展示
    UIButton *playRecord;//播放录音
    UIImageView *singeName;//签名
    NSString *popularityValue;
    UIImageView *_bgView;//背景图片
    
    AcclaimButton *popularityBtn;//人气
    MessageBoardInfo *_messageBoardInfo;
    
    UIPopoverController *_popController;
    UIView *_editTapView;
    UITapGestureRecognizer *_editGesture; //开启编辑的手势
    BOOL _bIsEdit;
    UIButton *editBgBtn;//修改背景
    UIButton *deleMessage;//删除留言
    
    VoiceHandle *_voiceHandle;
}

@end

@implementation CheckMessageViewController

@synthesize messageBoardInfo = _messageBoardInfo;
@synthesize bIsEdit = _bIsEdit;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)loadView
{
    [super loadView];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
    
    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;
    _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //获取背景图片填充
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *bgFilePath = [userDefaults stringForKey:HOME_PAGE_BACKGROUND_IMAGE_FILE_PATH];
    UIImage *bgImage = [[ResourceCache instance] imageForCachePath:bgFilePath];
    if (bgImage) {
        _bgView.image = bgImage;
    }
    _bgView.image = [UIImage imageNamed:@"bgCheckMessage.jpg"];
    [self.view addSubview:_bgView];
    
    //修改背景
    editBgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editBgBtn.frame = CGRectMake(50, 705, 180, 67);
    if (_bIsEdit) {
        editBgBtn.hidden = NO;
    }else{
        editBgBtn.hidden = YES;
    }
    [editBgBtn setBackgroundImage:[UIImage imageNamed:@"editBgBtn.png"] forState:UIControlStateNormal];
    [editBgBtn addTarget:self action:@selector(showEditBgView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBgBtn];
    
    //删除留言
    deleMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleMessage.frame = CGRectMake(800, 705, 180, 67);
    if (_bIsEdit) {
        deleMessage.hidden = NO;
    }else{
        deleMessage.hidden = YES;
    }
    [deleMessage setBackgroundImage:[UIImage imageNamed:@"deleMessage"] forState:UIControlStateNormal];
    [deleMessage addTarget:self action:@selector(deleMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleMessage];
    
    //点击三次,启动编辑功能
    _editTapView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100,
                                                            0,
                                                            100,
                                                            kToolBarHeight)];
    _editTapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editTapView];
    _editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureDidTap:)];
    _editGesture.numberOfTapsRequired = 3;
    [_editTapView addGestureRecognizer:_editGesture];
    
    //我也要留言按钮
    UIButton *editMessageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editMessageBtn.frame = CGRectMake(329, 705, 180, 67);
    [editMessageBtn setBackgroundImage:[UIImage imageNamed:@"editMessage.png"] forState:UIControlStateNormal];
    [editMessageBtn addTarget:self action:@selector(toEditMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editMessageBtn];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(625, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //显示头像
    UIImage *protraitImage = [[ResourceCache instance] imageForCachePath:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:_messageBoardInfo.headPortraits]];
    if (!protraitImage) {
        protraitImage  = [UIImage imageNamed:@"pickPhoto.png"];
    }
    headPortraits = [[UIImageView alloc]initWithFrame:CGRectMake(40, 410, 220, 160)];
    headPortraits.image = protraitImage;
    headPortraits.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:headPortraits];
    
    UIFont *font = [UIFont fontWithName:@"Courier-Oblique" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(380, 55, 130, 30)];
    messagelabel.text = @"我的留言:";
    messagelabel.backgroundColor = [UIColor clearColor];
    [messagelabel setFont:font];
    
    messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(80, 85, 710, 220)];
    messageTextView.editable = NO;
    messageTextView.text = _messageBoardInfo.messageContent;
    messageTextView.contentMode = UIViewContentModeScaleToFill;
    messageTextView.backgroundColor = [UIColor clearColor];
    [messageTextView setFont:font];
    
    UIImageView *messageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(93, 18, 869, 372)];
    messageImageView.image = [UIImage imageNamed:@"messageBoard.png"];
    messageImageView.userInteractionEnabled = YES;
    [messageImageView addSubview:messagelabel];
    [messageImageView addSubview:messageTextView];
    
    //显示签名
    UIImage *singeNameImage = [[ResourceCache instance] imageForCachePath:_messageBoardInfo.singeName];
    if (!singeNameImage) {
        singeNameImage  = [UIImage imageNamed:@"singe.png"];
    }
    singeName = [[UIImageView alloc]initWithImage:singeNameImage];
    singeName.frame = CGRectMake(374, 369, 497, 302);
    [self.view addSubview:singeName];
    [self.view addSubview:messageImageView];
    
    //录音图标
    UIImageView *recordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 440, 115, 178)];
    recordImageView.image = [UIImage imageNamed:@"recordImage.png"];
    [self.view addSubview:recordImageView];
    
    //播放录音
    playRecord= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(260, 600, 89, 89);
    //[playRecord setTitle:@"播放留言" forState:UIControlStateNormal];
    [playRecord setBackgroundImage:[UIImage imageNamed:@"listenRecord.png"] forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    
    
    //赞人气
    popularityBtn = [[AcclaimButton alloc]initWithFrame:CGRectMake(50, 580, 153, 71)];
    popularityBtn.ivBg.image = [UIImage imageNamed:@"bgacclaim.png"];
    //[popularityBtn setBackgroundColor:[UIColor redColor]];
    //[popularityBtn setIvBg:[UIImage imageNamed:@"popularity.png"]];
    [popularityBtn addTarget:self action:@selector(onAcclaimClick:) forControlEvents:UIControlEventTouchUpInside];
    [popularityBtn.lbCount setText:[NSString stringWithFormat:@"%d",_messageBoardInfo.popularity]];
    [self.view addSubview:popularityBtn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
        
}

-(void)toEditMessageBtn:(UIButton *)btn{
    EditMessageViewController *editMessageViewController = [[EditMessageViewController alloc]init];
    editMessageViewController.delegate = (id<MessageBoardViewControllerDelegate>)(self.delegate);
    editMessageViewController.bIsEdit = _bIsEdit;
    [self.navigationController pushViewController:editMessageViewController animated:YES];
}
-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)playRecord:(UIButton *)btn
{
    if (_voiceHandle == nil){
        _voiceHandle = [[VoiceHandle alloc] init];
//        _voiceHandle.delegate = self;
    }
    if (_messageBoardInfo.messageRecord.length == 0) {
        [[AutoDismissView instance] showInView:self.view title:@"没有录音" duration:1];
        return;
    }
    [_voiceHandle playVoice:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:_messageBoardInfo.messageRecord]];
}

-(void)onAcclaimClick:(AcclaimButton *)btn{
    _messageBoardInfo.popularity += 1;
    [[MessageBoardManager instance] updateMessageBoard:_messageBoardInfo];
    [popularityBtn.lbCount setText:[NSString stringWithFormat:@"%d",_messageBoardInfo.popularity]];
    [self showIncrementTipsView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHECK_MSG_ACCLAIM object:_messageBoardInfo];
}

-(void)showIncrementTipsView{
    UILabel *incrementTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100)/2, self.view.bounds.size.height - kBottomBarHeight - 100, 100, 100)];
    incrementTipsLabel.backgroundColor = [UIColor clearColor];
    incrementTipsLabel.text = @"+1";
    incrementTipsLabel.font = [UIFont boldSystemFontOfSize:40];
    incrementTipsLabel.textColor = [UIColor colorWithRed:0xff/255. green:0x2e/255. blue:0x55/255. alpha:1];
    incrementTipsLabel.textAlignment = NSTextAlignmentCenter;
    incrementTipsLabel.shadowOffset = CGSizeMake(5, 5);
    incrementTipsLabel.alpha = 0;
    [self.view addSubview:incrementTipsLabel];
    
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = incrementTipsLabel.frame;
        frame.origin.y = (self.view.bounds.size.height - 100)/2;
        incrementTipsLabel.frame = frame;
        incrementTipsLabel.alpha = 1;
    } completion:^(BOOL complete){
        [incrementTipsLabel removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////
#pragma mark 启动编辑功能
//////////////////////////////////////////////////////////////

-(void)editGestureDidTap:(UITapGestureRecognizer *)gesture{
    if (_bIsEdit) {
        [self cancelEdit];
        editBgBtn.hidden = YES;
        deleMessage.hidden = YES;
    }else{
        //判断是否已经设置了密码,没有的话直接进入编辑模式,有的话要输入密码
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_MAIN_CATALOG];
        if (editPwdStr.length > 0) {
            [self inputPassword];
        }else{
            self.bIsEdit = YES;
            editBgBtn.hidden = NO;
            deleMessage.hidden = NO;
        }
    }
}

-(void)cancelEdit{
    RIButtonItem *confirmItem = [RIButtonItem item];
    confirmItem.label = @"确定";
    confirmItem.action = ^{
        self.bIsEdit = NO;
        
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    cancelItem.action = ^{
        editBgBtn.hidden = NO;
        deleMessage.hidden = NO;
    };
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
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_MAIN_CATALOG];
        if([editPwdStr isEqualToString:textField.text]){
            _bIsEdit = YES;
            editBgBtn.hidden = NO;
            deleMessage.hidden = NO;
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


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [_popController dismissPopoverAnimated:YES];
    if (image) {
        //生成图片的uuid,保存到缓存
        NSString *bgUuid = [CommonUtil uuid];
        NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 0.8)
                                                                    relatePath:bgUuid
                                                                  resourceType:kResourceCacheTypeBackgroundImage];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:bgImageFilePath forKey:MSG_PAGE_BACKGROUND_IMAGE_FILE_PATH];
        [userDefaults synchronize];
        _bgView.image = image;
    }else{
        [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark 切换背景
//////////////////////////////////////////////////////////////
-(void)showEditBgView:(UIButton *)sender{
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
        [_popController presentPopoverFromRect:sender.frame
                                        inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                      animated:YES];
    }
    else
    {
        [_popController dismissPopoverAnimated:YES];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark 删除留言
//////////////////////////////////////////////////////////////
-(void)deleMessage:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(checkMessageCanDeleteMessageBoardInfo:)]) {
        if ([_delegate checkMessageCanDeleteMessageBoardInfo:_messageBoardInfo]) {
            MessageBoardInfo *nextMsgInfo = [_delegate checkMessageViewControllerNextMsg:_messageBoardInfo];
            [_delegate checkMessageViewControllerDidDeleteMsg:_messageBoardInfo];
            self.messageBoardInfo = nextMsgInfo;            
            //显示头像
            UIImage *protraitImage = [[ResourceCache instance] imageForCachePath:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:_messageBoardInfo.headPortraits]];
            if (!protraitImage) {
                protraitImage  = [UIImage imageNamed:@"pickPhoto.png"];
            }
            headPortraits.image = protraitImage;           
            messageTextView.text = _messageBoardInfo.messageContent;                        
            //显示签名
            UIImage *singeNameImage = [[ResourceCache instance] imageForCachePath:_messageBoardInfo.singeName];
            if (!singeNameImage) {
                singeNameImage  = [UIImage imageNamed:@"singe.png"];
            }
            singeName.image = singeNameImage;
        }else{
            ALERT_MSG(@"已经是最后一条留言", @"请回到留言列表中删除", @"确定");
        }
    }
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