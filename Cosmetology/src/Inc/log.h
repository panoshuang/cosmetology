/*********************************************************************
 *            Copyright (C) 2011, 网龙天晴数码应用产品二部
 * @文件描述:根据宏定义，输出Log或者不输出Log
 **********************************************************************
 *   Date        Name        Description
 *   2011/08/23  luzj        New
 *   2011/09/22  luzj        采用__OPTIMIZE__宏
 *********************************************************************/


//在正式发布的时候使用release方式,
//会自动定义__OPTIMIZE__宏,这样就会去除不必要的日志输出
#ifndef __OPTIMIZE__
#define DLog(f, ...) NSLog(f, ## __VA_ARGS__)
#define DlogWithFunName(f,...)  NSLog((@"方法名%s " f),__FUNCTION__,##__VA_ARGS__);
#define DDetailLog(fmt, ...) NSLog((@"方法名%s [Line %d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DBErrorCheckLog(db) if([db hadError]){DDetailLog(@"Database error >>>>>>>>>>>>>>:%@", [db lastErrorMessage]);}
#define DBErrorCheckLogWithSql(db,sql) if([db hadError]){DLog(@"%@",sql);DDetailLog(@"Database error >>>>>>>>>>>>>>:%@", [db lastErrorMessage]);}


#else
#define DLog(f, ...)
#define DlogWithFunName(f,...)
#define DDetailLog(fmt, ...)
#define DBErrorCheckLog(db)
#define DBErrorCheckLogWithSql(db,sql)

#endif

//ALog在任何时候都会生效
#define ALog(f, ...) NSLog(f, ## __VA_ARGS__)
