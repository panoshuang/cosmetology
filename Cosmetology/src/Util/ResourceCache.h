//
//  ImageCache.h
//  Cosmetology
//
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE_CACHE_PATH_BACKGROUND @"background"
#define IMAGE_CACHE_PATH_MAIN_CATALOG @"mainCatalog" //主产品代表图片目录
#define IMAGE_CACHE_PATH_AD  @"ad" //产品广告图片缓存目录
#define IMAGE_CACHE_PATH_PRICE @"price" //报价图片缓存目录
#define IMAGE_CACHE_PATH_MSG_USER_AUTOGRAPH @"autograph" //留言用户签名
#define IMAGE_CACHE_PATH_MSG_USER_PORTRAIT  @"portrait"  //留言用户头像
#define AUDIO_CACHE_PATH            @"audio" //用户留言录音缓存目录
#define VEDIO_CACHE_PATH            @"vedio" //视频缓存目录

@interface ResourceCache : NSObject

+(ResourceCache *)instance;

+(BOOL)createAllCachePath;

+(NSString*)resouceCachePathForCachePath:(EnumResourceCacheType)cacheType;

//保存资源data到指定类型的缓存目录中
+(NSString *)saveResouceData:(NSData *)data relatePath:(NSString *)relatePath resourceType:(EnumResourceCacheType)cacheType;

//通过绝对路径名获取图片
+(UIImage *)imageForCachePath:(NSString *)path;

//通过绝对路径删除资源
-(BOOL)deleteResourceForPath:(NSString *)path;

@end
