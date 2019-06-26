//
//  LQPhotoKitVideoEditView.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class LQPhotoKitVideoEditView;

typedef struct {
    NSTimeInterval startTime;
    NSTimeInterval timeLength;
} LQPhotoKitVideoEditViewPlayRange;

CG_INLINE LQPhotoKitVideoEditViewPlayRange LQPhotoKitVideoEditViewPlayRangeMake(NSTimeInterval time, NSTimeInterval length) {
    LQPhotoKitVideoEditViewPlayRange range;
    range.startTime  = time;
    range.timeLength = length;
    return range;
}

@protocol LQPhotoKitVideoEditViewDelegate <NSObject>

- (void)photoKitVideoEditView:(LQPhotoKitVideoEditView *)view
        willChangeVideoPlayRange:(LQPhotoKitVideoEditViewPlayRange)playRange;

- (void)photoKitVideoEditView:(LQPhotoKitVideoEditView *)view
         didChangeVideoPlayRange:(LQPhotoKitVideoEditViewPlayRange)playRange;

@end

@protocol LQPhotoKitVideoEditViewModel <NSObject>

@property (readonly) AVAsset *photoKitVideoEditView_avAsset;

@end

@interface LQPhotoKitVideoEditView : UIView

@property (nonatomic, weak) id<LQPhotoKitVideoEditViewDelegate> delegate;
@property (nonatomic, weak) id<LQPhotoKitVideoEditViewModel> model;

@end

NS_ASSUME_NONNULL_END
