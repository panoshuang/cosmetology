//
//  FileListTableView.m
//  WAVtoAMRtoWAV
//
//  Created by Jeans Huang on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation VoiceConverter

+ (int)amrToWav:(NSString *)fileNameString destinationFilePath:(NSString *)desFilePath{
    if (! DecodeAMRFileToWAVEFile([fileNameString cStringUsingEncoding:NSASCIIStringEncoding], [desFilePath cStringUsingEncoding:NSASCIIStringEncoding]))
    {
        DDetailLog(@"convert error");
        return 0;
    }
    DDetailLog(@"convert success");
    return 1;
}

+ (int)wavToAmr:(NSString *)fileNameString destinationFilePath:(NSString *)desFilePath {

    
    // WAVE音频采样频率是8khz 
    // 音频样本单元数 = 8000*0.02 = 16 (由采样频率决定)
    // 声道数 1 : 160
    //        2 : 160*2 = 320
    // bps决定样本(sample)大小
    // bps = 8 --> 8位 unsigned char
    //       16 --> 16位 unsigned short

    if (!EncodeWAVEFileToAMRFile([fileNameString cStringUsingEncoding:NSASCIIStringEncoding], [desFilePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
    {
        DDetailLog(@"convert error");
        return 0;
    }
    DDetailLog(@"convert success");
    return 1;
}



@end
