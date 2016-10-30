//
//  LLRegisterViewController.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "LLRegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "JCAlertView.h"

@interface LLRegisterViewController ()<UITextViewDelegate>{
    NSTimer *countDownTimer;
    unsigned secondsCountDown;
}

@property (strong, nonatomic) IBOutlet UITextField *wllResigterUsername;
@property (strong, nonatomic) IBOutlet UITextField *wllRegisterPassword;
@property (strong, nonatomic) IBOutlet UITextField *InputSMSCode;
@property (strong, nonatomic) IBOutlet UIButton *RequestSmsCodeBtn;
- (IBAction)RegisterUserName:(UIButton *)sender;
- (IBAction)RequestSmsCode:(UIButton *)sender;

@end

@implementation LLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"log_bg"]]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)RegisterUserName:(UIButton *)sender {
    
    //手机号注册用户
    NSLog(@"开始注册用户");
    //该方法可以进行注册和登录两步操作，如果已经注册过了就直接进行登录
    BmobUser *buser = [[BmobUser alloc] init];
    buser.mobilePhoneNumber = _wllResigterUsername.text;
    buser.password = _wllRegisterPassword.text;
    //    buser.email = @"xxx@gmail.com";
    [buser signUpOrLoginInbackgroundWithSMSCode:_InputSMSCode.text block:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [self FailtoRequestSmsCode];
        } else {
            BmobUser *user = [BmobUser currentUser];
            NSLog(@"%@",user);
            //跳转
            [self SuccessRegister];
        }
    }];
}

- (IBAction)RequestSmsCode:(UIButton *)sender {
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:_wllResigterUsername.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
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

#pragma mark - 点击请求验证码之后button不能够点击 60s后进行点击的相关逻辑

//设置点击验证码后 60秒内不能够点击
-(void)setRequestSmsCodeBtnCountDown{
    [self.RequestSmsCodeBtn setEnabled:NO];
    self.RequestSmsCodeBtn.backgroundColor = [UIColor grayColor];
    secondsCountDown = 60;
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES];
    [countDownTimer fire];
}

//60秒之后 可以点击发送验证码
-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (secondsCountDown == 0) {
        [self.RequestSmsCodeBtn setEnabled:YES];
        self.RequestSmsCodeBtn.backgroundColor = [UIColor redColor];
        [self.RequestSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [countDownTimer invalidate];
    } else {
        [self.RequestSmsCodeBtn setTitle:[[NSNumber numberWithInt:secondsCountDown] description] forState:UIControlStateNormal];
        secondsCountDown--;
    }
}

//注册成功后跳出提示框 点击进入
- (void)SuccessRegister{
    [JCAlertView showOneButtonWithTitle:@"" Message:@"注册成功" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"马上登录" Click:^{
        //注册完成 跳转
        [self performSegueWithIdentifier:@"RegistSuccess" sender:self];
    }];
    
}

//验证码验证失败后 跳出提示框
- (void)FailtoRequestSmsCode{
    [JCAlertView showOneButtonWithTitle:@"" Message:@"验证码有误" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"再次尝试" Click:nil];
}

@end
