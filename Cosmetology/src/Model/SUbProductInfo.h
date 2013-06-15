//
//  SubProductInfo.h
//  Cosmetology
//
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubProductInfo : NSObject
{
    int productID;
    int mainProductID;
    NSString *name;
    BOOL enable;
    int index;
}

@property(nonatomic)int productID;
@property(nonatomic)int mainProductID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic)BOOL enable;
@property(nonatomic) int index;
@end
