//
//  CustomGridViewCell.m
//  Cosmetology
//
//  Created by mijie on 13-6-2.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "CustomGridViewCell.h"

@implementation CustomGridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//    _contentView.userInteractionEnabled = !editing;
//    [self shakeStatus:editing];
    

            self.deleteButton.alpha = editing ? 1.f : 0.f;
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
