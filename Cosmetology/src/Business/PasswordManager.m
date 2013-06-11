//
// Created by mijie on 13-6-7.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PasswordManager.h"
#import "Userdefault_define.h"


@implementation PasswordManager {

}

SYNTHESIZE_SINGLETON_FOR_CLASS(PasswordManager)

-(id)init{
    self = [super init];
    if(self){
        [self initAllPasswordUserDefault];
    }
    return self;
}

//初始化所有的密码
-(void)initAllPasswordUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSMutableDictionary *defaultDic = [NSMutableDictionary dictionary] ;
    [defaultDic setObject:@"" forKey:PWD_MAIN_CATALOG];
    [defaultDic setObject:@"" forKey:PWD_SUB_CATALOG];
    //TODO:后续继续添加其他页面密码
    [userDefaults registerDefaults:defaultDic];
}

-(void)savePasswordForKey:(NSString *)key value:(NSString *)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
}

-(NSString *)passwordForKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
@end