//
//  LBAnalysis.h
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBDrawModel :NSObject
@property (nonatomic , assign)CGRect rect;
@property (nonatomic , copy)NSString *name;
@property (nonatomic , strong)UIView *view;

@end

@interface LBModel :NSObject
@property (nonatomic , assign)CGFloat width;
@property (nonatomic , assign)CGFloat ascent;
@property (nonatomic , assign)CGFloat descent;
@property (nonatomic , assign)CGFloat location;
@property (nonatomic , assign)CGFloat height;

@property (nonatomic , copy)NSString *name;
@property (nonatomic , strong)UIView *view;
@property (nonatomic , copy)NSString *urlString;


@end

@interface LBAnalysis : NSObject
@property (nonatomic , copy)NSString *text;
@property (nonatomic , strong,readonly)NSMutableAttributedString *muAttributeStr;
@property (nonatomic , strong)NSMutableArray <LBModel *>*models;
@property (nonatomic , copy) void(^adjustFontBlock)(LBAnalysis *analysis,NSMutableAttributedString *muAttributeStr,NSMutableArray <LBModel *>*models);

- (void)adjustFontToLargeSize;
- (void)adjustFontToMiddleSize;
- (void)adjustFontToSmallSize;

@end
