//
//  KTPhotoView.m
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KTPhotoView.h"
#import "KTPhotoScrollViewController.h"
#import "DeviceHelper.h"



@interface KTPhotoView (KTPrivateMethods)
- (void)loadSubviewsWithFrame:(CGRect)frame;
- (BOOL)isZoomed;
- (void)toggleChromeDisplay;
@end

@implementation KTPhotoView

@synthesize scroller = scroller_;
@synthesize index = index_;

- (void)dealloc 
{
    DDetailLog(@"");
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      [self setDelegate:self];
      [self setMaximumZoomScale:5.0];
      [self setShowsHorizontalScrollIndicator:YES];
      [self setShowsVerticalScrollIndicator:YES];
      [self loadSubviewsWithFrame:frame];
       self.clipsToBounds = YES;
   }
   return self;
}

- (void)loadSubviewsWithFrame:(CGRect)frame
{
   imageView_ = [[UIImageView alloc] initWithFrame:frame];
   [imageView_ setContentMode:UIViewContentModeScaleAspectFill];
   [self addSubview:imageView_];
}


- (void)setImage:(UIImage *)newImage 
{
    [progressBackgroundView removeFromSuperview];
    progressBackgroundView = nil;
   [imageView_ setImage:newImage];
}

-(void)setImageViewFrame{
    CGSize imageSize = imageView_.image.size;
    CGFloat minWidth = 0;
    CGFloat maxWidth = 0;
    CGFloat minHeight  = 0 ;
    CGFloat maxHeight = 0;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    minWidth  = 200*2;
    maxWidth  = screenBounds.size.width*2;
    minHeight = 300*2;
    maxHeight = screenBounds.size.height*2;

    if ((minWidth < imageSize.width && maxWidth > imageSize.width) && (minHeight<imageSize.height && maxHeight >imageSize.height)){
        //需要放大
        isImageShoulFill = YES;
        CGFloat imageWidth = imageView_.image.size.width;
        CGFloat imageHeight = imageView_.image.size.height;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat b = imageWidth/(screenSize.width) < imageHeight/(screenSize.height)?imageWidth/(screenSize.width):imageHeight/(screenSize.height);
        CGRect  frame = imageView_.frame;
        frame.size.height = imageHeight/b;
        frame.size.width = imageWidth/b;
        imageView_.frame = frame;
        imageView_.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    } else{
        isImageShoulFill = NO;
    }
}

- (void)layoutSubviews 
{
   [super layoutSubviews];
    if (progressBackgroundView){
        progressBackgroundView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) ;
    }

   if ([self isZoomed] == NO && CGRectEqualToRect([self bounds], [imageView_ frame]) == NO && !isImageShoulFill) {
      [imageView_ setFrame:[self bounds]];
//       [self setImageViewFrame];
   }
}

- (void)toggleChromeDisplay
{
   if (scroller_) {
      [scroller_ toggleChromeDisplay];
   }
}

- (BOOL)isZoomed
{
   return !([self zoomScale] == [self minimumZoomScale]);
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{
   
   CGRect zoomRect;
   
   // the zoom rect is in the content view's coordinates. 
   //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
   //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
   zoomRect.size.height = [self frame].size.height / scale;
   zoomRect.size.width  = [self frame].size.width  / scale;
   
   // choose an origin so as to get the right center.
   zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
   zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
   
   return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location
{
   float newScale;
   CGRect zoomRect;
   if ([self isZoomed]) {
      zoomRect = [self bounds];
   } else {
      newScale = [self maximumZoomScale];
      zoomRect = [self zoomRectForScale:newScale withCenter:location];
   }
   
   [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom
{
   if ([self isZoomed]) {
      [self zoomToLocation:CGPointZero];
   }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{

    DDetailLog(@"%@", self);
   UITouch *touch = [touches anyObject];
   
   if ([touch view] == self) {
      if ([touch tapCount] == 2) {
         [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleChromeDisplay) object:nil];
         [self zoomToLocation:[touch locationInView:self]];
      }
   }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    DDetailLog(@"%@", self);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DDetailLog(@"%@", self);
   UITouch *touch = [touches anyObject];
   isImageShoulFill = NO;
   if ([touch view] == self) {
      if ([touch tapCount] == 1) {
         [self performSelector:@selector(toggleChromeDisplay) withObject:nil afterDelay:0.5];
      }
   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
   UIView *viewToZoom = imageView_;
   return viewToZoom;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    isImageShoulFill = NO;
    DDetailLog(@"%@",self);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    DDetailLog(@"%@",self);
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

- (void)setMaxMinZoomScalesForCurrentBounds
{
   CGSize boundsSize = self.bounds.size;
   CGSize imageSize = imageView_.bounds.size;
   
   // calculate min/max zoomscale
   CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
   CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
   CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
   
   // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
   // maximum zoom scale to 0.5.
   CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
   
   // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
   if (minScale > maxScale) {
      minScale = maxScale;
   }
   
   self.maximumZoomScale = maxScale;
   self.minimumZoomScale = minScale;
}

// returns the center point, in image coordinate space, to try to restore after rotation. 
- (CGPoint)pointToCenterAfterRotation
{
   CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
   return [self convertPoint:boundsCenter toView:imageView_];
}

// returns the zoom scale to attempt to restore after rotation. 
- (CGFloat)scaleToRestoreAfterRotation
{
   CGFloat contentScale = self.zoomScale;
   
   // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
   // allowable scale when the scale is restored.
   if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
      contentScale = 0;
   
   return contentScale;
}

- (CGPoint)maximumContentOffset
{
   CGSize contentSize = self.contentSize;
   CGSize boundsSize = self.bounds.size;
   return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
   return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{    
   // Step 1: restore zoom scale, first making sure it is within the allowable range.
   self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
   
   
   // Step 2: restore center point, first making sure it is within the allowable range.
   
   // 2a: convert our desired center point back to our own coordinate space
   CGPoint boundsCenter = [self convertPoint:oldCenter fromView:imageView_];
   // 2b: calculate the content offset that would yield that center point
   CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
                                boundsCenter.y - self.bounds.size.height / 2.0);
   // 2c: restore offset, adjusted to be within the allowable range
   CGPoint maxOffset = [self maximumContentOffset];
   CGPoint minOffset = [self minimumContentOffset];
   offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
   offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
   self.contentOffset = offset;
}



@end
