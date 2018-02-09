//
//  LBScrollView.m
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "LBScrollView.h"
#import <CoreText/CoreText.h>

@interface LBScrollView()
@property (nonatomic , assign)int index;

@end

@implementation LBScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if ([UIDevice currentDevice].systemVersion.floatValue >11.0) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _index = 0;
      }
    return self;
}

- (void)buildFramesWithAttributeString:(NSAttributedString *)attr  andModels:(NSArray<LBModel *> *)models{

    // 正文
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attr length]);
    CGSize constraints = CGSizeMake(screenBounds.size.width, MAXFLOAT);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attr);
   
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, rangeToSize, NULL, constraints, NULL);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, suggestedSize.height));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    LBLabel *textlabel = [[LBLabel alloc]initWithctFrame:frame contentHeight:suggestedSize.height];
    textlabel.backgroundColor = self.backgroundColor;
    [self attachViewWithFrame:frame models:models label:textlabel];
    textlabel.frame = CGRectMake(0, 0, screenBounds.size.width, suggestedSize.height);
    [self addSubview:textlabel];
    self.contentSize = CGSizeMake(screenBounds.size.width,suggestedSize.height + screenBounds.size.width);
    CFRelease(frameSetter);
    CFRelease(path);

    // 结尾
    {
        NSString *endText = @"总有一天你将破蛹而出，成长得比人们期待的还要美丽。但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力。但这，也是生命的一部分。做好现在你能做的，然后，一切都会好的。我们都将孤独地长大,不要害怕";
        NSAttributedString *endAttributeStr = [[NSAttributedString alloc]initWithString:endText attributes:@{
                                                                                                             NSFontAttributeName :[UIFont systemFontOfSize:14]
                                                                                                             }];
        CTFramesetterRef endframeSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)endAttributeStr);
        UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,screenBounds.size.width,screenBounds.size.width) cornerRadius:screenBounds.size.width/2.0];
        [bPath addArcWithCenter:CGPointMake(screenBounds.size.width /2.0, screenBounds.size.width /2.0) radius:screenBounds.size.width /2.0 - 35 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        CGMutablePathRef endPath = CGPathCreateMutableCopy(bPath.CGPath);
        CTFrameRef endFrame = CTFramesetterCreateFrame(endframeSetter, CFRangeMake(0, 0), endPath, NULL);
        LBLabel *endLabel = [[LBLabel alloc]initWithctFrame:endFrame contentHeight:screenBounds.size.width];
        endLabel.backgroundColor = self.backgroundColor;
        UIImageView *catImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cat.jpg"]];
        catImageView.frame = CGRectMake(0, 0,(screenBounds.size.width /2.0 - 35) * 2, (screenBounds.size.width /2.0 - 35) * 2);
        catImageView.center = CGPointMake(screenBounds.size.width /2.0, screenBounds.size.width /2.0);
        catImageView.layer.cornerRadius = (screenBounds.size.width /2.0 - 35);
        catImageView.clipsToBounds = YES;
        [endLabel addSubview:catImageView];
        endLabel.frame = CGRectMake(0, suggestedSize.height, screenBounds.size.width, screenBounds.size.width);
        [self addSubview:endLabel];
        CFRelease(endframeSetter);
        CFRelease(endPath);
    }

}


- (void)attachViewWithFrame:(CTFrameRef)frame models:(NSArray<LBModel *> *)models label:(LBLabel *)label {
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        LBModel *model = nil;
        if (models.count >_index) {
            model = models[_index];
            if (model.location < 0) {
                continue;
            }
        }
        if (!model) continue;
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CGPoint origin = lineOrigins[i];
        for (int i = 0; i < CFArrayGetCount(runs); i++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            CFRange range = CTRunGetStringRange(run);
            if (range.location + range.length <= model.location || range.location > model.location) {
                continue;
            }
            CGFloat ascent,descent;
            CGFloat width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0),&ascent , &descent, NULL);
            CGFloat offsetX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            CGRect viewBounds = CGRectMake(origin.x + offsetX, origin.y - descent, width, ascent + descent);
            LBDrawModel *drawModel = [[LBDrawModel alloc]init];
            drawModel.rect = viewBounds;
            drawModel.name = model.name;
            drawModel.view= model.view;
            [label.drawModes addObject:drawModel];
            self.index += 1;
            if (self.index < models.count) {
                model = models[_index];
            }
        }
        
    }
}

- (void)resetScrollView {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LBLabel class]]) {
            [view removeFromSuperview];
        }
    }
    self.index = 0;
}


@end
