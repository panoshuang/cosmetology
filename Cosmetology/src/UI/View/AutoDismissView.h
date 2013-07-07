//
//  AutoDismissView.h
//  自动消失的提示组件
//
//

#import <Foundation/Foundation.h>

typedef void (^AutoDismissViewCompleteBlock)();


@interface AutoDismissView : UIView 
{
    NSString * displayText;
    NSTimeInterval dismissTime;
    
    UILabel * lbText;
    AutoDismissViewCompleteBlock completeBlock;
}
+(AutoDismissView *)instance;

-(void)showInView:(UIView *)aView title:(NSString *)string duration:(NSTimeInterval)duration;

- (void)showInView:(UIView *)aView title:(NSString *)string duration:(NSTimeInterval)duration complete:(AutoDismissViewCompleteBlock)block;

- (id) initWithDismissTime:(NSTimeInterval)time title:(NSString *)str;

- (void) showInView:(UIView *) aView;

- (void)removeAutoDismissView;
//- (void)showInViewWithTime:(NSTimeInterval)time text:(NSString *)str;


@end
