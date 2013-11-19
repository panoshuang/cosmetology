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
        _ivBg = [[DownLoaderImageView alloc] initWithFrame:self.bounds];
        _ivBg.downLoaderImageViewDelegate = self;
        [self addSubview:_ivBg];
    }
    return self;
}

-(void)imageDidDownLoad:(DownLoaderImageView *)downLoaderImageView{
    [self setNeedsLayout];
}

-(void)imageDownloadFailed:(DownLoaderImageView *)downLoaderImageView{
    DDetailLog(@"下载图片失败");
}

@end
