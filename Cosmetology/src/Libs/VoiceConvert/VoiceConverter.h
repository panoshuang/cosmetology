//
//  FileListTableView.m
//  WAVtoAMRtoWAV
//
//  Created by Jeans Huang on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceConverter : NSObject

+ (int)amrToWav:(NSString*)fileNameString destinationFilePath:(NSString *)desFilePath;

+ (int)wavToAmr:(NSString *)fileNameString destinationFilePath:(NSString *)desFilePath;

@end
