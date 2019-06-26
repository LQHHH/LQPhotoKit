//
//  LQPhotoKitGIFImageDisplayView.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/15.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitGIFImageDisplayView.h"
#import "UIView+config.h"

@interface LQPhotoKitGIFImageDisplayView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger playIndex;
@property (nonatomic, assign) CGFloat currentPlayedTime;
@property (nonatomic, strong) LQPhotoKitGIFImageModel *currentGIFImageModel;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation LQPhotoKitGIFImageDisplayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.queue = dispatch_queue_create("LQPhototKitGIFImage.play.queue", DISPATCH_QUEUE_SERIAL);
    return self;
}

#pragma mark - setter

/**
 内存占用比较高
 */
- (void)setImages:(NSArray<LQPhotoKitGIFImageModel *> *)images {
    _images = images;
    NSMutableArray *array = [NSMutableArray new];
    NSTimeInterval time = 0;
    for (LQPhotoKitGIFImageModel *model in images) {
        [array addObject:model.image];
        time = time + model.timeInterval;
    }
    UIImage *image = [UIImage animatedImageWithImages:array duration:time];
    self.imageView.image = image;
}

/**
 cpu占用比较高
 */
- (void)setGifImageData:(NSData *)gifImageData {
    _gifImageData = gifImageData;
    [self fetchImageCount];
    [self startDisplayLink];
}

#pragma mark - action

- (void)playGifImage {
    if (_playIndex == 0) {
        [self fetchImageInfoWithIndex:0 completionBlock:^(LQPhotoKitGIFImageModel *model) {
            self.currentGIFImageModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.layer.contents =  (__bridge id )(model.image.CGImage);
            });
        }];
    }
    self.currentPlayedTime += self.displayLink.duration;
    if (self.currentPlayedTime > self.currentGIFImageModel.timeInterval) {
        self.currentPlayedTime = 0;
        self.playIndex++;
        if (self.playIndex >= self.imageCount) {
            self.playIndex = 0;
        }
        [self fetchImageInfoWithIndex:self.playIndex completionBlock:^(LQPhotoKitGIFImageModel *model) {
            self.currentGIFImageModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.layer.contents =  (__bridge id )(model.image.CGImage);
            });
        }];

    }
    
}

#pragma mark - privite

- (void)fetchImageCount {
    CGImageSourceRef sourceRef    = CGImageSourceCreateWithData((__bridge CFDataRef)self.gifImageData, NULL);
    size_t count                  = CGImageSourceGetCount(sourceRef);
    self.imageCount               = count;
    CFRelease(sourceRef);
}

- (void)fetchImageInfoWithIndex:(NSInteger)index completionBlock:(void(^)(LQPhotoKitGIFImageModel *model))block {
    dispatch_async(self.queue, ^{
        CGImageSourceRef sourceRef    = CGImageSourceCreateWithData((__bridge CFDataRef)self.gifImageData, NULL);
        LQPhotoKitGIFImageModel *gifImage = [LQPhotoKitGIFImageModel new];
        CGImageRef image = CGImageSourceCreateImageAtIndex(sourceRef, index, NULL);
        gifImage.image   = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
        CFDictionaryRef dictionaryRef = CGImageSourceCopyPropertiesAtIndex(sourceRef, index, NULL);
        NSDictionary *info     = (__bridge NSDictionary *)dictionaryRef;
        NSDictionary *timeInfo = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeInfo objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        gifImage.timeInterval = time;
        CFRelease(sourceRef);
        if (block) {
            block(gifImage);
        }
    });
}

#pragma mark - startDisplayLink

- (void)startDisplayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playGifImage)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - stopDisplayLink

- (void)stopDisplayLink {
    [_displayLink invalidate];
    _displayLink = nil;
}


#pragma mark - lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView       = [UIImageView new];
        _imageView.frame = self.bounds;
        [self addSubview:_imageView];
    }
    
    return _imageView;
}


@end
