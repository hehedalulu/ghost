/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface OpenGLView : UIView{
    BOOL showPumpkintalkonce;
    BOOL Show;
    
    BOOL showSkeletonIntroduction;
    BOOL showSkeletonTalkOnce;
    
    BOOL showWitchIntroduction;
    BOOL showWitchTalkOnce;
    


};

@property(nonatomic, strong) CAEAGLLayer * eaglLayer;
@property(nonatomic, strong) EAGLContext *context;
@property(nonatomic) GLuint colorRenderBuffer;
@property(nonatomic) BOOL   hasTapView;


@property(nonatomic) BOOL   IsThefirstTimeIntroduction;
@property(nonatomic) BOOL   IsThefirstTimeMeetskeleton;
@property(nonatomic) BOOL   IsThefirstTimeMeetWitch;

@property(nonatomic) BOOL   HasCaptureSkeleton;
@property(nonatomic) BOOL   HasCaptureWitch;

@property(nonatomic) int TimeofMeetWitch;
@property(nonatomic) int TimeOfMeetPumpkin;
@property(nonatomic) int TimeOfMeetSkeleton;

@property(nonatomic) BOOL FONTORNOT;
- (void)start;
- (void)stop;
- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation;
- (void)setOrientation:(UIInterfaceOrientation)orientation;


@end
