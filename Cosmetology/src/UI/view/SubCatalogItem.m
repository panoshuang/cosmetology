//
//  SubCatalogItem.m
//  Cosmetology
//  @文件说明：主分类列表的分类view
//  Created by mijie on 13-6-3.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "SubCatalogItem.h"

@interface SubCatalogItem (){
    UIImageView *_ivBg;
}

@end

@implementation SubCatalogItem

@synthesize lbName = _lbName;
@synthesize swEdit = _swEdit;
@synthesize bIsEdit = _bIsEdit;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _ivBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivBg.image = [UIImage imageNamed:@"bg_main_catalog.png"];
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbName.textAlignment = UITextAlignmentCenter;
        _lbName.backgroundColor = [UIColor clearColor];
        _swEdit = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_swEdit addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_ivBg];
        [self addSubview:_lbName];
        [self addSubview:_swEdit];
        _swEdit.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect selfBounds = self.bounds;
    CGRect ivBgFrame = CGRectMake(0, 0, 184, 52);
    _ivBg.frame = ivBgFrame;
    _lbName.frame = ivBgFrame;
//    CGRect swEditFrame = CGRectMake(0,
//                                    ivBgFrame.origin.y + ivBgFrame.size.height + kCommonSpace,
//                                    selfBounds.size.width,
//                                    25);
    _swEdit.center = CGPointMake(selfBounds.size.width/2, selfBounds.size.height - 15);
}

-(void)setEdit:(BOOL)isEdit{
    if (isEdit == _bIsEdit) {
        return;
    }else{
        _bIsEdit = isEdit;
        if (_bIsEdit) {
            _swEdit.hidden = NO;
        }else{
            _swEdit.hidden = YES;
        }
    }
}

-(void)switchValueChange:(UISwitch *)sw{
    if ([_delegate respondsToSelector:@selector(mainCatalogItemDidSwitch:value:)]) {
        [_delegate mainCatalogItemDidSwitch:self value:sw.state];
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
