//
//  LQPhotoKitAlbumTableViewCell.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/5.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSInteger const LQPhotoKitAlbumTableViewCellHeight;

@class LQPhotoKitAlbumTableViewCell;

@protocol LQPhotoKitAlbumTableViewCellModel <NSObject>

@property (readonly) NSString *photoKitAlbumTableViewCel_title;
@property (readonly) NSInteger photoKitAlbumTableViewCel_count;

- (void)photoKitAlbumTableViewCell:(LQPhotoKitAlbumTableViewCell *)cell
             requestImageWithBlock:(void(^)(UIImage *image))block;

@optional

- (void)photoKitAlbumTableViewCell:(LQPhotoKitAlbumTableViewCell *)cell
       requestSecondImageWithBlock:(void(^)(UIImage *image))block;

- (void)photoKitAlbumTableViewCell:(LQPhotoKitAlbumTableViewCell *)cell
        requestThirdImageWithBlock:(void(^)(UIImage *image))block;

@end

@interface LQPhotoKitAlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LQPhotoKitAlbumTableViewCellModel> model;

@end

NS_ASSUME_NONNULL_END
