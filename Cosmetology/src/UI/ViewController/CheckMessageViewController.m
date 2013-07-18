//
//  CheckMessageViewController.m
//  MessageBoard
//
//  Created by mijie on 13-6-16.
//  Copyright (c) 2013年 mijie. All rights reserved.
//

#import "CheckMessageViewController.h"
#import "MessageBoardInfo.h"
#import "MessageBoardManager.h"

@interface CheckMessageViewController ()
{
    UIToolbar *_toolBar;
    UIImageView *headPortraits;//头像
    UITextView *messageTextView;//留言展示
    UIButton *playRecord;//播放录音
    UIImageView *singeName;//签名
    
    MessageBoardInfo *messageBoardInfo;
}

@end

@implementation CheckMessageViewController

- (id)init
{
    self = [super init];
    if (self) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
        [self.view addSubview:_toolBar];
        _toolBar.hidden = NO;
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
         _toolBar.items = [NSArray arrayWithObjects:back,nil];
        // Custom initialization
        //messageBoardInfo.headPortraits = [UIImage imageNamed:@"headPortraits.png"];
        NSArray *messageBoardInfoArray = [[MessageBoardManager instance] allMessageBoardForSubProductID:2];
        messageBoardInfo = [[MessageBoardInfo alloc]init];
        messageBoardInfo = [messageBoardInfoArray objectAtIndex:2];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    //头像
    headPortraits = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headPortraits.png"]];
    headPortraits.frame = CGRectMake(10, 54, 200, 200);
    headPortraits.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headPortraits];
    
    //留言展示
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 54, 130, 30)];
    messagelabel.text = @"我的留言:";
    [messagelabel setFont:font];
    [self.view addSubview:messagelabel];
    
    messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(330, 54, 600, 200)];
    messageTextView.editable = NO;
    messageTextView.text = messageBoardInfo.messageContent;
    messageTextView.contentMode = UIViewContentModeScaleToFill;
    messageTextView.backgroundColor = [UIColor yellowColor];
    
    [messageTextView setFont:font];
    [self.view addSubview:messageTextView];
    
    
    
    //播放录音
    playRecord= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(10, 400, 150, 50);
    [playRecord setTitle:@"播放留言" forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    //签名
    singeName = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headPortraits.png"]];
    singeName.frame = CGRectMake(600, 400, 300, 300);
    [self.view addSubview:singeName];
    
    //人气显示
    UILabel *popularityLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 500, 180, 30)];
    NSString *labelTitle = [NSString stringWithFormat:@"人气:%d",messageBoardInfo.popularity];
    popularityLabel.text = labelTitle;
    [self.view addSubview:popularityLabel];
    
}

-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)playRecord:(UIButton *)btn
{
    //TODO:播放留言
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end