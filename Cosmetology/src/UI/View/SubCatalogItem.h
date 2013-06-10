//
//  SubCatalogItem.h
//  Cosmetology
//
//  Created by mijie on 13-6-3.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainCatalogItemDelegate;

@interface SubCatalogItem : UIView

@property (nonatomic ,strong) UILabel  *lbName;
@property (nonatomic ,strong) UISwitch *swEdit;
@property (nonatomic )   BOOL      bIsEdit;
@property (nonatomic ,weak) id<MainCatalogItemDelegate> delegate;

-(void)setEdit:(BOOL)isEdit;

@end

@protocol MainCatalogItemDelegate <NSObject>

-(void)mainCatalogItemDidSwitch:(SubCatalogItem *)catalogItem value:(BOOL)isOpen;
@end
