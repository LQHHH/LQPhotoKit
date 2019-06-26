//
//  LQPhotoKitVideoDragView.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/15.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LQPhotoKitVideoDragViewDelegate <NSObject>

- (void)photoKitVideoDragViewStartChanged;
- (void)photoKitVideoDragViewEndChanged;

@end

@interface LQPhotoKitVideoDragView : UIView

@property (nonatomic, weak) id<LQPhotoKitVideoDragViewDelegate> delegate;
@property (nonatomic, assign) CGRect validRect;
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, assign) CGFloat maxWidth;

@end

NS_ASSUME_NONNULL_END
