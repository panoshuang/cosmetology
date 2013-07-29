//
//  PasswordEditViewController.m
//  Cosmetology
//
//  Created by mijie on 13-7-7.
//  Copyright (c) 2013年 pengpai. All rights reserved.
//

#import "PasswordEditViewController.h"
#import "PasswordEditView.h"
#import <QuartzCore/QuartzCore.h>
#import "Userdefault_define.h"

@interface PasswordEditViewController () <UITextFieldDelegate>{
    PasswordEditView *_passwordEditView ;
    NSString *_oriPassword; //原始密码
}

@end

@implementation PasswordEditViewController

@synthesize passwordType = _passwordType;

-(id)initWithPasswordType:(EnumPasswordType)aPasswordType
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.passwordType = aPasswordType;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        switch (_passwordType) {
            case kPasswordTypeHome:
                _oriPassword = [userdefaults stringForKey:PWD_MAIN_CATALOG];
                break;
            case kPasswordTypeSubProduct:
                _oriPassword = [userdefaults stringForKey:PWD_SUB_CATALOG];
                break;
            case kPasswordTypeMsg:
                _oriPassword = [userdefaults stringForKey:PWD_MSG];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover =  CGSizeMake(300, 400);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(back)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(save)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = saveItem;
    
    _passwordEditView = [[PasswordEditView alloc] initWithFrame:CGRectMake(kCommonSpace, kCommonSpace, 300 - 2 * kCommonSpace, 40*3)  oriPasswordStr:@""];
    _passwordEditView.backgroundColor = [UIColor whiteColor];
    _passwordEditView.layer.cornerRadius = 5;
    _passwordEditView.layer.masksToBounds = YES;
    _passwordEditView.layer.borderColor = [UIColor colorWithWhite:.5f alpha:.5f].CGColor;
    _passwordEditView.layer.borderWidth = 1;
    _passwordEditView.tfOriPwd.delegate = self;
    _passwordEditView.tfNewPwd.delegate = self;
    _passwordEditView.tfConfirmPwd.delegate = self;
    [self.view addSubview:_passwordEditView];
	// Do any additional setup after loading the view.
}

//检查新的密码是否正确
-(BOOL)checkNewPsd{
    BOOL isCorrect = NO;    

        if (_passwordEditView.tfNewPwd.text.length == 0)
        {
            ALERT_MSG(@"请输入新密码", nil, @"确定");
            [_passwordEditView.tfNewPwd becomeFirstResponder];
        }
        else if(_passwordEditView.tfNewPwd.text.length < 6){
            ALERT_MSG(@"密码长度至少为6位", nil, @"确定");
            [_passwordEditView.tfNewPwd becomeFirstResponder];
        }
        else
        {
            if (_passwordEditView.tfConfirmPwd.text.length == 0){
                ALERT_MSG(@"请再次输入密码", nil, @"确定");
                [_passwordEditView.tfConfirmPwd becomeFirstResponder];
            }
            else{
                if ([_passwordEditView.tfNewPwd.text isEqualToString:_passwordEditView.tfConfirmPwd.text])
                {
                    //判断原始密码是否正确
                    if ([_passwordEditView.tfOriPwd.text isEqualToString:_oriPassword] || (_passwordEditView.tfOriPwd.text.length == 0 && _oriPassword.length == 0)) {
                        //正确,提交
                        isCorrect = YES;
                    }
                    else{
                        ALERT_MSG(@"原始密码不正确", nil, @"确定");
                    }
                }
                else
                {
                    ALERT_MSG(@"两次输入的密码不一致", nil, @"确定");
                    
                }
            }
            
        }
    return isCorrect;
}

-(void)save{
    if ([self checkNewPsd]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *newPwd = _passwordEditView.tfNewPwd.text;
        switch (_passwordType) {
            case kPasswordTypeHome:
                [userDefaults setObject:newPwd forKey:PWD_MAIN_CATALOG];
                break;
            case kPasswordTypeSubProduct:
                [userDefaults setObject:newPwd forKey:PWD_SUB_CATALOG];
                break;
            case kPasswordTypeMsg:
                [userDefaults setObject:newPwd forKey:PWD_MSG];
                break;
            default:
                break;
        }
        [self back];
    }
    else{
        ALERT_MSG(@"密码修改错误", nil, @"确定");
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordEditView.tfOriPwd)
    {
        if (![textField.text isEqualToString:_oriPassword])
        {
            ALERT_MSG(@"原始密码不正确", nil, @"确定");
            return NO;
        }
        else
        {
            [_passwordEditView.tfNewPwd becomeFirstResponder];
        }
    }
    else if (textField == _passwordEditView.tfNewPwd)
    {
        if (textField.text.length == 0)
        {
            ALERT_MSG(@"请输入新密码", nil, @"确定");
            return NO;
        }
        else if(_passwordEditView.tfNewPwd.text.length < 6){
            ALERT_MSG(@"密码长度至少为6位", nil, @"确定");
            return NO;
        }
        else
        {
            [_passwordEditView.tfConfirmPwd becomeFirstResponder];
        }
    }
    else
    {
        if([self checkNewPsd]){
            [self save];
        }else{
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
