//
// Created by mijie on 13-6-15.
// Copyright (c) 2013 pengpai. All rights reserved.
// @: 超值体验页面
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "MainDelegate.h"
#import "SubProductInfo.h"
#import "MainProductInfo.h"
#import "AddSubCatalogViewController.h"

@class GMGridView;
@protocol ExperienceViewControllerDelegate;
@protocol MainDelegate;


@interface ExperienceViewController : UIViewController <AddSubCatalogViewControllerDelegate> {
    __weak id<ExperienceViewControllerDelegate> _delegate;
    __weak id<MainDelegate> _mainDelegate;
    MainProductInfo *_experienceInfo;
    BOOL _bIsEdit;
}

@property (nonatomic,weak) id<ExperienceViewControllerDelegate> delegate;
@property (nonatomic,weak) id<MainDelegate> mainDelegate;
@property (nonatomic) BOOL bIsEdit;
@property (nonatomic,strong) UIImageView *ivBg;
@property (nonatomic,strong) GMGridView *gmGridView;
@property(nonatomic, strong) MainProductInfo *experienceInfo;

-(id)initWithExperienceInfo:(MainProductInfo *)aExperienceInfo;
@end


@protocol ExperienceViewControllerDelegate <NSObject>

-(void)experienceViewController:(ExperienceViewController *)experienceViewController didSelectSubCatalog:(SubProductInfo *)subProductInfo;

@end