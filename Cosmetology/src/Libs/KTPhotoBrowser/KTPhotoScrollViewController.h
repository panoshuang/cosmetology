//
//  KTPhotoScrollViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPhotoScrollToolBar.h"
#import "KTPhotoScrollTitleBar.h"


@protocol KTPhotoBrowserDataSource;


@interface KTPhotoScrollViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>
{
    id <KTPhotoBrowserDataSource> dataSource_;
    UIScrollView          *scrollView_;
    KTPhotoScrollTitleBar *titlebar_;
    KTPhotoScrollToolBar  *toolbar_;
    NSUInteger startWithIndex_;
    NSInteger  currentIndex_;
    NSInteger  photoCount_;

    NSMutableArray *photoViews_;

    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int     firstVisiblePageIndexBeforeRotation_;
    CGFloat percentScrolledIntoFirstVisiblePage_;

    UIStatusBarStyle statusBarStyle_;

    BOOL statusbarHidden_; // Determines if statusbar is hidden at initial load. In other words, statusbar remains hidden when toggling chrome.
    BOOL isChromeHidden_;
    // BOOL rotationInProgress_;

    BOOL viewDidAppearOnce_;
    BOOL navbarWasTranslucent_;

    NSTimer *chromeHideTimer_;

    UIBarButtonItem *nextButton_;
    UIBarButtonItem *previousButton_;
}

@property (nonatomic, assign) UIStatusBarStyle               statusBarStyle;
@property (nonatomic, assign, getter=isStatusbarHidden) BOOL statusbarHidden;
@property (nonatomic, readonly) KTPhotoScrollToolBar  *toolbar;
@property (nonatomic, readonly) KTPhotoScrollTitleBar *titleBar;

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index;

- (void)setScrollViewContentSize;

- (void)toggleChromeDisplay;


- (void)deleteCurrentPhoto;

- (void)setCurrentIndex:(NSInteger)newIndex;

- (void)toggleChrome:(BOOL)hide;

- (void)startChromeDisplayTimer;

- (void)cancelChromeDisplayTimer;

- (void)hideChrome;

- (void)showChrome;

//- (void)swapCurrentAndNextPhotos;
- (void)nextPhoto;

- (void)previousPhoto;

- (void)toggleNavButtons;

- (CGRect)frameForPagingScrollView;

- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)loadPhoto:(NSInteger)index;

- (void)unloadPhoto:(NSInteger)index;

- (void)trashPhoto;

- (void)exportPhoto;

//播放视屏
-(void)playVedio:(UIButton *)vedioBtn;
@end
