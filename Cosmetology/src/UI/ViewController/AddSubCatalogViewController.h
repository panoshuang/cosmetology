//
//  AddSubCatalogViewController.h
//  Cosmetology
//
//  Created by mijie on 13-6-11.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubProductInfo;
@protocol AddSubCatalogViewControllerDelegate;

@interface AddSubCatalogViewController : UIViewController

@property(nonatomic,weak)id<AddSubCatalogViewControllerDelegate>delegate;

@end

@protocol AddSubCatalogViewControllerDelegate <NSObject>

-(void)addSubCatalogViewController:(AddSubCatalogViewController *)addSubCatalogViewController didSaveCatalog:(SubProductInfo *)subProductInfo;

@end
