//
//  LLEventTableViewController.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "LLEventTableViewController.h"
#import "UIView+SDAutoLayout.h"

@interface LLEventTableViewController ()

@end

@implementation LLEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer  = @"SelfCell";
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifer];
    //取消选中效果
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell == nil ) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        
        if (indexPath.row == 0) {
            UILabel *MainMenuLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, 200, 40)];
            MainMenuLabel.text = @"故事背景";
            MainMenuLabel.textColor = [UIColor blackColor];
            MainMenuLabel.font = [UIFont systemFontOfSize:30];
            [cell addSubview:MainMenuLabel];
            
            UILabel *ContextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 350, 200)];
            ContextLabel.text = @"从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜从前有个南瓜";
            ContextLabel.textColor = [UIColor grayColor];
            ContextLabel.font =[UIFont systemFontOfSize:18];
            ContextLabel.lineBreakMode = NSLineBreakByCharWrapping;
            ContextLabel.numberOfLines = 0 ;
            [cell addSubview:ContextLabel];
            
            
            UIButton *ToNextPage = [[UIButton alloc]initWithFrame:CGRectMake(150, 300, 80, 40)];
            [ToNextPage setTitle:@"前往捉妖" forState:UIControlStateNormal];
            [ToNextPage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            ToNextPage.backgroundColor = [UIColor orangeColor];
            
            [cell addSubview:ToNextPage];
            [ToNextPage addTarget:self action:@selector(clickin) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (indexPath.row == 1) {
            UILabel *EventTime = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, 150, 40)];
            EventTime.text = @"活动时间";
            EventTime.font = [UIFont systemFontOfSize:20];
            EventTime.textColor = [UIColor grayColor];
            
            UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(130, 50, 180, 40)];
            time.text = @"即日起至11月8日";
            time.font = [UIFont systemFontOfSize:20];
            time.textColor = [UIColor grayColor];
            
            UILabel *sencondLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 100, 150, 40)];
            sencondLabel.text = @"活动奖励";
            sencondLabel.font = [UIFont systemFontOfSize:20];
            
            [cell addSubview:EventTime];
            [cell addSubview:time];
            [cell addSubview:sencondLabel];
            
            UILabel *eventContext = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, 350, 100)];
            eventContext.text = @"获得什么什么什么什么获得什么什么什么什么获得什么什么什么什么获得什么什么什么什么获得什么什么什么什么获";
            eventContext.textColor = [UIColor grayColor];
            eventContext.font = [UIFont systemFontOfSize:20];
            eventContext.lineBreakMode = NSLineBreakByCharWrapping;
            eventContext.numberOfLines = 0;
            [cell addSubview:eventContext];
            
          
        }
    }
    
    
    //删除多余的分割线
    //    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    
    return cell;
}


-(void)clickin{
    [self performSegueWithIdentifier:@"ComeToCapture" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中效果
}


-(void)setupIntroduction{
    
    
}

@end
