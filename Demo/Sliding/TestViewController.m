//
//  TestViewController.m
//  Sliding
//
//  Created by DCX on 16/6/6.
//  Copyright © 2016年 戴晨惜. All rights reserved.
//

#import "TestViewController.h"
#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height
@interface TestViewController ()<CXSlidingViewDelegate,CXSlidingViewDatasouce>
{
}
@property (nonatomic,strong)  CXSlidingView * slidingView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view addSubview:self.slidingView];
    
    [self.slidingView reloadSlidingView];
    
}

- (CXSlidingView *)slidingView {
    if (!_slidingView) {
        _slidingView = [[CXSlidingView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, 500)];
        _slidingView.datasouce = self;
        _slidingView.delegate = self;
        _slidingView.backgroundColor = [UIColor redColor];
    }
    return _slidingView;
}


- (IBAction)lift_buttonClick:(id)sender {
    [_slidingView removeTopViewWithType:MoveToLift];
}
- (IBAction)right_buttonClick:(id)sender {
    //    [_viewArray.lastObject removeViewWith:MoveToRight];
}

- (NSInteger)numberOfItemInSlidingView:(CXSlidingView *)slidingView {
    return 45;
}

- (CXSlidingViewItem *)slidingView:(CXSlidingView *)slidingView itemWithNumber:(NSInteger )index {
    static NSString * itemID = @"itemID";
    CXSlidingViewItem * item = [slidingView dequeueReusableItemWithIdentifier:itemID];
    if (!item) {
        item = [[CXSlidingViewItem alloc] initWithIdentifier:itemID];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 80, 50)];
        label.font = [UIFont systemFontOfSize:50];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100;
        [item addSubview:label];
    }
    item.backgroundColor = [self randomColor];
    UILabel * label = [item viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%ld",index+1];
    return item;
}

- (UIEdgeInsets )slidingView:(CXSlidingView *)slidingView edgeForItemAtIndex:(NSInteger )index {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (void)topViewRemovedFromSupperView:(CXSlidingView *)slidingView slidingViewItem:(CXSlidingViewItem *)item {
    NSLog(@" -%ld  方向 is %ld",item.index,item.moveType);
}/** 最上层view已经移除完成 */


- (BOOL)lastSlidingViewCanMove {
    return YES;
}

//- (BOOL)cycleWithSlidingView:(CXSlidingView *)slidingView {
//    return YES;
//}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
