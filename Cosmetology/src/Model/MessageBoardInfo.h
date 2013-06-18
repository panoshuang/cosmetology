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
    NSInteger _messageID;//留言编号
    NSString *_messageContent;//留言内容
    NSString *_messageRecord;//录音
    NSString *_headPortraits;//头像
    NSString *_singeName;//签名
    NSInteger _popularity;//人气
    NSInteger _subProductID;//子产品ID
    
}

@property(nonatomic, strong)NSString *messageContent;
@property(nonatomic, strong)NSString *messageRecord;
@property(nonatomic, strong)NSString *headPortraits;
@property(nonatomic, strong)NSString *singeName;
@property(nonatomic)NSInteger popularity;
@property(nonatomic)NSInteger messageID;
@property(nonatomic)NSInteger subProductID;


@end
