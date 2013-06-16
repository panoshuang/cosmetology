//
//  KTPhotoScrollToolBar.h
//  homi
//  @重写KTPhotoScrollViewController的toolBar
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTPhotoScrollToolBar : UIView{
    UIImageView *viBg;
    NSArray *buttonArray;
    UIImageView *backGrounpImageView;
    UIButton *btnLeft;
    UIButton *btnRight;
}
@property (nonatomic,retain) NSArray *buttonArray;
@property (nonatomic,retain) UIImageView *backGrounpImageView;
@property (nonatomic,retain) UIButton *btnLeft;
@property (nonatomic, retain)UIButton *btnRight;
@end
