//
//  LBLabel.m
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "LBLabel.h"

@implementation LBLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.drawModes = [[NSMutableArray alloc]init];
    }
    return self;
}

- (instancetype)initWithctFrame:(CTFrameRef)frame contentHeight:(CGFloat)contentHeight
{
    LBLabel *label = [[LBLabel alloc]init];
    label.ctFrame = frame;
    label.contentHeight = contentHeight;
    return label;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0,rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(self.ctFrame, context);
    
    for (LBDrawModel *model in self.drawModes) {
        CGAffineTransform transform =  CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.contentHeight), 1.f, -1.f);
        rect = CGRectApplyAffineTransform(model.rect, transform);
        model.view.frame = rect;
        if ([model.view isKindOfClass:[UIButton class]]) model.view.backgroundColor = self.backgroundColor;
        [self addSubview:model.view];
    }
}
@end
