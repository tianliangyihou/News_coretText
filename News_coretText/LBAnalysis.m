//
//  LBAnalysis.m
//  News_coretText
//
//  Created by dengweihao on 2018/2/6.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "LBAnalysis.h"
#import <CoreText/CoreText.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+LBDecoder.h"
@implementation LBDrawModel

@end

@implementation LBModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = 0;
        _ascent = 0;
        _descent = 0;
        _location = 0;
        _height = 0;
    }
    return self;
}

@end

@interface LBAnalysis ()

@property (nonatomic , strong)UIFont *currentFont;
@property (nonatomic , assign)CGFloat btnWidth;


@end

@implementation LBAnalysis {
    NSMutableAttributedString *_muAttributeStr;
}
- (NSMutableAttributedString *)muAttributeStr {
    return _muAttributeStr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentFont = [UIFont systemFontOfSize:16];
        _models = [[NSMutableArray alloc]init];
        _btnWidth = 30;
    }
    return self;
}
- (void)setText:(NSString *)text {
    _text = text;
    NSMutableAttributedString *muattrStr = [[NSMutableAttributedString alloc]initWithString:text];
    [muattrStr addAttributes:@{
                               NSFontAttributeName :_currentFont
                               } range:NSMakeRange(0, muattrStr.string.length)];

    [self addAttributeForAttributeString:muattrStr AlignmentStyle:kCTTextAlignmentLeft lineSpaceStyle:10 paragraphSpaceStyle:0 lineBreakStyle:kCTLineBreakByCharWrapping range:NSMakeRange(0, text.length)];
    _muAttributeStr = muattrStr;
    [self.models removeAllObjects];
    
    {
       
        NSRange titleRange = [_muAttributeStr.string rangeOfString:@"关于你，我有太多东西关于你"];
        [muattrStr addAttributes:@{
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   NSFontAttributeName :[UIFont systemFontOfSize:20]
                                   } range:titleRange];
    }
    
    // 配置按钮
    {
        NSRange rangeS = [_muAttributeStr.string rangeOfString:@"[小]"];
        LBModel *model = [self fontPlaceHoldModelWithTitle:@"[小]" range:rangeS];
        [self replaceTextOfRange:rangeS withModel:model];
    }
    {
        NSRange rangeM = [_muAttributeStr.string rangeOfString:@"[中]"];
        LBModel *model = [self fontPlaceHoldModelWithTitle:@"[中]" range:rangeM];
        [self replaceTextOfRange:rangeM withModel:model];
    }
    {
        NSRange rangeL = [_muAttributeStr.string rangeOfString:@"[大]"];
        LBModel *model = [self fontPlaceHoldModelWithTitle:@"[大]" range:rangeL];
        [self replaceTextOfRange:rangeL withModel:model];
    }
    // 配置图片
    {//640 * 360
        NSString *urlString = @"http://p3.pstatp.com/large/w960/532100012cafac577bf6";
        NSRange linkRange = [_muAttributeStr.string rangeOfString:urlString];
        LBModel *model = [self imageViewPlaceHoldModelWithTitle:@"imageView" range:linkRange urlString:urlString imageSize:CGSizeMake(640, 360)];
        [self replaceTextOfRange:linkRange withModel:model];
    }
    {//418 * 235
        NSString *urlString = @"http://p7.pstatp.com/large/w960/532300012072044452cb";
        NSRange linkRange = [_muAttributeStr.string rangeOfString:urlString];
        LBModel *model = [self imageViewPlaceHoldModelWithTitle:@"imageView" range:linkRange urlString:urlString imageSize:CGSizeMake(418, 235)];
        [self replaceTextOfRange:linkRange withModel:model];
    }
}


- (LBModel *)fontPlaceHoldModelWithTitle:(NSString *)title range:(NSRange)range {
    LBModel *model = [[LBModel alloc]init];
    model.ascent = _currentFont.ascender;
    model.descent = -_currentFont.descender;
    model.width = _btnWidth;
    model.location = range.location;
    model.name = title;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = _currentFont;
    btn.frame = CGRectMake(0, 0, model.width, _currentFont.lineHeight);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = range.location;
    [btn setTitle:model.name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    model.view = btn;
    return model;
}
- (LBModel *)imageViewPlaceHoldModelWithTitle:(NSString *)title range:(NSRange)range urlString:(NSString *)urlString imageSize:(CGSize)size{
    LBModel *model = [[LBModel alloc]init];
    model.ascent = _currentFont.ascender;
    model.descent = -_currentFont.descender;
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    model.width = mainScreenSize.width;
    model.height = mainScreenSize.width / size.width * size.height;
    model.location = range.location;
    model.name = @"imageView";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, model.width, model.height)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image.images.count >0) {
            // 这种加载方式占用较多内存
            imageView.image = [UIImage sdOverdue_animatedGIFWithData:data];
        }else {
            imageView.image = image;
        }
    }];
    model.view = imageView;
    return model;
}

- (void)replaceTextOfRange:(NSRange)range withModel:(LBModel *)model{
    
    unichar objectReplacementChar = 0xFFFC;
    NSString * objectReplacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString *muAttrS = [[NSMutableAttributedString alloc]initWithString:objectReplacementString];
    
    CTRunDelegateCallbacks runCallBacks;
    runCallBacks.version = kCTRunDelegateVersion1;
    runCallBacks.dealloc = textRunDelegateDeallocCallback;
    runCallBacks.getAscent = textRunDelegateGetAscentCallback;
    runCallBacks.getDescent = textRunDelegateGetDescentCallback;
    runCallBacks.getWidth = textRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&runCallBacks, (__bridge void * _Nullable)(model));
    [muAttrS addAttribute:(__bridge_transfer NSString *) kCTRunDelegateAttributeName value:(__bridge id _Nonnull)(runDelegate) range:NSMakeRange(0, 1)];
    [_muAttributeStr replaceCharactersInRange:range withAttributedString:muAttrS];
    [self.models addObject:model];
    CFRelease(runDelegate);
}
#pragma mark - 调整间距


- (void)addAttributeForAttributeString:(NSMutableAttributedString *)muAttrStr AlignmentStyle:(CTTextAlignment)textAlignment
                    lineSpaceStyle:(CGFloat)linesSpacing
               paragraphSpaceStyle:(CGFloat)paragraphSpacing
                    lineBreakStyle:(CTLineBreakMode)lineBreakMode
                             range:(NSRange)range
{
    [muAttrStr removeAttribute:(id)kCTParagraphStyleAttributeName range:range];
    
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize = sizeof(textAlignment);
    alignmentStyle.value = &textAlignment;
    
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(linesSpacing);
    lineSpaceStyle.value = &linesSpacing;
    
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.value = &paragraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(paragraphSpacing);
    
    CTParagraphStyleSetting lineBreakStyle;
    lineBreakStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.value = &lineBreakMode;
    lineBreakStyle.valueSize = sizeof(lineBreakMode);
    
    CTParagraphStyleSetting settings[] = {alignmentStyle ,lineSpaceStyle, paragraphSpaceStyle, lineBreakStyle};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    [muAttrStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)CFBridgingRelease(paragraphStyle) range:range];
}



#pragma mark - CTRunDelegateCallbacks
//CTRun的回调，销毁内存的回调
void textRunDelegateDeallocCallback( void* refCon ){
}
//CTRun的回调，获取高度
CGFloat textRunDelegateGetAscentCallback( void *refCon ){
    LBModel *model = (__bridge LBModel *)refCon;
    if (![model.name isEqualToString:@"imageView"]) {
        return model.ascent;
    }
    return model.height;
}
CGFloat textRunDelegateGetDescentCallback(void *refCon){
    LBModel *model = (__bridge LBModel *)refCon;
    if (![model.name isEqualToString:@"imageView"]) {
        return model.descent;
    }
    return 0;
}
//CTRun的回调，获取宽度
CGFloat textRunDelegateGetWidthCallback(void *refCon){
    LBModel *model = (__bridge LBModel *)refCon;
    return model.width;
}

#pragma mark - 按钮的回调
- (void)btnClick:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"[小]"]) {
        [self adjustFontToSmallSize];
    }else if ([btn.titleLabel.text isEqualToString:@"[中]"]) {
        [self adjustFontToMiddleSize];
    }else {
        [self adjustFontToLargeSize];
    }
}

#pragma mark - 调整字体的大小

- (void)adjustFontToLargeSize {
    _currentFont = [UIFont systemFontOfSize:18];
    _btnWidth = 35;
    [self adjustFont];
}
- (void)adjustFontToMiddleSize {
    _currentFont = [UIFont systemFontOfSize:16];
    _btnWidth = 30;
    [self adjustFont];

}
- (void)adjustFontToSmallSize {
    _currentFont = [UIFont systemFontOfSize:14];
    _btnWidth = 25;
    [self adjustFont];
}
- (void)adjustFont {
    self.text = _text;
    if (self.adjustFontBlock) {
        self.adjustFontBlock(self, _muAttributeStr, _models);
    }
}


@end
