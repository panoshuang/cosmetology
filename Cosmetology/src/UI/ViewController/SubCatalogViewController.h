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
 @class MainProductInfo;


 @interface SubCatalogViewController : UIViewController{
    __weak id<SubCatalogViewControllerDelegate> _delegate;
    __weak id<MainDelegate> _mainDelegate;
    MainProductInfo *_mainProductInfo;
    BOOL _bIsEdit;
}

@property (nonatomic,weak) id<SubCatalogViewControllerDelegate> delegate;
@property (nonatomic,weak) id<MainDelegate> mainDelegate;
@property (nonatomic) BOOL bIsEdit;
@property (nonatomic,strong) UIImageView *ivBg;
@property (nonatomic,strong) GMGridView *gmGridView;
 @property(nonatomic, strong) MainProductInfo *mainProductInfo;

 - (id)initWithMainProductInfo:(MainProductInfo *)aMainProductInfo;

 + (id)objectWithMainProductInfo:(MainProductInfo *)aMainProductInfo;


 @end

@protocol SubCatalogViewControllerDelegate <NSObject>

-(void)subCatalogViewController:(SubCatalogViewController *)maiCatalogViewController didSelectCatalogID:(int)catalogID;

@end
