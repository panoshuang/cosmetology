//
//  MainCatalogItem.m
//  Cosmetology
//
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainCatalogItem.h"

@implementation MainCatalogItem

@synthesize ivBg = _ivBg;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _ivBg = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_ivBg];
    }
    return self;
}

@end
