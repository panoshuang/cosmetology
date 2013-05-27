/*********************************************************************
 *            Copyright (C) 2012, 广州米捷网络科技有限公司
 * @文件描述:用于快速的实现类的单例模式而设置的宏，
 * 在要实现的类中，需要先在h文件中定义+ (classname *)instance; 函数
 * 而后在实现文件中添加SYNTHESIZE_SINGLETON_FOR_CLASS(classname)
 **********************************************************************
 *   Date        Name        Description
 *   2012/06/18  luzj        New
 *********************************************************************/


#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
static classname *shared##classname = nil; \
+ (classname *)instance \
{\
@synchronized(self) \
{\
if (shared##classname == nil) \
{\
shared##classname = [[self alloc] init]; \
} \
} \
return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{\
@synchronized(self) \
{\
if (shared##classname == nil) \
{\
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
return nil; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} 

