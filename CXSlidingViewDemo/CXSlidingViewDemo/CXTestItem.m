//
//  CXTestItem.m
//  CXSlidingViewDemo
//
//  Created by DCX on 16/6/22.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "CXTestItem.h"

@implementation CXTestItem


- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.imageView.frame = self.bounds;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
