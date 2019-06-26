//
//  LQPhotoKitAlbumViewController.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQPhotoKitAlbumViewController;
@protocol LQPhotoKitAlbumViewControllerDelegate <NSObject>

@optional
- (void)photoKitAlbumViewController:(LQPhotoKitAlbumViewController *)viewController
                 didSelectedEditVideoWithURL:(NSURL *)editURL;

- (void)photoKitAlbumViewController:(LQPhotoKitAlbumViewController *)viewController
                        didSelectedEditImage:(UIImage *)editImage;

- (void)photoKitAlbumViewController:(LQPhotoKitAlbumViewController *)viewController
            didSelectedEditGIFImage:(UIImage *)editGIFImage;

@end

@interface LQPhotoKitAlbumViewController : UIViewController

@property (nonatomic, weak) id<LQPhotoKitAlbumViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
