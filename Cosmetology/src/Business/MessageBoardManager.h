//
//  MessageBoardManager.h
//  Cosmetology
//
//  Created by mijie on 13-6-18.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBoardInfo.h"

@interface MessageBoardManager : NSObject

+(MessageBoardManager *)instance;

-(int)addMessageBoard:(MessageBoardInfo *)messageBoardInfo;

- (BOOL)deleteMessageBoardForID:(int)messageID;

-(BOOL)updateMessageBoard:(MessageBoardInfo *)messageBoardInfo;

-(NSArray *)allMessageBoardForSubProductID:(int)subProductID;

-(MessageBoardInfo *)lastMessageBoard;
@end
