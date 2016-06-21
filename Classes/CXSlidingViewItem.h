//
//  CXSlidingViewItem.h
//  Sliding
//
//  Created by DCX on 16/5/13.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CXSlidingMoveType) {
    MoveToLift = 0,
    MoveToRight
};

@class CXSlidingViewItem;
@protocol CXSlidingViewItemDelegate <NSObject>


- (void)slidingViewItem:(CXSlidingViewItem *)item slidingValue:(CGFloat )value;

/** 已经从父试图中移除 */
- (void)removedFromSuperview:(CXSlidingViewItem *)item;

@end

@interface CXSlidingViewItem : UIView

@property (nonatomic,weak) id<CXSlidingViewItemDelegate> delegate;
/** 滑动后处理方式依赖的阀值 默认为宽的一半 */
@property (nonatomic,assign) CGFloat criticalValue;
/** 偏移量 -100 ～ 0 之间 默认不偏移 越靠近负值 越向下方偏移，并缩小*/
@property (nonatomic,assign) CGFloat offset;
/** 初始值偏移量 默认： 0 */
@property (nonatomic,assign) CGFloat initialOffSet;

@property (nonatomic,assign,readonly) CXSlidingMoveType moveType;

@property (nonatomic,strong) NSString * identifier;

@property (nonatomic,assign) NSInteger index;

- (instancetype)initWithIdentifier:(NSString *)identifier;

/** 根据方向移出屏幕 并删除 */
- (void)removeViewWith:(CXSlidingMoveType)type;
/** 启用手势 */
- (void)addPanGestureRecognizer;

@end
