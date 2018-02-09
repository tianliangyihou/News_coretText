//
//  ViewController.m
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "ViewController.h"
#import "LBScrollView.h"
#import "LBAnalysis.h"
@interface ViewController ()

@property (nonatomic , strong)LBAnalysis *ay;
@property (nonatomic , weak)UIScrollView *sc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CoreText";
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    LBScrollView *sc = [[LBScrollView alloc]initWithFrame:CGRectMake(0, 64, screenBounds.size.width, screenBounds.size.height - 64)];
    [self.view addSubview:sc];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"lb.txt" ofType:nil];
    NSString *resource = [[NSString alloc]initWithContentsOfFile:path encoding:4 error:nil];
    LBAnalysis *ay = [[LBAnalysis alloc]init];
    ay.text = resource;
    _ay = ay;
    [ay setAdjustFontBlock:^(LBAnalysis *analysis, NSMutableAttributedString *muAttributeStr, NSMutableArray<LBModel *> *models) {
        [sc resetScrollView];
        [sc buildFramesWithAttributeString:muAttributeStr andModels:models];
    }];
    [sc buildFramesWithAttributeString:ay.muAttributeStr andModels:ay.models];
    sc.tag = 0;
    _sc = sc;
}


- (IBAction)btnClick:(UIBarButtonItem *)sender {
    _sc.tag = _sc.tag == 0? 1 : 0;
    UIColor *color = [UIColor colorWithRed:0.6 green:0.81 blue:0.86 alpha:1.0];
    if (_sc.tag == 0) {
        color = [UIColor whiteColor];
    }
    for (UIView *view in _sc.subviews) {
        if ([view isKindOfClass:[LBLabel class]]) {
            view.backgroundColor = color;
        }
    }
}

@end
