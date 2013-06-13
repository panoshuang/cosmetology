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
@property (nonatomic, strong) MainProductInfo *mainProductInfo;
@property (nonatomic) BOOL bIsEdit;

- (id)initWithProductInfo:(MainProductInfo *)aProductInfo;

+ (id)controllerWithProductInfo:(MainProductInfo *)aProductInfo;


@end

@protocol AddMainCatalogViewControllerDelegate <NSObject>

-(void)addMainCatalogViewController:(AddMainCatalogViewController *)addMainCatalogViewController didAddCatalog:(MainProductInfo *)mainProductInfo;

-(void)addMainCatalogViewController:(AddMainCatalogViewController *)addMainCatalogViewController didUpdateCatalog:(MainProductInfo *)mainProductInfo;
@end
