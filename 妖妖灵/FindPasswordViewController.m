//
//  FindPasswordViewController.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()<UITextViewDelegate>{
    NSTimer *ResetcountDownTimer;
    unsigned ResetsecondsCountDown;
}

@property (strong, nonatomic) IBOutlet UITextField *ResetmobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *ResetPassword;
@property (strong, nonatomic) IBOutlet UITextField *ResetSmsCode;
@property (strong, nonatomic) IBOutlet UIButton *ResetRequestBtn;

- (IBAction)ResetRequestSmsCode:(UIButton *)sender;
- (IBAction)ResetLogin:(UIButton *)sender;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"log_bg"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//代码实现轻触背景关闭键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.view isExclusiveTouch]) {
        [self.view endEditing:YES];
    }
}
//换行关闭
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}



- (IBAction)ResetRequestSmsCode:(UIButton *)sender {
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:_ResetmobileNumber.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [JCAlertView showOneButtonWithTitle:@"" Message:@"请输入正确的手机号码" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:nil];
        } else {
            //获得smsID
            NSLog(@"sms ID：%d",number);
            //设置不可点击
            [self setRequestSmsCodeBtnCountDown];
        }
    }];
}

- (IBAction)ResetLogin:(UIButton *)sender {
    [BmobUser resetPasswordInbackgroundWithSMSCode:_ResetSmsCode.text andNewPassword:_ResetPassword.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"%@",@"重置密码成功");
            [self performSegueWithIdentifier:@"ReLoginUser" sender:self];
        } else {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - 点击请求验证码之后button不能够点击 60s后进行点击的相关逻辑

//设置点击验证码后 60秒内不能够点击
-(void)setRequestSmsCodeBtnCountDown{
    [self.ResetRequestBtn setEnabled:NO];
    self.ResetRequestBtn.backgroundColor = [UIColor grayColor];
    ResetsecondsCountDown = 60;
    
    ResetcountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES];
    [ResetcountDownTimer fire];
}

//60秒之后 可以点击发送验证码
-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (ResetsecondsCountDown == 0) {
        [self.ResetRequestBtn setEnabled:YES];
        self.ResetRequestBtn.backgroundColor = [UIColor redColor];
        [self.ResetRequestBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [ResetcountDownTimer invalidate];
    } else {
        [self.ResetRequestBtn setTitle:[[NSNumber numberWithInt:ResetsecondsCountDown] description] forState:UIControlStateNormal];
        ResetsecondsCountDown--;
    }
}

@end
