//
//  LQPhotoKitImageListCollectionViewCell.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/6.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQPhotoKitImageListCollectionViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol LQPhotoKitImageListCollectionViewCellModel <NSObject>

@property (readonly) NSString *photoKitImageListCollectionViewCell_duration;

- (void)photoKitImageListCollectionViewCell:(LQPhotoKitImageListCollectionViewCell *)cell
                         requestImageWithBlock:(void(^)(UIImage *image))block;

- (void)photoKitImageListCollectionViewCell:(LQPhotoKitImageListCollectionViewCell *)cell
                         requestIsGIFWithBlock:(void(^)(BOOL GIF))block;

@end

@interface LQPhotoKitImageListCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<LQPhotoKitImageListCollectionViewCellModel> model;

@end

NS_ASSUME_NONNULL_END
