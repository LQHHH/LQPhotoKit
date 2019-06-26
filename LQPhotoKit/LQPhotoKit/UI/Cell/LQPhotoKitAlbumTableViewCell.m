//
//  LQPhotoKitAlbumTableViewCell.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/5.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitAlbumTableViewCell.h"
#import "UIView+config.h"
#import "NSObject+config.h"

NSInteger const LQPhotoKitAlbumTableViewCellHeight = 120;

@interface LQPhotoKitAlbumTableViewCell ()

@property (nonatomic, strong) UIImageView *albumDisplayImageView;
@property (nonatomic, strong) UIImageView *albumSecondDisplayImageView;
@property (nonatomic, strong) UIImageView *albumThirdDisplayImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation LQPhotoKitAlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    [self refreshFrame];
    return self;
}

#pragma mark - setter

- (void)setModel:(id<LQPhotoKitAlbumTableViewCellModel>)model {
    _model = model;
    
    __weak typeof(self)wself = self;
    
    [model photoKitAlbumTableViewCell:self requestImageWithBlock:^(UIImage * _Nonnull image) {
        wself.albumDisplayImageView.image = image;
    }];
    
    self.nameLabel.text   = model.photoKitAlbumTableViewCel_title;
    self.countLabel.text  = [NSString localizedStringWithFormat:@"%ld",(long)model.photoKitAlbumTableViewCel_count];
    if (model.photoKitAlbumTableViewCel_count == 1) {
        self.albumSecondDisplayImageView.hidden = YES;
        self.albumThirdDisplayImageView.hidden  = YES;
    }
    else if (model.photoKitAlbumTableViewCel_count == 2) {
        self.albumSecondDisplayImageView.hidden = NO;
        
        [model photoKitAlbumTableViewCell:self requestSecondImageWithBlock:^(UIImage * _Nonnull image) {
            wself.albumSecondDisplayImageView.image = image;
        }];
        
        self.albumThirdDisplayImageView.hidden  = YES;
    }
    else {
        self.albumSecondDisplayImageView.hidden = NO;
        [model photoKitAlbumTableViewCell:self requestSecondImageWithBlock:^(UIImage * _Nonnull image) {
            wself.albumSecondDisplayImageView.image = image;
        }];
        
        self.albumThirdDisplayImageView.hidden  = NO;
        [model photoKitAlbumTableViewCell:self requestThirdImageWithBlock:^(UIImage * _Nonnull image) {
            wself.albumThirdDisplayImageView.image = image;
        }];
        
        
    }
}


#pragma mark - refreshFrame

- (void)refreshFrame {
    CGFloat width  = [self lq_screenWidth];
    CGFloat height = LQPhotoKitAlbumTableViewCellHeight;
    
    self.albumThirdDisplayImageView.frame = CGRectMake(30, (height - 70)/2-14, 70, 70);
    self.albumSecondDisplayImageView.frame = CGRectMake(25, (height - 80)/2-7, 80, 80);
    self.albumDisplayImageView.frame = CGRectMake(20, (height - 90)/2, 90, 90);
    self.nameLabel.frame                   = CGRectMake(self.albumDisplayImageView.lq_right+15, 35,width-30-self.nameLabel.lq_left, 20);
    self.countLabel.frame                  = CGRectMake(self.nameLabel.lq_left, self.nameLabel.lq_bottom+15, width - 30 - self.countLabel.lq_left, 20);
    self.arrowImageView.frame              = CGRectMake(width - 18 - 20,(height - 18)/2, 18, 18);
}

#pragma mark - lazy

- (UIImageView *)albumDisplayImageView {
    if (!_albumDisplayImageView) {
        _albumDisplayImageView = [UIImageView new];
        _albumDisplayImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumDisplayImageView.clipsToBounds = YES;
        _albumDisplayImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _albumDisplayImageView.layer.borderWidth = 0.5f;
        [self addSubview:_albumDisplayImageView];
    }
    return _albumDisplayImageView;
}

- (UIImageView *)albumSecondDisplayImageView {
    if (!_albumSecondDisplayImageView) {
        _albumSecondDisplayImageView = [UIImageView new];
        _albumSecondDisplayImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumSecondDisplayImageView.clipsToBounds = YES;
        _albumSecondDisplayImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _albumSecondDisplayImageView.layer.borderWidth = 0.5f;
        [self addSubview:_albumSecondDisplayImageView];
    }
    return _albumSecondDisplayImageView;
}

- (UIImageView *)albumThirdDisplayImageView {
    if (!_albumThirdDisplayImageView) {
        _albumThirdDisplayImageView = [UIImageView new];
        _albumThirdDisplayImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumThirdDisplayImageView.clipsToBounds = YES;
        _albumThirdDisplayImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _albumThirdDisplayImageView.layer.borderWidth = 0.5f;
        [self addSubview:_albumThirdDisplayImageView];
    }
    return _albumThirdDisplayImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.textColor     = [UIColor colorWithWhite:0 alpha:0.9];
        _nameLabel.font          = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel  = [[UILabel alloc] init];
        _countLabel.textColor     = [UIColor colorWithWhite:0 alpha:0.5];
        _countLabel.font          = [UIFont systemFontOfSize:14];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.image = [UIImage imageNamed:@"lan_list_icon_right"];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end
