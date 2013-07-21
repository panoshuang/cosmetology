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
#import "AcclaimButton.h"
#import "ResourceCache.h"

@interface CheckMessageViewController ()
{
    UIToolbar *_toolBar;
    UIImageView *headPortraits;//头像
    UITextView *messageTextView;//留言展示
    UIButton *playRecord;//播放录音
    UIImageView *singeName;//签名
    NSString *popularityValue;
    UIImageView *_bgView;//背景图片
    
    AcclaimButton *popularityBtn;//人气
    MessageBoardInfo *_messageBoardInfo;
}

@end

@implementation CheckMessageViewController

@synthesize messageBoardInfo = _messageBoardInfo;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)loadView
{
    [super loadView];
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
    
    mainView.backgroundColor=[UIColor whiteColor];
    self.view = mainView;
    _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //获取背景图片填充
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString *bgFilePath = [userDefaults stringForKey:HOME_PAGE_BACKGROUND_IMAGE_FILE_PATH];
    //    UIImage *bgImage = [[ResourceCache instance] imageForCachePath:bgFilePath];
    //    _bgView.image = bgImage;
    
    _bgView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:_bgView];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
    [self.view addSubview:_toolBar];
    _toolBar.hidden = NO;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    _toolBar.items = [NSArray arrayWithObjects:back,nil];
    // Custom initialization
    //messageBoardInfo.headPortraits = [UIImage imageNamed:@"headPortraits.png"];
    
    //头像
    UIImage *protraitImage = [[ResourceCache instance] imageForCachePath:_messageBoardInfo.headPortraits];
    if (!protraitImage) {
        protraitImage  = [UIImage imageNamed:@"pickPhoto"];
    }
    headPortraits = [[UIImageView alloc]initWithImage:protraitImage];
    headPortraits.contentMode = UIViewContentModeCenter;
    headPortraits.frame = CGRectMake(10, 54, 200, 200);
    headPortraits.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headPortraits];
    
    UIFont *font = [UIFont fontWithName:@"Courier-Oblique" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 70, 130, 30)];
    messagelabel.text = @"我的留言:";
    messagelabel.backgroundColor = [UIColor clearColor];
    [messagelabel setFont:font];
    
    messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(45, 100, 540, 220)];
    messageTextView.editable = NO;
    messageTextView.text = _messageBoardInfo.messageContent;
    messageTextView.contentMode = UIViewContentModeScaleToFill;
    messageTextView.backgroundColor = [UIColor clearColor];
    [messageTextView setFont:font];
    
    UIImageView *messageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 50, 637, 372)];
    messageImageView.image = [UIImage imageNamed:@"messageBoard.png"];
    messageImageView.userInteractionEnabled = YES;
    
    [messageImageView addSubview:messagelabel];
    [messageImageView addSubview:messageTextView];
    
    //签名
    singeName = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singeName.png"]];
    singeName.frame = CGRectMake(294, 389, 529, 322);
    [self.view addSubview:singeName];
    [self.view addSubview:messageImageView];
    
    //播放录音
    playRecord= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(10, 400, 150, 50);
    [playRecord setTitle:@"播放留言" forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    
    
    //赞人气
    popularityBtn = [[AcclaimButton alloc]initWithFrame:CGRectMake(64, 270, 230, 45)];
    [popularityBtn addTarget:self action:@selector(onAddPopularity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popularityBtn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
        
}

-(void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onAddPopularity:(UIButton *)btn{
   //TODO:增加人气
    popularityValue = [NSString stringWithFormat:@"人气:%d",(_messageBoardInfo.popularity + 1)];
    _messageBoardInfo.popularity += 1;
    //[popularityBtn setTitle:popularityValue forState:UIControlStateNormal];
    [[MessageBoardManager instance] updateMessageBoard:_messageBoardInfo];
    
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