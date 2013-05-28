//
// Created by mijie on 12-7-16.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"


@interface BaseDatabase : NSObject  {
    FMDatabaseQueue *fmDbQueue;
}

@property (nonatomic, strong)  FMDatabaseQueue *fmDbQueue;

+(BaseDatabase *)instance;


@end