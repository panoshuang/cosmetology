//
//  SubProductInfo.m
//  Cosmetology
//
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "SubProductInfo.h"

@implementation SubProductInfo

@synthesize productID;
@synthesize mainProductID;
@synthesize name;
@synthesize enable;
@synthesize index;
@synthesize priceImageFilePath;
@synthesize previewImageFilePath;


-(id)init{
    self = [super init];
    if (self) {
        previewImageFilePath = @"";
        priceImageFilePath = @"";
    }
    return self;
}
@end
