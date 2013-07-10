//
//  VideoItem.m
//  Cosmetology
//
//  Created by hongji_zhou on 13-6-24.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "VideoItem.h"

@implementation VideoItem

@synthesize stringURL;


-(id)init{
    self = [super init];
    if (self) {
        self = [[VideoItem alloc]init];
        self.stringURL = [[NSBundle mainBundle] pathForResource:@"ss11_8" ofType:@"mp4"];
    }
    
    return self;
}

@end
