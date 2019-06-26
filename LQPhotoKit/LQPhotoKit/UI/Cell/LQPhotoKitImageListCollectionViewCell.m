//
//  LQPhotoKitImageListCollectionViewCell.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/6.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitImageListCollectionViewCell.h"
#import "UIView+config.h"

@interface LQPhotoKitImageListCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation LQPhotoKitImageListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

#pragma mark - setter

- (void)setModel:(id<LQPhotoKitImageListCollectionViewCellModel>)model {
    _model = model;
    
    __weak typeof(self)wself = self;
    [model photoKitImageListCollectionViewCell:self requestImageWithBlock:^(UIImage * _Nonnull image) {
        [wself.imageView setImage:image];
        wself.timeLabel.text = model.photoKitImageListCollectionViewCell_duration;
    }];
    
    [model photoKitImageListCollectionViewCell:self requestIsGIFWithBlock:^(BOOL GIF) {
        if (GIF) {
            wself.timeLabel.text = @"GIF";
        }
    }];
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

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel                 = [[UILabel alloc] init];
        _timeLabel.frame           = CGRectMake(0, self.lq_height-20, self.lq_width - 8, 20);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor       = [UIColor whiteColor];
        _timeLabel.textAlignment   = NSTextAlignmentRight;
        _timeLabel.font            = [UIFont systemFontOfSize:13];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
