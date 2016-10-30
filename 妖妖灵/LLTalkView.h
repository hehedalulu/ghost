//
//  LLTalkView.h
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLTalkView : UIView{
    int  timeOfClick;
    UIButton *Save;
    UIButton *VoiceBtn;
    
    NSArray *LLtalkingArray;
    NSArray *pumpkinTalkArray;
    NSArray *skeletonTalkArray;
    NSArray *witchTalkArray;
    
    NSArray *talkviewimageArray;
    
    NSArray *LLTalkNameArray;
    NSArray *LLTalkAgeArray;
    
    NSArray *LLCaptureNameArray;
    
    NSArray *AfterKillWitch;
    NSArray *AfterKillSkeleton;
    UILabel *contextlabel;

}
@property (nonatomic,strong) UIButton *LLTalkView;

@property (nonatomic,strong) UILabel *LLTalkViewName;

@property (nonatomic,strong) UILabel *LLTalkViewAge;

@property (nonatomic) int TimeOfMonster;

@property (nonatomic) int MonsteriD;

@property (nonatomic,strong) NSString *LLTalkContext;

@property (nonatomic,strong) NSString *LLTalkName;

@property (nonatomic,strong) NSString *LLTalkAge;

@property (nonatomic) int TalkHasCaptureSkeleton;

@property (nonatomic) int TalkHasCaptureSwitch;
//@property (nonatomic) BOOL LLTalkPumpkinHasBeenSaved;

@end
