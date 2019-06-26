//
//  PhotoAlbumEditViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/5/25.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "PhotoAlbumEditViewController.h"
#import "LQPhotoKit.h"
#import <Masonry.h>
#import "ShowSelectedView.h"

@interface PhotoAlbumEditViewController () <LQPhotoKitAlbumViewControllerDelegate>

@property (nonatomic, strong) ShowSelectedView *displayView;

@end

@implementation PhotoAlbumEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title                = @"相册编辑";
    [self setUI];
}

#pragma mark - click

- (void)clickAction:(UIButton *)sender {
    LQPhotoKitAlbumViewController *vc = [LQPhotoKitAlbumViewController new];
    vc.delegate                       = self;
    UINavigationController *nav       = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LQPhotoKitAlbumViewControllerDelegate

- (void)photoKitAlbumViewController:(LQPhotoKitAlbumViewController *)viewController didSelectedEditImage:(UIImage *)editImage {
    self.displayView.image    = editImage;
}

- (void)photoKitAlbumViewController:(LQPhotoKitAlbumViewController *)viewController didSelectedEditVideoWithURL:(NSURL *)editURL {
    self.displayView.videoURL = editURL;
}

- (void)photoKitAlbumViewController:(LQPhotoKitAlbumViewController *)viewController didSelectedEditGIFImage:(UIImage *)editGIFImage {
    self.displayView.image    = editGIFImage;
}

#pragma mark - setUI

- (void)setUI {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"相册编辑" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset = 180;
        make.height.offset = 50;
        make.width.offset  = 100;
    }];
}

#pragma mark - lazy

- (ShowSelectedView *)displayView {
    if (!_displayView) {
        _displayView = [ShowSelectedView new];
        [self.view addSubview:_displayView];
        [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset         = 200;
            make.left.right.offset     = 0;
            make.top.offset            = 100;
        }];
        [_displayView layoutIfNeeded];
    }
    return _displayView;
}

@end
