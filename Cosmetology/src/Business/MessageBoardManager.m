//
//  MessageBoardManager.m
//  Cosmetology
//
//  Created by mijie on 13-6-18.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MessageBoardManager.h"
#import "MessageBoardInfoDao.h"

@implementation MessageBoardManager{
    
}

SYNTHESIZE_SINGLETON_FOR_CLASS(MessageBoardManager)

-(int)addMessageBoard:(MessageBoardInfo *)messageBoardInfo{
    return [[MessageBoardInfoDao instance] addMessageBoardInfo:messageBoardInfo];
}

- (BOOL)deleteMessageBoardForID:(int)messageID{
    return [[MessageBoardInfoDao instance] deleteMessageBoardForID:messageID];
}

-(BOOL)updateMessageBoard:(MessageBoardInfo *)messageBoardInfo{
    return [[MessageBoardInfoDao instance] updateMessageBoard:messageBoardInfo];
}

-(NSArray *)allMessageBoardForSubProductID:(int)subProductID{
    return [[MessageBoardInfoDao instance] allMessageBoardForSubProductID:subProductID];
}

-(MessageBoardInfo *)lastMessageBoard{
    return [[MessageBoardInfoDao instance] lastMessageBoard];
}


@end
