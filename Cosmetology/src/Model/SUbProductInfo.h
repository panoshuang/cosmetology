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
    NSString *priceImageFilePath; //报价图片路径
    NSString *vedioURL;//视频路径
}

@property(nonatomic)int productID;
@property(nonatomic)int mainProductID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic)BOOL enable;
@property(nonatomic) int index;
@property(nonatomic,strong) NSString *priceImageFilePath;
@property(nonatomic,strong) NSString *vedioURL;
@end
