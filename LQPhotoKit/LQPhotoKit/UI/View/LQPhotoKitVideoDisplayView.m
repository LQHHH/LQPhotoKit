//
//  LQPhotoKitVideoDisplayView.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitVideoDisplayView.h"

@interface  LQPhotoKitVideoDisplayView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LQPhotoKitVideoDisplayView

#pragma mark - setter

- (void)setModel:(id<LQPhotoKitVideoDisplayViewModel>)model {
    _model = model;
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:[AVPlayerItem playerItemWithAsset:model.photoKitVideoDisplayView_avAsset]];
    self.playerLayer.player = self.player;
    [self startTimer];
}

#pragma mark - public

- (void)stopVideoPlay {
    [self stopTimer];
}

- (void)changeVideoPlay {
    [self stopTimer];
    [self startTimer];
}

- (void)willChangeVideoPlay {
    [self stopTimer];
    [self.player seekToTime:[self startCMTime] toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - privite

- (CMTime)startCMTime {
    return CMTimeMakeWithSeconds(self.model.photoKitVideoDisplayView_startTime, self.model.photoKitVideoDisplayView_avAsset.duration.timescale);
}

- (NSTimeInterval)timeLength {
    return self.model.photoKitVideoDisplayView_timeLength;
}

- (void)startTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:[self timeLength]
                                                      target:self
                                                    selector:@selector(playVideo)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.timer fire];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)playVideo {
    [self.player seekToTime:[self startCMTime] toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

- (void)stopTimer {
    [self.player pause];
    [self.timer invalidate];
    self.timer = nil;
    
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
