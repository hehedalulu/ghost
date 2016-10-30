//
//  LLTalkView.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "LLTalkView.h"

@implementation LLTalkView

- (void)drawRect:(CGRect)rect {
    
    

    pumpkinTalkArray = [[NSArray alloc]initWithObjects:
                        @"让我把我唯一知道的秘密都告诉你\n我被困在这里是因为我的想象被亡命之徒盗窃一空",
                        @"找到那群拥有永不疲倦好奇心的人儿，是拯救我的唯一出路",
                        @"求....你快去",
                        @"Hey～你终于来了！带着对世界毫不设防，无限的好奇想法带着愿意尝试那些一无是处的美好带来的大笑你还记得我嘛？",nil];
    skeletonTalkArray = [[NSArray alloc]initWithObjects:
                        @"我的食物，你终于来了！",
                        @"嗅到鲜活淘气的想法",
                        @"啧啧啧可真馋啊", nil];
    witchTalkArray =[[NSArray alloc]initWithObjects:
                        @"我的食物，你终于来了！",
                        @"柔软欢乐的回忆里透着隐隐清香，可真诱人啊",
                        @"我要把它们都通通丢进毒汤中慢慢熬制", nil];
    LLTalkNameArray =[[NSArray alloc]initWithObjects:
                        @"南瓜(lantern)",
                        @"骷髅(skeleton)",
                        @"女巫(witch)",nil];
    LLTalkAgeArray = [[NSArray alloc]initWithObjects:
                        @"10",
                        @"1000",
                        @"200",nil];
    
    talkviewimageArray = [[NSArray alloc]initWithObjects:
                        @"pumkin_conversion_text_box",
                        @"skull_catch_box",
                        @"text_board",
                        @"",
                        @"skull_catch_box",
                        @"text_board",nil];
    
    LLCaptureNameArray = [[NSArray alloc]initWithObjects:
                          @"妖妖灵开始",
                          @"妖妖灵",
                          @"继续妖妖灵", nil];
    
    AfterKillWitch = [[NSArray alloc]initWithObjects:
                        @"好想攫夺走你那双闪耀着笑容的眼睛",
                        @"喂，请务必年轻得久一点哦",
                        @"我们江湖再见", nil];
    AfterKillSkeleton = [[NSArray alloc]initWithObjects:
                         @"羡慕你经得起消耗的想象和童心",
                         @"喂，请务必年轻得久一点哦",
                         @"它是你走向征途的唯一武器", nil];
    
    if (_MonsteriD == 0 ) {
        LLtalkingArray = pumpkinTalkArray;
    }else if (_MonsteriD == 1){
        LLtalkingArray = skeletonTalkArray;
    }else if(_MonsteriD == 2){
        LLtalkingArray = witchTalkArray;
    }else if(_MonsteriD == 4){
        LLtalkingArray = AfterKillSkeleton;
    }else if(_MonsteriD == 5){
        LLtalkingArray = AfterKillWitch;
    }
    timeOfClick = 0;
    
    if (_MonsteriD == 1) {
        _LLTalkView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 330, 100)];
    }else{
            _LLTalkView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 330, 220)];
    }

    _LLTalkView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:talkviewimageArray[_MonsteriD]]];
//    _LLTalkView.titleLabel.font = [UIFont systemFontOfSize:20];
    [_LLTalkView addTarget:self action:@selector(clickchangelabel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_LLTalkView];
    
    contextlabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 300, 200)];
    contextlabel.text = LLtalkingArray[0];
    contextlabel.textColor = [UIColor whiteColor];
    contextlabel.font = [UIFont systemFontOfSize:20];
    contextlabel.numberOfLines = 0;
    contextlabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_LLTalkView addSubview:contextlabel];
    
    
    
//    
//    _LLTalkViewName = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 50, 40)];
//    _LLTalkViewName.textColor = [UIColor grayColor];
//    _LLTalkViewName.text = LLTalkNameArray[_MonsteriD];
//    _LLTalkViewName.font = [UIFont systemFontOfSize:20];
//    [self addSubview:_LLTalkViewName];
//    
//    _LLTalkViewAge  = [[UILabel alloc]initWithFrame:CGRectMake(150, 350, 50, 40)];
//    _LLTalkViewAge.textColor = [UIColor grayColor];
//    _LLTalkViewAge.text =LLTalkAgeArray[_MonsteriD] ;
//    _LLTalkViewAge.font = [UIFont systemFontOfSize:20];
//    [self addSubview:_LLTalkViewAge];
}

-(void)clickchangelabel{
    timeOfClick++;
    if (timeOfClick == 1) {
//        [_LLTalkView setTitle:LLtalkingArray[timeOfClick] forState:UIControlStateNormal];
        contextlabel.text = LLtalkingArray[timeOfClick];
        
    }else if(timeOfClick == 2){
//        [_LLTalkView setTitle:LLtalkingArray[timeOfClick]forState:UIControlStateNormal];
        contextlabel.text = LLtalkingArray[timeOfClick];
    }else{
        _LLTalkView.hidden = YES;
        
        if (_MonsteriD == 5) {
            Save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
            [Save setTitle:@"完成捉妖" forState:UIControlStateNormal];
            [Save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            Save.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.5];
            Save.titleLabel.font = [UIFont systemFontOfSize:20];
            [self addSubview:Save];
            [Save addTarget:self action:@selector(kkkwwwitch5) forControlEvents:UIControlEventTouchUpInside];

        }else  if (_MonsteriD == 4) {
            Save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
            [Save setTitle:@"继续捉妖" forState:UIControlStateNormal];
            [Save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            Save.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pumkin_catch_text_box"]];
            Save.titleLabel.font = [UIFont systemFontOfSize:20];
            [self addSubview:Save];
            [Save addTarget:self action:@selector(kkkwwwitch) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (_MonsteriD == 0) {
            Save = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 200, 50)];
            [Save setTitle:@"开始拯救任务" forState:UIControlStateNormal];
            [Save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            Save.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pumkin_catch_text_box"]];
            Save.titleLabel.font = [UIFont systemFontOfSize:20];
            [self addSubview:Save];
            [Save addTarget:self action:@selector(kkkwwwitch) forControlEvents:UIControlEventTouchUpInside];
        }else if (_MonsteriD == 2) {
            Save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
            [Save setTitle:@"继续捉妖" forState:UIControlStateNormal];
            [Save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            Save.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pumkin_catch_text_box"]];
            Save.titleLabel.font = [UIFont systemFontOfSize:20];
            [self addSubview:Save];
            [Save addTarget:self action:@selector(sendkillWitch) forControlEvents:UIControlEventTouchUpInside];

//            [Save addTarget:self action:@selector(kkkwwwitch) forControlEvents:UIControlEventTouchUpInside];
        }else if (_MonsteriD == 1) {
            VoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 350, 80, 80)];
            [VoiceBtn setBackgroundImage:[UIImage imageNamed:@"witch_talking"] forState:UIControlStateNormal];
            [VoiceBtn setBackgroundImage:[UIImage imageNamed:@"talking_press"] forState:UIControlStateHighlighted];
            [self addSubview:VoiceBtn];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SkeletonHasBeenCapture" object:@"Success_CaptureSkeleton"];
        }


    }
}
-(void)kkkwwwitch{
    Save.hidden = YES;

}

-(void)kkkwwwitch5{
    Save.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwipeToFont" object:@"Success_Save"];
}
-(void)sendkillWitch{
    Save.hidden = YES;
    NSLog(@"点击按钮");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WitchHasBeenCapture" object:@"Success_CaptureWitch"];
        

}


@end
