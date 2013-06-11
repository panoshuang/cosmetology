//
//  ImageCache.m
//  Cosmetology
//  @文件描述
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "ResourceCache.h"
#import "FileUtil.h"

@implementation ResourceCache


/**
	创建缓存目录
 */
+(BOOL)createAllCachePath{
    //创建背景图片缓存目录
    BOOL result0 = [FileUtil createPathWithRelativeToDocFilePath:IMAGE_CACHE_PATH_BACKGROUND];
    //创建主页产品图片
    BOOL result1 = [FileUtil createPathWithRelativeToDocFilePath:IMAGE_CACHE_PATH_MAIN_CATALOG];
    //创建广告图片
    BOOL result2  = [FileUtil createPathWithRelativeToDocFilePath:IMAGE_CACHE_PATH_AD];
    //创建留言签名图片缓存目录
    BOOL result3  = [FileUtil createPathWithRelativeToDocFilePath:IMAGE_CACHE_PATH_MSG_USER_AUTOGRAPH];
    //创建留言用户头像缓存目录
    BOOL result4  = [FileUtil createPathWithRelativeToDocFilePath:IMAGE_CACHE_PATH_MSG_USER_PORTRAIT];
    //创建音频缓存目录
    BOOL result5  = [FileUtil createPathWithRelativeToDocFilePath:AUDIO_CACHE_PATH];
    //创建视频缓存目录
    BOOL result6  = [FileUtil createPathWithRelativeToDocFilePath:VEDIO_CACHE_PATH];
    return result0 && result1 && result2 && result3 && result4 && result5 && result6;
}

@end
