//
//  ViewController.m
//  MessageBoard
//
//  Created by mijie on 06/16/13.
//  Copyright (c) 2013 mijie. All rights reserved.
//

#import "EditMessageViewController.h"
#import "MyPaletteViewController.h"
#import "CheckMessageViewController.h"
#import "MessageBoardInfo.h"
#import "MessageBoardManager.h"
#import "VoiceHandle.h"
#import "MicroView.h"
#import "CommonUtil.h"
#import "ResourceCache.h"
#import "AutoDismissView.h"

@interface EditMessageViewController ()<VoiceHandleDelegate>
{
    UIButton *headPortraits;//头像
    UITextView *messageEditTextView;//留言编辑
    UIButton *OKBtn;//OK按钮
    UIButton *record;//录音
    UIButton *playRecord;//播放录音
    UIButton *singeName;//签名
    MessageBoardInfo *messageBoardInfo;//留言板信息
    
    //录音功能
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    UIImageView *recordImageView;
    AVAudioPlayer *avPlay;
    
    UIImageView *_bgView;//背景图片
    
   VoiceHandle *_voiceHandle;
    MicroView *_microView;
    NSString *_recordWavFilePath;
    NSTimer  *_recordTimer;
    NSTimeInterval _beginRecordAudioInterval; //开始录音时间
    NSTimeInterval _endRecordAudioInterval; //结束录音时间
    
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

-(void)loadView{
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
    
    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;
    _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //获取背景图片填充
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *bgFilePath = [userDefaults stringForKey:HOME_PAGE_BACKGROUND_IMAGE_FILE_PATH];
//    UIImage *bgImage = [[ResourceCache instance] imageForCachePath:bgFilePath];
//    _bgView.image = bgImage;
    
    _bgView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:_bgView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self audio];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    //头像
    headPortraits = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headPortraits.frame = CGRectMake(60, 160, 204, 143);
    headPortraits.contentMode = UIViewContentModeScaleToFill;
    [headPortraits setBackgroundImage:[UIImage imageNamed:@"pickPhoto.png"] forState:UIControlStateNormal];
    //headPortraits.imageView.image = [UIImage imageNamed:@"headPortraits.png"];
    [headPortraits addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headPortraits];
    
    //留言编辑
    UIFont *font = [UIFont fontWithName:@"Courier-Oblique" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 55, 130, 30)];
    messagelabel.text = @"我的留言:";
    messagelabel.backgroundColor = [UIColor clearColor];
    [messagelabel setFont:font];
    
    messageEditTextView = [[UITextView alloc]initWithFrame:CGRectMake(45, 85, 540, 220)];
    messageEditTextView.delegate = self;
    messageEditTextView.contentMode = UIViewContentModeScaleToFill;
    messageEditTextView.backgroundColor = [UIColor clearColor];
    [messageEditTextView setFont:font];
    
    UIImageView *messageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 10, 637, 372)];
    messageImageView.image = [UIImage imageNamed:@"messageBoard.png"];
    messageImageView.userInteractionEnabled = YES;
    
    [messageImageView addSubview:messagelabel];
    [messageImageView addSubview:messageEditTextView];
    
    
    //OK按钮
    OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKBtn.frame = CGRectMake(940, 20, 50, 50);
    
    [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(saveMessage:) forControlEvents:UIControlEventTouchUpInside];
    OKBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:OKBtn];
    
    //录音图标
    recordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 380, 75, 111)];
    recordImageView.image = [UIImage imageNamed:@"record_animate_01.png"];
    [self.view addSubview:recordImageView];
    
    //录音
    record = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    record.frame = CGRectMake(10, 500, 80, 40);
    [record setTitle:@"我有话说" forState:UIControlStateNormal];
    [record addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [record addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    [record addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:record];
    
    //播放留言
    playRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(100, 500, 80, 40);
    [playRecord setTitle:@"播放留言" forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    //签名
    singeName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    singeName.frame = CGRectMake(294, 349, 529, 322);
    singeName.backgroundColor = [UIColor yellowColor];
    [singeName setImage:[UIImage imageNamed:@"singeName.png"] forState:UIControlStateNormal];
    [singeName addTarget:self action:@selector(singeName:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:singeName];
    [self.view addSubview:messageImageView];
    
    //初始化留言板信息
    messageBoardInfo = [[MessageBoardInfo alloc]init];
    messageBoardInfo.messageContent = nil;
    messageBoardInfo.messageRecord = @"录音路劲";
    messageBoardInfo.headPortraits = @"头像路劲";
    messageBoardInfo.singeName = @"签名路径";
    messageBoardInfo.popularity = 0;
    messageBoardInfo.subProductID = _subProductID;

}


-(void)singeName:(UIButton *)btn
{
    MyPaletteViewController *myPaletteViewController = [[MyPaletteViewController alloc]initWithNibName:@"MyPaletteViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:myPaletteViewController animated:YES];
}



-(void)saveMessage:(UIButton *)btn
{
    messageBoardInfo.messageContent = messageEditTextView.text;
    [[MessageBoardManager instance] addMessageBoard:messageBoardInfo];
    //TODO:
    [messageEditTextView resignFirstResponder];
    if ([_delegate respondsToSelector:@selector(saveMessage:forSubProductID:)]) {
        [_delegate saveMessage:_messageBoardInfo forSubProductID:_subProductID];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pickImage:(UIButton *)btn
{
    //TODO:拍照
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
    if (avPlay.playing) {
        [avPlay stop];
        return;
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    avPlay = player;
    [avPlay play];
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
    if (error == nil){
        //记录录音时间
        _beginRecordAudioInterval = [[NSDate date] timeIntervalSince1970];
        DDetailLog(@"beginRecordAudioInterval %f",_beginRecordAudioInterval);
        
    } else{
        ALERT_MSG(@"录音失败", nil, @"确定");
    }
}

-(void)voiceHandleDidStopRecord:(VoiceHandle *)aVoiceHandle error:(NSError *)error{
    //结束录音
    DDetailLog(@"isOnMainThread %d",[NSThread currentThread].isMainThread);
    _endRecordAudioInterval = [[NSDate date] timeIntervalSince1970];
    DDetailLog(@"endRecordAudioInterval %f",_endRecordAudioInterval);
    double recordDuration = (_endRecordAudioInterval-_beginRecordAudioInterval);
    //判断录音时间,过短则丢弃该录音(最短不能少于1s),否则进行把录音转成amr文件并且发送出去
    if (recordDuration >= 1){
        //TODO:处理录音成功
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



@end