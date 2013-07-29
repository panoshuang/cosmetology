//
//  EditSubProductViewController.h
//  Cosmetology
//
//  Created by mijie on 13-7-27.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SUbProductInfo.h"

@protocol EditSubProductViewControllerDelegate;

@interface EditSubProductViewController : UIViewController{
    SubProductInfo *_subProductInfo;
    id<EditSubProductViewControllerDelegate> delegate;
}

@property (nonatomic,strong) SubProductInfo *subProductInfo;
@property (nonatomic,weak) id<EditSubProductViewControllerDelegate> delegate;

-(id)initWithSubProductInfo:(SubProductInfo *)aProduct;

@end

@protocol EditSubProductViewControllerDelegate <NSObject>

-(void)editSubProductViewControllerDidSave:(EditSubProductViewController *)editSubProductViewController didUpdateCatalog:(SubProductInfo *)subProduct;

@end
