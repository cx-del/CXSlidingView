//
//  CXSlidingView.h
//  Sliding
//
//  Created by DCX on 16/5/17.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXSlidingViewItem.h"

@class CXSlidingView;

@protocol CXSlidingViewDelegate <NSObject>

@required

/**
 *  标示 item 到其父视图边界的距离
 *
 *  @return UIEdgeInsets 对象
 */
- (UIEdgeInsets )slidingView:(CXSlidingView *)slidingView edgeForItemAtIndex:(NSInteger )index;

@optional

/**
 *  最后一张图是否可以滑动
 *
 *  @return bool 标示是否 ，default is NO
 */
- (BOOL)lastSlidingViewCanMove;

/**
 *  是否开启循环
 *
 *  @return bool 标示循环开启 ， default is NO 不循环
 */
- (BOOL)cycleWithSlidingView:(CXSlidingView *)slidingView;

/**
 *  item 移除完成的回调
 *
 *  @param item   当前移除的item
 */
- (void)topViewRemovedFromSupperView:(CXSlidingView *)slidingView slidingViewItem:(CXSlidingViewItem *)item;

@end

@protocol CXSlidingViewDatasouce <NSObject>

@required

/**
 *  item 的数目
 */
- (NSInteger)numberOfItemInSlidingView:(CXSlidingView *)slidingView;

/**
 *  需要一个 item 的对象
 *
 */
- (__kindof CXSlidingViewItem *)slidingView:(CXSlidingView *)slidingView itemWithNumber:(NSInteger )index;

@end


@interface CXSlidingView : UIView

@property (nonatomic,weak) id<CXSlidingViewDatasouce> datasouce;

@property (nonatomic,weak) id<CXSlidingViewDelegate> delegate;

/** 是否可以删除最上层的view */
@property (nonatomic,assign,readonly) BOOL canRemoveTopView;

/** 滑动后处理方式依赖的阀值 默认为Item的宽的一半 */
@property (nonatomic,assign) CGFloat criticalValue;

/**
 *  根据 identifier 去重用池中找 item
 *
 *  @return 对应的 item
 */
- (__kindof CXSlidingViewItem *)dequeueReusableItemWithIdentifier:(NSString *)identifier;

/**
 *  刷新视图
 */
- (void)reloadSlidingView;

/**
 *  根据传入方向 移除最上层的视图
 *
 *  @param type CXSlidingMoveType 类型的枚举值
 */
- (void)removeTopViewWithType:(CXSlidingMoveType )type;

@end
