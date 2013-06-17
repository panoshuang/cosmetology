//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AdPhotoManager.h"
#import "AdPhotoInfoDao.h"


@implementation AdPhotoManager {

}

SYNTHESIZE_SINGLETON_FOR_CLASS(AdPhotoManager)


-(int)addAdPhoto:(AdPhotoInfo *)adPhotoInfoInfo{
   return [[AdPhotoInfoDao instance] addAdPhotoInfo:adPhotoInfoInfo];
}

-(BOOL)deleteAdPhotoForId:(int)photoInfoId{
   return [[AdPhotoInfoDao instance] deleteAdPhotoForID:photoInfoId];
}

-(BOOL)updateAdPhoto:(AdPhotoInfo *)adPhotoInfoInfo{
   return [[AdPhotoInfoDao instance] updateAdPhoto:adPhotoInfoInfo];
}

-(NSArray *)allAdPhotoInfoForSubProductID:(int)subProductID {
   return [[AdPhotoInfoDao instance] allAdPhotoInfoForSubProductID:subProductID];
}

-(AdPhotoInfo *)lastAdPhotoInfo{
    return [[AdPhotoInfoDao instance] lastAdPhotoInfo];
}

//为新增类别获取合适的index排序索引
-(int)indexForNewPhoto {
    //获取最后插入的一条类别
    AdPhotoInfo *photoInfo = [[AdPhotoInfoDao instance] lastAdPhotoInfo];
    if(!photoInfo) {
        int newIndex = 0;
        return newIndex;
    } else{
        int newIndex = photoInfo.index + 1;
        return newIndex;
    }


}
@end