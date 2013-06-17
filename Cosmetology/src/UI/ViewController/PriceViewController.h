//
// Created by mijie on 13-6-17.
// Copyright (c) 2013 pengpai. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PriceViewController : UIViewController {
    UIImageView *_ivPrice;
    BOOL _bIsEdit;
    int  _subProductID;

}
@property(nonatomic, strong) UIImageView *ivPrice;
@property(nonatomic) BOOL bIsEdit;
@property(nonatomic) int subProductID;

- (id)initWithSubProductID:(int)aSubProductID;

+ (id)controllerWithSubProductID:(int)aSubProductID;

@end