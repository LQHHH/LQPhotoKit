//
//  LQPhotoKitChooseImageCell.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/24.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitChooseImageCell.h"
#import "UIView+config.h"

@interface LQPhotoKitChooseImageCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation LQPhotoKitChooseImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    [self imageView];
    [self selectedImageView];
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setModel:(id<LQPhotoKitChooseImageCellModel>)model {
    _model = model;
    [model photoKitChooseImageCell:self
             requestImageWithBlock:^(UIImage * _Nonnull image) {
                 self.imageView.image = image;
    }];
    self.selectedImageView.image = model.photoKitChooseImageCell_selected?[UIImage imageNamed:@"selectbox_on"]:[UIImage imageNamed:@"selectbox"];
}

#pragma mark - lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView                   = [UIImageView new];
        _imageView.frame             = CGRectMake(0, 0, self.lq_width, self.lq_height);
        _imageView.contentMode       = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds     = YES;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.layer.borderWidth = 0.5f;
        [self addSubview:_imageView];
        
    }
    return _imageView;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView                     = [UIImageView new];
        _selectedImageView.frame               = CGRectMake(self.lq_width - 20, 0, 20, 20);
        _selectedImageView.layer.cornerRadius  = 10;
        _selectedImageView.layer.masksToBounds = YES;
        _selectedImageView.backgroundColor     = [UIColor whiteColor];
        [self addSubview:_selectedImageView];
    }
    return _selectedImageView;
}

@end
