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
   KTPhotoScrollViewController *scroller_;
   NSInteger index_;
   ImageDownloadReceiver *imageDownloadReceiver;
    UIView *progressBackgroundView;
    UIProgressView *progressBar;
    UILabel * progressLabel;
    BOOL isImageShoulFill;
}


@property (nonatomic, assign) KTPhotoScrollViewController *scroller;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic , retain)     ImageDownloadReceiver *imageDownloadReceiver;

- (void)setImage:(UIImage *)newImage;
- (void)turnOffZoom;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

- (void)setImageWithURL:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;
@end
