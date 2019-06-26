//
//  UIView+config.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/5.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "UIView+config.h"

@implementation UIView (config)

- (void)setLq_size:(CGSize)size;
{
    CGPoint origin = [self frame].origin;
    
    [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGSize)lq_size;
{
    return [self frame].size;
}

- (CGFloat)lq_left;
{
    return CGRectGetMinX([self frame]);
}

- (void)setLq_left:(CGFloat)x;
{
    CGRect frame = [self frame];
    frame.origin.x = x;
    [self setFrame:frame];
}

- (CGFloat)lq_top;
{
    return CGRectGetMinY([self frame]);
}

- (void)setLq_top:(CGFloat)y;
{
    CGRect frame = [self frame];
    frame.origin.y = y;
    [self setFrame:frame];
}

- (CGFloat)lq_right;
{
    return CGRectGetMaxX([self frame]);
}

- (void)setLq_right:(CGFloat)right;
{
    CGRect frame = [self frame];
    frame.origin.x = right - frame.size.width;
    
    [self setFrame:frame];
}

- (CGFloat)lq_bottom;
{
    return CGRectGetMaxY([self frame]);
}

- (void)setLq_bottom:(CGFloat)bottom;
{
    CGRect frame = [self frame];
    frame.origin.y = bottom - frame.size.height;
    
    [self setFrame:frame];
}

- (CGFloat)lq_centerX;
{
    return [self center].x;
}

- (void)setLq_centerX:(CGFloat)centerX;
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)lq_centerY;
{
    return [self center].y;
}

- (void)setLq_centerY:(CGFloat)centerY;
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)lq_width;
{
    return CGRectGetWidth([self frame]);
}

- (void)setLq_width:(CGFloat)width;
{
    CGRect frame = [self frame];
    frame.size.width = width;
    
    [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)lq_height;
{
    return CGRectGetHeight([self frame]);
}

- (void)setLq_height:(CGFloat)height;
{
    CGRect frame = [self frame];
    frame.size.height = height;
    
    [self setFrame:CGRectStandardize(frame)];
}


@end
