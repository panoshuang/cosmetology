//
//  ViewController.m
//  MessageBoard
//
//  Created by mijie on 06/16/13.
//  Copyright (c) 2013 mijie. All rights reserved.
//

#import "EditMessageViewController.h"
#import "CheckMessageViewController.h"
#import "MessageBoardInfo.h"
#import "MessageBoardManager.h"
#import "VoiceHandle.h"
#import "MicroView.h"
#import "CommonUtil.h"
#import "ResourceCache.h"
#import "AutoDismissView.h"
#import "RIButtonItem.h"
#import "PasswordManager.h"
#import "UIAlertView+Blocks.h"

@interface EditMessageViewController ()<VoiceHandleDelegate>
{
    UIButton *takePhotoBtn;//照相
    UITextView *messageEditTextView;//留言编辑
    UIButton *OKBtn;//OK按钮
    UIButton *backBtn;//返回按钮
    UIButton *record;//录音
    UIButton *playRecord;//播放录音
    UIButton *singeName;//签名
    MessageBoardInfo *_messageBoardInfo;//留言板信息
    
    //录音功能
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    UIImageView *recordImageView;//录音图标
    AVAudioPlayer *avPlay;
    
    UIImageView *_bgView;//背景图片
    
   VoiceHandle *_voiceHandle;
    MicroView *_microView;
    NSString *_recordWavFilePath;
    NSTimer  *_recordTimer;
    NSTimeInterval _beginRecordAudioInterval; //开始录音时间
    NSTimeInterval _endRecordAudioInterval; //结束录音时间
    
    UIImageView *headImageView;//头像
    UIImage *headPortraitsImage;//头像图片
    UIImage *singeNameImage;//签名图片
    
    UIPopoverController *_popController;
    UIView *_editTapView;
    UITapGestureRecognizer *_editGesture; //开启编辑的手势
    BOOL _bIsEdit;
    UIButton *editBgBtn;//修改背景
}

@property (nonatomic,strong) MicroView *microView;
@property (nonatomic,strong) NSString *recordWavFilePath;
@property (nonatomic,strong) NSTimer  *recordTimer;

@end

@implementation EditMessageViewController

@synthesize delegate = _delegate;
@synthesize subProductID = _subProductID;
@synthesize microView = _microView;
@synthesize recordWavFilePath = _recordWavFilePath;
@synthesize bIsEdit = _bIsEdit;

-(void)loadView{
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
    _bgView.image = [UIImage imageNamed:@"bgEditMessage.jpg"];
    [self.view addSubview:_bgView];
    
    //修改背景
    editBgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editBgBtn.frame = CGRectMake(50, 705, 180, 67);
    editBgBtn.hidden = YES;
    editBgBtn.tag = 1000;
    [editBgBtn setBackgroundImage:[UIImage imageNamed:@"editBgBtn.png"] forState:UIControlStateNormal];
    [editBgBtn addTarget:self action:@selector(showEditBgView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBgBtn];
    
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self audio];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    //照相
    takePhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoBtn.frame = CGRectMake(100, 414, 89, 89);
    [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"takePhoto.png"] forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    
    //显示头像
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 410, 130, 93)];
    UIImage *headImage = [UIImage imageNamed:@"pickPhoto.png"];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = headImage;
    headImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headImageView];
    
    //留言编辑
    UIFont *font = [UIFont fontWithName:@"Courier-Oblique" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(380, 55, 130, 30)];
    messagelabel.text = @"我的留言:";
    messagelabel.backgroundColor = [UIColor clearColor];
    [messagelabel setFont:font];
    
    messageEditTextView = [[UITextView alloc]initWithFrame:CGRectMake(80, 85, 710, 220)];
    messageEditTextView.delegate = self;
    messageEditTextView.contentMode = UIViewContentModeScaleToFill;
    messageEditTextView.backgroundColor = [UIColor clearColor];
    [messageEditTextView setFont:font];
    
    UIImageView *messageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(93, 18, 869, 372)];
    messageImageView.image = [UIImage imageNamed:@"messageBoard.png"];
    messageImageView.userInteractionEnabled = YES;
    [messageImageView addSubview:messagelabel];
    [messageImageView addSubview:messageEditTextView];
    
    
    //保存按钮
    OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKBtn.frame = CGRectMake(329, 705, 120, 67);
    [OKBtn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(saveMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBtn];
    
    //返回按钮
    backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(625, 705, 120, 67);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //录音图标
    recordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 525, 115, 178)];
    recordImageView.image = [UIImage imageNamed:@"recordImage.png"];
    [self.view addSubview:recordImageView];
    
    //录音
    record = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    record.frame = CGRectMake(100, 535, 89, 89);
    //[record setTitle:@"我有话说" forState:UIControlStateNormal];
    [record setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    [record addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [record addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    [record addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:record];
    
    //播放留言
    playRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(100, 620, 89, 89);
    [playRecord setBackgroundImage:[UIImage imageNamed:@"playRecord.png"] forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    //签名
    singeName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    singeName.frame = CGRectMake(374, 369, 497, 302);
    [singeName setBackgroundImage:[UIImage imageNamed:@"singe.png"] forState:UIControlStateNormal];
    [singeName addTarget:self action:@selector(singeName:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:singeName];
    [self.view addSubview:messageImageView];
    
    //初始化留言板信息
    _messageBoardInfo = [[MessageBoardInfo alloc]init];
    _messageBoardInfo.messageContent = nil;
    _messageBoardInfo.messageRecord = @"录音路劲";
    _messageBoardInfo.headPortraits = @"头像路劲";
    _messageBoardInfo.singeName = @"签名路径";
    _messageBoardInfo.popularity = 0;
    _messageBoardInfo.subProductID = _subProductID;

}


-(void)singeName:(UIButton *)btn
{
    MyPaletteViewController *myPaletteViewController = [[MyPaletteViewController alloc]init];
    myPaletteViewController.delegate =self;
    [self.navigationController pushViewController:myPaletteViewController animated:YES];
}



-(void)saveMessage:(UIButton *)btn
{
    //保存头像到缓存
    NSString *headPortraitsUuid = [CommonUtil uuid];
    NSString *headPortraitsFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(headPortraitsImage, 1)
                                                                      relatePath:[headPortraitsUuid stringByAppendingPathExtension:@"JPEG"]
                                                                    resourceType:kResourceCacheTypeUserPortrait];
    //保存签名到缓存
    NSString *bgUuid = [CommonUtil uuid];
    NSString *singeNameImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(singeNameImage, 1)
                                                                       relatePath:bgUuid
                                                                     resourceType:kResourceCacheTypeUserAutograph];
    
    if (singeNameImageFilePath.length != 0) {
        _messageBoardInfo.singeName = singeNameImageFilePath;
    }
    if (headPortraitsFilePath.length != 0) {
        _messageBoardInfo.headPortraits = headPortraitsFilePath;
    }
    if (messageEditTextView.text.length != 0) {
        _messageBoardInfo.messageContent = messageEditTextView.text;
    }
    //留言内容不能全部为空
    if(headPortraitsFilePath.length == 0
       && messageEditTextView.text.length == 0 && _messageBoardInfo.messageRecord.length == 0){
        ALERT_MSG(@"请输入您的留言", nil, @"确定");
        return;
    }
    
    _messageBoardInfo.messageID = [[MessageBoardManager instance] addMessageBoard:_messageBoardInfo];
    //TODO:
    [messageEditTextView resignFirstResponder];
    if ([_delegate respondsToSelector:@selector(saveMessage:forSubProductID:)]) {
        [_delegate saveMessage:_messageBoardInfo forSubProductID:_subProductID];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pickImage:(UIButton *)btn
{
    //TODO:拍照
    //指定图片来源
	UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
	//判断如果摄像机不能用图片来源与图片库
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
	}
	UIImagePickerController *picker=[[UIImagePickerController alloc] init];
	picker.delegate= self;
	//前后摄像机
	//picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
	picker.allowsEditing=YES;
	picker.sourceType=sourceType;
    picker.view.tag = 1000;
	[self presentModalViewController:picker animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [messageEditTextView resignFirstResponder];
}

#pragma mark 录音功能
-(void)record:(UIButton *)btn
{
    //TODO:录音功能
    //开始录音
    if (_voiceHandle == nil){
        _voiceHandle = [[VoiceHandle alloc] init];
        _voiceHandle.delegate = self;
    }    
    //缓存使用MD5算法去生成文件名,所以在这里只能生成url后让缓存生成文件名作为保存地址
    NSString *uuid = [[CommonUtil uuid] stringByAppendingPathExtension:@"wav"];
    NSString *recordWavUrl = [[ResourceCache instance] filePathForMediaRelatePath:uuid resourceType:kResourceCacheTypeAudio];
    self.recordWavFilePath = recordWavUrl;
    _voiceHandle.curRecordFilePath = self.recordWavFilePath;
    [_voiceHandle startRecord];
    //显示录音图标
    MicroView *tmpMicroView = [[MicroView alloc] init];
    self.microView = tmpMicroView;
    [tmpMicroView showMicroViewAtView:self.view];
}

-(void)playRecord:(UIButton *)btn{
    //TODO:播放录音
    if (_voiceHandle == nil){
        _voiceHandle = [[VoiceHandle alloc] init];
        _voiceHandle.delegate = self;
    }
    if (_messageBoardInfo.messageRecord.length == 0) {
        return;
    }
    [_voiceHandle playVoice:_messageBoardInfo.messageRecord];
}

- (IBAction)btnDown:(id)sender
{
    //创建录音文件，准备录音
    [self record:sender];
}
- (IBAction)btnUp:(id)sender
{
    //做停止延迟处理,延迟0.2秒,解决最后一个字被截断
    [self performSelector:@selector(delayHandleEndTouchButton) withObject:nil afterDelay:.2];
}

-(void)delayHandleEndTouchButton{
    //取消禁用页面其他ui的用户响应
    [_microView removeFromSuperview];
    self.microView = nil;
    [_voiceHandle stopRecord];
}

- (IBAction)btnDragUp:(id)sender
{
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    
    NSLog(@"取消发送");
}
- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    urlPlay = url;
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [recordImageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

- (void) updateImage
{
    [recordImageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
}

#pragma mark - 声音处理VoiceHandle的delegate回调

-(void)voiceHandleDidStartRecord:(VoiceHandle *)aVoiceHandle error:(NSError *)error{
    messageEditTextView.userInteractionEnabled = NO;
    singeName.enabled = NO;
    if (error == nil){
        //记录录音时间
        _beginRecordAudioInterval = [[NSDate date] timeIntervalSince1970];
        DDetailLog(@"beginRecordAudioInterval %f",_beginRecordAudioInterval);
        
    } else{
        ALERT_MSG(@"录音失败", nil, @"确定");
    }
}

-(void)voiceHandleDidStopRecord:(VoiceHandle *)aVoiceHandle error:(NSError *)error{
    messageEditTextView.userInteractionEnabled = YES;
    singeName.enabled = YES;
    //结束录音
    DDetailLog(@"isOnMainThread %d",[NSThread currentThread].isMainThread);
    _endRecordAudioInterval = [[NSDate date] timeIntervalSince1970];
    DDetailLog(@"endRecordAudioInterval %f",_endRecordAudioInterval);
    double recordDuration = (_endRecordAudioInterval-_beginRecordAudioInterval);
    //判断录音时间,过短则丢弃该录音(最短不能少于1s),否则进行把录音转成amr文件并且发送出去
    if (recordDuration >= 1){
        if (_messageBoardInfo.messageRecord.length > 0) {
            [[ResourceCache instance] deleteResourceForPath:_messageBoardInfo.messageRecord];
        }
        _messageBoardInfo.messageRecord = self.recordWavFilePath;
    } else {
        [[AutoDismissView instance] showInView:self.view
                                         title:@"时间过短"
                                      duration:.7];
        
    }
}

//音量大小,单位为分贝
-(void)voiceHandleDidRecordVolumeLevelChange:(VoiceHandle *)aVoiceHandle level:(CGFloat)decibels{
    //刷新录音音量
    [_microView setVolumeLevel:[VoiceHandle levelForVolume:decibels]];
}

- (void)voiceHandleDidStartPlay:(VoiceHandle *)aVoiceHandle wavFilePath:(NSString *)wavFilePath error:(NSError *)error{
    
}

//音频播放完毕
- (void)voiceHandleDidStopPlay:(VoiceHandle *)aVoiceHandle wavFilePath:(NSString *)wavFilePath error:(NSError *)error{
    DDetailLog(@"音频播放完成");
}

//录音文件转码成amr文件结束回调
- (void)voiceHandleDidConvertWavToAmrVoiceHandle:(VoiceHandle *)aVoiceHandle wavFilePath:(NSString *)wavFilePath amrFilePath:(NSString *)amrFilePath error:(NSError *)error{

}

-(void)voiceHandleDidConvertAmrToWav:(VoiceHandle *)aVoiceHandle amrFilePath:(NSString *)amrFilePath wavFilePath:(NSString *)wavFilePath error:(NSError *)error{
    [aVoiceHandle playVoice:wavFilePath];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.view.tag == 1000) {
        
        headPortraitsImage = image;
        headImageView.image = headPortraitsImage;
        DDetailLog(@"%@",info);
    }
    else if(picker.view.tag == 10000){
        if (image) {
            //生成图片的uuid,保存到缓存
            NSString *bgUuid = [CommonUtil uuid];
            NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 1)
                                                                        relatePath:bgUuid
                                                                      resourceType:kResourceCacheTypeBackgroundImage];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:bgImageFilePath forKey:MSG_PAGE_BACKGROUND_IMAGE_FILE_PATH];
            [userDefaults synchronize];
            _bgView.image = image;
        }else{
            [[AutoDismissView instance] showInView:self.view title:@"修改失败" duration:1];
        }
        [_popController dismissPopoverAnimated:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [_popController dismissPopoverAnimated:YES];
    if (picker.view.tag = 10000) {
        if (image) {
            //生成图片的uuid,保存到缓存
            NSString *bgUuid = [CommonUtil uuid];
            NSString *bgImageFilePath = [[ResourceCache instance] saveResourceData:UIImageJPEGRepresentation(image, 1)
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
    
}


#pragma mark MyPaletteViewControllerDelegate
-(void)setSingeNameImage:(UIImage *)img{
    singeNameImage = img;
    [singeName setImage:singeNameImage forState:UIControlStateNormal];
}

//////////////////////////////////////////////////////////////
#pragma mark 启动编辑功能
//////////////////////////////////////////////////////////////

-(void)editGestureDidTap:(UITapGestureRecognizer *)gesture{
    if (_bIsEdit) {
        [self cancelEdit];
        editBgBtn.hidden = YES;
    }else{
        //判断是否已经设置了密码,没有的话直接进入编辑模式,有的话要输入密码
        NSString *editPwdStr = [[PasswordManager instance] passwordForKey:PWD_MAIN_CATALOG];
        if (editPwdStr.length > 0) {
            [self inputPassword];
        }else{
            self.bIsEdit = YES;
            editBgBtn.hidden = NO;
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
        }else{
            [[AutoDismissView instance] showInView:self.view
                                             title:@"密码错误"
                                          duration:1];
            editBgBtn.hidden = YES;
        }
    };
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    [alertView addButtonItem:cancelItem];
    [alertView addButtonItem:confirmItem];
    [alertView show];
    
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
        controller.view.tag = 10000;
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