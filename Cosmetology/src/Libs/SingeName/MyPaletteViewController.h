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
}
@property int Segment;
@property (nonatomic,retain)IBOutlet UILabel* labelColor;
@property (nonatomic,retain)IBOutlet UILabel* labelLoanshift;

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

