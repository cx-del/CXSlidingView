//
//  CXSlidingView.m
//  Sliding
//
//  Created by DCX on 16/5/17.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "CXSlidingView.h"

@interface CXSlidingView ()<CXSlidingViewItemDelegate>

@property (nonatomic,strong) NSMutableDictionary * itemDict;

@property (nonatomic,assign) NSInteger numberOfItem;

@property (nonatomic,strong) NSMutableArray <CXSlidingViewItem *>* viewArray;

@property (nonatomic,assign,readwrite) BOOL canRemoveTopView;

@end

@implementation CXSlidingView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _canRemoveTopView = YES;
}

- (void)reloadSlidingView {
    
    NSInteger number = self.numberOfItem > 3 ? 3 : self.numberOfItem;
    
    for (NSInteger i = number ; i >= 0; i --) {
        
        CXSlidingViewItem * item = [self getSlidingViewWithIndex:i];
        
        UIEdgeInsets edge = [self getSlidingViewEdgeWithIndex:i];
        
        item.frame = CGRectMake(edge.left, edge.top, CGRectGetWidth(self.frame) - edge.left - edge.right, CGRectGetHeight(self.frame) - edge.top - edge.bottom);
        item.index = i;
        item.initialOffSet = i * -50;
        
        [self addSubview:item];
        if (self.viewArray.count>=1) {
            [_viewArray insertObject:item atIndex:0];
        }else {
            [_viewArray addObject:item];
        }
    }
    self.viewArray.firstObject.delegate = self;
    [self.viewArray.firstObject addPanGestureRecognizer];
}

- (void)removeTopViewWithType:(CXSlidingMoveType )type {
    if (_canRemoveTopView) {
        _canRemoveTopView = NO;
        [self.viewArray.firstObject removeViewWith:type];
    }
}

#pragma mark - CXBaseSlidingViewDelegate

- (void)slidingViewItem:(CXSlidingViewItem *)item slidingValue:(CGFloat )value {
    if (item == _viewArray.firstObject) {
        CGFloat offset = 100 * - (value/item.criticalValue);
        for (NSInteger i = _viewArray.count - 1 ; i >= 1; i --) {
            CXSlidingViewItem * view = _viewArray[i];
            CGFloat tempOffSet = view.initialOffSet;
            tempOffSet = tempOffSet - offset/2;
            view.offset = tempOffSet;
        }
    }
}

/** 已经从父试图中移除 */
- (void)removedFromSuperview:(CXSlidingViewItem *)item {
    
    CXSlidingViewItem * slidingView = item;
    slidingView.offset = 0;
    slidingView.initialOffSet = 0;
    [self.itemDict setObject:slidingView forKey:slidingView.identifier];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewRemovedFromSupperView:slidingViewItem:)]) {
        [self.delegate topViewRemovedFromSupperView:self slidingViewItem:slidingView];
    }
    [self updateViewArray];
    
    if (self.viewArray.count > 1) {
        _canRemoveTopView = YES;
    }else {
        BOOL canMove = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(lastSlidingViewCanMove)]) {
            canMove = [self.delegate lastSlidingViewCanMove];
        }
        _canRemoveTopView = canMove;
    }
}

- (void)insertSlidingViewAtFirst {
    
    BOOL cycle = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleWithSlidingView:)]) {
        cycle = [self.delegate cycleWithSlidingView:self];
    }
    
    NSInteger index = 0;
    
    if (cycle) {
        index =  _viewArray.lastObject.index + 1 > self.numberOfItem ? 0 : _viewArray.lastObject.index + 1;
    }else {
        if (_viewArray.count == 0 || _viewArray.lastObject.index + 1 >= self.numberOfItem) {
            return;
        }else {
            index = _viewArray.lastObject.index + 1;
        }
    }
    
    CXSlidingViewItem * item = [self.datasouce slidingView:self itemWithNumber:index];
    item.index = index;
    UIEdgeInsets edge = [self getSlidingViewEdgeWithIndex:index];
    
    item.frame = CGRectMake(edge.left, edge.top, CGRectGetWidth(self.frame) - edge.left - edge.right, CGRectGetHeight(self.frame) - edge.top - edge.bottom);
    item.initialOffSet = _viewArray.lastObject.initialOffSet - 50;
    
    [self insertSubview:item belowSubview:_viewArray.lastObject];
    [_viewArray addObject:item];
}

- (void)updateViewArray {
    
    [_viewArray removeObject:_viewArray.firstObject];
    [self insertSlidingViewAtFirst];
    
    for (CXSlidingViewItem * item in _viewArray) {
        item.initialOffSet +=50;
    }
    
    BOOL canMove = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(lastSlidingViewCanMove)]) {
        canMove = [self.delegate lastSlidingViewCanMove];
    }
    
    if (_viewArray.count > 1) {
        _viewArray.firstObject.delegate = self;
        [_viewArray.firstObject addPanGestureRecognizer];
    }else {
        if (canMove) {
            _viewArray.firstObject.delegate = self;
            [_viewArray.firstObject addPanGestureRecognizer];
        }
    }
    
}

#pragma mark - getter

- (NSMutableDictionary *)itemDict {
    if (!_itemDict) {
        _itemDict = [NSMutableDictionary dictionary];
    }
    return _itemDict;
}

- (NSInteger )numberOfItem {
    if (!_numberOfItem) {
        if (self.datasouce && [self.datasouce respondsToSelector:@selector(numberOfItemInSlidingView:)]) {
            _numberOfItem = [self.datasouce numberOfItemInSlidingView:self];
        }else {
            NSAssert(YES, @"numberOfItemInSlidingView: 没有实现");
        }
    }
    return _numberOfItem;
}

- (NSMutableArray <CXSlidingViewItem *>*)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

- (CXSlidingViewItem *)getSlidingViewWithIndex:(NSInteger )index {
    CXSlidingViewItem * slidingView;
    if (self.datasouce && [self.datasouce respondsToSelector:@selector(slidingView:itemWithNumber:)]) {
        slidingView = [self.datasouce slidingView:self itemWithNumber:index];
    }else {
        NSAssert(YES, @"SlidingView:itemWithNumber: 没有实现");
        return nil;
    }
    return slidingView;
}

- (UIEdgeInsets )getSlidingViewEdgeWithIndex:(NSInteger )index {
    UIEdgeInsets edge = UIEdgeInsetsZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidingView:edgeForItemAtIndex:)]) {
        edge = [self.delegate slidingView:self edgeForItemAtIndex:index];
    } else {
        NSAssert(YES, @"slidingView:edgeForItemAtIndex: 没有实现");
        return edge;
    }
    return edge;
}

- (CXSlidingViewItem *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    CXSlidingViewItem * sidingView = [self.itemDict objectForKey:identifier];
    return sidingView;
}


@end
