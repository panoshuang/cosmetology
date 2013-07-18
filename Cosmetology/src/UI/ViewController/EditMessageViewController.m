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

@interface EditMessageViewController ()
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
}

@end

@implementation EditMessageViewController

@synthesize delegate = _delegate;
@synthesize subProductID = _subProductID;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self audio];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    //头像
    headPortraits = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headPortraits.frame = CGRectMake(10, 10, 200, 200);
    headPortraits.contentMode = UIViewContentModeScaleToFill;
    [headPortraits setBackgroundImage:[UIImage imageNamed:@"headPortraits.png"] forState:UIControlStateNormal];
    //headPortraits.imageView.image = [UIImage imageNamed:@"headPortraits.png"];
    [headPortraits addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headPortraits];
    
    //留言编辑
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 10, 130, 30)];
    messagelabel.text = @"我的留言:";
    [messagelabel setFont:font];
    [self.view addSubview:messagelabel];
    messageEditTextView = [[UITextView alloc]initWithFrame:CGRectMake(330, 10, 600, 200)];
    messageEditTextView.delegate = self;
    messageEditTextView.contentMode = UIViewContentModeScaleToFill;
    messageEditTextView.backgroundColor = [UIColor yellowColor];
    
    [messageEditTextView setFont:font];
    [self.view addSubview:messageEditTextView];
    
    //OK按钮
    OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKBtn.frame = CGRectMake(950, 10, 50, 50);
    
    [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(saveMessage:) forControlEvents:UIControlEventTouchUpInside];
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
    [record addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:record];
    
    //播放留言
    playRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(100, 500, 80, 40);
    [playRecord setTitle:@"播放留言" forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    //签名
    singeName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    singeName.frame = CGRectMake(600, 400, 300, 300);
    [singeName addTarget:self action:@selector(singeName:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:singeName];
    
    //初始化留言板信息
    messageBoardInfo = [[MessageBoardInfo alloc]init];
    messageBoardInfo.messageContent = nil;
    messageBoardInfo.messageRecord = @"录音路劲";
    messageBoardInfo.headPortraits = @"头像路劲";
    messageBoardInfo.singeName = @"签名路径";
    messageBoardInfo.popularity = 10000;
    messageBoardInfo.subProductID = 2;

}


-(void)singeName:(UIButton *)btn
{
    //TODO:签名
    MyPaletteViewController *myPaletteViewController = [[MyPaletteViewController alloc]init];
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
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}
- (IBAction)btnUp:(id)sender
{
    double cTime = recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
        NSLog(@"发出去");
    }else {
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    [recorder stop];
    [timer invalidate];
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


@end