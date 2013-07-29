//
//  AutoDismissView.m


#import "AutoDismissView.h"
#import <QuartzCore/QuartzCore.h>


@implementation AutoDismissView

SYNTHESIZE_SINGLETON_FOR_CLASS(AutoDismissView )

- (void)showInView:(UIView *)aView title:(NSString *)string duration:(NSTimeInterval)duration
{
    if (completeBlock != NULL){
        Block_release(completeBlock);
        completeBlock = NULL;
    }
    displayText=[string copy];
    dismissTime=duration;
    if (self.superview){
        [lbText removeFromSuperview];
    	[self removeFromSuperview];
    }
    [self showInView:aView];
}

- (void)showInView:(UIView *)aView title:(NSString *)string duration:(NSTimeInterval)duration  complete:(AutoDismissViewCompleteBlock)block
{
    completeBlock = Block_copy(block);
    displayText=[string copy];
    dismissTime=duration;
    if (self.superview){
        [lbText removeFromSuperview];
        [self removeFromSuperview];
    }
    [self showInView:aView];
}


- (id) initWithDismissTime:(NSTimeInterval)time title:(NSString *)str
{
    if(self=[super init])
    {
        displayText=[str copy];
        dismissTime=time;
    }
    return self;
}

- (void) showInView:(UIView *) aView
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    self.layer.cornerRadius=5;
    self.layer.masksToBounds=YES;
    
    self.backgroundColor=[UIColor blackColor];
    self.alpha=0.8;
    
    CGFloat defaultWidth=100.0f;
    CGFloat defaultHeight=100.0f;
    
    self.frame=CGRectMake(0,0,defaultWidth,defaultHeight);
    //self.center=aView.center;
	self.center = CGPointMake(aView.center.x-aView.frame.origin.x, aView.center.y - aView.frame.origin.y);
    
    UIFont *lbFont=[UIFont systemFontOfSize:13];
    
    
    
    CGSize lbSize = [displayText sizeWithFont:lbFont
                            constrainedToSize:CGSizeMake(180.0f, 200.0f)
                                lineBreakMode:UILineBreakModeCharacterWrap];
    
    
    lbText=[[UILabel alloc] init];
    lbText.text=displayText;
    lbText.font=lbFont;
    lbText.backgroundColor=[UIColor clearColor];
    lbText.textColor=[UIColor whiteColor];
    lbText.frame=CGRectMake(0,0,lbSize.width,lbSize.height);
    lbText.lineBreakMode = UILineBreakModeCharacterWrap;
    lbText.textAlignment = NSTextAlignmentCenter;
    lbText.numberOfLines = 0;
    //lbText.center=aView.center;
	lbText.center=self.center;
    
    if(lbSize.width>self.frame.size.width || lbSize.height>self.frame.size.height)
    {
        if(lbSize.height>defaultHeight)
        {
            self.frame=CGRectMake(0,0,lbSize.width+8,lbSize.height+8);
        }
        else
        {
            self.frame=CGRectMake(0,0,lbSize.width+8,defaultHeight);
        }
        
        //self.center=aView.center;
		self.center = CGPointMake(aView.center.x-aView.frame.origin.x, aView.center.y - aView.frame.origin.y);
    }
    
    [aView addSubview:self];
    [aView addSubview:lbText];
    
    [NSTimer scheduledTimerWithTimeInterval:dismissTime
                                     target:self
                                   selector:@selector(removeAutoDismissView)
                                   userInfo:nil
                                    repeats:NO];
    
}

/*

- (void)showInViewWithTime:(NSTimeInterval)time text:(NSString *)str {
	[[self layer] setCornerRadius:5];
	[[self layer] setMasksToBounds:YES];
	self.textAlignment = UITextAlignmentCenter;
	self.backgroundColor = [UIColor blackColor];
	self.textColor = [UIColor whiteColor];
	self.alpha = 0.8;
	self.font = [UIFont systemFontOfSize:20];
	self.text = str;
	
	self.numberOfLines = 0;
	CGSize sizeDefault = CGSizeMake(260, 80);
	CGSize ssize = [self sizeThatFits:CGSizeMake(260, 80)];
	CGRect rct = self.frame;
	if (ssize.height < 80) {
		rct.size = sizeDefault;
	}
	else {
		rct.size = ssize;
	}
	
	self.frame = rct;
	self.center = CGPointMake(160, 208);
	
	NSTimer *showTimer = [NSTimer scheduledTimerWithTimeInterval:time
														  target:self
														selector:@selector(removeAutoDismissView)
														userInfo:nil
														 repeats:NO];
}
*/
- (void)removeAutoDismissView 
{

    if (completeBlock != NULL){
        completeBlock();
        Block_release(completeBlock);
        completeBlock = NULL;
    }
    [lbText removeFromSuperview];
	[self removeFromSuperview];
    
}

- (void) dealloc
{
    [displayText release];
    [lbText release];
    [super dealloc];
}


@end
