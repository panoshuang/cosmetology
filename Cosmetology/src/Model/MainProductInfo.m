//
// Created by mijie on 13-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainProductInfo.h"


@implementation MainProductInfo {

}
@synthesize productID;
@synthesize name;
@synthesize enable;
@synthesize index;
@synthesize bgImageFile;
@synthesize previewImageFile;
@synthesize subItemBtnImageName;
@synthesize colorType;
@synthesize productType;

-(id)init{
    self = [super init];
    if (self) {
        name = @"";
        bgImageFile = @"";
        previewImageFile = @"";
        subItemBtnImageName = @"";
    }
    return self;
}


@end