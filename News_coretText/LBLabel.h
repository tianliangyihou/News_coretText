//
//  LBLabel.h
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "LBAnalysis.h"

@interface LBLabel : UIView
@property (nonatomic , strong)NSMutableArray <LBDrawModel *> *drawModes;
@property (nonatomic , assign)CTFrameRef ctFrame;
@property (nonatomic , assign)CGFloat contentHeight;

- (instancetype)initWithctFrame:(CTFrameRef)frame  contentHeight:(CGFloat)contentHeight;
@end
