//
//  SubCatalogItem.h
//  Cosmetology
//
//  Created by mijie on 13-6-3.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@protocol MainCatalogItemDelegate;

@interface SubCatalogItem : UIView

@property (nonatomic, strong) UIImageView *ivBg;
@property (nonatomic ,strong) FXLabel  *lbName;
@property (nonatomic ,strong) UISwitch *swEdit;
@property (nonatomic ,strong) UIButton *btnEdit;
@property (nonatomic )   BOOL      bIsEdit;
@property (nonatomic ,weak) id<MainCatalogItemDelegate> delegate;

-(void)setEdit:(BOOL)isEdit;

@end

@protocol MainCatalogItemDelegate <NSObject>

-(void)mainCatalogItemDidSwitch:(SubCatalogItem *)catalogItem value:(BOOL)isOpen;

-(void)subCatalogItemEdit;

@end
