//
//  FileUtil.m
//  WeiBoApp
//
//  Created by Martin on 04/02/2011.
//  Copyright 2011 ePangaea. All rights reserved.
//

#import "FileUtil.h"


@implementation FileUtil

@synthesize fileName;


+(NSString *) getDocumentDirectory
{
	NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(
															  NSDocumentDirectory,
															  NSUserDomainMask,
															  YES);
	
	NSString *docDir = [arrayPaths objectAtIndex:0];
			
	return docDir;
}

//获取相对与docment目录下面的文件的绝对路径
+(NSString *)getAbsoluteUrlOnDocumentDirectory:(NSString *)relativeFilePath{
    NSString *docDir = [FileUtil getDocumentDirectory];
    return [docDir stringByAppendingPathComponent:relativeFilePath];
}

-(NSMutableDictionary *) readFileOfDocumentDirectory
{
	if (self.fileName != nil)
		return [FileUtil readFileOfDocumentDirectory:self.fileName];
	else 
		return nil;
}

+(NSMutableDictionary *) readFileOfDocumentDirectory:(NSString *)name
{
	NSString *docDir = [FileUtil getDocumentDirectory];
	NSString *path = [docDir stringByAppendingPathComponent:name];	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if (![fm fileExistsAtPath:path]) {
		NSString *resDir = [[NSBundle mainBundle] bundlePath];		
		NSString *path2 = [resDir stringByAppendingPathComponent:name];
		
		[fm copyItemAtPath:path2 toPath:path error:nil];
	}
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];	
	
	return dic;
}

-(void) writeToFileOfDocumentDirectory:(NSMutableDictionary *)dic
{
	if (self.fileName != nil)
		[FileUtil writeToFileOfDocumentDirectory:dic fileName:fileName];
}

+(void) writeToFileOfDocumentDirectory:(NSMutableDictionary *)dic fileName:(NSString *)name
{
	
	NSString *docDir = [self getDocumentDirectory];	
	NSString *path = [docDir stringByAppendingPathComponent:name];	
	
	[dic writeToFile:path atomically:YES];
}

//根据绝对路径创建doc目录下文件，创建成功返回绝对路径
+ (BOOL) createPathWithAbsoluteFilePath:(NSString *) filePath{

	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:filePath]) {
		return YES;
	}else {
	  BOOL isSuccess = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        return isSuccess;
	}
}

//根据相对路径创建对应的目录
+ (BOOL) createPathWithRelativeToDocFilePath:(NSString *) filePath{
    NSString *absoluteFileStr = [[FileUtil getDocumentDirectory] stringByAppendingPathComponent:filePath];
    return [FileUtil createPathWithAbsoluteFilePath:absoluteFileStr];
}

//保存对象到指定文件
+ (void) saveObjectToFile:(id)obj key:(NSString *) fileName
{
    NSMutableData *data=[[NSMutableData alloc] init];//存放对象数据的缓冲
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];//用缓冲实例化存档对象
    [archiver encodeObject:obj forKey:fileName];//用存档对象的方法，把对象保存在数据缓冲中
    [archiver finishEncoding];//通知对象保存到缓冲中结束
    [data writeToFile:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:fileName] atomically:YES];//缓冲把对象数据保存到文件中
}

+(NSString *)cachesPath
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
     NSString *cachePath = [cache objectAtIndex:0] ;
    return cachePath;
}

+(BOOL)createPathWithRelativeToCachesPath:(NSString *)filePath{
    NSString *absoluteFileStr = [[FileUtil cachesPath] stringByAppendingPathComponent:filePath];
       return [FileUtil createPathWithAbsoluteFilePath:absoluteFileStr];
}

//删除目录或者文件
+(BOOL)deleteFileWithAbsoluteFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:NULL];
}



@end
