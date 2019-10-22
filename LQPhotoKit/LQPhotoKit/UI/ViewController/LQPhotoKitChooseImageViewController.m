//
//  LQPhotoKitChooseImageViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/22.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitChooseImageViewController.h"
#import "LQPhotoKitChooseImageCell.h"
#import "NSObject+config.h"
#import "LQPhotoKitImageModel.h"

@interface LQPhotoKitChooseImageViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoModels;

@end

@implementation LQPhotoKitChooseImageViewController

- (void)dealloc {
    [[LQPhotoKitManager defaultManager] removeAlbums];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title                = @"照片多选";
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem * sureButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completion)];
    self.navigationItem.rightBarButtonItem = sureButton;
    
    __weak typeof(self)wself = self;
    
    [[LQPhotoKitManager defaultManager]
     requestAuthorizationWithHandler:^(BOOL authorized) {
        if (!authorized) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相册"
                                                            message:@"请在设置-隐私-相册中允许访问相册"
                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }]];
            return;
        }
        
        [wself requestImageList];
        
    }];
}

- (void)requestImageList {
     __weak typeof(self)wself = self;
    LQPhotoKitManager *manager = [LQPhotoKitManager defaultManager];
    manager.maxChooseImageCount = 5;
    [manager requestAllAssetModelsWithCompletionBlock:^(NSArray<id<LQPhotoKitAssetModel>> * _Nonnull photoModels) {
        for (id <LQPhotoKitAssetModel> assetModel in photoModels) {
            LQPhotoKitImageModel *model = [LQPhotoKitImageModel creatWithPhotoModel:assetModel];
            [wself.photoModels addObject:model];
        }
        [wself.collectionView reloadData];
    }];
}

#pragma mark - action

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completion {
    NSMutableArray *images = @[].mutableCopy;
    for (LQPhotoKitImageModel *model in self.photoModels) {
        if (model.selected) {
            [images addObject:model.cacheImage];
        }
    }
    if (self.completiomBlock) {
        self.completiomBlock(images);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoModels.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self lq_screenWidth]/4, [self lq_screenWidth]/4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LQPhotoKitChooseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LQPhotoKitChooseImageCell" forIndexPath:indexPath];
    //cell.image = self.photoModels[indexPath.item];
    cell.model = self.photoModels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LQPhotoKitImageModel *model = self.photoModels[indexPath.item];
    if (!model.selected) {
        int count = 0;
        for (LQPhotoKitImageModel *tmpModel in self.photoModels) {
            if (tmpModel.selected) {
                count++;
            }
        }
        if (count == [LQPhotoKitManager defaultManager].maxChooseImageCount) {
            [self showAlert];
            return;
        }
    }
    model.selected = !model.selected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

#pragma mark - alert

- (void)showAlert {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"提示"
                                          message:[NSString stringWithFormat:@"您最多只能选择%ld张",[LQPhotoKitManager defaultManager].maxChooseImageCount]
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
        [_collectionView registerClass:LQPhotoKitChooseImageCell.class forCellWithReuseIdentifier:@"LQPhotoKitChooseImageCell"];
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
