//
//  NSObject+config.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "NSObject+config.h"

@implementation NSObject (config)

- (CGFloat)lq_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)lq_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)lq_navigationBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height + 44.f;
}

@end
