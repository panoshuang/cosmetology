//
// Created by mijie on 12-7-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhotoBrowserDataSource.h"
#import "KTPhotoView.h"
#import "KTThumbView.h"

#import "PhotoInfo.h"
#import "HomiUtil.h"


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
        [arrPhoto release];
        arrPhoto = tmpArrPhoto;
    }
}

-(void)dealloc
{
    [arrPhoto release];
    [super dealloc];
}

#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos
{
   return [arrPhoto count];
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView
{
    PhotoInfo *photoInfo = [arrPhoto objectAtIndex:index];
    if (photoInfo.isBlock)
    {
        [photoView setImage:[UIImage imageNamed:@"image_block.jpg"]];
    }
    else
    {
        UIImage *placeHolderImage = [HomiUtil imageFromCacheForUrl:photoInfo.smallPhotoUrl];
        if (placeHolderImage == nil)
        {
            placeHolderImage = [UIImage imageNamed:@"photowall_loading.png"];//[HomiUtil defaultContentImage];
        }
        [photoView setImageWithURL:photoInfo.largePhotoUrl placeholderImage:placeHolderImage];
    }
}

- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView
{
    PhotoInfo *photoInfo = [arrPhoto objectAtIndex:index];
    if (photoInfo.isBlock)
    {
        [thumbView setThumbImage:[UIImage imageNamed:@"image_block.jpg"]];
    }
    else
    {
        UIImage *placeHolderImage = [HomiUtil imageFromCacheForUrl:photoInfo.smallPhotoUrl];
        if (placeHolderImage == nil)
        {
            placeHolderImage = [HomiUtil defaultContentImage];
        }
        [thumbView setImageWithURL:photoInfo.smallPhotoUrl placeholderImage:placeHolderImage];
    }
}

- (void)deleteImageAtIndex:(NSInteger)index
{
    [arrPhoto removeObjectAtIndex:index];
}

@end