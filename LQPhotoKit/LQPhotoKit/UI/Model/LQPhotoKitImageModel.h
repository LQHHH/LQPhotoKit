//
//  LQPhotoKitImageModel.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/6.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQPhotoKitManager.h"

#import "LQPhotoKitImageListCollectionViewCell.h"
#import "LQPhotoKitChooseImageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQPhotoKitImageModel : NSObject <LQPhotoKitImageListCollectionViewCellModel, LQPhotoKitChooseImageCellModel>

@property (readonly) PHAsset *asset;
@property (readonly) NSString *duration;

@property (nonatomic, assign) BOOL selected;
@property (readonly) UIImage *cacheImage;

+ (instancetype)creatWithPhotoModel:(id<LQPhotoKitAssetModel>)model;

@end

NS_ASSUME_NONNULL_END
