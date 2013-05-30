//
//  AppDelegate.h
//  Cosmetology
//
//  Created by mijie on 13-5-23.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) MainViewController *mainController;

@end
