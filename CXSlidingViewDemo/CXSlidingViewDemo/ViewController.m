//
//  ViewController.m
//  CXSlidingViewDemo
//
//  Created by DCX on 16/6/22.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "ViewController.h"
#import "TYJSON.h"
#import "CXTestItem.h"
#import "CXSlidingView.h"
#import "UIImageView+WebCache.h"
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<CXSlidingViewDelegate,CXSlidingViewDatasouce>

@property (nonatomic,strong) NSArray * imagesArray;

@property (nonatomic,strong)  CXSlidingView * slidingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.slidingView];
    
    [self.slidingView reloadSlidingView];
    
    [self addButton];
}

#pragma mark - buttonClick

- (void)lift_buttonClick:(id)sender {
    [_slidingView removeTopViewWithType:MoveToLift];
}
- (void)right_buttonClick:(id)sender {
    [_slidingView removeTopViewWithType:MoveToRight];
}

#pragma mark - CXSlidingViewDatasouce

- (NSInteger)numberOfItemInSlidingView:(CXSlidingView *)slidingView {
    return self.imagesArray.count;
}

- (CXSlidingViewItem *)slidingView:(CXSlidingView *)slidingView itemWithNumber:(NSInteger )index {
    static NSString * itemID = @"itemID";
    CXTestItem * item = (CXTestItem *)[slidingView dequeueReusableItemWithIdentifier:itemID];
    if (!item) {
        item = [[CXTestItem alloc] initWithIdentifier:itemID];
        
        // 加边界
        item.layer.cornerRadius = 5;
        item.layer.borderWidth = 1;
        item.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL * imageUrl = [NSURL URLWithString:self.imagesArray[index]];
    [item.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    return item;
}

#pragma mark - CXSlidingViewDelegate
- (UIEdgeInsets )slidingView:(CXSlidingView *)slidingView edgeForItemAtIndex:(NSInteger )index {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (void)topViewRemovedFromSupperView:(CXSlidingView *)slidingView slidingViewItem:(CXSlidingViewItem *)item {
    NSString * moveType = item.moveType==MoveToLift?@"左":@"右";
    NSLog(@"  \n    当前移除的是第%ld个  \n   移除时的方向 :%@ \n*********************",item.index,moveType);
}


- (BOOL)lastSlidingViewCanMove {
    return YES;
}

//- (BOOL)cycleWithSlidingView:(CXSlidingView *)slidingView {
//    return YES;
//}

#pragma mark - init view

- (NSArray *)imagesArray {
    if (!_imagesArray) {
        NSString * imagesFile = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"json"];
        NSArray * array = [NSData dataWithContentsOfFile:imagesFile].JSONObject;
        _imagesArray = array;
    }
    return _imagesArray;
}

- (CXSlidingView *)slidingView {
    if (!_slidingView) {
        _slidingView = [[CXSlidingView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, KScreenHeight - 100 - 30)];
        _slidingView.datasouce = self;
        _slidingView.delegate = self;
    }
    return _slidingView;
}

- (void)addButton {
    
    UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [left_button addTarget:self action:@selector(lift_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [left_button setTitle:@"左滑" forState:UIControlStateNormal];
    left_button.frame = CGRectMake(20, KScreenHeight - 80, 60, 60);
    left_button.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:left_button];
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_button addTarget:self action:@selector(right_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setTitle:@"右滑" forState:UIControlStateNormal];
    right_button.frame = CGRectMake(KScreenWidth - 80, KScreenHeight - 80, 60, 60);
    right_button.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:right_button];
    
}


@end
