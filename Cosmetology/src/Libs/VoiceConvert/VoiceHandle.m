/*********************************************************************
 *  文件: VoiceRecord
 *  项目: homi
 *  文件描述:
 *  Created by huangsp on 13-1-11.
 *  Copyright (C) 2013, 广州米捷网络科技有限公司
 **********************************************************************/


#import "VoiceHandle.h"
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

//把分贝为单位的声音装换成0-5个级别
+(int) levelForVolume:(CGFloat)decibels{
    //ios默认的录音分贝范围为:-160.0-0  ,这里为了录音时候更加明显的显示波动而做了范围缩小,-75-0之前
    //如果小于-75会默认等于-75 ,在这个范围内划分5个等级
    CGFloat calculateDecibels = decibels;
    if (decibels < -75){
        calculateDecibels = -75;
    }
    
    return 5 - abs((int)(calculateDecibels/(75/5)));
}


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



-(void)stopPlayVoice{
    [audioPlayer stop];
    [audioPlayer release];
    audioPlayer = nil;
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