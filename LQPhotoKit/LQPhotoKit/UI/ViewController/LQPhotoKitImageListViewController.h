//
//  LQPhotoKitImageListViewController.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/6.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQPhotoKitAlbumModel;

NS_ASSUME_NONNULL_BEGIN

@interface LQPhotoKitImageListViewController : UIViewController

@property (nonatomic, strong) LQPhotoKitAlbumModel *model;

@end

NS_ASSUME_NONNULL_END
