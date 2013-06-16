//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AdPhotoInfo.h"


@interface AdPhotoManager : NSObject

+(AdPhotoManager *)instance;

-(int)addAdPhoto:(AdPhotoInfo *)adPhotoInfoInfo;

-(BOOL)deleteAdPhotoForId:(int)photoInfoId;

-(BOOL)updateAdPhoto:(AdPhotoInfo *)adPhotoInfoInfo;

-(NSArray *)allAdPhotoInfoForSubProductID:(int)subProductID;

-(AdPhotoInfo *)lastAdPhotoInfo;

//为新增类别获取合适的index排序索引
-(int)indexForNewPhoto;

@end