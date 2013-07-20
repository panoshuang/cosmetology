//
//  MessageListsViewController.h
//  MessageBoard
//
//  Created by hongji_zhou on 13-6-18.
//  Copyright (c) 2013年 hongji_zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MessageListsViewController : UIViewController{
    UIToolbar *_toolBar;
    UIView *_editTapView ;
    int _productId;
}

@property (nonatomic) BOOL bIsEdit;
@property (nonatomic) int productId;

-(id)initWithProductId:(int)aId;

@end
