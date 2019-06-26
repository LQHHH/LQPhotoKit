//
//  LQPhotoKitImageListViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/6.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitImageListViewController.h"
#import "LQPhotoKitImageListCollectionViewCell.h"
#import "LQPhotoKitAlbumModel.h"
#import "LQPhotoKitImageModel.h"
#import "NSObject+config.h"

#import "LQPhotoKitImageEditViewController.h"
#import "LQPhotoKitGIFImageEditViewController.h"
#import "LQPhotoKitVideoEditViewController.h"

@interface LQPhotoKitImageListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoModels;

@end

@implementation LQPhotoKitImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.model.assetCollection.localizedTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self)wself = self;
    [[LQPhotoKitManager defaultManager]
     requestAssetModelsWithPHAssetCollection:self.model.assetCollection completionBlock:^(NSArray<id<LQPhotoKitAssetModel>> * _Nonnull photoModels) {
        for (id<LQPhotoKitAssetModel> model in photoModels) {
            LQPhotoKitImageModel *imageModel = [LQPhotoKitImageModel creatWithPhotoModel:model];
            [wself.photoModels addObject:imageModel];
        }
        [wself.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoModels.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self lq_screenWidth]/4, [self lq_screenWidth]/4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LQPhotoKitImageListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoKitImageListCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.photoModels[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LQPhotoKitImageModel *model = self.photoModels[indexPath.row];
    
    __weak typeof(self)wself = self;
    [[LQPhotoKitManager defaultManager]
     requestPhotoTypeWithPHAsset:model.asset
     completionBlock:^(LQPhotoKitType type) {
         switch (type) {
             case LQPhotoKitTypeImage: {
                 LQPhotoKitImageEditViewController *vc = [LQPhotoKitImageEditViewController new];
                 vc.model = model;
                 [wself.navigationController pushViewController:vc animated:YES];
                 break;
             }
                 
             case LQPhotoKitTypeGIF: {
                 LQPhotoKitGIFImageEditViewController *vc = [LQPhotoKitGIFImageEditViewController new];
                 vc.model = model;
                 [wself.navigationController pushViewController:vc animated:YES];
                 
                 break;
             }
                 
             case LQPhotoKitTypeVideo: {
                 LQPhotoKitVideoEditViewController *vc = [LQPhotoKitVideoEditViewController new];
                 vc.model = model;
                 [wself.navigationController pushViewController:vc animated:YES];
                 
                 break;
             }
         }
    }];
    
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [self lq_navigationBarHeight], [self lq_screenWidth], [self lq_screenHeight] - [self lq_navigationBarHeight]) collectionViewLayout:layout];
        _collectionView.pagingEnabled = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor =  [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:LQPhotoKitImageListCollectionViewCell.class forCellWithReuseIdentifier:@"photoKitImageListCollectionViewCell"];
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

- (NSMutableArray *)photoModels {
    if (!_photoModels) {
        _photoModels = [NSMutableArray new];
    }
    return _photoModels;
}


@end
