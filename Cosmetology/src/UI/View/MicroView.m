/*********************************************************************
 *  文件: microView
 *  项目: microView
 *  文件描述:
 *  Created by huangsp on 13-1-14.
 *  Copyright (C) 2013, 广州米捷网络科技有限公司
 **********************************************************************/


#import <QuartzCore/QuartzCore.h>
#import "MicroView.h"


@implementation MicroView {

}
@synthesize levelImageView;
@synthesize level;

-(id)init{
    CGRect bounds = CGRectMake(0, 0, 150, 150);
    self = [super initWithFrame:bounds];
    if (self){
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        CGRect levelImageViewFrame = CGRectMake(0, 0, 55, 105);
        levelImageView = [[UIImageView alloc] initWithFrame:levelImageViewFrame];
        levelImageView.image = [UIImage imageNamed:@"microphone0.png"];
        [self addSubview:levelImageView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    levelImageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

-(void)setVolumeLevel:(int)aLevel{
//    @synchronized (self) {
    DDetailLog(@"setVolumeLevel %d",aLevel);

       if (levelImageView.isAnimating){
           [levelImageView stopAnimating];
       }
        NSMutableArray *animationArray = [NSMutableArray arrayWithCapacity:6];
        if (aLevel < level){
            int beginAnimationLevel = level;
            for (;beginAnimationLevel >= aLevel;beginAnimationLevel--){
                [animationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"microphone%d.png",beginAnimationLevel]]];
            }
        }
        else{
            int beginAnimationLevel = level;
            for (;beginAnimationLevel <= aLevel;beginAnimationLevel++){
                [animationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"microphone%d.png",beginAnimationLevel]]];
            }
        }
        [levelImageView setAnimationImages:animationArray];
        levelImageView.animationDuration = .3;
        [levelImageView startAnimating];
//    }
    level = aLevel;
}

-(void)showMicroViewAtView:(UIView *)aSuperView{
    CGRect superViewBounds = aSuperView.bounds;
     CGPoint centerPoint = CGPointMake(CGRectGetMidX(superViewBounds), CGRectGetMidY(superViewBounds));
    [aSuperView addSubview:self];
    self.center = centerPoint;
}


- (void)dealloc {
    if (levelImageView.isAnimating){
        [levelImageView stopAnimating];
    }
    [levelImageView release];
    [super dealloc];
}


@end