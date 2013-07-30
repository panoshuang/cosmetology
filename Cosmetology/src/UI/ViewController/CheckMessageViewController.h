//
//  CheckMessageViewController.h
//  MessageBoard
//
//  Created by mijie on 13-6-16.
//  Copyright (c) 2013年 mijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageBoardInfo;
@class MessageListsViewController;
@protocol CheckMessageViewControllerDelegate ;
@interface CheckMessageViewController : UIViewController

@property(nonatomic,strong) MessageBoardInfo *messageBoardInfo;
@property (nonatomic) BOOL bIsEdit;
@property(nonatomic,weak) id<CheckMessageViewControllerDelegate> delegate;

@end


@protocol CheckMessageViewControllerDelegate <NSObject>

-(BOOL)checkMessageCanDeleteMessageBoardInfo:(MessageBoardInfo *)msgInfo;

-(void)checkMessageViewControllerDidDeleteMsg:(MessageBoardInfo *)msgInfo;

-(MessageBoardInfo *)checkMessageViewControllerNextMsg:(MessageBoardInfo *)msgInfo;

@end

