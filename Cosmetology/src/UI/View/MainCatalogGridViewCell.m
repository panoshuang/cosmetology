//
//  MainCatalogGridViewCell.m
//  Cosmetology
//
//  Created by mijie on 13-6-4.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainCatalogGridViewCell.h"

@implementation MainCatalogGridViewCell

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - MainCatalogItemDelegate

-(void)mainCatalogItemDidSwitch:(SubCatalogItem *)catalogItem value:(BOOL)isOpen{
    if ([_delegate respondsToSelector:@selector(mainCatalogGridViewCellDidSwitch:value:)]) {
        [_delegate mainCatalogGridViewCellDidSwitch:self value:isOpen];
    }
}

-(void)subCatalogItemEdit
{
    if ([_delegate respondsToSelector:@selector(subCatalogGridViewCellDidBtn)]) {
        [_delegate subCatalogGridViewCellDidBtn];
    }
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
