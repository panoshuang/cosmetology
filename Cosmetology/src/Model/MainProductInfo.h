//
// Created by mijie on 13-5-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface MainProductInfo : NSObject
{
    int productID;
    NSString *name;
    BOOL enable;
}
@property(nonatomic) int productID;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) BOOL enable;

@end