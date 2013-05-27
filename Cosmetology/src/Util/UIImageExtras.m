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
#import "UIImageExtras.h"
#import "DeviceHelper.h"


@implementation UIImage (UIImageExtras)

- (UIImage *)mirror
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * 2, self.size.height * 2));

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height * 2);
    CGContextScaleCTM(context, 2.0, -2.0);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)addImageReflection:(CGFloat)reflectionFraction {
	int reflectionHeight = self.size.height * reflectionFraction;
	
    // create a 2 bit CGImage containing a gradient that will be used for masking the 
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = NULL;
	
    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(nil, 1, reflectionHeight,
                                                               8, 0, colorSpace, kCGImageAlphaNone);
    
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointMake(0, reflectionHeight);
    CGPoint gradientEndPoint = CGPointZero;
    
    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
                                gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// add a black fill with 50% opacity
	CGContextSetGrayFillColor(gradientBitmapContext, 0.0, 0.5);
	CGContextFillRect(gradientBitmapContext, CGRectMake(0, 0, 1, reflectionHeight));
    
    // convert the context into a CGImageRef and release the context
    gradientMaskImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);
	
    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGImageRef reflectionImage = CGImageCreateWithMask(self.CGImage, gradientMaskImage);
    CGImageRelease(gradientMaskImage);
	
	CGSize size = CGSizeMake(self.size.width, self.size.height + reflectionHeight);
	
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawAtPoint:CGPointZero];
	CGContextDrawImage(context, CGRectMake(0, self.size.height, self.size.width, reflectionHeight), reflectionImage);
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    CGImageRelease(reflectionImage);
	
	return result;
}

- (UIImage *)rescaleImageToSize:(CGSize)size {
//	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
//	UIGraphicsBeginImageContext(rect.size);
//	[self drawInRect:rect];  // scales image to rect
//	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	return resImage;
    UIImage *sourceImage = self;
   	UIImage *newImage = nil;
   	CGSize imageSize = sourceImage.size;
   	CGFloat width = imageSize.width;
   	CGFloat height = imageSize.height;
   	CGFloat targetWidth = size.width;
   	CGFloat targetHeight = size.height;
   	CGFloat scaleFactor = 0.0;
   	CGFloat scaledWidth = targetWidth;
   	CGFloat scaledHeight = targetHeight;
   	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
   	if (CGSizeEqualToSize(imageSize, size) == NO)
   	{
   		CGFloat widthFactor = targetWidth / width;
   		CGFloat heightFactor = targetHeight / height;
   		if (widthFactor > heightFactor)
   			scaleFactor = widthFactor; // scale to fit height
   		else
   			scaleFactor = heightFactor; // scale to fit width
   		scaledWidth= width * scaleFactor;
   		scaledHeight = height * scaleFactor;
   		// center the image
   		if (widthFactor > heightFactor)
   		{
   			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
   		}
   		else if (widthFactor < heightFactor)
   		{
   			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
   		}
   	}
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0); // this will crop
   	CGRect thumbnailRect = CGRectZero;
   	thumbnailRect.origin = thumbnailPoint;
   	thumbnailRect.size.width= scaledWidth;
   	thumbnailRect.size.height = scaledHeight;
   	[sourceImage drawInRect:thumbnailRect];
   	newImage = UIGraphicsGetImageFromCurrentImageContext();
   	if(newImage == nil)
       DLog(@"rescale image failed");
   	//pop the context to get back to the default
   	UIGraphicsEndImageContext();
   	return newImage;
}

//可以消除锯齿
- (UIImage *)rescaleImageToSize2:(CGSize)size {
	CGRect rect = CGRectMake(0.0, 0.0, size.width + 2, size.height + 2);
	UIGraphicsBeginImageContext(rect.size);
	CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
	CGContextSetFillColor (UIGraphicsGetCurrentContext(),components);
	CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
	rect = CGRectMake(1, 1, size.width, size.height);
	[self drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

- (UIImage *)rescaleImageToSize3:(CGSize)size {
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height + 1);
	UIGraphicsBeginImageContext(rect.size);
	CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
	CGContextSetFillColor (UIGraphicsGetCurrentContext(),components);
	CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
	rect = CGRectMake(0, 1, size.width, size.height);
	[self drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

//放大缩小图片的大小
-(UIImage *)rescaleImageToAspect:(CGFloat)aspect{
    CGSize size;
    size.width = self.size.width * aspect;
    size.height = self.size.height * aspect;
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//用这个方法替代UIGraphicsBeginImageContext(size)
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage*scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)cropImageToRect:(CGRect)cropRect {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

//按比例计算裁剪大小,比例为宽/高
- (CGSize)calculateNewSizeForAspect:(CGFloat)aspect
{
    CGSize result;
    // CGSize oriSize = self.size;
    CGFloat oriAspect = self.size.width/self.size.height;
    if (oriAspect > aspect)
    {
        result.height = self.size.height;
        result.width  = self.size.height * aspect;
    }
    else
    {
        result.width  = self.size.width;
        result.height = self.size.width / aspect;
    }
    return result;
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize {
	UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{

	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
		else
			scaleFactor = heightFactor; // scale to fit width
		scaledWidth= width * scaleFactor;
		scaledHeight = height * scaleFactor;
		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else if (widthFactor < heightFactor)
		{
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	UIGraphicsBeginImageContext(targetSize); // this will crop
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width= scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	[sourceImage drawInRect:thumbnailRect];
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
		NSLog(@"could not scale image");
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}


+(UIImage *)loadImageFromBundleWithNoCacheNoAutoRetina:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

//没有采取缓存加载bundle图片,不自动识别@2x图片
+(UIImage *)loadImageFromBundleWithNoCacheNoAutoRetina:(NSString *)imageName type:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

//没有采取缓存加载bundle图片,自动识别@2x图片
+(UIImage *)loadImageFromBundleWithNoCache:(NSString *)imageName{
    NSString *path = nil;
    UIImage *image;
    if([DeviceHelper isRetina]){
        if([[imageName stringByDeletingPathExtension] hasSuffix:@"@2x"]){
            path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil] ;
            image = [UIImage imageWithContentsOfFile:path];
        }else{
            NSString *sufix = [imageName pathExtension];
            path = [[NSBundle mainBundle] pathForResource:[[[imageName stringByDeletingPathExtension] stringByAppendingString:@"@2x"] stringByAppendingPathExtension:sufix] ofType:nil];
            image = [UIImage imageWithContentsOfFile:path];
            if(image == nil){
                path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil] ;
                image = [UIImage imageWithContentsOfFile:path];
            }
        }
    }else{
        path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        image = [UIImage imageWithContentsOfFile:path];
        if(image == nil){
            if(![[imageName stringByDeletingPathExtension] hasSuffix:@"@2x"]){
                NSString *sufix = [imageName pathExtension];
                path = [[NSBundle mainBundle] pathForResource:[[[imageName stringByDeletingPathExtension] stringByAppendingString:@"@2x"] stringByAppendingPathExtension:sufix] ofType:nil];
                image = [UIImage imageWithContentsOfFile:path];
            }
        }
    }

    return image;
}

//没有采取缓存加载bundle图片,自动识别@2x图片
+(UIImage *)loadImageFromBundleWithNoCache:(NSString *)imageName type:(NSString *)type{
    NSString *path = nil;
    UIImage *image;
    if([DeviceHelper isRetina]){
        path = [[NSBundle mainBundle] pathForResource:[imageName stringByAppendingString:@"@2x"] ofType:type];
        image = [UIImage imageWithContentsOfFile:path];
        if(image == nil){
            path = [[NSBundle mainBundle] pathForResource:imageName ofType:type] ;
            image = [UIImage imageWithContentsOfFile:path];
        }
    }else{
        path = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
        image = [UIImage imageWithContentsOfFile:path];
        if(image == nil){
            path = [[NSBundle mainBundle] pathForResource:[imageName stringByAppendingString:@"@2x"] ofType:type];
            image = [UIImage imageWithContentsOfFile:path];
        }
    }

    return image;
}

@end