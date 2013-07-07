//
//  PasswordEditView.h
//  homi 修改密码组件
//
//  Created by mijie on 07/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface PasswordEditView : UIView    <UITextFieldDelegate>  {
    UIImageView *bgView;
    UITextField *tfOriPwd;
    UITextField *tfNewPwd;
    UITextField *tfConfirmPwd;
    NSString *oriPasswordStr;
}

@property(nonatomic, retain) UIImageView *bgView;
@property(nonatomic, retain) UITextField *tfOriPwd;
@property(nonatomic, retain) UITextField *tfNewPwd;
@property(nonatomic, retain) UITextField *tfConfirmPwd;
@property (nonatomic, retain) NSString *oriPasswordStr;


- (id)initWithFrame:(CGRect)frame  oriPasswordStr:(NSString *)oriPdwStr;

@end
