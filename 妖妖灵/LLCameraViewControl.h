//
//  LLCameraViewControl.h
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"
#import "iflyMSC/iflyMSC.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;

@interface LLCameraViewControl : UIViewController <IFlySpeechRecognizerDelegate>{
    BOOL NoticeSkeleton;
}

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) OpenGLView *glView;
@property (nonatomic, strong) NSString * voiceStr;
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, strong) NSString *ResultString;

@property (nonatomic, assign) BOOL EndSuccessCaptureWitch;
@property (nonatomic, assign) BOOL EndSuccessCaptureSkeleton;


@end
