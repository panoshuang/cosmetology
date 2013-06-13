//
//  FileUtil.h
//  WeiBoApp
//
//  Created by Martin on 04/02/2011.
//  Copyright 2011 ePangaea. All rights reserved.
//


@interface FileUtil : NSObject {
	NSString *fileName;
}

@property (nonatomic, strong) NSString *fileName;

+(NSString *) getDocumentDirectory;

//获取相对与docment目录下面的文件的绝对路径
+(NSString *)getAbsoluteUrlOnDocumentDirectory:(NSString *)relativeFilePath;


+(NSMutableDictionary *) readFileOfDocumentDirectory:(NSString *)name;
+(void) writeToFileOfDocumentDirectory:(NSMutableDictionary *)dic fileName:(NSString *)name;

-(NSMutableDictionary *) readFileOfDocumentDirectory;
-(void) writeToFileOfDocumentDirectory:(NSMutableDictionary *)dic;

//根据绝对路径创建对应的目录
+ (BOOL) createPathWithAbsoluteFilePath:(NSString *) filePath;

//根据相对路径创建对应的目录
+ (BOOL) createPathWithRelativeToDocFilePath:(NSString *) filePath;

//保存对象到指定文件
+ (void) saveObjectToFile:(id)obj key:(NSString *) fileName;

+ (BOOL) saveData:(NSData *)data toFileName:(NSString *)fileName;

//获取缓存目录
+(NSString *)cachesPath;

//根据相对缓存的路径创建目录
+(BOOL)createPathWithRelativeToCachesPath:(NSString *)filePath;

//删除目录或者文件
+(BOOL)deleteFileWithAbsoluteFilePath:(NSString *)filePath;



@end