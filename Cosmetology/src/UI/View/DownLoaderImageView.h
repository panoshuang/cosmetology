//DownLoaderImageView   create by mijie on 12-7-26
//************************************
//@文件描述：异步下载的ImageView
//***********************************


#import <Foundation/Foundation.h>

@protocol DownLoaderImageViewDelegate;

@interface DownLoaderImageView : UIView{
    UIImageView *imageView;
    UIImage *image;
    UIImage *defaultImage;
    UIImage *downFailedImage;
    NSString *imageUrl;
    id<DownLoaderImageViewDelegate> downLoaderImageViewDelegate;
    BOOL isFinishDownload;
    BOOL isDownloading;
    BOOL isDownloadFailed;
    BOOL isCancelDownload;
    BOOL isRenderSny; //是否同步加载

}

@property (nonatomic , retain)     UIImageView *imageView;
@property (nonatomic , retain)     UIImage *image;
@property (nonatomic , retain)     UIImage *defaultImage;
@property (nonatomic , retain)     UIImage *downFailedImage;
@property (nonatomic , retain)     NSString *imageUrl;
@property (nonatomic, assign)      id<DownLoaderImageViewDelegate> downLoaderImageViewDelegate;
@property (nonatomic) BOOL                                         isFinishDownload;
@property (nonatomic) BOOL                                         isDownloading;
@property (nonatomic) BOOL isDownloadFailed;
@property(nonatomic) BOOL isRenderSny;      //是否是在主线程中加载图片



@end

@protocol DownLoaderImageViewDelegate  <NSObject>
 @optional
-(void)imageDidDownLoad:(DownLoaderImageView *)downLoaderImageView;
-(void)imageDownloadFailed:(DownLoaderImageView *)downLoaderImageView;

@end