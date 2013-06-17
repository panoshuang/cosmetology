//
//  PhotoScrollViewController.h
//  homi
//  @：照片滑动预览
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KTPhotoScrollViewController.h"
#import "MHImagePickerMutilSelector.h"


@protocol PhotoScrollViewControllerDelegate;


@interface PhotoScrollViewController : KTPhotoScrollViewController <UIAlertViewDelegate, UINavigationControllerDelegate,  UINavigationControllerDelegate,
        MHImagePickerMutilSelectorDelegate>
{
    BOOL _bIsEdit;
    UIPopoverController *_popController;
    int _subProductID;
}

@property (nonatomic, assign) id <PhotoScrollViewControllerDelegate> delegate;
@property (nonatomic) BOOL bIsEdit;
@property(nonatomic) int subProductID;

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index1;

@end


@protocol PhotoScrollViewControllerDelegate <NSObject>

- (void)photoScrollViewController:(PhotoScrollViewController *)photoScrollViewController didDeletePhotoIndex:(int)index;

@end
