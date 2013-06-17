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

SYNTHESIZE_SINGLETON_FOR_CLASS(ResourceCache)


/**
	创建缓存目录
 */
-(BOOL)createAllCachePath{
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
    //创建价格缓存目录
    BOOL result7 = [FileUtil createPathWithRelativeToDocFilePath:IMAGE_CACHE_PATH_PRICE];
    return result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7;
}

-(NSString*)resourceCachePathForCachePath:(EnumResourceCacheType)cacheType{
    NSString *path = [FileUtil getDocumentDirectory];
    switch (cacheType) {
        case kResourceCacheTypeBackgroundImage:
            path = [path stringByAppendingPathComponent:IMAGE_CACHE_PATH_BACKGROUND];
            break;
        case kResourceCacheTypeMainCatalogPreviewImage:
            path = [path stringByAppendingPathComponent:IMAGE_CACHE_PATH_MAIN_CATALOG];
            break;
        case kResourceCacheTypeAdImage:
            path = [path stringByAppendingPathComponent:IMAGE_CACHE_PATH_AD];
            break;
        case kResourceCacheTypePriceImage:
            path = [path stringByAppendingPathComponent:IMAGE_CACHE_PATH_PRICE];
            break;
        case kResourceCacheTypeUserAutograph:
            path = [path stringByAppendingPathComponent:IMAGE_CACHE_PATH_MSG_USER_AUTOGRAPH];
            break;
        case kResourceCacheTypeUserPortrait:
            path = [path stringByAppendingPathComponent:IMAGE_CACHE_PATH_MSG_USER_PORTRAIT];
            break;
        case kResourceCacheTypeAudio:
            path = [path stringByAppendingPathComponent:AUDIO_CACHE_PATH];
            break;
        case kResourceCacheTypeVedio:
            path = [path stringByAppendingPathComponent:VEDIO_CACHE_PATH];
            break;
        default:
            break;
    }
    return path;
}

/**
	保存资源data到指定类型的缓存目录中
	@param data 类型的data数据
	@param relatePath 文件名
	@param cacheType 缓存类型
	@returns 返回绝对路径
 */
-(NSString *)saveResourceData:(NSData *)data relatePath:(NSString *)relatePath resourceType:(EnumResourceCacheType)cacheType{
    NSString *absolutePath = [[self resourceCachePathForCachePath:cacheType] stringByAppendingPathComponent:relatePath];
    BOOL success =  [FileUtil saveData:data toFileName:absolutePath];
    if (success) {
        return absolutePath;
    }else{
        return nil;
    }
}

//通过绝对路径名获取图片
-(UIImage *)imageForCachePath:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//通过绝对路径删除资源
-(BOOL)deleteResourceForPath:(NSString *)path{
    return [FileUtil deleteFileWithAbsoluteFilePath:path];
}



@end
