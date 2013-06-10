//
//  MainCatalogGridViewCell.h
//  Cosmetology
//
//  Created by mijie on 13-6-4.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "GMGridViewCell.h"
#import "SubCatalogItem.h"

@protocol MainCatalogGridViewCellDelegate;

@interface MainCatalogGridViewCell : GMGridViewCell <MainCatalogItemDelegate>

@property (nonatomic,weak) id<MainCatalogGridViewCellDelegate> delegate;

@end


@protocol MainCatalogGridViewCellDelegate <NSObject>

@optional
-(void)mainCatalogGridViewCellDidSwitch:(MainCatalogGridViewCell *)cell value:(BOOL)isOpen;

@end
