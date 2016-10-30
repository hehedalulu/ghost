/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import "OpenGLView.h"
#import "AppDelegate.h"

#include <iostream>
#include "ar.hpp"
#include "renderer.hpp"

#import "LLDetailView.h"
#import "LLTalkView.h"
#import "JCAlertView.h"

/*
* Steps to create the key for this sample:
*  1. login www.easyar.com
*  2. create app with
*      Name: HelloARVideo
*      Bundle ID: cn.easyar.samples.helloarvideo
*  3. find the created item in the list and show key
*  4. set key string bellow
*/
NSString* key = @"CDzPD8QPwSn4zBbqikT46C335CLZZiyPjk59SRP8ZvaL4l8YVJgqMZpZKoilPit4hRw9f4XXkPiM8SwLbVvswgcIZbldULs4IRrM621f22479a8333bd44802fa829a96ad3cXzjALCpkYfEWJor98ypwa9JnW6If1BZycaPPbpKbpgbFNydVSg2MH9dNT7pDzh86IYR";

namespace EasyAR {
namespace samples {

class HelloARVideo : public AR
{
public:
    HelloARVideo();
    ~HelloARVideo();
    virtual void initGL();
    virtual void resizeGL(int width, int height);
    virtual void render();
    virtual bool clear();
    //定制
    BOOL    hastap;
    int     timeOfMeetPumpkin;
    int     timeOfMeetskeleton;
    int     timeOfMeetWitch;
    
    BOOL    isThefirstTimeIntroduction;
    BOOL    showDetail;
    BOOL    showPumpkintalk;
    
    BOOL    isThefirstTimeMeetskeleton;
    BOOL    showskeletonIntroduction;
    BOOL    showSkeletontalk;
    
    BOOL    isThefirstTimeMeetWitch;
    BOOL    showwitchIntroduction;
    BOOL    showWitchtalk;
private:
    Vec2I view_size;
    VideoRenderer* renderer[3];
    int tracked_target;
    int active_target;
    int texid[3];

    ARVideo* video;
    VideoRenderer* video_renderer;
};

HelloARVideo::HelloARVideo()
{
    view_size[0] = -1;
    tracked_target = 0;
    active_target = 0;
    for(int i = 0; i < 3; ++i) {
        texid[i] = 0;
        renderer[i] = new VideoRenderer;
    }
    video = NULL;
    video_renderer = NULL;
}
    
//建三个缓冲区
HelloARVideo::~HelloARVideo()
{
    for(int i = 0; i < 3; ++i) {
        delete renderer[i];
    }
}

//初始化video
void HelloARVideo::initGL()
{
    augmenter_ = Augmenter();
    for(int i = 0; i < 3; ++i) {
        renderer[i]->init();
        //给每一个缓冲区绑定一个id
        texid[i] = renderer[i]->texId();
    }
}


void HelloARVideo::resizeGL(int width, int height)
{
    view_size = Vec2I(width, height);
}

void HelloARVideo::render()
{
    glClearColor(0.f, 0.f, 0.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    Frame frame = augmenter_.newFrame();
    if(view_size[0] > 0){
        int width = view_size[0];
        int height = view_size[1];
        Vec2I size = Vec2I(1, 1);
        if (camera_ && camera_.isOpened())
            size = camera_.size();
        if(portrait_)
            std::swap(size[0], size[1]);
        float scaleRatio = std::max((float)width / (float)size[0], (float)height / (float)size[1]);
        Vec2I viewport_size = Vec2I((int)(size[0] * scaleRatio), (int)(size[1] * scaleRatio));
        if(portrait_)
            viewport_ = Vec4I(0, height - viewport_size[1], viewport_size[0], viewport_size[1]);
        else
            viewport_ = Vec4I(0, width - height, viewport_size[0], viewport_size[1]);
        if(camera_ && camera_.isOpened())
            view_size[0] = -1;
    }
    augmenter_.setViewPort(viewport_);
    augmenter_.drawVideoBackground();
    glViewport(viewport_[0], viewport_[1], viewport_[2], viewport_[3]);

    AugmentedTarget::Status status = frame.targets()[0].status();
    if(status == AugmentedTarget::kTargetStatusTracked){
        int id = frame.targets()[0].target().id();
        if(active_target && active_target != id) {
            video->onLost();
            delete video;
            video = NULL;
            tracked_target = 0;
            active_target = 0;
        }
        //定制
        if (!tracked_target) {
            if (video == NULL) {
                //南瓜
                if(frame.targets()[0].target().name() == std::string("IMG_9023") && texid[0]) {
                    //介绍的view出现之后
                    if (isThefirstTimeIntroduction) {
                        showDetail = YES;//截获识别到了图像
                    }
                    else{
                        if (timeOfMeetPumpkin == 2) {
                            video = new ARVideo;
                            video->openTransparentVideoFile("video.mp4", texid[0]);
                            video_renderer = renderer[0];
                            showPumpkintalk = YES;
                        }else if (timeOfMeetPumpkin == 3){
                            video = new ARVideo;
                            video->openTransparentVideoFile("video_pumkin_rescure.mp4", texid[0]);
                            video_renderer = renderer[0];
                        }
                    }
                }
                //骷髅
                else if(frame.targets()[0].target().name() == std::string("IMG_9025") && texid[1]) {
                    //介绍的view出现之后
                    if (isThefirstTimeMeetskeleton) {
                        showskeletonIntroduction = YES;//截获识别到了图像
                    }
                    else{
                        if (timeOfMeetskeleton == 2) {
                            video = new ARVideo;
                            video->openTransparentVideoFile("mummy.mp4", texid[1]);
                            video_renderer = renderer[1];
                            showSkeletontalk = YES;
                        }else if (timeOfMeetskeleton == 3){
                            video = new ARVideo;
                            video->openTransparentVideoFile("mummydie.mp4", texid[1]);
                            video_renderer = renderer[1];
                        }else if(timeOfMeetskeleton == 4){
                            //kill之后
                        }
                    }
                }
                //女巫
                else if(frame.targets()[0].target().name() == std::string("WechatIMG3") && texid[2]) {
                    if (isThefirstTimeMeetWitch) {
                        showwitchIntroduction = YES;
                    }else{
                        if (timeOfMeetWitch == 2) {
                            video = new ARVideo;
                            video->openTransparentVideoFile("video_witch.mp4", texid[2]);
                            video_renderer = renderer[2];
                            showWitchtalk = YES;
                        }else if (timeOfMeetWitch == 3){
                            video = new ARVideo;
                            video->openTransparentVideoFile("video_witch_elder.mp4", texid[2]);
                            video_renderer = renderer[2];
                        }else if( timeOfMeetWitch == 4){
                            //kill之后
                        }

                    }
                }
            }
            if (video) {
                video->onFound();
                tracked_target = id;
                active_target = id;
            }
        }
        //相机的投影矩阵
        Matrix44F projectionMatrix = getProjectionGL(camera_.cameraCalibration(), 0.2f, 500.f);
        Matrix44F cameraview = getPoseGL(frame.targets()[0].pose());
        ImageTarget target = frame.targets()[0].target().cast_dynamic<ImageTarget>();
        if(tracked_target) {
            video->update();
            video_renderer->render(projectionMatrix, cameraview, target.size());
        }
    } else {
        if (tracked_target) {
            video->onLost();
            tracked_target = 0;
        }
    }
}

   
bool HelloARVideo::clear()
{
    AR::clear();
    if(video){
        delete video;
        video = NULL;
        tracked_target = 0;
        active_target = 0;
    }
    return true;
}

}
}
EasyAR::samples::HelloARVideo ar;

@interface OpenGLView ()
{
}

@property(nonatomic, strong) CADisplayLink * displayLink;

- (void)displayLinkCallback:(CADisplayLink*)displayLink;

@end

@implementation OpenGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = frame.size.height = MAX(frame.size.width, frame.size.height);
    self = [super initWithFrame:frame];
    if(self){

        [self setupGL];
        EasyAR::initialize([key UTF8String]);
        ar.initGL();
        //判断点击事件
        

    }
    return self;
}

- (void)dealloc
{
    ar.clear();
}

- (void)setupGL
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;

    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context)
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
    if (![EAGLContext setCurrentContext:_context])
        NSLog(@"Failed to set current OpenGL context");

    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);

    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);

    int width, height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);

    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
}

//加载图片
- (void)start{
    ar.fontOrNot = _FONTORNOT;
    ar.initCamera();
    ar.loadAllFromJsonFile("targets.json");
    ar.loadFromImage("meilidexuejie.jpeg");
    ar.loadFromImage("WechatIMG1.jpeg");
    ar.loadFromImage("WechatIMG2.jpeg");
    ar.loadFromImage("WechatIMG3.jpeg");
    ar.loadFromImage("IMG_9023.JPG");
    ar.loadFromImage("IMG_9025.JPG");
    //初始化点击为0 把数值传进去
    ar.hastap = _hasTapView;
    ar.isThefirstTimeIntroduction = _IsThefirstTimeIntroduction;
    ar.isThefirstTimeMeetWitch = _IsThefirstTimeMeetWitch;
    ar.isThefirstTimeMeetskeleton = _IsThefirstTimeMeetskeleton;
    
    ar.timeOfMeetPumpkin = _TimeOfMeetPumpkin;
    ar.timeOfMeetskeleton = _TimeofMeetWitch;
    ar.timeOfMeetskeleton = _TimeOfMeetSkeleton;
    ar.start();
    //介绍显示一次 对话显示一次
    Show = YES;
    showSkeletonIntroduction = YES;
    showWitchIntroduction = YES;
    
    showPumpkintalkonce = YES;
    showSkeletonTalkOnce = YES;
    showWitchTalkOnce = YES;
    
    
    

    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}

- (void)stop
{
    ar.clear();
}

- (void)displayLinkCallback:(CADisplayLink*)displayLink
{
    if (!((AppDelegate*)[[UIApplication sharedApplication]delegate]).active)
        return;
    ar.render();

    
    (void)displayLink;
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    //回调显示模型
    [self ShowPumpkinARmodel];
    [self ShowWitchARModel];
    [self ShowSkeletonARModel];
}

//对南瓜回调的AR显示
-(void)ShowPumpkinARmodel{
    //如果已经见过 就不再出现介绍页面
    if(_TimeOfMeetPumpkin == 3){
        ar.isThefirstTimeIntroduction = NO;
        ar.timeOfMeetPumpkin = _TimeOfMeetPumpkin;
    }else{
        if (ar.showDetail) {
            if(Show){
                LLDetailView *lldetaView = [[LLDetailView alloc]initWithFrame:CGRectMake(0, 0, 450, 700)];
                lldetaView.llDetailMonsteriD = 0;
                JCAlertView *customIntroduction = [[JCAlertView alloc] initWithCustomView:lldetaView dismissWhenTouchedBackground:YES];
                [customIntroduction show];
                ar.isThefirstTimeIntroduction = NO;
                ar.timeOfMeetPumpkin = 2;
                ar.showDetail = NO;
                Show = NO;
            }
        }else if (ar.showPumpkintalk){
            if(showPumpkintalkonce){
                LLTalkView *lulu = [[LLTalkView alloc]initWithFrame:CGRectMake(5, 100, 310, 300)];
                lulu.backgroundColor = [UIColor clearColor];
                lulu.MonsteriD = 0;
                [self addSubview:lulu];
                
                showPumpkintalkonce = NO;
                ar.showPumpkintalk = NO;
            }
        }
    }
}
//对女巫回调的显示
-(void)ShowWitchARModel{
    if(_TimeofMeetWitch == 3){
        ar.isThefirstTimeMeetWitch = NO;
        ar.timeOfMeetWitch = _TimeofMeetWitch;
    }if (_TimeofMeetWitch == 4) {
        ar.isThefirstTimeMeetWitch = NO;
        ar.timeOfMeetWitch = 4;
    }else{
        if (ar.showwitchIntroduction) {//调到女巫
            if(showWitchIntroduction){//只显示一次
                LLDetailView *lldetaView = [[LLDetailView alloc]initWithFrame:CGRectMake(20, 20, 450, 600)];
                lldetaView.llDetailMonsteriD = 2;
                JCAlertView *customIntroduction = [[JCAlertView alloc] initWithCustomView:lldetaView dismissWhenTouchedBackground:YES];
                [customIntroduction show];
                ar.isThefirstTimeMeetWitch = NO;
                ar.timeOfMeetWitch = 2;
                ar.showwitchIntroduction = NO;
                showWitchIntroduction = NO;
            }
        }else if (ar.showWitchtalk){
            if(showWitchTalkOnce){
                LLTalkView *lulu = [[LLTalkView alloc]initWithFrame:CGRectMake(50, 150, 330, 300)];
                lulu.backgroundColor = [UIColor clearColor];
                lulu.MonsteriD = 2;
                [self addSubview:lulu];
                //抓到女巫
                if (lulu.TalkHasCaptureSwitch) {
                    _HasCaptureWitch = YES;
                    NSLog(@"抓到女巫");
                }
                showWitchTalkOnce = NO;
                ar.showWitchtalk = NO;
            }
        }
    }
}
//对骷髅回调的显示
-(void)ShowSkeletonARModel{
    if(_TimeOfMeetSkeleton == 3){
        ar.isThefirstTimeMeetskeleton = NO;
        ar.timeOfMeetskeleton = _TimeOfMeetSkeleton;
    }if (_TimeOfMeetPumpkin == 4) {
        ar.isThefirstTimeMeetskeleton = NO;
        ar.timeOfMeetskeleton = 4;
    }
    else{
        if (ar.showskeletonIntroduction) {//调到骷髅
            if(showSkeletonIntroduction){//只显示一次
                LLDetailView *lldetaView = [[LLDetailView alloc]initWithFrame:CGRectMake(0, 0, 450, 700)];
                lldetaView.llDetailMonsteriD = 1;
                JCAlertView *customIntroduction = [[JCAlertView alloc] initWithCustomView:lldetaView dismissWhenTouchedBackground:YES];
                [customIntroduction show];
                ar.isThefirstTimeMeetskeleton = NO;
                ar.timeOfMeetskeleton = 2;
                ar.showskeletonIntroduction = NO;
                showSkeletonIntroduction = NO;
            }
        }else if (ar.showSkeletontalk){
            if(showSkeletonTalkOnce){
                LLTalkView *lulu = [[LLTalkView alloc]initWithFrame:CGRectMake(50, 150, 350, 400)];
                lulu.backgroundColor = [UIColor clearColor];
                lulu.MonsteriD = 1;
                [self addSubview:lulu];
                
                showSkeletonTalkOnce = NO;
                ar.showSkeletontalk = NO;
            }
        }
    }
}

- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation
{
    BOOL isPortrait = FALSE;
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            isPortrait = TRUE;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isPortrait = FALSE;
            break;
        default:
            break;
    }
    ar.setPortrait(isPortrait);
    ar.resizeGL(frame.size.width, frame.size.height);
}



- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
            EasyAR::setRotationIOS(270);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            EasyAR::setRotationIOS(90);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            EasyAR::setRotationIOS(180);
            break;
        case UIInterfaceOrientationLandscapeRight:
            EasyAR::setRotationIOS(0);
            break;
        default:
            break;
    }
}

@end
