//
//  GCLCaptureViewController.m
//  GCLLiveApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "GCLCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface GCLCaptureViewController ()<AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong)AVCaptureSession *captureSession;
@property (nonatomic, strong)AVCaptureDeviceInput *currentDideoDeviceInput;
@property (nonatomic, strong)UIImageView *focusCursorImageView;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong)AVCaptureConnection *videoConnection;

@end

@implementation GCLCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频采集";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCaptureVideo];
}

//捕获音视频
- (void)setupCaptureVideo{
    
    //1.session:创建捕获会话，必须要强引用，否则会被释放
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    _captureSession = session;
    
    //2.device:获取设备
    //2.1.video:获取摄像头设备，默认是后置摄像头
    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
    //2.2.audio:获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    //3.input:创建输出对象
    //3.1.video input:创建相应视频设备输入对象
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    _currentDideoDeviceInput = videoDeviceInput;
    //3.2.audio input:创建相应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    //4.添加音视频到会话中
    //注意最好要判断是否能添加输入，不能添加空的音视频到会话中
    //4.1添加视频
    if ([session canAddInput:videoDeviceInput]) {
        [session addInput:videoDeviceInput];
    }
    //4.2添加音频
    if ([session canAddInput:audioDeviceInput]) {
        [session addInput:audioDeviceInput];
    }
    
    //5.output:输出
    //5.1.获取视频数据输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
    //5.2设置代理，捕获视频样品数据
    //注意：队列必须是串行队列，才能获取到数据，而且不能是空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([session canAddOutput:videoOutput]) {
        [session addOutput:videoOutput];
    }
    //5.3.获取音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc]init];
    //5.4设置代理，捕获音频样品数据
    //注意：队列必须是串行队列，才能获取到数据，而且不能是空
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([session canAddOutput:audioOutput]) {
        [session addOutput:audioOutput];
    }
    
    //6.视频输入与输出连接，用于分辨音视频数据
    _videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //7.添加视频预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    _previewLayer = previewLayer;
    
    //8.启动会话
    [session startRunning];
}

//指定摄像头方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position{

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//获取输入设备数据，有可能是音频，有可能是视频
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    if (_videoConnection == connection) {
        NSLog(@"采集到视频数据");
    }else{
        NSLog(@"采集到音频数据");
    }
}
#pragma mark - 视频采集额外功能一（切换摄像头）
- (IBAction)toggleCapture:(id)sender {
    
    //1.获取当前输入设备方向
    AVCaptureDevicePosition currentPosition = _currentDideoDeviceInput.device.position;
    
    //2.获取需要改变的方向
    AVCaptureDevicePosition togglePosition = currentPosition == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
    
    //3.获取改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    //4.获取改变的摄像头输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    //5.移除之前摄像头输入设备
    [_captureSession removeInput:_currentDideoDeviceInput];
    
    //6.添加新的摄像头输入设备
    [_captureSession addInput:toggleDeviceInput];
    
    //7.修改本地保存的当前输入设备的值
    _currentDideoDeviceInput = toggleDeviceInput;
}

#pragma mark - 视频采集额外功能二（聚焦光标）
//懒加载聚焦视图
-(UIImageView *)focusCursorImageView{
    
    if (_focusCursorImageView == nil) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"focus"]];
        _focusCursorImageView = imgView;
        [self.view addSubview:_focusCursorImageView];
    }
    return _focusCursorImageView;
}
//点击屏幕，出现聚焦视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //获取点击位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    //将当前位置转换为摄像头点上的位置
    CGPoint cameraPoint = [_previewLayer captureDevicePointOfInterestForPoint:point];
    
    //设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    
    //设置聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}
//设置聚焦点光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point{

    self.focusCursorImageView.center = point;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha  =1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha = 0;
    }];
}
//设置聚焦
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{

    AVCaptureDevice *captureDevice = _currentDideoDeviceInput.device;
    //锁定配置
    [captureDevice lockForConfiguration:nil];
    
    //1.聚焦
    //设置聚焦模式
    if ([captureDevice isFocusModeSupported:focusMode]) {
        [captureDevice setFocusMode:focusMode];
    }
    //设置聚焦点
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    //2.曝光
    //设置曝光模式
    if ([captureDevice isExposureModeSupported:exposureMode]) {
        [captureDevice setExposureMode:exposureMode];
    }
    //设置曝光点
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    //解锁配置
    [captureDevice unlockForConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
