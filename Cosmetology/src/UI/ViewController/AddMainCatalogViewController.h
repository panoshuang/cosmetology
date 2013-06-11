//
//  AddMainCatalogViewController.h
//  Cosmetology
//
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainProductInfo;
@protocol AddMainCatalogViewControllerDelegate ;

@interface AddMainCatalogViewController : UIViewController

@property (nonatomic,weak) id<AddMainCatalogViewControllerDelegate> delegate;

@end

@protocol AddMainCatalogViewControllerDelegate <NSObject>

-(void)addMainCatalogViewController:(AddMainCatalogViewController *)addMainCatalogViewController didSaveCatalog:(MainProductInfo *)mainProductInfo;

@end
