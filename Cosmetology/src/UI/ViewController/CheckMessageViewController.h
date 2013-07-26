//
//  CheckMessageViewController.h
//  MessageBoard
//
//  Created by mijie on 13-6-16.
//  Copyright (c) 2013年 mijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageBoardInfo;
@interface CheckMessageViewController : UIViewController

@property(nonatomic,strong) MessageBoardInfo *messageBoardInfo;
@property (nonatomic) BOOL bIsEdit;

@end
