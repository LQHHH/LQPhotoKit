//
//  LQPhotoKitVideoDisplayView.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LQPhotoKitVideoDisplayViewModel <NSObject>

@property (readonly) AVAsset *photoKitVideoDisplayView_avAsset;
@property (readonly) NSTimeInterval photoKitVideoDisplayView_startTime;
@property (readonly) NSTimeInterval photoKitVideoDisplayView_timeLength;

@end

@interface LQPhotoKitVideoDisplayView : UIView

@property (nonatomic, weak) id<LQPhotoKitVideoDisplayViewModel> model;

- (void)stopVideoPlay;
- (void)willChangeVideoPlay;
- (void)changeVideoPlay;

@end

NS_ASSUME_NONNULL_END
