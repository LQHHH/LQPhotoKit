//
//  LQPhotoKitChooseImageCell.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/24.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LQPhotoKitChooseImageCell;

@protocol LQPhotoKitChooseImageCellModel <NSObject>

@property (readonly) BOOL photoKitChooseImageCell_selected;

- (void)photoKitChooseImageCell:(LQPhotoKitChooseImageCell *)cell
                      requestImageWithBlock:(void(^)(UIImage *image))block;

@end

@interface LQPhotoKitChooseImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<LQPhotoKitChooseImageCellModel> model;

@end

NS_ASSUME_NONNULL_END
