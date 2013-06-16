//
//  KTThumbView.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTThumbsViewController;

@class ImageDownloadReceiver;

@interface KTThumbView : UIButton 
{
@private
   KTThumbsViewController *controller_;

   ImageDownloadReceiver *imageDownloadReceiver;
}

@property (nonatomic, assign) KTThumbsViewController *controller;
@property (nonatomic , retain)ImageDownloadReceiver *imageDownloadReceiver;


- (id)initWithFrame:(CGRect)frame;
- (void)setThumbImage:(UIImage *)newImage;
- (void)setHasBorder:(BOOL)hasBorder;

- (void)setImageWithURL:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;

@end

