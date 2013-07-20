//
//  AcclaimButton.h
//  Cosmetology
//
//  Created by mijie on 13-7-20.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcclaimButton : UIControl{
    UIImageView *_ivBg;
    UILabel     *_lbCount;
}

@property (nonatomic,strong)UIImageView *ivBg;
@property (nonatomic,strong)UILabel     *lbCount;

@end
