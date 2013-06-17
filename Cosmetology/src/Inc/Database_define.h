//
// Created by mijie on 12-7-17.
//
// @数据库路径，表名定义
//

#define DATABASE_PARENT_PATH       @"Database"
#define DATABASE_PATH              @"Database/cosmetology.db"

#pragma mark - MainProductInfo表
#define MAIN_PRODUCT_INFO_TABLE_TABLE_NAME       @"MainProductInfo"
#define MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID       @"productID"
#define MAIN_PRODUCT_INFO_TABLE_NAME             @"name"
#define MAIN_PRODUCT_INFO_ENABLE                 @"enable"
#define MAIN_PRODUCT_INFO_INDEX                  @"sortIndex"
#define MAIN_PRODUCT_INFO_BG_IMAGE_FILE          @"bgImageFile"
#define MAIN_PRODUCT_INFO_PREVIEW_IMAGE_FILE     @"previewImageFile"
#define MAIN_PRODUCT_INFO_SUB_ITEM_BTN_IMAGE_NAME @"subItemBtnImageName"
#define MAIN_PRODUCT_INFO_CREATE_AT               @"createAt" //创建时间,不在实体中记录

#pragma mark - SubProductInfo表
#define SUB_PRODUCT_INFO_TABLE_TABLE_NAME       @"subProductInfo"
#define SUB_PRODUCT_INFO_TABLE_PRODUCT_ID       @"productID"
#define SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID  @"mainProductID"
#define SUB_PRODUCT_INFO_TABLE_NAME             @"name"
#define SUB_PRODUCT_INFO_TABLE_ENABLE           @"enable"
#define SUB_PRODUCT_INFO_TABLE_INDEX            @"sortIndex"

#pragma mark - AdPhotoInfo表
#define AD_PHOTO_INFO_TABLE_TABLE_NAME          @"adPhotoInfo"
#define AD_PHOTO_INFO_TABLE_PHOTO_ID            @"photoID"
#define AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID      @"subProductID"
#define AD_PHOTO_INFO_TABLE_INDEX               @"sortIndex"
#define AD_PHOTO_INFO_TABLE_IMAGE_FILE_PATH     @"imageFilePath"




