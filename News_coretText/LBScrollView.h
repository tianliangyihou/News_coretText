//
//  LBScrollView.h
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBAnalysis.h"
#import "LBLabel.h"
@interface LBScrollView : UIScrollView
@property (nonatomic , weak)LBLabel *label;

- (void)buildFramesWithAttributeString:(NSAttributedString *)attr andModels:(NSArray <LBModel *>*)models;
- (void)resetScrollView;
@end
