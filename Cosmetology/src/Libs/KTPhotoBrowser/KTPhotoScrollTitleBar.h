//
//  KTPhotoScrollToolBar.h
//  homi
//  @重写KTPhotoScrollViewController的toolBar
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTPhotoScrollTitleBar : UIView{
    UILabel *lbTitle;
    UIButton *btnBack;
    UIImageView *viBg;
}
@property (nonatomic,retain) UILabel *lbTitle;
@property (nonatomic,retain) UIButton *btnBack;
@end
