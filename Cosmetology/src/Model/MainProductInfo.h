//
// Created by mijie on 13-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TypeDef.h"


@interface MainProductInfo : NSObject
{
    int productID;
    NSString *name;
    BOOL enable;
    
    int  index; //排序索引
    NSString *bgImageFile; //背景图片
    NSString *previewImageFile; //预览图片
    NSString *subItemBtnImageName; //子产品的按钮图片
    EnumSubBtnColorType colorType;
    EnumProductType productType;
}
@property(nonatomic) int productID;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) BOOL enable;
@property(nonatomic) int index;
@property(nonatomic,strong) NSString *bgImageFile;
@property(nonatomic,strong) NSString *previewImageFile;
@property(nonatomic,strong) NSString *subItemBtnImageName;
@property(nonatomic) EnumSubBtnColorType colorType;
@property(nonatomic) EnumProductType productType;


@end