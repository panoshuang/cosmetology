//
//  MyPaletteViewController.h
//  MyPalette
//
//  Created by xiaozhu on 11-6-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"
#import <QuartzCore/QuartzCore.h>

@protocol MyPaletteViewControllerDelegate;

@interface MyPaletteViewController : UIViewController 
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
	UILabel* labelColor;
	UILabel* labelLoanshift;
	CGPoint MyBeganpoint;
	CGPoint MyMovepoint;
	int Segment;
	int SegmentWidth;
	//----------------
	UIImageView* pickImage;
	
	UISegmentedControl* WidthButton;
	UISegmentedControl* ColorButton;
    __weak id<MyPaletteViewControllerDelegate> _delegate;
}
@property int Segment;
@property (nonatomic,retain)IBOutlet UILabel* labelColor;
@property (nonatomic,retain)IBOutlet UILabel* labelLoanshift;
@property (nonatomic,weak) id<MyPaletteViewControllerDelegate> delegate;

-(IBAction)myAllColor;
-(IBAction)myAllWidth;
-(IBAction)myPalttealllineclear;
-(IBAction)LineFinallyRemove;
-(IBAction)myRubberSeraser;
-(IBAction)cancel;

-(void)segmentColor;
-(void)segmentWidth;
//=====================
-(IBAction)captureScreen;
@end

@protocol MyPaletteViewControllerDelegate <NSObject>

-(void)setSingeNameImage:(UIImage *)img;

@end

