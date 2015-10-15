//
//  ViewController.m
//  QRCodeTest
//
//  Created by Roger on 15/10/15.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "ZBarSDK.h"


@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_captureSession;
}
@property (weak, nonatomic) IBOutlet UIImageView *_qrCodeImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    生成二维码的资源（地址随意写）
    UIImage *qrcodeImage = [self generateQRCodeFromString:@"http://www.baidu.com"];
//    图片的规模
    qrcodeImage = [self image:qrcodeImage scale:10];
    __qrCodeImageView.image = qrcodeImage;
    
//    将生成的二维码写到桌面
    NSData *data = UIImagePNGRepresentation(qrcodeImage);
    [data writeToFile:@"/Users/apple/Desktop/qrcode.png" atomically:YES];
//    ZBarSDK的调用，将图片添加到识别器
    [self scanImage:[UIImage imageWithContentsOfFile:@"/Users/apple/Desktop/qrcode.png"]];
    
    //真机调试
//    [self scan];
    
    
}
#pragma mark 生成二维码
- (UIImage *)generateQRCodeFromString:(NSString *)string{
    //需要生成二维码的内容
    NSData *strinData = [string dataUsingEncoding:NSUTF8StringEncoding];
//    二维码生成器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    设置输入参数
    [filter setValue:strinData forKey:@"inputMessage"];
//    设置识别率
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
//    获取生成的图片
    CGImageRef cgImage = [[CIContext contextWithOptions:nil]createCGImage:[filter outputImage] fromRect:[[filter outputImage]extent]];
    return [UIImage imageWithCGImage:cgImage];
}
#pragma mark 使生成的二维码变得清晰
- (UIImage *)image:(UIImage *)image scale:(CGFloat)scale{
    CGSize size = image.size;
//    1、缩放图片，使生成的二维码变得更清晰
    UIGraphicsBeginImageContext(CGSizeMake(size.width * scale, size.width *scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
//    2、插值
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
//    3、绘制图片
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), image.CGImage);
//    4、获取图片
    UIImage *preImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    5、旋转图片
    UIImage *qrImage = [UIImage imageWithCGImage:[preImage CGImage] scale:[preImage scale] orientation:UIImageOrientationUpMirrored];
    return qrImage;
}
#pragma mark 真机的调试
- (void)scanQRCode{
//    1、输入设备
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    if (!input) {
        return;
    }
    AVCaptureSession *captureSesstion = [[AVCaptureSession alloc]init];
//    6、添加输出(第六步一定要在这里出现)
    _captureSession = captureSesstion;
//    2、添加输入设备
    [captureSesstion addInput:input];
//    3、输出设备
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    dispatch_queue_t queue = dispatch_get_main_queue();\
     [captureSesstion addOutput:output];
//    设置代理，设别后调用
    [output setMetadataObjectsDelegate:self queue:queue];
//    4、可用的数据类型
    NSLog(@"%@",output.availableMetadataObjectTypes);
//    5、设别QRECode
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
//    7、显示预览
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSesstion];
    previewLayer.frame = CGRectMake(100, 100, 200, 200);
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
//    8、开始识别
    [captureSesstion startRunning];
    
    
}
//设别输出的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"metadataObjects:%@",metadataObjects);
}

//ZBarSDK设别二维码的图片（对二维码进行解析）
- (void)scanImage:(UIImage *)image {
    //1. 需要识别的图⽚片对象
    ZBarImage *zImage = [[ZBarImage alloc]
                         initWithCGImage:image.CGImage];
    //2. 图⽚片识别器
    ZBarImageScanner *imageScanner = [[ZBarImageScanner alloc]init];
    //3. 识别图⽚片⼆二维码
    [imageScanner scanImage:zImage];
    //4. 获取⼆二维码信息
    for (ZBarSymbol *symbol in zImage.symbols) {
        NSLog(@"%@", symbol.data);
    }
}

//设别停止
- (void)viewWillDisappear:(BOOL)animated{
    [_captureSession stopRunning];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















































