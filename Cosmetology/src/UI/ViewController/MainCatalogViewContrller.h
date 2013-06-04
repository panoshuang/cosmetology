 //
//  MainCatalogViewContrller.h
//  Cosmetology
//
//  Created by mijie on 13-6-2.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "MainDelegate.h"

@protocol MainCatalogViewControllerDelegate;

@interface MainCatalogViewContrller : UIViewController{
    __weak id<MainCatalogViewControllerDelegate> _delegate;
}

@property (nonatomic,weak) id<MainCatalogViewControllerDelegate> delegate;
@property (nonatomic) BOOL bIsEdit;

@end

@protocol MainCatalogViewControllerDelegate <NSObject>

-(void)mainCatalogViewController:(MainCatalogViewContrller *)maiCatalogViewController didSelectCatalogID:(int)catalogID;

@end
