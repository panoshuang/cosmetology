/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import <UIKit/UIKit.h>

/**
 * Convenience methods to help with resizing images retrieved from the 
 * ObjectiveFlickr library.
 */
@interface UIImage (UIImageExtras)

- (UIImage *)mirror;
- (UIImage *)addImageReflection:(CGFloat)reflectionFraction;
- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)rescaleImageToSize2:(CGSize)size;
- (UIImage *)rescaleImageToSize3:(CGSize)size;
//放大缩小图片的大小
-(UIImage *)rescaleImageToAspect:(CGFloat)aspect;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
//按比例计算裁剪大小,比例为宽/高
- (CGSize)calculateNewSizeForAspect:(CGFloat)aspect;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;
//
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

//没有采取缓存加载bundle图片,
//@para:imageName必须包含后缀名
+(UIImage *)loadImageFromBundleWithNoCacheNoAutoRetina:(NSString *)imageName;

//没有采取缓存加载bundle图片,不自动识别@2x图片
+(UIImage *)loadImageFromBundleWithNoCacheNoAutoRetina:(NSString *)imageName type:(NSString *)type;

//没有采取缓存加载bundle图片,自动识别@2x图片
//@para:imageName必须包含后缀名
+(UIImage *)loadImageFromBundleWithNoCache:(NSString *)imageName;

//没有采取缓存加载bundle图片,自动识别@2x图片
+(UIImage *)loadImageFromBundleWithNoCache:(NSString *)imageName type:(NSString *)type;

@end