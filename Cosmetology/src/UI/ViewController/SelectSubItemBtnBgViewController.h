//
//  SelectSubItemBtnBgViewController.h
//  Cosmetology
//
//  Created by mijie on 13-6-12.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeDef.h"

@protocol SelectSubItemBtnBgViewControllerDelegate;

@interface SelectSubItemBtnBgViewController : UIViewController

@property (nonatomic,weak) id<SelectSubItemBtnBgViewControllerDelegate> delegate;

@end

@protocol SelectSubItemBtnBgViewControllerDelegate <NSObject>

-(void)selectSubItemBtnBgViewController:(SelectSubItemBtnBgViewController *)controller didSelectImageName:(NSString *)imageName colorType:(EnumSubBtnColorType)colorType;

@end
