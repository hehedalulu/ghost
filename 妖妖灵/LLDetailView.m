//
//  LLDetailView.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "LLDetailView.h"

@implementation LLDetailView

- (void)drawRect:(CGRect)rect {
    
    DetailimageNameArray = [[NSArray alloc]initWithObjects:
                            @"pumkin_character_pumkin_BG",
                            @"skull_bg",
                            @"character_bg", nil];
    DetailcontextArray = [[NSArray alloc]initWithObjects:
                            @"期待被拯救的灵魂，和黑暗中的妖精有场不请之约\n外表圆润光亮，灵魂藏匿在空空如也的大肚子里\n就像个不动声色的大人\n旅途上请不时回头张望，让一切物归原主\n风刀霜剑严相逼，被改变的从来都只有自己",
                          @"木讷的臂膀挥舞着绝望的气息\n空洞的双眼看不到一丝思维的跃动\n一步两步，踉踉跄跄，像是被冗杂教条绑架的傀儡\n入侵者所有闪烁着的好奇和想象，都被绷带捆绑杀戮\n少年，请用力摇晃挣脱！\n",
                          @"美貌的外表下，藏匿着歹毒的心\n嘴里振振有词，“咕咕咕”熬制着蛊惑人心的毒药\n入侵者所有快乐的情绪，都被弥漫着恶臭的毒药洗劫一空\n只剩下那些涂抹着黑暗、痛苦、孤独的回忆\n少年，请放声反抗！\n",
                            nil];
    DetailTextBoxArray = [[NSArray alloc]initWithObjects:
                            @"pumkin_conversion_text_box",
                            @"skull_catch_box",
                            @"text_board", nil];
    
    

    CGSize size = self.frame.size;
    UIImageView *BackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    BackgroundImageView.image = [UIImage imageNamed:DetailimageNameArray[_llDetailMonsteriD]];
    [self addSubview:BackgroundImageView];
    
    UIImageView *text_box = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, 410, 200)];
    text_box.image = [UIImage imageNamed:DetailTextBoxArray[_llDetailMonsteriD]];
    [BackgroundImageView addSubview:text_box];
    
    
    _llDetailContext = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 360, 200)];
    _llDetailContext.text = DetailcontextArray[_llDetailMonsteriD];
    _llDetailContext.textColor = [UIColor whiteColor];
    _llDetailContext.font = [UIFont systemFontOfSize:17];
//    _llDetailContext.lineBreakMode = NSLineBreakByCharWrapping;
    _llDetailContext.numberOfLines = 0;
    [text_box addSubview:_llDetailContext];
    
//    _llDetailName = [[UILabel alloc]initWithFrame:CGRectMake(260, 500, 100, 50)];
//    _llDetailName.text = @"名字";
//    _llDetailName.textColor = [UIColor blackColor];
//    _llDetailName.font = [UIFont systemFontOfSize:18];
//    [self addSubview:_llDetailName];
//    
//    _llDetailAge = [[UILabel alloc]initWithFrame:CGRectMake(350, 500, 70, 50)];
//    _llDetailAge.text = @"年龄";
//    _llDetailAge.textColor = [UIColor blackColor];
//    _llDetailAge.font = [UIFont systemFontOfSize:18];
//    [self addSubview:_llDetailAge];
    
}
@end
