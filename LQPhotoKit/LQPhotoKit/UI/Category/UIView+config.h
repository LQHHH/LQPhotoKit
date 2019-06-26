//
//  UIView+config.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/5.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (config)

@property (nonatomic, assign) CGSize lq_size;

@property (nonatomic, assign) CGFloat lq_left;
@property (nonatomic, assign) CGFloat lq_right;
@property (nonatomic, assign) CGFloat lq_top;
@property (nonatomic, assign) CGFloat lq_bottom;

@property (nonatomic, assign) CGFloat lq_centerX;
@property (nonatomic, assign) CGFloat lq_centerY;

@property (nonatomic, assign) CGFloat lq_width;
@property (nonatomic, assign) CGFloat lq_height;

@end

NS_ASSUME_NONNULL_END
