//
//  LQPhotoKitAlbumModel.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/5.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitAlbumModel.h"

@interface LQPhotoKitAlbumModel ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) NSInteger count;
@property (nonatomic, strong, readwrite) PHAsset *asset;
@property (nonatomic, strong, readwrite) PHAsset *secondAsset;
@property (nonatomic, strong, readwrite) PHAsset *thirdAsset;
@property (nonatomic, strong, readwrite) PHAssetCollection *assetCollection;

@end

@implementation LQPhotoKitAlbumModel

+ (instancetype)creatWithPhotoAlbumModel:(id<LQPhotoKitAlbumModel>)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(id<LQPhotoKitAlbumModel>)model {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title           = model.lqPhotoKitAlbum_title;
    self.count           = model.lqPhotoKitAlbum_count;
    self.asset           = model.lqPhotoKitAlbum_asset;
    self.secondAsset    = model.lqPhotoKitAlbum_secondAsset;
    self.thirdAsset      = model.lqPhotoKitAlbum_thirdAsset;
    self.assetCollection = model.lqPhotoKitAlbum_assetCollection;
    return self;
}

@end


@implementation LQPhotoKitAlbumModel  (LQPhotoKitAlbumTableViewCellModel)

- (NSString *)photoKitAlbumTableViewCel_title {
    return self.title;
}

- (NSInteger)photoKitAlbumTableViewCel_count {
    return self.count;
}

- (void)photoKitAlbumTableViewCell:(LQPhotoKitAlbumTableViewCell *)cell requestImageWithBlock:(void (^)(UIImage * _Nonnull))block {
    [[LQPhotoKitManager defaultManager]
     requestImageWithPHAsset:self.asset
     size:CGSizeMake(200, 200)
     completionBlock:^(UIImage * _Nonnull image) {
         if (block) {
             block(image);
         }
    }];
}

- (void)photoKitAlbumTableViewCell:(LQPhotoKitAlbumTableViewCell *)cell requestSecondImageWithBlock:(void (^)(UIImage * _Nonnull))block {
    [[LQPhotoKitManager defaultManager]
     requestImageWithPHAsset:self.secondAsset
     size:CGSizeMake(200, 200)
     completionBlock:^(UIImage * _Nonnull image) {
         if (block) {
             block(image);
         }
     }];
}

- (void)photoKitAlbumTableViewCell:(LQPhotoKitAlbumTableViewCell *)cell requestThirdImageWithBlock:(void (^)(UIImage * _Nonnull))block {
    [[LQPhotoKitManager defaultManager]
     requestImageWithPHAsset:self.thirdAsset
     size:CGSizeMake(200, 200)
     completionBlock:^(UIImage * _Nonnull image) {
         if (block) {
             block(image);
         }
     }];
}

@end
