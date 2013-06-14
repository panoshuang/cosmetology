//
//  Test.m
//  Cosmetology
//
//  Created by hongji_zhou on 13-6-14.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "Test.h"
static Test *sharedTest = nil;

@implementation Test



+(Test *)instance
{
    @synchronized(self){
    if(sharedTest == nil)
    {
        sharedTest = [[self alloc] init]; 
    }
    return sharedTest;
    }
}

@end
