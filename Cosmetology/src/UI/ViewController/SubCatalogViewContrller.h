 //
//  MainCatalogViewContrller.h
//  Cosmetology
//
//  Created by mijie on 13-6-2.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainDelegate.h"

@class GMGridView;
@protocol SubCatalogViewControllerDelegate;
@protocol MainDelegate;


@interface SubCatalogViewContrller : UIViewController{
    __weak id<SubCatalogViewControllerDelegate> _delegate;
    __weak id<MainDelegate> _mainDelegate;
    BOOL _bIsEdit;
}

@property (nonatomic,weak) id<SubCatalogViewControllerDelegate> delegate;
@property (nonatomic,weak) id<MainDelegate> mainDelegate;
@property (nonatomic) BOOL bIsEdit;
@property (nonatomic,strong) UIImageView *ivBg;
@property (nonatomic,strong) GMGridView *gmGridView;

@end

@protocol SubCatalogViewControllerDelegate <NSObject>

-(void)subCatalogViewController:(SubCatalogViewContrller *)maiCatalogViewController didSelectCatalogID:(int)catalogID;

@end
