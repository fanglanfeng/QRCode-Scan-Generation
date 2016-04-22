//
//  BarCodeViewController.m
//  QRCode
//
//  Created by admin on 15/8/1.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "BarCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CreateQRViewController.h"

@interface BarCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/**
 *  冲击波的顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brcodeContror;
/**
 *  会话
 */
@property(nonatomic,strong) AVCaptureSession *session;
/**
 *  预览界面
 */
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *preLayer;

@end

@implementation BarCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0. 设置定时器
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self scanBarCode];
}

/**
 *  扫描条形码
 */
-(void)scanBarCode{
    //1.获取输入设备
#warning 注意, 获取输入设备一定要通过 default 方法获取，不能直接alloc,init,否则会报错
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.根据输入设备创建输入对象
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:inputDevice error:NULL];
    //3.创建输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //4.设置输出对象的代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //5.创建会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    //6.将输入和输出添加到会话中
    
#warning 由于输入和输出不能重复添加，所以添加之前需要判断是否可以添加
    if([session canAddInput:input]){
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
#warning 设置数据类型一定要在输入对象添加到会话以后再设置，否则会报错
    //7.设置输出的数据类型
    [output setMetadataObjectTypes:@[
                                     AVMetadataObjectTypeUPCECode,
                                     AVMetadataObjectTypeCode39Code,
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code,
                                     AVMetadataObjectTypeCode128Code,
                                     AVMetadataObjectTypePDF417Code,
                                     AVMetadataObjectTypeAztecCode,
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode
                                     ]];
    //8.设置预览界面
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.frame = self.view.bounds;
    self.preLayer = preLayer;
    [self.view.layer insertSublayer:preLayer atIndex:0];
    //8.开始采集数据
    [session startRunning];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    //1. 判断是否解析到了数据
    if (metadataObjects.count > 0) {
        //2.停止扫描
        [self.session stopRunning];
        //3.移除预览界面
        [self.preLayer removeFromSuperlayer];
        //4.取出数据
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        
        NSLog(@"%@",[obj stringValue]);
    }
}

-(void)update{
    
    self.brcodeContror.constant += 5;
    
    if (self.brcodeContror.constant >= 150) {
        self.brcodeContror.constant = -150;
    }
}
- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)meQRCode:(UIButton *)sender {
    
    
    CreateQRViewController *creat = [[CreateQRViewController alloc] init];
    
    [self.navigationController pushViewController:creat animated:YES];
    
}

@end
