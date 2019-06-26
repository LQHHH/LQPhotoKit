//
//  LQPhotoKitVideoEditViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitVideoEditViewController.h"
#import "LQPhotoKitAlbumViewController.h"
#import "LQPhotoKitManager.h"
#import "NSObject+config.h"
#import "UIView+config.h"
#import "LQPhotoKitImageModel.h"
#import "LQPhotoKitVideoDisplayView.h"
#import "LQPhotoKitVideoEditView.h"

#define LQMaxVideoTime 2

@interface LQPhotoKitVideoEditViewController () <LQPhotoKitVideoDisplayViewModel, LQPhotoKitVideoEditViewModel ,LQPhotoKitVideoEditViewDelegate>

@property (nonatomic, strong) LQPhotoKitVideoDisplayView *displayView;
@property (nonatomic, strong) LQPhotoKitVideoEditView *editView;
@property (nonatomic, strong) AVAsset *avAsset;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval timeLength;
@property (nonatomic, assign) CMTimeRange timeRange;

@end

@implementation LQPhotoKitVideoEditViewController

- (void)dealloc {
    [self.displayView stopVideoPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"编辑";
    
    UIBarButtonItem *item     = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clickSure)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.startTime  = 0;
    self.timeLength = LQMaxVideoTime;
    
    __weak typeof(self)wself = self;
    [[LQPhotoKitManager defaultManager]
     requestVideoWithPHAsset:self.model.asset
     completiomBlock:^(AVAsset * _Nonnull avAsset) {
         if (wself.model.asset.duration < 0.5) {
             [wself.navigationController popViewControllerAnimated:YES];
             return;
         }
         
         wself.avAsset           = avAsset;
         wself.displayView.model = wself;
         wself.editView.model    = wself;
     }];
}


#pragma mark - action

- (void)clickSure {
    [[LQPhotoKitManager defaultManager]
     exportEditVideoForAVAsset:self.avAsset
     timeRange:self.timeRange
     completionBlock:^(NSString *error, NSURL *editURL) {
         if (error) {
             return;
         }
         
        LQPhotoKitAlbumViewController *vc = self.navigationController.viewControllers.firstObject;
         if ([vc.delegate respondsToSelector:@selector(photoKitAlbumViewController:didSelectedEditVideoWithURL:)]) {
             [vc.delegate photoKitAlbumViewController:vc didSelectedEditVideoWithURL:editURL];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}


#pragma mark - LQPhotoKitVideoDisplayViewModel

- (AVAsset *)photoKitVideoDisplayView_avAsset {
    return self.avAsset;
}

- (NSTimeInterval)photoKitVideoDisplayView_startTime {
    return self.startTime;
}

- (NSTimeInterval)photoKitVideoDisplayView_timeLength {
    return self.timeLength;
}

#pragma mark - LQPhotoKitVideoEditViewModel

- (AVAsset *)photoKitVideoEditView_avAsset {
    return self.avAsset;
}

#pragma mark - LQPhotoKitVideoEditViewDelegate

- (void)photoKitVideoEditView:(LQPhotoKitVideoEditView *)view willChangeVideoPlayRange:(LQPhotoKitVideoEditViewPlayRange)playRange {
    self.startTime           = playRange.startTime;
    self.timeLength          = playRange.timeLength;
    [self.displayView willChangeVideoPlay];
}

- (void)photoKitVideoEditView:(LQPhotoKitVideoEditView *)view didChangeVideoPlayRange:(LQPhotoKitVideoEditViewPlayRange)playRange {
    self.startTime           = playRange.startTime;
    self.timeLength          = playRange.timeLength;
    [self.displayView changeVideoPlay];
    self.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(self.startTime, self.avAsset.duration.timescale), CMTimeMakeWithSeconds(self.timeLength, self.avAsset.duration.timescale));
}

#pragma mark - lazy

- (LQPhotoKitVideoDisplayView *)displayView {
    if (!_displayView) {
        _displayView         = [[LQPhotoKitVideoDisplayView alloc] initWithFrame:CGRectMake(0, [self lq_navigationBarHeight]+50, [self lq_screenWidth], 300)];
        [self.view addSubview:_displayView];
    }
    return _displayView;
}


- (LQPhotoKitVideoEditView *)editView {
    if (!_editView) {
        _editView          = [[LQPhotoKitVideoEditView alloc] initWithFrame:CGRectMake(0, [self lq_screenHeight]-200, [self lq_screenWidth], 200)];
        _editView.delegate = self;
        [self.view addSubview:_editView];
    }
    return _editView;
}

@end
