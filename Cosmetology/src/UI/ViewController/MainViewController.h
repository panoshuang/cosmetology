//
//  MainViewController.h
//  Cosmetology
//
//  Created by mijie on 13-5-23.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MainDelegate.h"
#import "VideoItem.h"

@interface MainViewController : UIViewController<MainDelegate>

@property(nonatomic,strong)VideoItem *item;

@end
