/*********************************************************************
 *  文件: VoiceRecord
 *  项目: homi
 *  文件描述:录音类
 *  Created by huangsp on 13-1-11.
 *  Copyright (C) 2013, 广州米捷网络科技有限公司
 **********************************************************************/



#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol VoiceHandleDelegate;


@interface VoiceHandle : NSObject <AVAudioPlayerDelegate,
                       AVAudioRecorderDelegate,AVAudioSessionDelegate>
{
    AVAudioSession *audioSession;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    NSMutableDictionary *convertWavToAmrTaskFilePathDic;
    NSMutableDictionary *convertAmrToWavTaskFilePathDic;
    NSString *curRecordFilePath; //wav文件路径
    NSString *curConvertAmrToWavFilePathOri; //当前正在转换的amr原文件
    NSString *curConvertAmrToWavFilePathDes; //当前正在转换的wav目标文件
    NSString *curPlayFilePath; //amr文件路径
    NSTimer *levelTimer; //定时检查音量大小的计时器
    id<VoiceHandleDelegate> delegate;
}
@property(nonatomic, retain) AVAudioSession *audioSession;
@property(nonatomic, retain) AVAudioRecorder *audioRecorder;
@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic, copy) NSString *curPlayFilePath;
@property(nonatomic, copy) NSString *curRecordFilePath;
@property(nonatomic, assign) id <VoiceHandleDelegate> delegate;
@property(nonatomic, copy) NSString *curConvertAmrToWavFilePathOri;
@property(nonatomic, copy) NSString *curConvertAmrToWavFilePathDes;
@property(nonatomic, retain) NSTimer *levelTimer;

//把分贝为单位的声音装换成0-5个级别
+(int) levelForVolume:(CGFloat)decibels;


-(void)startRecord;

-(void)stopRecord;

-(BOOL)playVoice:(NSString *)aVoicePath;

-(void)stopPlayVoice;


@end


@protocol VoiceHandleDelegate  <NSObject>

-(void)voiceHandleDidStartRecord:(VoiceHandle *)voiceHandle error:(NSError *)error;

-(void)voiceHandleDidStopRecord:(VoiceHandle *)voiceHandle error:(NSError *)error;

//音量大小,单位为分贝
-(void)voiceHandleDidRecordVolumeLevelChange:(VoiceHandle *)voiceHandle level:(CGFloat)decibels;

- (void)voiceHandleDidStartPlay:(VoiceHandle *)voiceHandle wavFilePath:(NSString *)wavFilePath error:(NSError *)error;

- (void)voiceHandleDidStopPlay:(VoiceHandle *)voiceHandle wavFilePath:(NSString *)wavFilePath error:(NSError *)error;

- (void)voiceHandleDidConvertWavToAmrVoiceHandle:(VoiceHandle *)voiceHandle wavFilePath:(NSString *)wavFilePath amrFilePath:(NSString *)amrFilePath error:(NSError *)error;

-(void)voiceHandleDidConvertAmrToWav:(VoiceHandle *)voiceHandle amrFilePath:(NSString *)amrFilePath wavFilePath:(NSString *)wavFilePath error:(NSError *)error;

@end