//
//  LQPhotoKit.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LQPhotoKitType) {
    LQPhotoKitTypeImage = 1,
    LQPhotoKitTypeGIF,
    LQPhotoKitTypeVideo
};

@protocol LQPhotoKitAlbumModel,LQPhotoKitAssetModel;

@protocol LQPhotoKitManagerRequest <NSObject>

- (void)requestAuthorizationWithHandler:(void(^)(BOOL authorized))handler;

- (void)requestAllAlbumsWithCompletionBlock:(void(^)(NSArray <id<LQPhotoKitAlbumModel>>*albums))completionBlock;

- (void)requestAssetModelsWithPHAssetCollection:(PHAssetCollection *)collection
                          completionBlock:(void(^)(NSArray <id<LQPhotoKitAssetModel>>*photoModels))completionBlock;

- (void)requestImageWithPHAsset:(PHAsset *)asset
                           size:(CGSize)size
                completionBlock:(void (^)(UIImage *image))completionBlock;


- (void)requestPhotoTypeWithPHAsset:(PHAsset *)asset
                    completionBlock:(void(^)(LQPhotoKitType type))completionBlock;

- (void)requestVideoWithPHAsset:(PHAsset *)asset
                completiomBlock:(void(^)(AVAsset *avAsset))completionBlock;

- (void)exportEditVideoForAVAsset:(AVAsset *)asset
                        timeRange:(CMTimeRange)timeRange
                  completionBlock:(void(^)(NSString *error,NSURL *editURL))completionBlock;

- (void)requestGIFImageDataWithPHAsset:(PHAsset *)asset
                       completiomBlock:(void(^)(NSData *data))completionBlock;

- (void)requestAllImagesWithCompletionBlock:(void(^)(NSArray *images))completionBlock;

- (void)requestAllAssetModelsWithCompletionBlock:(void(^)(NSArray <id<LQPhotoKitAssetModel>>*photoModels))completionBlock;

- (void)removeAlbums;

@end

#define LQPhotoKitManagerMaximumSize PHImageManagerMaximumSize

@class LQPhotoKitConfig;

@interface LQPhotoKitManager : NSObject <LQPhotoKitManagerRequest>

+ (instancetype)defaultManager;

@property (nonatomic, assign) NSUInteger maxChooseImageCount;

@end

@protocol LQPhotoKitAlbumModel <NSObject>

@property (readonly) NSString *lqPhotoKitAlbum_title;
@property (readonly) NSInteger lqPhotoKitAlbum_count;
@property (readonly) PHAsset *lqPhotoKitAlbum_asset;
@property (readonly) PHAsset *lqPhotoKitAlbum_secondAsset;
@property (readonly) PHAsset *lqPhotoKitAlbum_thirdAsset;
@property (readonly) PHAssetCollection *lqPhotoKitAlbum_assetCollection;

@end

@protocol LQPhotoKitAssetModel <NSObject>

@property (readonly) PHAsset *lqPhotoKit_asset;
@property (readonly) NSString *lqPhotoKit_duration;

@end

NS_ASSUME_NONNULL_END
