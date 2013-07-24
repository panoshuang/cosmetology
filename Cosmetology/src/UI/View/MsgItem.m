//
//  MsgItem.m
//  Cosmetology
//
//  Created by mijie on 13-7-20.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MsgItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation MsgItem

@synthesize viContentBg = _viContentBg;
@synthesize ivAutograph = _ivAutograph;
@synthesize btnAcclaim = _btnAcclaim;
@synthesize headPortraits = _headPortraits;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viContentBg = [[UIView alloc] initWithFrame:CGRectZero];
        _viContentBg.backgroundColor = [UIColor blackColor];
        _viContentBg.layer.borderColor = [UIColor yellowColor].CGColor;
        _viContentBg.layer.borderWidth = 1;
        _ivAutograph = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headPortraits = [[UIImageView alloc] initWithFrame:CGRectZero];
        _btnAcclaim = [[AcclaimButton alloc] initWithFrame:CGRectZero];
        [_ivAutograph addSubview:_headPortraits];
        [self addSubview:_viContentBg];
        [self addSubview:_ivAutograph];
        [self addSubview:_btnAcclaim];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect acclaimFrame = CGRectMake(20, self.bounds.size.height - 71, 153, 71);
    _btnAcclaim.frame = acclaimFrame;
    CGRect contentBgFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 5 -acclaimFrame.size.height);
    _viContentBg.frame = contentBgFrame;
    CGRect autographFrame = CGRectMake(5, 5, contentBgFrame.size.width - 10, contentBgFrame.size.height - 10);
    _ivAutograph.frame = autographFrame;
    CGRect headPortraitsFrame = CGRectMake(autographFrame.size.width - 40, 0, 40, 30);
    _headPortraits.frame = headPortraitsFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
