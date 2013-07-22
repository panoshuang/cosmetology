//
//  KTPhotoView.h
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPhotoScrollViewController;
@class ImageDownloadReceiver;
@class KDGoalBar;


@interface KTPhotoView : UIScrollView <UIScrollViewDelegate>
{
   UIImageView *imageView_;
   NSInteger index_;
   ImageDownloadReceiver *imageDownloadReceiver;
    UIView *progressBackgroundView;
    UIProgressView *progressBar;
    UILabel * progressLabel;
    UIButton *vedioBtn;
    BOOL isShowVedioBtn;
    BOOL isImageShoulFill;
    
}


@property (nonatomic, weak) KTPhotoScrollViewController *scroller;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,strong) UIButton *vedioBtn;

- (void)setImage:(UIImage *)newImage;
- (void)turnOffZoom;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

- (void)setImageWithURL:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;

-(void)showOrHideVedioBtn:(BOOL)isShow;
@end
