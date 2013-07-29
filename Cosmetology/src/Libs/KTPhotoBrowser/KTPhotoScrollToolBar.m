//
//  KTPhotoScrollToolBar.m
//  homi
//  @重写KTPhotoScrollViewController的toolBar
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KTPhotoScrollToolBar.h"

@implementation KTPhotoScrollToolBar

@synthesize buttonArray;
@synthesize backGrounpImageView;
@synthesize btnLeft;
@synthesize btnRight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        viBg.image = [UIImage imageNamed:@"photowall_botttom.png"];
        viBg.alpha = .4f;
        [self addSubview:viBg];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //self.backgroundColor = [UIColor redColor];

    viBg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    backGrounpImageView.frame = self.bounds;
    backGrounpImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:backGrounpImageView];

    if (btnLeft || btnRight){
        btnLeft.frame = CGRectMake(kCommonSpaceSmall, (self.frame.size.height - kToolBtnBackHeight)/2, kToolBtnSmallWidth, kToolBtnBackHeight);
        [self addSubview:btnLeft];

        btnRight.frame = CGRectMake(self.bounds.size.width - kCommonSpaceSmall - kToolBtnSmallWidth, (self.frame.size.height - kToolBtnBackHeight)/2, kToolBtnSmallWidth, kToolBtnBackHeight);
        [self addSubview:btnRight];
        return;
    }
    int itemCount = [buttonArray count];
    CGFloat fSpace = (self.bounds.size.width - kPhotoBrowerToolBarHight * itemCount) / (itemCount+1);
    for (int i = 0; i < itemCount; i++)
    {
        UIButton *button = [buttonArray objectAtIndex:i];
        button.frame = CGRectMake(fSpace * (i + 1) + kPhotoBrowerToolBarHight*i, 2, kPhotoBrowerToolBarHight * 2, kPhotoBrowerToolBarHight);
        [self addSubview:button];
    }
}

-(void)dealloc{
    [viBg release];
    [buttonArray release];
    [backGrounpImageView release];
    [btnLeft release];
    [btnRight release];
    [super dealloc];
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
