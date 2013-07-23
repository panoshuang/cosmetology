//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
// @: 广告图片实体
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface AdPhotoInfo : NSObject {
    int _photoId;
    int _subProductId;
    int _index;
    NSString *_imageFilePath; //图片保存在缓存
    BOOL _hadVedio;
    NSString *_vedioFilePath;
}
@property(nonatomic) int photoId;
@property(nonatomic) int subProductId;
@property(nonatomic) int index;
@property(nonatomic, strong) NSString *imageFilePath;
@property(nonatomic) BOOL hadVedio;
@property(nonatomic,strong) NSString *vedioFilePath;
@end