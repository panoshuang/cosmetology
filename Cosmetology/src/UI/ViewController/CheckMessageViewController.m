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
    NSString *popularityValue;
    MessageBoardInfo *messageBoardInfo;
    UIButton *popularityBtn;//人气
    
    UIImageView *_bgView;//背景图片
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
        NSLog(@"%d",messageBoardInfo.popularity);
        
        //头像
        headPortraits = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headPortraits.jpg"]];
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
        singeName = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headPortraits.jpg"]];
        singeName.frame = CGRectMake(600, 400, 300, 300);
        [self.view addSubview:singeName];
        
        //赞人气
        popularityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        popularityBtn.frame = CGRectMake(50, 500, 180, 30);
        NSLog(@"%d",messageBoardInfo.popularity);
        popularityValue = [NSString stringWithFormat:@"人气:%d",messageBoardInfo.popularity];
        [popularityBtn setTitle:popularityValue forState:UIControlStateNormal];
        [popularityBtn addTarget:self action:@selector(onAddPopularity:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popularityBtn];

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
    popularityValue = [NSString stringWithFormat:@"人气:%d",(messageBoardInfo.popularity + 1)];
    messageBoardInfo.popularity += 1;
    [popularityBtn setTitle:popularityValue forState:UIControlStateNormal];
    [[MessageBoardManager instance] updateMessageBoard:messageBoardInfo];
    
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