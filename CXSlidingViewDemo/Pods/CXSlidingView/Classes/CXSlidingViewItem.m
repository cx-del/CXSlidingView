//
//  CXSlidingViewItem.m
//  Sliding
//
//  Created by DCX on 16/5/13.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "CXSlidingViewItem.h"

#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface CXSlidingViewItem ()

@property (nonatomic,assign) CGRect currentFrame;

@property (nonatomic,strong) UIPanGestureRecognizer * panGestureRecognizer;

@property (nonatomic,assign,readwrite) CXSlidingMoveType moveType;

@property (nonatomic,assign) BOOL notLayout;

@property (nonatomic,strong) CADisplayLink * displayLink;

@end

@implementation CXSlidingViewItem

#pragma mark - init

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.identifier = identifier;
        [self stupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentFrame = self.frame;
        [self stupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!_currentFrame.size.height) {
        _currentFrame = frame;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self stupView];
    }
    return self;
}
- (void)stupView {
    
    self.backgroundColor = [UIColor whiteColor];
    _initialOffSet = 0;
    self.criticalValue = self.frame.size.width/2;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    [self addGestureRecognizer:_panGestureRecognizer];
}

- (CGFloat )criticalValue {
    if (_criticalValue == 0) {
        _criticalValue = self.frame.size.width/2;
    }
    return _criticalValue;
}

- (void)addPanGestureRecognizer {
    _notLayout = YES;
    [_panGestureRecognizer addTarget:self action:@selector(handlePan:)];
}

#pragma mark - setter

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    
    if (_notLayout) {
        _notLayout = NO;
        return;
    }
    if (_initialOffSet == _offset) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1 + 2 * (_offset/1000), 1+ 2 *(_offset/1000));
            self.transform = CGAffineTransformTranslate(self.transform , 0 , 0-80*(_offset/100));
        } completion:nil];
    }else {
        self.transform = CGAffineTransformMakeScale(1 + 2 * (_offset/1000), 1+ 2 *(_offset/1000));
        self.transform = CGAffineTransformTranslate(self.transform , 0 , -80*(_offset/100));
    }
}

- (void)setInitialOffSet:(CGFloat)initialOffSet {
    _initialOffSet = initialOffSet;
    self.transform = CGAffineTransformMakeScale(1 + 2 * (initialOffSet/1000), 1+ 2 *(initialOffSet/1000));
    self.transform = CGAffineTransformTranslate(self.transform , 0 , -80*(initialOffSet/100));
    _notLayout = YES;
    self.offset = initialOffSet;
}

#pragma mark - event
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.superview];
        sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
        [sender setTranslation:CGPointZero inView:self];
        if ([self.delegate respondsToSelector:@selector(slidingViewItem:slidingValue:)]) {
            [self.delegate slidingViewItem:self slidingValue:[self getSlidingValue:self.frame]];
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        BOOL isComeBack = [self VerifyTheLocation];
        if (isComeBack) {
            _notLayout = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = _currentFrame;
                _offset = _initialOffSet;
                if ([self.delegate respondsToSelector:@selector(slidingViewItem:slidingValue:)]) {
                    [self.delegate slidingViewItem:self slidingValue:[self getSlidingValue:self.frame]];
                }
            } completion:nil];
        }else {
            [self removeViewWith:_moveType];
        }
    }
}


- (void)removeViewWith:(CXSlidingMoveType)type {
    _moveType = type;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(checkFrame)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    CGRect frame = self.frame;
    frame.origin.x = KScreenWidth;
    if (type == MoveToLift) {
        frame.origin.x = -1*KScreenWidth;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [_displayLink invalidate];
            _displayLink = nil;
            [_panGestureRecognizer removeTarget:self action:@selector(handlePan:)];
            if ([self.delegate respondsToSelector:@selector(removedFromSuperview:)]) {
                [self.delegate removedFromSuperview:self];
            }
            self.delegate = nil;
        }
    }];
}

- (void)checkFrame {
    CALayer * layer = self.layer.presentationLayer;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidingViewItem:slidingValue:)]) {
        [self.delegate slidingViewItem:self slidingValue:[self getSlidingValue:layer.frame]];
    }
}

#pragma mark - handle
/** 小于临界值 return YES */
- (BOOL)VerifyTheLocation {
    
    CGFloat currentCenterX = CGRectGetMidX(_currentFrame);
    CGFloat newCenterX = CGRectGetMidX(self.frame);
    CGFloat changedCenterX = fabs(currentCenterX - newCenterX);
    
    CGFloat currentCenterY = CGRectGetMidY(_currentFrame);
    CGFloat newCenterY = CGRectGetMidY(self.frame);
    CGFloat changedCenterY = fabs(currentCenterY - newCenterY);
    
    if (changedCenterX > _criticalValue || changedCenterY > _criticalValue) {
        if (currentCenterX - newCenterX > 0) {
            _moveType = MoveToLift;
        }else {
            _moveType = MoveToRight;
        }
        return NO;
    }
    return YES;
}
/** 获取 当前偏移量 */
- (CGFloat )getSlidingValue:(CGRect)frame {
    
    CGFloat currentCenterX = CGRectGetMidX(_currentFrame);
    CGFloat newCenterX = CGRectGetMidX(frame);
    CGFloat changedCenterX = fabs(currentCenterX - newCenterX);
    
    CGFloat currentCenterY = CGRectGetMidY(_currentFrame);
    CGFloat newCenterY = CGRectGetMidY(frame);
    CGFloat changedCenterY = fabs(currentCenterY - newCenterY);
    
    CGFloat value = changedCenterX > changedCenterY ? changedCenterX : changedCenterY;
    value = value >= _criticalValue ? _criticalValue : value;
    
    return value;
}

- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
    self.delegate = nil;
}

@end
