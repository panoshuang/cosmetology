//
//  PasswordEditView.m
//  homi
//
//  Created by mijie on 07/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PasswordEditView.h"

#define FONT_SIZE 14
#define TEXTFIELD_HEIGHT 40

@implementation PasswordEditView

@synthesize bgView;
@synthesize tfOriPwd;
@synthesize tfNewPwd;
@synthesize tfConfirmPwd;
@synthesize oriPasswordStr;

- (id)initWithFrame:(CGRect)frame  oriPasswordStr:(NSString *)oriPdwStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.oriPasswordStr = oriPdwStr;

        bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:bgView];

        tfOriPwd = [[UITextField alloc] initWithFrame:CGRectZero];
        tfOriPwd.placeholder =   @"请输入旧密码";
        tfOriPwd.font = [UIFont systemFontOfSize:FONT_SIZE];
        tfOriPwd.secureTextEntry = YES;
        tfOriPwd.returnKeyType = UIReturnKeyNext;
        UILabel *oriLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, TEXTFIELD_HEIGHT)] ;
        oriLeftView.text = @"    旧密码";
        oriLeftView.backgroundColor = [UIColor clearColor];
        tfOriPwd.leftView = oriLeftView;
        tfOriPwd.leftViewMode = UITextFieldViewModeAlways;
        tfOriPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfOriPwd.layer.borderColor = [UIColor colorWithWhite:.5f alpha:.5f].CGColor;
        tfOriPwd.layer.borderWidth = .5;
        [self addSubview:tfOriPwd];

        tfNewPwd = [[UITextField alloc] initWithFrame:CGRectZero];
        tfNewPwd.placeholder =   @"请输入新密码";
        tfNewPwd.font = [UIFont systemFontOfSize:FONT_SIZE];
        tfNewPwd.secureTextEntry = YES;
        tfNewPwd.text = @"";
        tfNewPwd.returnKeyType = UIReturnKeyNext;
        tfNewPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfNewPwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        oriLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, TEXTFIELD_HEIGHT)] ;
        oriLeftView.text = @"    新密码" ;
        oriLeftView.backgroundColor = [UIColor clearColor];
        tfNewPwd.leftView = oriLeftView;
        tfNewPwd.leftViewMode = UITextFieldViewModeAlways;
        tfNewPwd.layer.borderColor = [UIColor colorWithWhite:.5f alpha:.5f].CGColor;
        tfNewPwd.layer.borderWidth = .5;
        [self addSubview:tfNewPwd];

        tfConfirmPwd = [[UITextField alloc] initWithFrame:CGRectZero];
        tfConfirmPwd.placeholder =  @"再次输入新密码";
        tfConfirmPwd.font = [UIFont systemFontOfSize:FONT_SIZE];
        tfConfirmPwd.text = @"";
        tfConfirmPwd.secureTextEntry = YES;
        tfConfirmPwd.returnKeyType = UIReturnKeyDone;
        tfConfirmPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        oriLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, TEXTFIELD_HEIGHT)] ;
        oriLeftView.text = @"    重复密码";
        oriLeftView.backgroundColor = [UIColor clearColor];
        tfConfirmPwd.leftView = oriLeftView;
        tfConfirmPwd.leftViewMode = UITextFieldViewModeAlways;
        tfConfirmPwd.layer.borderColor = [UIColor colorWithWhite:.5f alpha:.5f].CGColor;
        tfConfirmPwd.layer.borderWidth = .5;
        [self addSubview:tfConfirmPwd];

        tfOriPwd.frame = CGRectMake(0, 0, self.bounds.size.width, TEXTFIELD_HEIGHT);

        tfNewPwd.frame = CGRectMake(tfOriPwd.frame.origin.x,
                tfOriPwd.frame.origin.y + tfOriPwd.frame.size.height,
                tfOriPwd.frame.size.width,
                tfOriPwd.frame.size.height);

        tfConfirmPwd.frame = CGRectMake(tfNewPwd.frame.origin.x,
                tfNewPwd.frame.origin.y + tfNewPwd.frame.size.height,
                tfNewPwd.frame.size.width,
                tfNewPwd.frame.size.height);
    }
    return self;
}






@end
