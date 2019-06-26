//
//  LQPhotoKitImageEditViewController.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitImageEditViewController.h"
#import "LQPhotoKitAlbumViewController.h"
#import "LQPhotoKitImageEditView.h"
#import "NSObject+config.h"
#import "UIView+config.h"
#import "LQPhotoKitManager.h"
#import "LQPhotoKitImageModel.h"


@interface LQPhotoKitImageEditViewController ()

@property (nonatomic, strong) LQPhotoKitImageEditView *imageEditView;

@end

@implementation LQPhotoKitImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"编辑";
    
    UIBarButtonItem *item     = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                        style:UIBarButtonItemStylePlain
                                                                target:self
                                                    action:@selector(clickSure)];
    self.navigationItem.rightBarButtonItem = item;
    
    __weak typeof(self) wself = self;
    [[LQPhotoKitManager defaultManager]
     requestImageWithPHAsset:self.model.asset
     size:LQPhotoKitManagerMaximumSize
     completionBlock:^(UIImage * _Nonnull image) {
         wself.imageEditView.image = image;
    }];
    
}

#pragma mark - action

- (void)clickSure {
    CGSize size = self.imageEditView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, 0);
    [self.imageEditView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    LQPhotoKitAlbumViewController *vc = self.navigationController.viewControllers.firstObject;
    if ([vc.delegate respondsToSelector:@selector(photoKitAlbumViewController:didSelectedEditImage:)]) {
        [vc.delegate photoKitAlbumViewController:vc didSelectedEditImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - lazy

- (LQPhotoKitImageEditView *)imageEditView {
    if (!_imageEditView) {
        _imageEditView        = [LQPhotoKitImageEditView new];
        _imageEditView.bounds = CGRectMake(0, 0, [self lq_screenWidth], 300);
        _imageEditView.center = self.view.center;
        [self.view addSubview:_imageEditView];
    }
    
    return _imageEditView;
}

@end
