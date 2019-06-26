//
//  LQPhotoKitImageEditView.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitImageEditView.h"

@interface LQPhotoKitImageEditView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,assign) CGFloat totalScale;

@end

@implementation LQPhotoKitImageEditView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(changeImageSize:)];
    [self addGestureRecognizer:pinchRecognizer];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    self.totalScale = 1;
    return self;
}

#pragma mark - action

-(void)changeImageSize:(UIPinchGestureRecognizer *)recognizer
{
//    CGFloat scale = recognizer.scale;
//    
//    //放大情况
//    if(scale > 1.0){
//        if(self.totalScale > 2.0) return;
//    }
//    
//    //缩小情况
//    if (scale < 1.0) {
//        if (self.totalScale < .5) return;
//    }
//    
//    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
//    self.totalScale *=scale;
//    recognizer.scale = 1.0;
    
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    // CGPoint point = [pan translationInView:self];
    
    //self.imageView.center = CGPointMake(self.imageView.centerX+point.x, self.imageView.centerY+point.y);
}

#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

#pragma mark - lazy

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView                        = [UIImageView new];
        _imageView.frame                  = self.bounds;
        _imageView.contentMode            = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds          = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}


@end
