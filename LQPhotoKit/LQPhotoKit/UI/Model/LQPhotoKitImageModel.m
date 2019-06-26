//
//  LQPhotoKitImageModel.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/6.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitImageModel.h"

@interface LQPhotoKitImageModel ()

@property (nonatomic, strong, readwrite) PHAsset *asset;
@property (nonatomic, copy, readwrite) NSString *duration;
@property (nonatomic, strong, readwrite) UIImage *cacheImage;
@end

@implementation LQPhotoKitImageModel

+ (instancetype)creatWithPhotoModel:(id<LQPhotoKitAssetModel>)model {
     return [[self alloc] initWithPhotoModel:model];
}

- (instancetype)initWithPhotoModel:(id<LQPhotoKitAssetModel>)model {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.asset    = model.lqPhotoKit_asset;
    self.duration = model.lqPhotoKit_duration;
    return self;
}

#pragma mark -  LQPhotoKitImageListCollectionViewCellModel

- (NSString *)photoKitImageListCollectionViewCell_duration {
    return self.duration;
}

- (void)photoKitImageListCollectionViewCell:(LQPhotoKitImageListCollectionViewCell *)cell requestIsGIFWithBlock:(void (^)(BOOL))block {
    [[LQPhotoKitManager defaultManager]
     requestPhotoTypeWithPHAsset:self.asset
     completionBlock:^(LQPhotoKitType type) {
         if (block && type == LQPhotoKitTypeGIF) {
             block(YES);
             return;
         }
         if (block) {
             block(NO);
         }
    }];
}

- (void)photoKitImageListCollectionViewCell:(LQPhotoKitImageListCollectionViewCell *)cell requestImageWithBlock:(void (^)(UIImage * _Nonnull))block {
    if (self.cacheImage) {
        if (block) {
            block(self.cacheImage);
        }
        return;
    }
    
    [[LQPhotoKitManager defaultManager]
     requestImageWithPHAsset:self.asset
     size:CGSizeMake(200, 200)
     completionBlock:^(UIImage * _Nonnull image) {
         self.cacheImage = image;
         if (block) {
             block(image);
         }
     }];
}

#pragma mark - LQPhotoKitChooseImageCellModel

- (void)photoKitChooseImageCell:(LQPhotoKitChooseImageCell *)cell requestImageWithBlock:(void (^)(UIImage * _Nonnull))block {
    if (self.cacheImage) {
        if (block) {
            block(self.cacheImage);
        }
        return;
    }
    [[LQPhotoKitManager defaultManager]
     requestImageWithPHAsset:self.asset
     size:CGSizeMake(300, 300)
     completionBlock:^(UIImage * _Nonnull image) {
         self.cacheImage = image;
         if (block) {
             block(image);
         }
     }];
}

- (BOOL)photoKitChooseImageCell_selected {
    return self.selected;
}

@end
