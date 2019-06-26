//
//  LQPhotoKitChooseImageViewController.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/22.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQPhotoKitChooseImageViewController : UIViewController

@property (nonatomic, copy) void(^completiomBlock)(NSArray *images);

@end

