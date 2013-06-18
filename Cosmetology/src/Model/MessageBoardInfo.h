//
//  MessageBoardInfo.h
//  MessageBoard
//
//  Created by mijie on 13-6-16.
//  Copyright (c) 2013年 mijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageBoardInfo : NSObject
{
    NSString *_messageContent;//留言内容
    NSString *_messageRecord;//录音
    NSString *_headPortraits;//头像
    NSString *_singeName;//签名
    NSInteger _popularity;//人气
}

@property(nonatomic, strong)NSString *messageContent;
@property(nonatomic, strong)NSString *messageRecord;
@property(nonatomic, strong)NSString *headPortraits;
@property(nonatomic, strong)NSString *singeName;
@property(nonatomic)NSInteger popularity;


@end
