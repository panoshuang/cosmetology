//
//  MainCatalogItem.h
//  Cosmetology
//
//  Created by mijie on 13-6-10.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReflectionView.h"
#import "DownLoaderImageView.h"

@interface MainCatalogItem : ReflectionView<DownLoaderImageViewDelegate>{
    DownLoaderImageView *_ivBg;
}

@property (nonatomic,strong) DownLoaderImageView *ivBg;

@end
