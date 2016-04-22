//
//  CreateQRViewController.m
//  QRCode
//
//  Created by admin on 15/8/1.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "CreateQRViewController.h"

@interface CreateQRViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation CreateQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.还原滤镜默认属性
    [filter setDefaults];
    //3.将需要生成二维码的数据转换为二进制数据
    NSString *string = @"www.baidu.com";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //4给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    //5.生成图片
    CIImage *qrcodeImage = [filter outputImage];
    //6显示图片
    self.qrCodeImageView.image = [self createUIImageFormCIImage:qrcodeImage withSize:800];
}

-(UIImage *)createUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
     CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationHigh);//kCGInterpolationNone
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
    
}


@end
