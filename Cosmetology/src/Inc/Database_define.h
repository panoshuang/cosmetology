//
// Created by mijie on 12-7-17.
//
// @数据库路径，表名定义
//

#define DATABASE_PARENT_PATH                           @"Database"
#define DATABASE_PATH                                  @"Database/cosmetology.db"

#pragma mark - MainProductInfo表
#define MAIN_PRODUCT_INFO_TABLE_TABLE_NAME              @"MainProductInfo"
#define MAIN_PRODUCT_INFO_TABLE_PRODUCT_ID              @"productID"
#define MAIN_PRODUCT_INFO_TABLE_NAME                    @"name"
#define MAIN_PRODUCT_INFO_ENABLE                        @"enable"
#define MAIN_PRODUCT_INFO_INDEX                         @"sortIndex"
#define MAIN_PRODUCT_INFO_BG_IMAGE_FILE                 @"bgImageFile"
#define MAIN_PRODUCT_INFO_PREVIEW_IMAGE_FILE            @"previewImageFile"
#define MAIN_PRODUCT_INFO_SUB_ITEM_BTN_IMAGE_NAME       @"subItemBtnImageName"
#define MAIN_PRODDUCT_INFO_SUB_ITEM_BTN_COLOR_TYPE      @"subItemBtnColorType"
#define MAIN_PRODUCT_INFO_PRODUCT_TYPE                  @"productType"//产品类型
#define MAIN_PRODUCT_INFO_CREATE_AT                     @"createAt" //创建时间,不在实体中记录

#pragma mark - SubProductInfo表
#define SUB_PRODUCT_INFO_TABLE_TABLE_NAME               @"subProductInfo"
#define SUB_PRODUCT_INFO_TABLE_PRODUCT_ID               @"productID"
#define SUB_PRODUCT_INFO_TABLE_MAIN_PRODUCT_ID          @"mainProductID"
#define SUB_PRODUCT_INFO_TABLE_NAME                     @"name"
#define SUB_PRODUCT_INFO_TABLE_ENABLE                   @"enable"
#define SUB_PRODUCT_INFO_TABLE_INDEX                    @"sortIndex"
#define SUB_PRODUCT_INFO_TABLE_PRICE_IMAGE_FILE         @"priceImageFile"
#define SUB_PRODUCT_INFO_TABLE_PREVIEW_FILE             @"previewImageFile"

#pragma mark - AdPhotoInfo表
#define AD_PHOTO_INFO_TABLE_TABLE_NAME                  @"adPhotoInfo"
#define AD_PHOTO_INFO_TABLE_PHOTO_ID                    @"photoID"
#define AD_PHOTO_INFO_TABLE_SUB_PRODUCT_ID              @"subProductID"
#define AD_PHOTO_INFO_TABLE_INDEX                       @"sortIndex"
#define AD_PHOTO_INFO_TABLE_IMAGE_FILE_PATH              @"imageFilePath"
#define AD_PHOTO_INFO_TABLE_HAD_VEDIO                   @"hadVedio"
#define AD_PHOTO_INFO_TABLE_VIDIO_FILE_PATH             @"vedioFilePath"
#define AD_PHOTO_INFO_TABLE_CREATE_AT                   @"createAt" 

#pragma mark - MessageBoardInfo表
#define MESSAGE_BOARD_INFO_TABLE_TABLE_NAME             @"messageBoardInfo"
#define MESSAGE_BOARD_INFO_TABLE_MESSAGE_ID             @"messageID"
#define MESSAGE_BOARD_INFO_TABLE_MESSAGE_CONTENT        @"messageContent"
#define MESSAGE_BOARD_INFO_TABLE_MESSAGE_RECORD         @"messageRecord"
#define MESSAGE_BOARD_INFO_TABLE_HEAD_PORTRAITS         @"headPortraits"
#define MESSAGE_BOARD_INFO_TABLE_SINGE_NAME             @"singeName"
#define MESSAGE_BOARD_INFO_TABLE_POPULARITY             @"popularity"
#define MESSAGE_BOARD_INFO_TABLE_SUB_PRODUCT_ID         @"subProductID"
#define MESSAGE_BOARD_INFO_TABLE_CREATE_AT              @"createAt" //创建时间,不在实体中记录










