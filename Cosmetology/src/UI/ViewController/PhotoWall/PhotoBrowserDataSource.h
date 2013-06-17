//
// Created by mijie on 12-7-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"
#import "AdPhotoInfo.h"


@interface PhotoBrowserDataSource : NSObject <KTPhotoBrowserDataSource>
{
    NSMutableArray *arrPhoto;
}

- (NSMutableArray *)photoList;

- (void)setPhotoList:(NSMutableArray *)arrPhoto;

@end