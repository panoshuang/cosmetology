//
//  PhotoScrollViewController.h
//  homi
//  @：照片滑动预览
//  Created by mijie on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KTPhotoScrollViewController.h"
#import "PhotoAlbumInfo.h"


@protocol PhotoScrollViewControllerDelegate;


@interface PhotoScrollViewController : KTPhotoScrollViewController <UIAlertViewDelegate, UINavigationControllerDelegate>
{
    NSString *userID;
    id <PhotoScrollViewControllerDelegate> delegate;
    UIActionSheet *actionSheet;
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, assign) id <PhotoScrollViewControllerDelegate> delegate;

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index1;

@end


@protocol PhotoScrollViewControllerDelegate <NSObject>

- (void)photoScrollViewController:(PhotoScrollViewController *)photoScrollViewController didDeletePhotoIndex:(int)index;

@end
