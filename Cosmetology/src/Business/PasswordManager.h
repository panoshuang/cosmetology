//
// Created by mijie on 13-6-7.
// Copyright (c) 2013 pengpai. All rights reserved.
// @:密码编辑
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PasswordManager : NSObject

+(PasswordManager *)instance;

-(void)savePasswordForKey:(NSString *)key value:(NSString *)value;

-(NSString *)passwordForKey:(NSString *)key;

@end