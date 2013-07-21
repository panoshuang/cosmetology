/*********************************************************************
 *  文件: microView
 *  项目: Homi
 *  文件描述:录音时候显示音量的view
 *  Created by huangsp on 13-1-14.
 *  Copyright (C) 2013, 广州米捷网络科技有限公司
 **********************************************************************/



#import <Foundation/Foundation.h>


@interface MicroView : UIView {
    UIImageView *levelImageView;
    int level;
}
@property(nonatomic, retain) UIImageView *levelImageView;
@property(nonatomic) int level;

-(void)setVolumeLevel:(int)aLevel;

-(void)showMicroViewAtView:(UIView *)aSuperView;


@end