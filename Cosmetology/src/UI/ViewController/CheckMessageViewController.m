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
#import "EditMessageViewController.h"

@interface CheckMessageViewController ()
{
    
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
    
    _bgView.image = [UIImage imageNamed:@"bgCheckMessage.jpg"];
    [self.view addSubview:_bgView];
    
    //我也要留言按钮
    UIButton *editMessageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editMessageBtn.frame = CGRectMake(329, 705, 180, 67);
    [editMessageBtn setBackgroundImage:[UIImage imageNamed:@"editMessage.png"] forState:UIControlStateNormal];
    [editMessageBtn addTarget:self action:@selector(toEditMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editMessageBtn];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(625, 705, 120, 67);
    //[backBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //显示头像
    UIImage *protraitImage = [[ResourceCache instance] imageForCachePath:_messageBoardInfo.headPortraits];
    if (!protraitImage) {
        protraitImage  = [UIImage imageNamed:@"pickPhoto.png"];
    }
    headPortraits = [[UIImageView alloc]initWithFrame:CGRectMake(40, 410, 220, 160)];
    headPortraits.image = protraitImage;
    headPortraits.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:headPortraits];
    
    UIFont *font = [UIFont fontWithName:@"Courier-Oblique" size:24];
    UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(380, 55, 130, 30)];
    messagelabel.text = @"我的留言:";
    messagelabel.backgroundColor = [UIColor clearColor];
    [messagelabel setFont:font];
    
    messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(80, 85, 710, 220)];
    messageTextView.editable = NO;
    messageTextView.text = _messageBoardInfo.messageContent;
    messageTextView.contentMode = UIViewContentModeScaleToFill;
    messageTextView.backgroundColor = [UIColor clearColor];
    [messageTextView setFont:font];
    
    UIImageView *messageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(93, 18, 869, 372)];
    messageImageView.image = [UIImage imageNamed:@"messageBoard.png"];
    messageImageView.userInteractionEnabled = YES;
    [messageImageView addSubview:messagelabel];
    [messageImageView addSubview:messageTextView];
    
    //显示签名
    UIImage *singeNameImage = [[ResourceCache instance] imageForCachePath:_messageBoardInfo.singeName];
    if (!singeNameImage) {
        singeNameImage  = [UIImage imageNamed:@"singeName"];
    }
    singeName = [[UIImageView alloc]initWithImage:singeNameImage];
    singeName.frame = CGRectMake(374, 369, 497, 302);
    [self.view addSubview:singeName];
    [self.view addSubview:messageImageView];
    
    //录音图标
    UIImageView *recordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 440, 115, 178)];
    recordImageView.image = [UIImage imageNamed:@"recordImage.png"];
    [self.view addSubview:recordImageView];
    
    //播放录音
    playRecord= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playRecord.frame = CGRectMake(260, 600, 89, 89);
    //[playRecord setTitle:@"播放留言" forState:UIControlStateNormal];
    [playRecord setBackgroundImage:[UIImage imageNamed:@"listenRecord.png"] forState:UIControlStateNormal];
    [playRecord addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playRecord];
    
    
    
    //赞人气
    popularityBtn = [[AcclaimButton alloc]initWithFrame:CGRectMake(50, 580, 153, 71)];
    popularityBtn.ivBg.image = [UIImage imageNamed:@"bgacclaim.png"];
    //[popularityBtn setBackgroundColor:[UIColor redColor]];
    //[popularityBtn setIvBg:[UIImage imageNamed:@"popularity.png"]];
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

-(void)toEditMessageBtn:(UIButton *)btn{
    EditMessageViewController *editMessageViewController = [[EditMessageViewController alloc]init];
    [self.navigationController pushViewController:editMessageViewController animated:YES];
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