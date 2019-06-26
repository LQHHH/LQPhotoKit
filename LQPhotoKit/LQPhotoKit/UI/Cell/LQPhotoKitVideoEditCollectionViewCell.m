//
//  LQPhotoKitVideoEditCollectionViewCell.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/15.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitVideoEditCollectionViewCell.h"
#import "UIView+config.h"

@interface LQPhotoKitVideoEditCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LQPhotoKitVideoEditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupUI];
    return self;
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.imageView];
}

#pragma mark - lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView                     = [UIImageView new];
        _imageView.frame               = CGRectMake(0, 0, self.lq_width, self.lq_height);
        _imageView.contentMode         = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds       = YES;
        
    }
    return _imageView;
}

@end
