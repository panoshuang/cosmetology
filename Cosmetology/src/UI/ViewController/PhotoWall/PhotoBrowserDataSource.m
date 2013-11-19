//
// Created by mijie on 12-7-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhotoBrowserDataSource.h"
#import "KTPhotoView.h"
#import "KTThumbView.h"

#import "AdPhotoInfo.h"
#import "ResourceCache.h"
#import "FileUtil.h"


@implementation PhotoBrowserDataSource

- (NSMutableArray *)photoList
{
    return arrPhoto;
}

-(void)setPhotoList:(NSMutableArray *)arrNewPhoto;
{
    if (arrNewPhoto == arrPhoto)
    {
        return;
    }
    else
    {
        NSMutableArray *tmpArrPhoto =  [arrNewPhoto mutableCopy];
        arrPhoto = tmpArrPhoto;
    }
}

-(void)dealloc
{
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos
{
   return [arrPhoto count];
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView
{
    AdPhotoInfo *photoInfo = [arrPhoto objectAtIndex:index];
    [photoView setImage:[[ResourceCache instance] imageForCachePath:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:photoInfo.imageFilePath]]];

}

- (BOOL)isVedioItemAtIndex:(NSInteger)index{
    AdPhotoInfo *photoInfo = [arrPhoto objectAtIndex:index];
    return photoInfo.hadVedio;
}

- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView
{
    AdPhotoInfo *photoInfo = [arrPhoto objectAtIndex:index];
    [thumbView setThumbImage:[[ResourceCache instance] imageForCachePath:[[FileUtil getDocumentDirectory] stringByAppendingPathComponent:photoInfo.imageFilePath]]];
}

- (void)deleteImageAtIndex:(NSInteger)index
{
    [arrPhoto removeObjectAtIndex:index];
}

@end