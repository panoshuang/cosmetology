//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AdPhotoInfo.h"


@interface AdPhotoInfoDao : NSObject

+(AdPhotoInfoDao *)instance;

-(int)addAdPhotoInfo:(AdPhotoInfo *)subProductInfo;

- (BOOL)deleteAdPhotoForID:(int)productID;

-(BOOL)updateAdPhoto:(AdPhotoInfo *)subProductInfo;

-(NSArray *)allAdPhotoInfoForSubProductID:(int)subProductID;

-(AdPhotoInfo *)lastAdPhotoInfo;

@end