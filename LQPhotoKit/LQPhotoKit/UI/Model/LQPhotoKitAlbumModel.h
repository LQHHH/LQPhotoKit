//
//  LQPhotoKitAlbumModel.h
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/5.
//  Copyright © 2019 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQPhotoKitManager.h"

#import "LQPhotoKitAlbumTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQPhotoKitAlbumModel : NSObject

@property (readonly) NSString *title;
@property (readonly) NSInteger count;
@property (readonly) PHAsset *asset;
@property (readonly) PHAsset *secondAsset;
@property (readonly) PHAsset *thirdAsset;
@property (readonly) PHAssetCollection *assetCollection;

+ (instancetype)creatWithPhotoAlbumModel:(id<LQPhotoKitAlbumModel>)model;

@end



@interface LQPhotoKitAlbumModel (LQPhotoKitAlbumTableViewCellModel) <LQPhotoKitAlbumTableViewCellModel>

@end

NS_ASSUME_NONNULL_END
