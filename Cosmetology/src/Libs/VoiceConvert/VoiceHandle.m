/*********************************************************************
 *  文件: VoiceRecord
 *  项目: homi
 *  文件描述:
 *  Created by huangsp on 13-1-11.
 *  Copyright (C) 2013, 广州米捷网络科技有限公司
 **********************************************************************/


#import "VoiceHandle.h"
#import "VoiceConverter.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation VoiceHandle {

}
@synthesize audioSession;
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize curPlayFilePath;
@synthesize delegate;
@synthesize curRecordFilePath;
@synthesize curConvertAmrToWavFilePathOri;
@synthesize curConvertAmrToWavFilePathDes;
@synthesize levelTimer;


-(id)init{
    self = [super init];
    if (self) {
        convertAmrToWavTaskFilePathDic = [[NSMutableDictionary alloc] init];
        convertWavToAmrTaskFilePathDic = [[NSMutableDictionary alloc] init];
        self.audioSession= [AVAudioSession sharedInstance];
        audioSession.delegate = self;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        [[AVAudioSession sharedInstance] setCategory:
                AVAudioSessionCategoryPlayAndRecord error:NULL];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,
                sizeof(audioRouteOverride), &audioRouteOverride);
    }
    return self;
}

-(void)startRecord{
    DDetailLog(@"");
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:8000],AVSampleRateKey,
            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
            nil];
    NSError *error;
    AVAudioRecorder * tmpAudioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:curRecordFilePath] settings:settings error:&error];
    self.audioRecorder = tmpAudioRecorder;
    audioRecorder.delegate = self;
    [tmpAudioRecorder release];

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
    [audioSession setActive: YES error: nil];


    if (audioRecorder) {
        [audioRecorder prepareToRecord];
        audioRecorder.meteringEnabled = YES;
        [audioRecorder peakPowerForChannel:0];
        //开启音量监听,0.5秒钟一次
        if (self.levelTimer.isValid){
            [self.levelTimer invalidate];
            self.levelTimer = nil;
        }
        self.levelTimer=[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];

        [self performSelectorInBackground:@selector(recordOnBackground) withObject:nil];
        if ([delegate respondsToSelector:@selector(voiceHandleDidStartRecord:error:)]){
            [delegate voiceHandleDidStartRecord:self error:error];
        }
    } else{
        //启动录音失败
        if ([delegate respondsToSelector:@selector(voiceHandleDidStartRecord:error:)]){
            [delegate voiceHandleDidStartRecord:self error:error];
        }
    }

}

-(void)recordOnBackground{
    if (audioRecorder){
        [audioRecorder record];
    }
}

-(void)stopRecord{
    [audioRecorder stop];
    self.audioRecorder = nil;
}

-(BOOL)playVoice:(NSString *)aVoicePath{
    self.curPlayFilePath = aVoicePath;
    return  [self playVoice];
}

-(BOOL)playVoice{
    NSData *data= [NSData dataWithContentsOfFile:curPlayFilePath options:0 error:nil];

    NSError *error;
    audioPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];
    audioPlayer.volume = 1;
    audioPlayer.meteringEnabled=YES;
    audioPlayer.numberOfLoops= 0;
    audioPlayer.delegate=self;

    if(audioPlayer== nil)
    {    DDetailLog(@"Error");
        return NO;
    }
    else
    {

        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        [audioPlayer play];
        return YES;
    }
}

-(void)addConvertWavToAmrTaskToQueue:(NSString *)wavFilePath amrFilePath:(NSString *)amrFilePath{
    [convertWavToAmrTaskFilePathDic setObject:amrFilePath forKey:wavFilePath];
    [self performSelectorInBackground:@selector(convertWavToAmrOnBackground:) withObject:wavFilePath];
}

-(void)convertWavToAmrOnBackground:(NSString *)wavFilePath{
    DDetailLog(@" 开始转码: %@", wavFilePath)
     NSString *destinationAmrFilePath = [convertWavToAmrTaskFilePathDic objectForKey:wavFilePath];
    DDetailLog(@" 开始转码目标地址: %@", destinationAmrFilePath);
    int convertResult = [VoiceConverter wavToAmr:wavFilePath destinationFilePath:destinationAmrFilePath];
    DDetailLog(@" 转码结束: %@", destinationAmrFilePath);
    DDetailLog(@" 结束转码: %d", convertResult);
    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:wavFilePath,@"wavFilePath",[NSNumber numberWithInt:convertResult],@"result", nil] ;
    [self performSelectorOnMainThread:@selector(afterWavToAmrOnMainThread:) withObject:resultDic waitUntilDone:NO];
}


//转换成功后在主线程调用这个方法通知结果
//@resultDic:结果参数,格式{@"wavFilePath":NSString,@"result":NSNumber}
-(void)afterWavToAmrOnMainThread:(NSDictionary *)resultDic{
    NSString *wavFilePath = [resultDic objectForKey:@"wavFilePath"];
    NSString *amrFilePath = [convertWavToAmrTaskFilePathDic objectForKey:wavFilePath];
    int result = [[resultDic objectForKey:@"result"] intValue];

    if ([delegate respondsToSelector:@selector(voiceHandleDidConvertWavToAmrVoiceHandle:wavFilePath:amrFilePath:error:)]) {
        if (result == 1){
            [delegate voiceHandleDidConvertWavToAmrVoiceHandle:self wavFilePath:wavFilePath amrFilePath:amrFilePath error:nil];
        }else{
            NSError *error = [[NSError alloc] init];
            [delegate voiceHandleDidConvertWavToAmrVoiceHandle:self wavFilePath:wavFilePath amrFilePath:amrFilePath error:error];
            [error release];
        }
    }

    //将该装换任务从任务字典中移除
    [convertWavToAmrTaskFilePathDic removeObjectForKey:wavFilePath];
}

-(void)convertAmrToWav:(NSString *)aAmrFilePath wavFilePath:(NSString *)aWavFilePath{
    //amr->wav在同一时间只有一个任务存在,所以把不需要的取消掉
   [self cancelCurConvertAmrToWavTask];
    [convertAmrToWavTaskFilePathDic setObject:aWavFilePath forKey:aAmrFilePath];
    NSDictionary *filePathDic = [NSDictionary dictionaryWithObjectsAndKeys:aWavFilePath,aAmrFilePath,nil];
   [self performSelectorInBackground:@selector(convertAmrToWavOnBackground:) withObject:filePathDic];
}


-(void)convertAmrToWavOnBackground:(NSDictionary *)filePathDic{
    DDetailLog(@" 开始amr to wav");
    NSString *amrFilePath = [[filePathDic allKeys] objectAtIndex:0];
    NSString *wavFilePath = [filePathDic objectForKey:amrFilePath];
    if ([[convertAmrToWavTaskFilePathDic objectForKey:amrFilePath] length] <= 0){
        return;
    }
    int convertResult = [VoiceConverter amrToWav:amrFilePath destinationFilePath:wavFilePath];
    DDetailLog(@" 转码结束 : %d",convertResult);
    if ([[convertAmrToWavTaskFilePathDic objectForKey:amrFilePath] length] <= 0){
        return;
    }else{
        NSNumber *resultNumber = [NSNumber numberWithInt:convertResult];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:wavFilePath,@"wavFilePath",amrFilePath,@"amrFilePath",resultNumber,@"result", nil];
        [self performSelectorOnMainThread:@selector(afterAmrToWavOnMainThread:) withObject:dictionary waitUntilDone:NO];
    }    
}

//转换成功后在主线程调用这个方法通知结果
//@resultDic:结果参数,格式{@"amrFilePath":NSString,@"wavFilePath":NSString,@"result":NSNumber}
-(void)afterAmrToWavOnMainThread:(NSDictionary *)resultDic {
    NSString *amrFilePath = [resultDic objectForKey:@"amrFilePath"];
    NSString *wavFilePath = [resultDic objectForKey:@"wavFilePath"];
    int result = [[resultDic objectForKey:@"result"] intValue];

    //判断是否转码被取消
    if([[convertAmrToWavTaskFilePathDic objectForKey:amrFilePath] length] > 0){
        [convertAmrToWavTaskFilePathDic removeObjectForKey:amrFilePath];
        if ([delegate respondsToSelector:@selector(voiceHandleDidConvertAmrToWav:amrFilePath:wavFilePath:error:)]){
            if (result == 1){
                [delegate voiceHandleDidConvertAmrToWav:self
                                            amrFilePath:amrFilePath
                                            wavFilePath:wavFilePath
                                                  error:nil];
            }else{
                NSError *error = [[NSError alloc] init];
                [delegate voiceHandleDidConvertAmrToWav:self
                                            amrFilePath:amrFilePath
                                            wavFilePath:wavFilePath
                                                  error:error];
                [error release];
            }

        }
    }
}

-(void)stopPlayVoice{
    [audioPlayer stop];
    [audioPlayer release];
    audioPlayer = nil;
}

-(void)cancelCurConvertAmrToWavTask{
    //取消当前正在装换的任务
    [convertAmrToWavTaskFilePathDic removeAllObjects];
}


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [audioPlayer stop];
    if ([delegate respondsToSelector:@selector(voiceHandleDidStopPlay:wavFilePath:error:)]){
        if (!flag){
            NSError *error = [[NSError alloc] initWithDomain:nil
                                                        code:0
                                                    userInfo:[NSDictionary dictionaryWithObject:@"recodr error"
                                                                                         forKey:@"detail"]];
            [delegate voiceHandleDidStopPlay:self wavFilePath:audioPlayer.url.absoluteString error:error];
            [error release];
        }
        else{
            [delegate voiceHandleDidStopPlay:self wavFilePath:audioPlayer.url.absoluteString error:nil];
        }
    }
    [audioPlayer release];
    audioPlayer = nil;
}

-(void)levelTimerCallback:(NSTimer *)timer{
    [audioRecorder updateMeters];
    DDetailLog(@"1 %f 2%f",[audioRecorder averagePowerForChannel:0],[audioRecorder peakPowerForChannel:0]);
    if ([delegate respondsToSelector:@selector(voiceHandleDidRecordVolumeLevelChange:level:)]){
        [delegate voiceHandleDidRecordVolumeLevelChange:self level:[audioRecorder averagePowerForChannel:0]];
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    DDetailLog(@" successfully : %d", flag);
    DDetailLog(@" is finish call back on mainThread %d", [NSThread currentThread].isMainThread);
    [audioSession setActive: NO error: nil];
    [levelTimer invalidate];
    self.levelTimer = nil;
    if ([delegate respondsToSelector:@selector(voiceHandleDidStopRecord:error:)]){
         if (!flag){
             NSError *error = [[NSError alloc] initWithDomain:nil
                                                         code:0
                                                     userInfo:[NSDictionary dictionaryWithObject:@"recodr error"
                                                                                          forKey:@"detail"]];
             [delegate voiceHandleDidStopRecord:self error:error];
             [error release];
         }
        else{
             [delegate voiceHandleDidStopRecord:self error:nil];
         }
    }

}


- (void)dealloc {
    [audioSession release];
    [audioRecorder release];
    [audioPlayer release];
    [curPlayFilePath release];
    [curRecordFilePath release];
    [curConvertAmrToWavFilePathOri release];
    [curConvertAmrToWavFilePathDes release];
    [convertAmrToWavTaskFilePathDic release];
    [convertWavToAmrTaskFilePathDic release];
    [levelTimer release];
    [super dealloc];
}


@end