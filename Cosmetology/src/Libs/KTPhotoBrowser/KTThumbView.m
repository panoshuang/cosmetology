//
//  KTThumbView.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbView.h"
#import "KTThumbsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageDownloader.h"
#import "ImageDownloadReceiver.h"


@implementation KTThumbView

@synthesize controller = controller_;
@synthesize imageDownloadReceiver;

- (void)dealloc 
{
    [imageDownloadReceiver release];
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame]) {

      [self addTarget:self
               action:@selector(didTouch:)
     forControlEvents:UIControlEventTouchUpInside];
      
      [self setClipsToBounds:YES];

      // If the thumbnail needs to be scaled, it should mantain its aspect
      // ratio.
      [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
   }
   return self;
}

- (void)didTouch:(id)sender 
{
   if (controller_) {
      [controller_ didSelectThumbAtIndex:[self tag]];
   }
}

- (void)setThumbImage:(UIImage *)newImage 
{
  [self setImage:newImage forState:UIControlStateNormal];
}

- (void)setHasBorder:(BOOL)hasBorder
{
   if (hasBorder) {
      self.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.0].CGColor;
      self.layer.borderWidth = 1;
   } else {
      self.layer.borderColor = nil;
   }
}

- (void)setImageWithURL:(NSString *)urlStr placeholderImage:(UIImage *)placeholder{
    if (placeholder){
        [self setImage:placeholder forState:UIControlStateNormal];
    }
    [[ImageDownloader photosDownloader] removeDelegate:imageDownloadReceiver forURL:urlStr];
    [[ImageDownloader photosDownloader] queueImage:urlStr delegate:imageDownloadReceiver];
}

- (void)imageDidDownload:(NSData *)imageData url:(NSString *)url {
    DDetailLog(@"imageDidDownload: %@", url);
    UIImage *resultImage = [UIImage imageWithData:imageData];
    if (resultImage) {
        [self setImage:resultImage forState:UIControlStateNormal] ;
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
}


- (void)imageDownloadFailed:(NSError *)error url:(NSString *)url {
    DDetailLog(@"imageDownloadFailed: %@, %@", url, [error localizedDescription]);
}


@end
