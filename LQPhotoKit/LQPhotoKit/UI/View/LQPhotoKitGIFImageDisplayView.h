//
//  LQPhotoKitGIFImageDisplayView.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/15.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQPhotoKitGIFImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQPhotoKitGIFImageDisplayView : UIView

@property (nonatomic, strong) NSArray <LQPhotoKitGIFImageModel *> *images;
@property (nonatomic, strong) NSData *gifImageData;

- (void)stopDisplayLink;

@end


NS_ASSUME_NONNULL_END
