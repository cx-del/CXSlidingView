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

@optional

- (BOOL)lastSlidingViewCanMove; /** default is NO */

- (BOOL)cycleWithSlidingView:(CXSlidingView *)slidingView; /** default is NO 不循环 */

- (UIEdgeInsets )slidingView:(CXSlidingView *)slidingView edgeForItemAtIndex:(NSInteger )index;

- (void)topViewRemovedFromSupperView:(CXSlidingView *)slidingView slidingViewItem:(CXSlidingViewItem *)item;/** 最上层view已经移除完成 */

@end

@protocol CXSlidingViewDatasouce <NSObject>

@required

- (NSInteger)numberOfItemInSlidingView:(CXSlidingView *)slidingView;

- (CXSlidingViewItem *)slidingView:(CXSlidingView *)slidingView itemWithNumber:(NSInteger )index;

@end


@interface CXSlidingView : UIView

@property (nonatomic,weak) id<CXSlidingViewDatasouce> datasouce;

@property (nonatomic,weak) id<CXSlidingViewDelegate> delegate;

/** 是否可以删除最上层的view */
@property (nonatomic,assign,readonly) BOOL canRemoveTopView;

/** 滑动后处理方式依赖的阀值 默认为Item的宽的一半 */
@property (nonatomic,assign) CGFloat criticalValue;


- (CXSlidingViewItem *)dequeueReusableItemWithIdentifier:(NSString *)identifier;

- (void)reloadSlidingView;

- (void)removeTopViewWithType:(CXSlidingMoveType )type;

@end
