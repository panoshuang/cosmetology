//
//  ViewController.m
//  MessageBoard
//
//  Created by mijie on 06/16/13.
//  Copyright (c) 2013 mijie. All rights reserved.
//

#import "EditMessageViewController.h"
#import "MyPaletteViewController.h"
#import "CheckMessageViewController.h"

@interface EditMessageViewController ()
{
    UIButton *headPortraits;//头像
    UITextView *messageEditTextView;//留言编辑
    UIButton *OKBtn;//OK按钮
    UIButton *record;//录音
    UIButton *singeName;//签名
}

@end

@implementation EditMessageViewController

@synthesize delegate = _delegate;
@synthesize subProductID = _subProductID;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //头像
    headPortraits = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headPortraits.frame = CGRectMake(10, 10, 200, 200);
    headPortraits.contentMode = UIViewContentModeScaleToFill;
    [headPortraits setBackgroundImage:[UIImage imageNamed:@"headPortraits.png"] forState:UIControlStateNormal];
    //headPortraits.imageView.image = [UIImage imageNamed:@"headPortraits.png"];
    [headPortraits addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headPortraits];
    
    //留言编辑
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 10, 130, 30)];
    messagelabel.text = @"我的留言:";
    [messagelabel setFont:font];
    [self.view addSubview:messagelabel];
    messageEditTextView = [[UITextView alloc]initWithFrame:CGRectMake(330, 10, 600, 200)];
    messageEditTextView.delegate = self;
    messageEditTextView.contentMode = UIViewContentModeScaleToFill;
    messageEditTextView.backgroundColor = [UIColor yellowColor];
    
    [messageEditTextView setFont:font];
    [self.view addSubview:messageEditTextView];
    
    //OK按钮
    OKBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OKBtn.frame = CGRectMake(950, 10, 50, 50);
    
    [OKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(saveMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBtn];
    
    //录音
    record = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    record.frame = CGRectMake(10, 400, 150, 50);
    [record setTitle:@"我有话说" forState:UIControlStateNormal];
    [record addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:record];
    
    //签名
    singeName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    singeName.frame = CGRectMake(600, 400, 300, 300);
    [singeName addTarget:self action:@selector(singeName:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:singeName];

}


-(void)singeName:(UIButton *)btn
{
    //TODO:签名
    MyPaletteViewController *myPaletteViewController = [[MyPaletteViewController alloc]init];
    [self.navigationController pushViewController:myPaletteViewController animated:YES];
}

-(void)record:(UIButton *)btn
{
    //TODO:录音功能
}

-(void)saveMessage:(UIButton *)btn
{
    //TODO:
    [messageEditTextView resignFirstResponder];
    if ([_delegate respondsToSelector:@selector(saveMessage:forSubProductID:)]) {
        [_delegate saveMessage:_messageBoardInfo forSubProductID:_subProductID];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pickImage:(UIButton *)btn
{
    //TODO:拍照
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [messageEditTextView resignFirstResponder];
}

@end