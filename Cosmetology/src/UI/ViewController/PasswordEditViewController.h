//
//  PasswordEditViewController.h
//  Cosmetology
//
//  Created by mijie on 13-7-7.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordEditViewController : UIViewController{
    EnumPasswordType _passwordType;
    
}

@property (nonatomic) EnumPasswordType passwordType;

-(id)initWithPasswordType:(EnumPasswordType)aPasswordType;

@end
