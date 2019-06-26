//
//  LQPhotoKit.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitManager.h"

@interface LQAssetModel : NSObject <LQPhotoKitAssetModel>

@property (nonatomic, strong, readwrite) PHAsset *asset;
@property (nonatomic, copy, readwrite) NSString *duration;

@end

@implementation LQAssetModel

- (PHAsset *)lqPhotoKit_asset {
    return self.asset;
}

- (NSString *)lqPhotoKit_duration {
    return self.duration;
}

@end

@interface LQAlbumModel : NSObject <LQPhotoKitAlbumModel>

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) NSInteger count;
@property (nonatomic, strong, readwrite) PHAsset *asset;
@property (nonatomic, strong, readwrite) PHAsset *secondAsset;
@property (nonatomic, strong, readwrite) PHAsset *thirdAsset;
@property (nonatomic, strong, readwrite) PHAssetCollection *assetCollection;
@property (nonatomic, strong, readwrite) NSMutableArray <LQAssetModel *>*photoModels;

@end

@implementation LQAlbumModel

- (NSString *)lqPhotoKitAlbum_title {
    return self.title;
}

- (NSInteger)lqPhotoKitAlbum_count {
    return self.count;
}

- (PHAsset *)lqPhotoKitAlbum_asset {
    return self.asset;
}

- (PHAsset *)lqPhotoKitAlbum_secondAsset {
    return self.secondAsset;
}

- (PHAsset *)lqPhotoKitAlbum_thirdAsset {
    return self.thirdAsset;
}

- (PHAssetCollection *)lqPhotoKitAlbum_assetCollection {
    return self.assetCollection;
}

- (NSMutableArray<LQAssetModel *> *)photoModels {
    if (!_photoModels) {
        _photoModels = [NSMutableArray new];
    }
    return _photoModels;
}

@end



@interface LQPhotoKitManager ()

@property (nonatomic, strong) NSMutableArray <id<LQPhotoKitAlbumModel>>*albums;

@end



@implementation LQPhotoKitManager

+ (instancetype)defaultManager {
    static LQPhotoKitManager *photoKit;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoKit = [[LQPhotoKitManager alloc] init];
    });
    return photoKit;
}

#pragma mark - LQPhotoKitRequest

- (void)requestAuthorizationWithHandler:(void(^)(BOOL authorized))handler {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        if (handler) {
            handler(YES);
        }
    }else if (status == PHAuthorizationStatusDenied ||
              status == PHAuthorizationStatusRestricted) {
        if (handler){
            handler(NO);
        }
    }else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(status == PHAuthorizationStatusAuthorized);
                }
            });
        }];
    }
    
}

- (void)requestAllAlbumsWithCompletionBlock:(void(^)(NSArray <id<LQPhotoKitAlbumModel>>*albums))completionBlock {
    if (self.albums.count > 0) {
        if (completionBlock) {
            completionBlock(self.albums);
        }
        return;
    }
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    NSArray *albums = @[smartAlbums, userAlbums];
    for (PHFetchResult *fetchResult in albums) {
        for (PHAssetCollection *assetCollection in fetchResult) {
            //过滤不需要的相册
            if (![assetCollection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            if ([assetCollection estimatedAssetCount] <= 0) {
                continue;
            }
            @autoreleasepool {
                LQAlbumModel *albumModel = [[LQAlbumModel alloc] init];
                albumModel.title              = assetCollection.localizedTitle;
                PHFetchResult *result         = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
                albumModel.count              = result.count;
                albumModel.assetCollection    = assetCollection;
                albumModel.asset              = result.firstObject;
                if (albumModel.count >=2) {
                    albumModel.secondAsset    = result[1];
                }
                if (albumModel.count >=3) {
                    albumModel.thirdAsset     = result[2];
                }
                if (albumModel.count > 0) {
                    [self.albums addObject:albumModel];
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completionBlock) {
            completionBlock(self.albums);
        }
    });
}

- (void)requestAssetModelsWithPHAssetCollection:(PHAssetCollection *)collection
                                completionBlock:(void(^)(NSArray <id<LQPhotoKitAssetModel>>*photoModels))completionBlock {
    LQAlbumModel *album = nil;
    for (LQAlbumModel *obj in self.albums) {
        if (collection == obj.assetCollection) {
            album = obj;
        }
    }
    if (album.photoModels.count > 0) {
        if (completionBlock) {
            completionBlock(album.photoModels);
        }
        return;
    }
    if (!album) {
        album = [LQAlbumModel new];
        [self.albums addObject:album];
    }
    
    album.photoModels = nil;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
    [result enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LQAssetModel *model = [LQAssetModel new];
        model.asset         = obj;
        if (obj.mediaType == PHAssetMediaTypeVideo) {
            model.duration      = [self transFormTimeIntervalToTime:obj.duration];
        }
        [album.photoModels addObject:model];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completionBlock) {
            completionBlock(album.photoModels);
        }
    });
    
}

- (void)requestImageWithPHAsset:(PHAsset *)asset
                           size:(CGSize)size
                completionBlock:(void (^)(UIImage *image))completionBlock {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode           = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed   = YES;
    [[PHImageManager defaultManager]
     requestImageForAsset:asset
     targetSize:size
     contentMode:PHImageContentModeAspectFill
     options:options
     resultHandler:^(UIImage *image, NSDictionary *info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock) {
                        completionBlock(image);
                    }
                });
            }
        }];
}

- (void)requestPhotoTypeWithPHAsset:(PHAsset *)asset
                    completionBlock:(void(^)(LQPhotoKitType type))completionBlock {
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        if (completionBlock) {
            completionBlock(LQPhotoKitTypeVideo);
        }
        return;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode           = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed   = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
                                                    uint8_t c;
                                                    LQPhotoKitType imageType = LQPhotoKitTypeImage;
                                                    [imageData getBytes:&c length:1];
                                                    if (c == 0x47) {
                                                        imageType = LQPhotoKitTypeGIF;
                                                    }
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (completionBlock) {
                                                            completionBlock(imageType);
                                                        }
                                                    });
                                                    
                                                }];
}

- (void)requestVideoWithPHAsset:(PHAsset *)asset
                completiomBlock:(void(^)(AVAsset *avAsset))completionBlock {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode           = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed   = YES;
    options.version                = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager]
     requestAVAssetForVideo:asset
     options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
         BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
         if (downloadFinined && asset) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (completionBlock) {
                     completionBlock(asset);
                 }
             });
         }
     }];
}

- (void)exportEditVideoForAVAsset:(AVAsset *)asset
                        timeRange:(CMTimeRange)timeRange
                  completionBlock:(void(^)(NSString *error,NSURL *editURL))completionBlock {
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([presets containsObject:AVAssetExportPresetHighestQuality]) {
        NSString *fileName = [[self lq_fileName] stringByAppendingString:@".mp4"];
        NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSURL *videoURL = [NSURL fileURLWithPath:fullPathToFile];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = videoURL;
        NSArray *supportedTypeArray = exportSession.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            exportSession.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            if (completionBlock) {
                completionBlock(@"导出视屏失败!",nil);
            }
            return;
        }else {
            exportSession.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        exportSession.timeRange = timeRange;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    if (completionBlock) {
                        completionBlock(nil,videoURL);
                    }
                }else {
                    if (completionBlock) {
                        completionBlock(@"导出视屏失败!",nil);
                    }
                }
            });
        }];
    }else {
        if (completionBlock) {
            completionBlock(@"导出视屏失败!",nil);
        }
    }
}

- (void)requestGIFImageDataWithPHAsset:(PHAsset *)asset
                       completiomBlock:(void(^)(NSData *data))completionBlock {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode           = PHImageRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed   = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
                                                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                                                    if (downloadFinined && imageData) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            if (completionBlock) {
                                                                completionBlock(imageData);
                                                            }
                                                        });
                                                    }
                                                    
                                                }];
}

- (void)requestAllImagesWithCompletionBlock:(void(^)(NSArray *images))completionBlock {
    PHFetchResult *needAlbum = [PHAssetCollection
                                fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHAssetCollection *collection = needAlbum.firstObject;
    [self requestAssetModelsWithPHAssetCollection:collection
                                  completionBlock:^(NSArray<id<LQPhotoKitAssetModel>> * _Nonnull photoModels) {
                                      NSMutableArray *allImages = [NSMutableArray new];
                                      for (int i = 0 ; i < photoModels.count; i++) {
                                          id <LQPhotoKitAssetModel> model = photoModels[i];
                                          [self requestImageWithPHAsset:model.lqPhotoKit_asset
                                                                   size:CGSizeMake(300, 300)
                                                        completionBlock:^(UIImage * _Nonnull image) {
                                                            [allImages addObject:image];
                                                            if (i == photoModels.count -1) {
                                                                if (completionBlock) {
                                                                    completionBlock(allImages);
                                                                }
                                                            }
                                                        }];
                                      }
    }];
}


- (void)requestAllAssetModelsWithCompletionBlock:(void(^)(NSArray <id<LQPhotoKitAssetModel>>*photoModels))completionBlock {
    PHFetchResult *needAlbum = [PHAssetCollection
                                fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHAssetCollection *collection = needAlbum.firstObject;
    [self requestAssetModelsWithPHAssetCollection:collection
                                  completionBlock:^(NSArray<id<LQPhotoKitAssetModel>> * _Nonnull photoModels) {
                                      if (completionBlock) {
                                          completionBlock(photoModels);
                                      }
                                  }];
}

- (void)removeAlbums {
    for (LQAlbumModel *model in _albums) {
        [model.photoModels removeAllObjects];
        model.photoModels = nil;
    }
    [_albums removeAllObjects];
    _albums = nil;
}


#pragma mark - privite

- (NSString *)transFormTimeIntervalToTime:(NSTimeInterval)timeInterval {
    if(timeInterval == 0) {
        return nil;
    }
    int time = timeInterval+0.5;
    int hour   = time/3600;
    int min    = time/60;
    int second = time;
    if (hour >= 1) {
        if (second <= 9) {
            return [NSString stringWithFormat:@"%d:%d:0%d",hour,min,second];
        }
        return [NSString stringWithFormat:@"%d:%d:%d",hour,min,second];
    }
    
    if (second <= 9) {
        return [NSString stringWithFormat:@"%d:0%d",min,second];
    }
    return [NSString stringWithFormat:@"%d:%d",min,second];
}

- (NSString *)lq_fileName {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
    
    NSString *fileName = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    fileName = [fileName stringByAppendingString:@"az"];
    fileName = [fileName stringByAppendingString:dateStr];
    fileName = [fileName stringByAppendingString:numStr];
    
    return [NSString stringWithFormat:@"%@%@",name,fileName];
}

#pragma mark - lazy

- (NSMutableArray <id<LQPhotoKitAlbumModel>>*)albums {
    if (!_albums) {
        _albums = [NSMutableArray new];
    }
    return _albums;
}

@end
