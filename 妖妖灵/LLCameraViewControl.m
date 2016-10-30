//
//  LLCameraViewControl.m
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import "LLCameraViewControl.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "JCAlertView.h"
#import "LLDetailView.h"
#import "LLTalkView.h"

@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechRecognizer;

@interface LLCameraViewControl ()<UIScrollViewDelegate>

@end
@implementation LLCameraViewControl{
    UIButton *VoiceBtn;
    UIView *longpressView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _glView.FONTORNOT = NO;
    
    self.ResultString = @"";
    self.navigationController.navigationBar.hidden = YES;
    self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.glView];
    [self.glView setOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    
    _glView.hasTapView = false;
    _glView.IsThefirstTimeIntroduction = YES;
    _glView.IsThefirstTimeMeetWitch = YES;
    _glView.IsThefirstTimeMeetskeleton = YES;

    //    [self JudgeTap];
    
    UIButton *StoryBackground =  [[UIButton alloc]initWithFrame:CGRectMake(340, 30, 60, 60)];
    [StoryBackground setImage:[UIImage imageNamed:@"book"]forState:UIControlStateNormal];
    StoryBackground.titleLabel.font = [UIFont systemFontOfSize:25];
    [StoryBackground addTarget:self action:@selector(BackStoryBackground) forControlEvents:UIControlEventTouchUpInside];
    [self.glView addSubview:StoryBackground];
    
    UIButton *GiveUpGhost = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 40, 40)];
    [GiveUpGhost setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    GiveUpGhost.titleLabel.font = [UIFont systemFontOfSize:25];
    [GiveUpGhost addTarget:self action:@selector(GiveUpNowTask) forControlEvents:UIControlEventTouchUpInside];
    [self.glView addSubview:GiveUpGhost];
    

    
    UIButton *Hint = [[UIButton alloc]initWithFrame:CGRectMake(340, 120, 60, 60)];
    [Hint setImage:[UIImage imageNamed:@"light_bulb"] forState:UIControlStateNormal];
    Hint.titleLabel.font = [UIFont systemFontOfSize:25];
    [Hint addTarget:self action:@selector(GiveHint) forControlEvents:UIControlEventTouchUpInside];
    [self.glView addSubview:Hint];
    

    //观察女巫被捕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeWitchVideo:) name:@"WitchHasBeenCapture" object:nil];
    //观察女巫被捕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeSkeletonVideo:) name:@"SkeletonHasBeenCapture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SuccessCCC:) name:@"SwipeToFont" object:nil];
//    if (_EndSuccessCaptureSkeleton) {
//        if(_EndSuccessCaptureWitch){
//            [_glView stop];
//            _glView.FONTORNOT = YES;
//            [_glView start];
//        }
//    }
}

-(void)SuccessCCC:(NSNotification *)notification{
    if ([[notification object]  isEqual: @"Success_Save"] ) {
        [_glView stop];
        _glView.FONTORNOT = YES;
        [_glView start];
        
    }
}


-(void)ChangeWitchVideo:(NSNotification *)notification{
    NSLog(@"成功杀死女巫");
    if ([[notification object]  isEqual: @"Success_CaptureWitch"] ) {
        [_glView stop];
        _glView.TimeofMeetWitch = 3;
        [_glView start];
        [self performSelector:@selector(AfterkillWitch) withObject:nil afterDelay:5.0f];
        
    }
}

-(void)AfterkillWitch{
    [_glView stop];
    _glView.TimeofMeetWitch = 4;
    [_glView start];
    LLTalkView *afterKillWitchView = [[LLTalkView alloc]initWithFrame:CGRectMake(50, 150, 350, 400)];
    afterKillWitchView.backgroundColor = [UIColor clearColor];
    afterKillWitchView.MonsteriD = 5;
    [_glView addSubview:afterKillWitchView];
    
    
    
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇一摇停止");
    if (NoticeSkeleton) {
        [_glView stop];
        _glView.TimeOfMeetSkeleton = 3;
        [_glView start];
        _EndSuccessCaptureSkeleton = YES;
    [self performSelector:@selector(AfterkillSkeleton) withObject:nil afterDelay:5.0f];
    }
}
-(void)AfterkillSkeleton{
    [_glView stop];
    _glView.TimeOfMeetSkeleton = 4;
    _glView.IsThefirstTimeMeetskeleton = NO;
    [_glView start];
    LLTalkView *afterKillSkeletonView = [[LLTalkView alloc]initWithFrame:CGRectMake(50, 150, 350, 400)];
    afterKillSkeletonView.backgroundColor = [UIColor clearColor];
    afterKillSkeletonView.MonsteriD = 4;
    [_glView addSubview:afterKillSkeletonView];
    _EndSuccessCaptureSkeleton = YES;
    
}
-(void)ChangeSkeletonVideo:(NSNotification *)notification{
    NSLog(@"成功获取骷髅结束对话");
    if ([[notification object]  isEqual: @"Success_CaptureSkeleton"] ) {
        NoticeSkeleton = YES;
        _EndSuccessCaptureWitch = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.glView start];
    [self initRecognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.glView stop];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.glView resize:self.view.bounds orientation:[UIApplication sharedApplication].statusBarOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.glView setOrientation:toInterfaceOrientation];
}

#pragma mark - 点击之后的处理
-(void)JudgeTap{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.glView addGestureRecognizer:tapGestureRecognizer];
}


-(void)handleTap:(UITapGestureRecognizer *)sender{
    
    [_glView stop];
    if (sender.state == UIGestureRecognizerStateEnded) {
        UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 400, 100)];
        testLabel.font = [UIFont systemFontOfSize:45];
        testLabel.text = @"捉住一只可爱的lulu";
        testLabel.textColor = [UIColor redColor];
        [self.glView addSubview:testLabel];
        _glView.hasTapView = TRUE;
        [_glView start];
        
        UIButton *testbtn1 =[[UIButton alloc]initWithFrame:CGRectMake(100, 400, 50, 50)];
        testbtn1.titleLabel.text = @"点击开始语音";
        testbtn1.backgroundColor = [UIColor redColor];
        [self.view addSubview:testbtn1];
        [testbtn1 addTarget:self action:@selector(touchSpeak) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *testbtn2 =[[UIButton alloc]initWithFrame:CGRectMake(200, 500, 50, 50)];
        testbtn2.titleLabel.text = @"结束语音";
        testbtn2.backgroundColor = [UIColor greenColor];
        [self.view addSubview:testbtn2];
        [testbtn2 addTarget:self action:@selector(stopBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
}




#pragma mark- 初始化语音识别参数
-(void)initRecognizer
{
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        //单例模式，无UI的实例
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}

- (void)stopBtnHandler{
    
    NSLog(@"结束说话");
    [_iFlySpeechRecognizer stopListening];
    NSLog(@"%@",self.ResultString);
    
}

#pragma mark - 语音听写方法的回调

-(void)touchSpeak{//开始监听用户的语音
    
    //    NSLog(@"说话了....");
    
    //启动识别服务
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        self.voiceStr = @"";
        
        self.isCanceled = NO;
        
        if(_iFlySpeechRecognizer == nil)
            
        {
            
            [self initRecognizer];
            
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            
            //启动识别服务成功
            
        }else{
            
            //启动识别服务失败
            
        }
        
    }
    
}

#pragma mark 语音代理方法 IFlySpeechRecognizerDelegate

/**
 
 无界面，听写结果回调
 
 results：听写结果
 
 isLast：表示最后一次
 
 ****/

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast

{
    
    NSLog(@"说完了...");
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        
        [resultString appendFormat:@"%@",key];
        
    }
    
    NSString * resultFromJson =  [ISRDataHelper    stringFromJson:resultString];
    
    //    NSLog(@"%@",resultString);
    
    self.voiceStr = [NSString stringWithFormat:@"%@%@",    self.voiceStr,resultFromJson];
    //    NSLog(@"听到的话：%@",self.voiceStr);
    
    if (isLast){//是否是最后一次回调 因为此方法会调用多次
        
        NSLog(@"听写结果(json)：%@",  self.voiceStr);
        
        
        
        if (self.voiceStr.length>0) {
            
            self.ResultString = _voiceStr;
            
        }
        
        else{
            
            NSLog(@"未检测到");
            
        }
        
    }
    
}

/**
 
 听写结束回调（注：无论听写是否正确都会回调）
 
 error.errorCode =
 
 0     听写正确
 
 other 听写出错
 
 ****/

- (void) onError:(IFlySpeechError *) error

{
    
    //    NSLog(@"%s",__func__);
    
    NSString *text ;
    
    if (self.isCanceled) {
        
        text = @"识别取消";
        
    } else if (error.errorCode == 0 ) {
        
        if (self.voiceStr.length == 0) {
            
            text = @"无识别结果";
            
        }else {
            
            text = @"识别成功";
            
        }
        
    }else {
        
        text = [NSString stringWithFormat:@"发生错误：%d %@",    error.errorCode,error.errorDesc];
        
        NSLog(@"%@",text);
        
    }
    
}

/**
 
 音量回调函数
 
 volume 0－30
 
 ****/

- (void) onVolumeChanged: (int)volume

{
    
    //    NSLog(@"%d",volume);
    
    if (self.isCanceled) {
        
        return;
        
    }
    
    if (volume == 0) {
        //没有检测到声音 做一个静态的麦克风图片
    }
    
    if (volume > 0) {
        //有检测到声音 做一个动态的麦克风图片
    }
    
}

#pragma mark - 咒语学习弹窗

- (void)LearnSpellAlertView{
    [JCAlertView showOneButtonWithTitle:@"柳柳咒语大法" Message:@"常明明是世界上最帅的斑马" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"got it" Click:nil];
}

-(void)GiveUpNowTask{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - 咒语匹配
-(void)HasTapVoiceMatch{
    //    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    //    longPressGr.minimumPressDuration = 0.5;
    //    [VoiceBtn addGestureRecognizer:longPressGr];
    
    [self touchSpeak];
    NSLog(@"开始说话");
    
    [self performSelector:@selector(stopBtnHandler) withObject:nil afterDelay:4.0f];
    
    [self performSelector:@selector(delayToMatch) withObject:nil afterDelay:5.0f];
    
    
}



//匹配nsstring是否相同
-(void)delayToMatch{
    NSLog(@"%@",self.ResultString);
    NSLog(@"%@",self.voiceStr);
    
    //    NSString *CorrectString = @"常明明是世界上最帅的斑马。";
    //    if ([self.ResultString isEqualToString:CorrectString]) {
    [self SuccessCapture];
    [_glView stop];
    _glView.hasTapView = TRUE;
    [_glView start];
    //        [self performSelector:@selector(GiveUpNowTask) withObject:nil afterDelay:2.0f];
    //    }
    
}

-(void)backtoPage{
    
    
}
# pragma mark - 右上角的提示
-(void)BackStoryBackground{
    UIView *BackScroll = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 330, 330)];
    BackScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text-block"]];
    UILabel *hintlabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, 70, 30)];
    hintlabel.text = @"提示";
    hintlabel.textColor = [UIColor colorWithRed:240.0/255.0 green:221.0/255.0 blue:223.0/255.0 alpha:1];
    hintlabel.font = [UIFont systemFontOfSize:18];
    [BackScroll addSubview:hintlabel];
    
    UIScrollView *BackgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 45, 300, 205)];
    [BackScroll addSubview:BackgroundScrollView];
    [BackgroundScrollView setCanCancelContentTouches:NO];
    BackgroundScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    BackgroundScrollView.clipsToBounds = YES;
    BackgroundScrollView.pagingEnabled = YES;
    BackgroundScrollView.scrollEnabled = YES;
    BackgroundScrollView.delegate = self;
    BackgroundScrollView.showsHorizontalScrollIndicator = NO;
    BackgroundScrollView.tag = 1;
    UIPageControl *pageControl;
    
    int count = 3;
    CGSize size = CGSizeMake(300, 205);
    for (int i = 0; i < count; i++) {
//        UIView *ContextView = [[UIView alloc]init];
        CGFloat x = i * size.width;
//        ContextView.frame = CGRectMake(x, 0, size.width, size.height);
        UILabel *Context = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, size.width, size.height)];
        Context.textColor = [UIColor colorWithRed:240.0/255.0 green:221.0/255.0 blue:223.0/255.0 alpha:1];
        Context.font = [UIFont systemFontOfSize:14];
        Context.numberOfLines = 0;
        Context.lineBreakMode = NSLineBreakByCharWrapping;
        if (i == 0) {
            Context.text = @"故事背景";
        }else if (i == 1){
            Context.text = @"测试1111";
        }else{
            Context.text = @"测试2222";
        }
        [BackgroundScrollView addSubview:Context];
    }
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(50, 220, 100, 20)];
    [pageControl setBackgroundColor:[UIColor whiteColor]];
    [BackScroll addSubview:pageControl];
    
    //设置滚动范围
    BackgroundScrollView.contentSize = CGSizeMake(count *size.width,0);
    BackgroundScrollView.showsHorizontalScrollIndicator = NO;
    //设置分页
    BackgroundScrollView.pagingEnabled = YES;
    //设置pagecontroll
    pageControl.numberOfPages = count;
    //设置scrollview的代理
    BackgroundScrollView.delegate = self;
    
    int page = BackgroundScrollView.contentOffset.x /BackgroundScrollView.frame.size.width;
    pageControl.currentPage = page;
    
    
    JCAlertView *customIntroduction = [[JCAlertView alloc]initWithCustomView:BackScroll dismissWhenTouchedBackground:YES];
    [customIntroduction show];
    
}

//-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
//    int page = self.scrollView.contentOffset.x /self.scrollView.frame.size.width;
//    self.pageControl.currentPage = page;
//
//}

-(void)GiveHint{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 330, 260)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text-block"]];
    
    UILabel *hinttitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 20, 50, 40)];
    hinttitle.text = @"提示";
    hinttitle.textColor = [UIColor colorWithRed:4.0/255.0 green:19.0/255.0 blue:34.0/255.0 alpha:0.8];
    hinttitle.font = [UIFont systemFontOfSize:20];
    [backgroundView addSubview: hinttitle];
    
    UIButton *BuyBtn = [[UIButton alloc]initWithFrame:CGRectMake(55, 200, 100, 40)];
    [BuyBtn setTitle:@"5积分购买" forState:UIControlStateNormal];
    BuyBtn.titleLabel.textColor = [UIColor grayColor];
    BuyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    BuyBtn.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:BuyBtn];
    
    UIImageView *puzzelimage = [[UIImageView alloc]initWithFrame:CGRectMake(60, 55, 80, 80)];
    puzzelimage.backgroundColor = [UIColor greenColor];
    [backgroundView addSubview:puzzelimage];
    
    JCAlertView *customPuzzle = [[JCAlertView alloc]initWithCustomView:backgroundView dismissWhenTouchedBackground:YES];
    [customPuzzle show];
}

- (void)SuccessCapture{
    [JCAlertView showOneButtonWithTitle:@"恭喜你" Message:@"成功捕获一只柳柳" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"收下啦" Click:nil];
}


@end
