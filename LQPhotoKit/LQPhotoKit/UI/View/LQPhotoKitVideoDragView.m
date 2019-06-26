//
//  LQPhotoKitVideoDragView.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/15.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitVideoDragView.h"
#import "UIView+config.h"

#define lq_imageViewWidth 9
#define lq_borderOffset 20

@interface LQPhotoKitVideoDragView ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation LQPhotoKitVideoDragView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self setupUI];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, self.validRect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 4.0);
    
    CGPoint topPoints[2];
    topPoints[0] = CGPointMake(self.validRect.origin.x, 0);
    topPoints[1] = CGPointMake(self.validRect.size.width + self.validRect.origin.x, 0);
    
    CGPoint bottomPoints[2];
    bottomPoints[0] = CGPointMake(self.validRect.origin.x, self.validRect.size.height);
    bottomPoints[1] = CGPointMake(self.validRect.size.width + self.validRect.origin.x, self.validRect.size.height);
    
    CGContextAddLines(context, topPoints, 2);
    CGContextAddLines(context, bottomPoints, 2);
    
    CGContextDrawPath(context, kCGPathStroke);
    CGPDFContextClose(context);
}

#pragma mark - setter

- (void)setValidRect:(CGRect)validRect {
    _validRect = validRect;
    
    self.leftImageView.lq_left = validRect.origin.x - lq_imageViewWidth;
    self.rightImageView.lq_left = validRect.size.width+validRect.origin.x;
    
    [self setNeedsDisplay];
}

#pragma mark - panGestureAction

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self];
    point.y = 0;
    CGRect rect   = self.validRect;
    switch (panGesture.view.tag) {
        case 0: {
            if (point.x < lq_imageViewWidth+lq_borderOffset ||
                rect.origin.x + (self.minWidth - (rect.size.width - (point.x - rect.origin.x))) > self.lq_width - lq_imageViewWidth - lq_borderOffset - rect.size.width) {
                break;
            }
            
            if (rect.size.width + (rect.origin.x - point.x) > self.maxWidth) {
                rect.origin.x = rect.origin.x - ((rect.size.width + (rect.origin.x - point.x)) - self.maxWidth);
                break;
            }
            
            if (rect.size.width - (point.x - rect.origin.x) < self.minWidth) {
                rect.origin.x = rect.origin.x + (self.minWidth - (rect.size.width - (point.x - rect.origin.x)));
                break;
            }
            
            rect.size.width = rect.size.width - (point.x - rect.origin.x);
            rect.origin.x = point.x;
        }
            break;
            
        case 1:  {
            if (point.x > self.lq_width-lq_imageViewWidth-lq_borderOffset ||
                rect.origin.x - (self.minWidth - (point.x - rect.origin.x)) < lq_imageViewWidth+lq_borderOffset) {
                break;
            }
            
            if (point.x - rect.origin.x > self.maxWidth) {
                rect.origin.x = rect.origin.x + (point.x - rect.origin.x - self.maxWidth);
                break;
            }
            
            if (point.x - rect.origin.x < self.minWidth) {
                rect.origin.x = rect.origin.x - (self.minWidth - (point.x - rect.origin.x));
                break;
            }
            
            
            rect.size.width = (point.x - rect.origin.x);
        }
            break;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoKitVideoDragViewStartChanged)]) {
                [self.delegate photoKitVideoDragViewStartChanged];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoKitVideoDragViewEndChanged)]) {
                [self.delegate photoKitVideoDragViewEndChanged];
            }
            break;
            
        default:
            break;
    }
    
    self.validRect = rect;
}

#pragma mark - setupUI

- (void)setupUI {
    self.leftImageView.frame  = CGRectMake(0, 0, lq_imageViewWidth, self.lq_height);
    [self addSubview:self.leftImageView];
    
    self.rightImageView.frame = CGRectMake(0, 0, lq_imageViewWidth, self.lq_height);
    [self addSubview:self.rightImageView];
}

#pragma mark - lazy

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lq_videoedit_left"]];
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.tag = 0;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_leftImageView addGestureRecognizer:panGesture];
    }
    return _leftImageView;
}
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lq_videoedit_right"]];
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.tag = 1;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_rightImageView addGestureRecognizer:panGesture];
    }
    return _rightImageView;
}

@end
