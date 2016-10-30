//
//  LLLoginViViewController.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "LLLoginViViewController.h"
#import <BmobSDK/Bmob.h>
#import "JCAlertView.h"

@interface LLLoginViViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *wllUsername;
@property (strong, nonatomic) IBOutlet UITextField *wllUserpassword;
- (IBAction)LoginUser:(UIButton *)sender;

@end

@implementation LLLoginViViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"log_bg"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//换行关闭
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

//代码实现轻触背景关闭键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.view isExclusiveTouch]) {
        [self.view endEditing:YES];
    }
}


- (IBAction)LoginUser:(UIButton *)sender {
    NSString *mobilePhoneNumber = _wllUsername.text;
    NSString *userpassword = _wllUserpassword.text;
    [BmobUser loginInbackgroundWithAccount:mobilePhoneNumber andPassword:userpassword block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"%@",user);
            [self performSegueWithIdentifier:@"LoginUser" sender:self];
        } else {
            NSLog(@"%@",error);
            [JCAlertView showOneButtonWithTitle:@"" Message:@"密码输入错误" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"再次尝试" Click:nil];
        }
    }];
}
@end
