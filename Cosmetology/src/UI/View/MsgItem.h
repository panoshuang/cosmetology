//
//  MsgItem.h
//  Cosmetology
//
//  Created by mijie on 13-7-20.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcclaimButton.h"

@interface MsgItem : UIView{
    UIView *_viContentBg;
    UIImageView *_ivAutograph;
    AcclaimButton *_btnAcclaim;
    UIImageView *_headPortraits;
}

@property (nonatomic,strong) UIView *viContentBg;
@property (nonatomic,strong) UIImageView *ivAutograph;
@property (nonatomic,strong) AcclaimButton *btnAcclaim;
@property (nonatomic,strong) UIImageView *headPortraits;

@end
