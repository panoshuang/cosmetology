//
//  KTPhotoScrollToolBar.m
//  homi
//  @重写KTPhotoScrollViewController的toolBar
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KTPhotoScrollTitleBar.h"

@implementation KTPhotoScrollTitleBar

@synthesize btnBack;
@synthesize lbTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        viBg = [[UIImageView alloc] initWithFrame:self.bounds];
        viBg.backgroundColor = [UIColor clearColor];
        viBg.image = [UIImage imageNamed:@"photowall_top.png"];
        viBg.alpha = .4f;
        [self addSubview:viBg];
        
        lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor whiteColor];
        lbTitle.textAlignment = UITextAlignmentCenter;
        lbTitle.font = [UIFont boldSystemFontOfSize:20];
        lbTitle.text = @"";
        [self addSubview:lbTitle];
        
        btnBack = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [btnBack setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_back_nomal.png"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageNamed:@"btn_photo_brower_toolbar_back_highted.png"] forState:UIControlStateHighlighted];
        [self addSubview:btnBack];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    viBg.frame = self.bounds;
    
    lbTitle.frame = self.bounds;

    btnBack.frame = CGRectMake(kCommonSpace, 0, kPhotoBrowerToolBarHight, kPhotoBrowerToolBarHight);
}

-(void)dealloc{
    [btnBack release];
    [lbTitle release];
    [viBg release];
    
    [super dealloc];
}


@end
