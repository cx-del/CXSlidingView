//
//  ViewController.m
//  Sliding
//
//  Created by DCX on 16/5/13.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "ViewController.h"
#import "CXBaseSlidingView.h"
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<CXSlidingViewDelegate>

@property (nonatomic,strong) NSMutableArray <CXBaseSlidingView *>* viewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addSlidingView];
    
    
    
    
//    UITableView
    
}

- (void)slidingView:(CXBaseSlidingView *)slidingView slidingValue:(CGFloat )value {
    
    if (slidingView == _viewArray.lastObject) {
        CGFloat offset = 100 * - (value/slidingView.criticalValue);
        for (NSInteger i = _viewArray.count - 1 ; i >= 0; i --) {
            CXBaseSlidingView * view = _viewArray[i];
            CGFloat tempOffSet = view.initialOffSet;
            tempOffSet = tempOffSet - offset/2;
            view.offset = tempOffSet;
        }
    }
}
- (IBAction)lift_buttonClick:(id)sender {
    [_viewArray.lastObject removeViewWith:MoveToLift];
}
- (IBAction)right_buttonClick:(id)sender {
//    [_viewArray.lastObject removeViewWith:MoveToRight];
    [self insertSlidingViewAtFirst];

}

/** 已经从父试图中移除 */
- (void)removedFromSuperview:(CXBaseSlidingView *)slidingView {
    if (slidingView.moveType == MoveToLift) {
        NSLog(@" - 喜欢 －");
    }else {
        NSLog(@" - 不喜欢 －");
    }
    [self updateViewArray];
}

- (void)insertSlidingViewAtFirst {
    CXBaseSlidingView * view = [[CXBaseSlidingView alloc] initWithFrame:CGRectMake(20, 50, KScreenWidth - 40, 400)];//_viewArray.lastObject;
    view.tag = _viewArray.lastObject.tag;
    view.backgroundColor = _viewArray.lastObject.backgroundColor;
    view.initialOffSet = _viewArray.firstObject.initialOffSet - 50;
    [self.view insertSubview:view belowSubview:_viewArray.firstObject];
    [_viewArray insertObject:view atIndex:0];
}

- (void)updateViewArray {

    [self insertSlidingViewAtFirst];
    
    [_viewArray removeLastObject];

    for (NSInteger i = _viewArray.count - 1; i >=0; i --) {
        CXBaseSlidingView * slidingView = _viewArray[i];
        slidingView.initialOffSet += 50;
        if (_viewArray.count - i > 5) {
            slidingView.alpha = 0;
        }else {
            slidingView.alpha = 1;
        }
    }
    if (_viewArray.count > 1) {
        _viewArray.lastObject.delegate = self;
        [_viewArray.lastObject addPanGestureRecognizer];
    }
}

- (void)addSlidingView {
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, KScreenWidth, 1.)];
    lab.backgroundColor = [UIColor blueColor];
    [self.view addSubview:lab];
    
    _viewArray = [NSMutableArray array];
    for (NSInteger i = 5; i >= 0; i --) {
        CXBaseSlidingView * view = [[CXBaseSlidingView alloc] initWithFrame:CGRectMake(20, 50, KScreenWidth - 40, 400)];
        view.initialOffSet = i * -50;
        UILabel * label = [[UILabel alloc]initWithFrame:view.bounds];
        label.font = [UIFont systemFontOfSize:50];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld",(long)i];
        [view addSubview:label];
        view.tag = 100 + i;
        view.backgroundColor = [self randomColor];
        
        if (i > 5) {
            view.alpha = 0;
        }else {
            view.alpha = 1;
        }
        
        [self.view addSubview:view];
        [_viewArray addObject:view];
    }
    
    _viewArray.lastObject.delegate = self;
    [_viewArray.lastObject addPanGestureRecognizer];

}


- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
