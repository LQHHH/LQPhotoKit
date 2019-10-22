//
//  ImageChooseViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "ImageChooseViewController.h"
#import "LQPhotoKit.h"
#import <Masonry.h>

@interface ImageChooseViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;

@end

@implementation ImageChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title                = @"照片选择";
    [self setUI];
}

#pragma mark - click

- (void)clickAction:(UIButton *)sender {
    LQPhotoKitChooseImageViewController *vc = [LQPhotoKitChooseImageViewController new];
    UINavigationController *nav             = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle        = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
    __weak typeof(self)wself = self;
    [vc setCompletiomBlock:^(NSArray *images) {
        wself.images = images;
        [wself.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)/4, CGRectGetWidth([UIScreen mainScreen].bounds)/4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIView *view = [cell viewWithTag:indexPath.row + 100];
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
    UIImageView *imageView = [UIImageView new];
    imageView.frame        = cell.bounds;
    imageView.tag          = indexPath.item + 100;
    [cell addSubview:imageView];
    imageView.image        = self.images[indexPath.item];
    return cell;
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor =  [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.top.offset = 10;
            make.bottom.offset = -100;
        }];
    }
    return _collectionView;
}

#pragma mark - setUI

- (void)setUI {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"点击选择照片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.offset = -20;
        make.height.offset = 50;
        make.width.offset  = 150;
    }];
}

@end
