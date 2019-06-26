//
//  LQPhotoKitVideoEditView.m
//  LQPhotoKit
//
//  Created by hongzhiqiang on 2019/6/10.
//  Copyright © 2019 LQ. All rights reserved.
//

#import "LQPhotoKitVideoEditView.h"
#import "LQPhotoKitVideoDragView.h"
#import "LQPhotoKitVideoEditCollectionViewCell.h"
#import "UIView+config.h"

#define lq_imageWidth  35
#define lq_imageHeight 80
#define lq_dragImageViewWidth 8
#define lq_borderOffset 20
#define lq_maxClipVideoTime 2
#define lq_minClipVideoTime 0.5

@interface LQPhotoKitVideoEditView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LQPhotoKitVideoDragViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LQPhotoKitVideoDragView *dragView;
@property (nonatomic, strong) AVAssetImageGenerator *generator;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *operationDict;
@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, assign) CGFloat videoTime;
@property (nonatomic, assign) CGFloat singleSecondWidth;

@end

@implementation LQPhotoKitVideoEditView

- (void)dealloc {
    [self.operationQueue cancelAllOperations];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.videoTime = lq_maxClipVideoTime;
    [self setupUI];
    return self;
}

#pragma mark - hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - setter

- (void)setModel:(id<LQPhotoKitVideoEditViewModel>)model {
    _model = model;
    CGFloat second            = roundf(CMTimeGetSeconds(model.photoKitVideoEditView_avAsset.duration));
    if (second < 2) {
        self.videoTime = second;
    }
    self.singleSecondWidth = (self.lq_width - lq_dragImageViewWidth*2 - lq_borderOffset*2)/2/(CGFloat)lq_maxClipVideoTime;
    self.contentWidth         = self.singleSecondWidth * second;
    self.dataCount            = ceilf(self.contentWidth/lq_imageWidth);
    self.interval             = lq_imageWidth/self.singleSecondWidth;
    
    self.dragView.validRect   = CGRectMake(lq_dragImageViewWidth+lq_borderOffset, 0, (self.lq_width - lq_dragImageViewWidth*2 - lq_borderOffset*2)/2, lq_imageHeight);
    self.dragView.minWidth    = self.contentWidth * lq_minClipVideoTime/second;
    self.dragView.maxWidth    = self.contentWidth * lq_maxClipVideoTime/second;
    
    [self.collectionView reloadData];
    
    [self startMoveAnimation];
    
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(lq_imageWidth, lq_imageHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LQPhotoKitVideoEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LQPhotoKitVideoEditCollectionViewCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.operationDict objectForKey:@(indexPath.item).stringValue]) {
        NSBlockOperation *operation = [self blockOperationWithIndex:indexPath.item];
        [self.operationQueue addOperation:operation];
        [self.operationDict setObject:operation forKey:@(indexPath.item).stringValue];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.operationDict[@(indexPath.item).stringValue]) {
        NSBlockOperation *operation = self.operationDict[@(indexPath.item).stringValue];
        [operation cancel];
        [self.operationDict removeObjectForKey:@(indexPath.item).stringValue];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self willChangeVideoPlay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self changeVideoPlayRange];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changeVideoPlayRange];
}

#pragma mark - LQPhotoKitVideoDragViewDelegate

- (void)photoKitVideoDragViewStartChanged {
    [self willChangeVideoPlay];
}

- (void)photoKitVideoDragViewEndChanged {
    [self changeVideoPlayRange];
}

- (void)willChangeVideoPlay {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoKitVideoEditView:willChangeVideoPlayRange:)]) {
        CGRect  validRect = self.dragView.validRect;
        CGFloat offsetX  = self.collectionView.contentOffset.x;
        NSTimeInterval startTime  = (offsetX + validRect.origin.x-lq_dragImageViewWidth-lq_borderOffset)/self.singleSecondWidth;
        if (startTime < 0) {
            startTime = 0;
        }
        NSTimeInterval timeLength = validRect.size.width/self.singleSecondWidth;
        if (timeLength > lq_maxClipVideoTime) {
            timeLength = lq_maxClipVideoTime;
        }

        LQPhotoKitVideoEditViewPlayRange range = LQPhotoKitVideoEditViewPlayRangeMake(startTime, timeLength);
        [self.delegate photoKitVideoEditView:self willChangeVideoPlayRange:range];
        [self stopMoveAnimation];
    }
}

- (void)changeVideoPlayRange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoKitVideoEditView:didChangeVideoPlayRange:)]) {
        CGRect  validRect = self.dragView.validRect;
        CGFloat offsetX  = self.collectionView.contentOffset.x;
        NSTimeInterval startTime  = (offsetX + validRect.origin.x-lq_dragImageViewWidth-lq_borderOffset)/self.singleSecondWidth;
        if (startTime < 0) {
            startTime = 0;
        }
        NSTimeInterval timeLength = validRect.size.width/self.singleSecondWidth;
        if (timeLength > lq_maxClipVideoTime) {
            timeLength = lq_maxClipVideoTime;
        }

        LQPhotoKitVideoEditViewPlayRange range = LQPhotoKitVideoEditViewPlayRangeMake(startTime, timeLength);
        [self.delegate photoKitVideoEditView:self didChangeVideoPlayRange:range];
        self.videoTime = timeLength;
        [self startMoveAnimation];
    }
}

#pragma mark - aniamtion

- (void)startMoveAnimation {
    self.moveLine.hidden = NO;
    CABasicAnimation *baseAnimation   = [CABasicAnimation animationWithKeyPath:@"position.x"];
    baseAnimation.duration            = self.videoTime;
    baseAnimation.repeatCount         = MAXFLOAT;
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode            = kCAFillModeForwards;
    baseAnimation.fromValue           = @(self.dragView.validRect.origin.x);
    baseAnimation.toValue             = @(self.dragView.validRect.origin.x+self.dragView.validRect.size.width);
    [self.moveLine.layer addAnimation:baseAnimation forKey:@"seleterVideoMoveAnimation"];
}

- (void)stopMoveAnimation {
    [self.moveLine.layer removeAnimationForKey:@"seleterVideoMoveAnimation"];
    self.moveLine.hidden = YES;
}

#pragma mark - privite

- (CMTime)getTimeWithIndex:(CGFloat)index {
    return CMTimeMakeWithSeconds(index * self.interval, self.model.photoKitVideoEditView_avAsset.duration.timescale);
}

- (NSBlockOperation *)blockOperationWithIndex:(NSInteger)index {
    __weak typeof(self)weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSInteger item = index;
        CMTime time = [weakSelf getTimeWithIndex:(CGFloat)index];
        NSError *error;
        CGImageRef cgImg = [weakSelf.generator copyCGImageAtTime:time actualTime:NULL error:&error];
        if (!error && cgImg) {
            UIImage *image = [UIImage imageWithCGImage:cgImg];
            [weakSelf displayImage:image item:item];
        }else {
            CMTime tempTime = [weakSelf getTimeWithIndex:item - 0.5];
            error = nil;
            cgImg = [weakSelf.generator copyCGImageAtTime:tempTime actualTime:NULL error:&error];
            if (!error && cgImg) {
                UIImage *image = [UIImage imageWithCGImage:cgImg];
                [weakSelf displayImage:image item:item];
            }
        }
        CGImageRelease(cgImg);
    }];
    return operation;
}

- (void)displayImage:(UIImage *)image item:(NSInteger)item {
    dispatch_async(dispatch_get_main_queue(), ^{
        LQPhotoKitVideoEditCollectionViewCell *tempCell = (LQPhotoKitVideoEditCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        if (tempCell) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.1f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            tempCell.image = image;
            [tempCell.layer addAnimation:transition forKey:nil];
        }
    });
}

#pragma mark - setupUI

- (void)setupUI {
    self.collectionView.frame = CGRectMake(0, 0, self.lq_width, lq_imageHeight);
    [self addSubview:self.collectionView];
    
    self.label.frame = CGRectMake(0, self.collectionView.lq_bottom+15, self.lq_width, 20);
    [self addSubview:self.label];
    
    
    [self addSubview:self.moveLine];
    
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout   = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing            = 0;
        layout.minimumInteritemSpacing       = 0;
        layout.scrollDirection               = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset                  = UIEdgeInsetsMake(0, lq_dragImageViewWidth+lq_borderOffset, 0, lq_dragImageViewWidth+lq_borderOffset);
        _collectionView                      = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled        = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.backgroundColor      =  [UIColor blackColor];
        _collectionView.delegate             = self;
        _collectionView.dataSource           = self;
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:LQPhotoKitVideoEditCollectionViewCell.class forCellWithReuseIdentifier:@"LQPhotoKitVideoEditCollectionViewCell"];
    }
    return _collectionView;
}

- (LQPhotoKitVideoDragView *)dragView {
    if (!_dragView) {
        _dragView = [[LQPhotoKitVideoDragView alloc] initWithFrame:CGRectMake(0, 0, self.lq_width, lq_imageHeight)];
        _dragView.delegate = self;
        [self addSubview:_dragView];
    }
    return _dragView;
}

- (UILabel *)label {
    if (!_label) {
        _label               = [[UILabel alloc] init];
        _label.text          = @"拖动或调节选择框选择合适的片段";
        _label.font          = [UIFont systemFontOfSize:15];
        _label.textColor     = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        
    }
    
    return _label;
}

- (UIView *)moveLine {
    if (!_moveLine) {
        _moveLine                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.5,lq_imageHeight)];
        _moveLine.backgroundColor     = [UIColor whiteColor];
        _moveLine.layer.shadowColor   = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        _moveLine.layer.shadowOpacity = 0.5f;
        _moveLine.hidden              = YES;
    }
    return _moveLine;
}

- (AVAssetImageGenerator *)generator {
    if (!_generator) {
        _generator                                = [[AVAssetImageGenerator alloc] initWithAsset:self.model.photoKitVideoEditView_avAsset];
        _generator.maximumSize                    = CGSizeMake(lq_imageWidth+20,lq_imageHeight);
        _generator.appliesPreferredTrackTransform = YES;
        _generator.requestedTimeToleranceBefore   = kCMTimeZero;
        _generator.requestedTimeToleranceAfter    = kCMTimeZero;
        _generator.apertureMode                   = AVAssetImageGeneratorApertureModeProductionAperture;
    }
    return _generator;
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;
    }
    return _operationQueue;
}

- (NSMutableDictionary *)operationDict {
    if (!_operationDict) {
        _operationDict = [NSMutableDictionary dictionary];
    }
    return _operationDict;
}


@end
