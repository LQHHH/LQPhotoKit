//
//  LQPhotoKitGIFImageEditViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitGIFImageEditViewController.h"
#import "LQPhotoKitManager.h"
#import "LQPhotoKitGIFImageDisplayView.h"
#import "LQPhotoKitImageModel.h"
#import "NSObject+config.h"
#import "LQPhotoKitAlbumViewController.h"

@interface LQPhotoKitGIFImageEditViewController ()

@property (nonatomic, strong) LQPhotoKitGIFImageDisplayView *displayView;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (nonatomic, strong) UIImage *animationImage;

@end

@implementation LQPhotoKitGIFImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"GIF图";
    
    UIBarButtonItem *item     = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickSure)];
    self.navigationItem.rightBarButtonItem = item;
    
    __weak typeof(self)wself = self;
    [[LQPhotoKitManager defaultManager]
     requestGIFImageDataWithPHAsset:self.model.asset
     completiomBlock:^(NSData *data) {
         //wself.displayView.gifImageData = data;
         [wself handleImageData:data];
     }];
}

- (void)dealloc {
    [self.displayView stopDisplayLink];
}

#pragma mark - action

- (void)clickSure {
    LQPhotoKitAlbumViewController *vc = self.navigationController.viewControllers.firstObject;
    if ([vc.delegate respondsToSelector:@selector(photoKitAlbumViewController:didSelectedEditImage:)]) {
        [vc.delegate photoKitAlbumViewController:vc didSelectedEditImage:self.animationImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - handleImageData

- (void)handleImageData:(NSData *)data {
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *array = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageSourceRef sourceRef    = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        size_t count                  = CGImageSourceGetCount(sourceRef);
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                LQPhotoKitGIFImageModel *gifImage = [LQPhotoKitGIFImageModel new];
                CGImageRef image = CGImageSourceCreateImageAtIndex(sourceRef, i, NULL);
                gifImage.image   = [[UIImage alloc] initWithCGImage:image];
                CGImageRelease(image);
                
                CFDictionaryRef dictionaryRef = CGImageSourceCopyPropertiesAtIndex(sourceRef, i, NULL);
                NSDictionary *info     = (__bridge NSDictionary *)dictionaryRef;
                NSDictionary *timeInfo = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
                CGFloat time = [[timeInfo objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
                self.totalTime += time;
                gifImage.timeInterval = time;
                [images addObject:gifImage];
                [array addObject:[[UIImage alloc] initWithCGImage:image]];
            }
        }
        CFRelease(sourceRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.displayView.images = images;
            self.animationImage = [UIImage animatedImageWithImages:array duration:self.totalTime];
        });
    });
}

#pragma mark - lazy

- (LQPhotoKitGIFImageDisplayView *)displayView {
    if (!_displayView) {
        _displayView        = [[LQPhotoKitGIFImageDisplayView alloc] initWithFrame:CGRectMake(0, 0, [self lq_screenWidth], 300)];
        _displayView.center = self.view.center;
        [self.view addSubview:_displayView];
    }
    return _displayView;
}


@end
