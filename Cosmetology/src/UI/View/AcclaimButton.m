//
//  AcclaimButton.m
//  Cosmetology
//
//  Created by mijie on 13-7-20.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "AcclaimButton.h"

@implementation AcclaimButton

@synthesize ivBg = _ivBg;
@synthesize lbCount = _lbCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ivBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lbCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbCount.textColor = [UIColor whiteColor];
        _lbCount.font = [UIFont fontWithName:@"Courier-Oblique" size:30];
        _lbCount.backgroundColor = [UIColor clearColor];
        [self addSubview:_ivBg];
        [self addSubview:_lbCount];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _ivBg.frame = self.bounds;
    
    CGRect labelFrame = CGRectMake(127, 15, self.bounds.size.width - 127 - kCommonSpaceBig, self.bounds.size.height - 20);
    _lbCount.frame = labelFrame;
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
