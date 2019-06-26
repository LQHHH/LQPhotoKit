//
//  ShowSelectedView.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "ShowSelectedView.h"
#import <AVFoundation/AVFoundation.h>

@interface ShowSelectedView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation ShowSelectedView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:[AVPlayerItem playerItemWithURL:videoURL]];
    self.playerLayer.player = self.player;
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(runLoopTheMovie:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:self.player.currentItem];
}

- (void)runLoopTheMovie:(NSNotification *)notification {
    AVPlayerItem *playerItem = notification.object;
    [playerItem seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView                        = [UIImageView new];
        _imageView.frame                  = self.bounds;
        _imageView.contentMode            = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds          = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

#pragma mrak - lazy

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.frame = self.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:_playerLayer];
    }
    return _playerLayer;
}

@end
