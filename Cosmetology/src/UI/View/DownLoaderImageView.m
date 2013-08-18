//${FILENAME}   create by mijie on 12-7-26
//************************************
//@文件描述：异步下载的ImageView
//***********************************

#import "DownLoaderImageView.h"
#import "UIImageExtras.h"
#import "ResourceCache.h"


@implementation DownLoaderImageView

@synthesize imageView;
@synthesize image;
@synthesize defaultImage;
@synthesize downFailedImage;
@synthesize imageUrl;
@synthesize downLoaderImageViewDelegate;
@synthesize isFinishDownload;
@synthesize isDownloading;
@synthesize isDownloadFailed;
@synthesize isRenderSny;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.autoresizesSubviews = YES;
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        if (!image){
//            defaultImage = [[UIImage imageNamed:@"defaultBg"] retain];
//            image = [defaultImage retain];
//            imageView.image = defaultImage;
        }
        [self addSubview:imageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    imageView.image = image;
    imageView.frame = self.bounds;
}



-(void)dealloc
{
    [imageView release];
    [image release];
    [defaultImage release];
    [imageUrl release];
    self.downFailedImage = nil;
    [super dealloc];
}


-(void)setImageUrl:(NSString *)anImageUrl
{
    [anImageUrl retain];
    if (anImageUrl == nil){
        imageView.image = defaultImage;
        [imageUrl release];
        imageUrl = nil;
        return;
    }
    if (([anImageUrl isEqualToString:imageUrl] && (isFinishDownload || isDownloading))){
        [anImageUrl release];
        return;
    }
    else
    {
        isCancelDownload = NO;
        isDownloading = YES;
        isFinishDownload = NO;
        [imageUrl release];
        imageUrl = anImageUrl;
        //后台加载
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downLoadImageOnBg:imageUrl];
        });
    }
}

-(void)downLoadImageOnBg:(NSString *)imageFile{
    UIImage *resultImage = [[ResourceCache instance] imageForCachePath:imageFile];
    if (resultImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([imageFile isEqualToString:self.imageUrl] && !isCancelDownload) {
                [image release];
                image = [resultImage retain];
                self.imageView.image = image;
                isDownloading = NO;
                isFinishDownload = YES;
            }
            if (downLoaderImageViewDelegate){
                if ([downLoaderImageViewDelegate respondsToSelector:@selector(imageDidDownLoad:)]) {
                    [downLoaderImageViewDelegate imageDidDownLoad:self];
                }
            }
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
                [downLoaderImageViewDelegate imageDownloadFailed:self];
        });
    }
}

-(void)setDefaultImage:(UIImage *)aDefaultImage
{
    if (aDefaultImage == defaultImage)
        return;
    else{
        [aDefaultImage retain];
        [defaultImage release];
        defaultImage = aDefaultImage;
        imageView.image = defaultImage;
    }
}

-(void)setImage:(UIImage *)anImage
{
    if (anImage == image){
        return;
    }
    else{
        if(imageUrl){
            [imageUrl release];
            imageUrl = nil;
        }
        isCancelDownload = YES;
        [anImage retain];
        [image release];
        image = anImage;
        imageView.image = image;
        //[self performSelectorInBackground:@selector(reScaleImage:) withObject:image];
    }
}

//- (void)imageDidDownload:(NSData *)imageData url:(NSString *)url {
////    DDetailLog(@"%@",self);
//    //判断是否已经取消下载
//    if([imageUrl isEqualToString:url]){
//        UIImage *resultImage = [UIImage imageWithData:imageData];
//        if (isRenderSny){
//            if (resultImage){
//                CGSize rescaleSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
//                resultImage = [resultImage rescaleImageToSize:rescaleSize];
//                if (resultImage) {
//                    [resultImage retain];
//                    [image release];
//                    image = resultImage;
//                    imageView.image = image;
//                }else{
//                    self.image = (self.downFailedImage == nil ? [HomiUtil defaultImageForDownloadFail] : self.downFailedImage);
//                }
//                if (downLoaderImageViewDelegate){
//                    if ([downLoaderImageViewDelegate respondsToSelector:@selector(imageDidDownLoad:)]) {
//                        [downLoaderImageViewDelegate imageDidDownLoad:self];
//                    }
//                }
//                isDownloading = NO;
//                isFinishDownload = YES;
//            }else{
//                self.image = (self.downFailedImage == nil ? [HomiUtil defaultImageForDownloadFail] : self.downFailedImage);
//            }
//        }else{
//            [self performSelectorInBackground:@selector(reScaleImage:) withObject:resultImage];
//        }
//    }
//}
//
//-(void)reScaleImage:(UIImage *)aimage{
////    DDetailLog(@"%@ ",self);
//    @autoreleasepool
//    {
//        CGSize rescaleSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
//        UIImage *resultImage = [aimage rescaleImageToSize:rescaleSize];
//        [self performSelectorOnMainThread:@selector(afterRescaleImage:) withObject:resultImage waitUntilDone:NO];
//    }
//
//}
//
//-(void)afterRescaleImage:(UIImage *)aimage{
//    isFinishDownload = YES;
//    isDownloading = NO;
//    if(isCancelDownload){
//
//    }else{
//        if (downLoaderImageViewDelegate){
//            if ([downLoaderImageViewDelegate respondsToSelector:@selector(imageDidDownLoad:)]) {
//                [downLoaderImageViewDelegate imageDidDownLoad:self];
//            }
//        }
//        // Luzj_20120925,增加为空情况的判断
//        if (aimage != nil) {
//            [image release];
//            image = [aimage retain];
//            imageView.image = image;
//        }
//        else {
//            //下载图片失败
//            [image release];
//            image = nil;
//            imageView.image = (self.downFailedImage == nil ? [HomiUtil defaultImageForDownloadFail] : self.downFailedImage);
//        }
//    }
////    DDetailLog(@"%@ ",self);
//}
//
//
//- (void)imageDownloadFailed:(NSError *)error url:(NSString *)url {
//    DlogWithFunName(@"imageDownloadFailed: %@, %@", url, [error localizedDescription]);
//    [downLoaderImageViewDelegate imageDownloadFailed:self];
//    imageView.image = (self.downFailedImage == nil ? [HomiUtil defaultImageForDownloadFail] : self.downFailedImage);
//    isDownloadFailed = YES;
//    isDownloading = NO;
//}


@end