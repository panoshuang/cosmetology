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
@synthesize vedioURL;


-(id)init{
    self = [super init];
    if (self) {
        vedioURL = @"";
    }
    return self;
}
@end
