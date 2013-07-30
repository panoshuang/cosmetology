//
//  ViewController.h
//  MessageBoard
//
//  Created by mijie on 06/16/13.
//  Copyright (c) 2013 mijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SubProductInfo.h"
#import "MessageBoardInfo.h"
#import "MyPaletteViewController.h"

@protocol MessageBoardViewControllerDelegate; 
@interface EditMessageViewController : UIViewController<UITextViewDelegate,AVAudioRecorderDelegate,MyPaletteViewControllerDelegate>
{
    __weak id<MessageBoardViewControllerDelegate> _delegate;
    NSInteger _subProductID;
}

@property(nonatomic, weak)id<MessageBoardViewControllerDelegate> delegate;
@property(nonatomic)NSInteger subProductID;
@property (nonatomic) BOOL bIsEdit;

@end

@protocol MessageBoardViewControllerDelegate <NSObject>

-(void)saveMessage:(MessageBoardInfo *)messageBoardInfo forSubProductID:(NSInteger)subProductID;


@end