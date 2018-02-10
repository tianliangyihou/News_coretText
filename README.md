##### 效果图：

![1.gif](http://upload-images.jianshu.io/upload_images/2306467-382a49e7eea5d78a.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

上面的效果是用CoreText实现的。

 demo的github地址 https://github.com/tianliangyihou/News_coretText
***
如果你对CoreText也比较感兴趣的话，建议可以看看下面这篇文章，了解一些文字排版的基本知识：

链接：http://www.cocoachina.com/industry/20140521/8504.html
***

 然后再看看下面这个老外用swift4 写的一个比较好的效果，介绍也写得很清楚（都是英文）。很多介绍CoreText都提到这篇文章：
https://www.raywenderlich.com/153591/core-text-tutorial-ios-making-magazine-app
***
还有唐巧写的猿题库中的一篇CoreText的知识：

链接：http://ju.outofmemory.cn/entry/53649
***
再之后可以看看这个github上的一个关于CoreText的开源库，代码比较少，读起来比较容易：

https://github.com/12207480/TYAttributedLabel 

这个是github上一个有2300多个star的库，demo写的也很详细
***
再再之后可以读一下YYKit作者写的 YYText，学习一下异步排版和渲染和更多的效果
https://github.com/ibireme/YYText

本人最近也是刚刚读完TYAttributedLabel，顺便写了个上面的效果。YYText也是看了一点，不过马上就要过年了，这一拖不知道要拖多久了。
***
下面是关于上图效果的一点简单介绍：
![Wechat.jpeg](http://upload-images.jianshu.io/upload_images/2306467-3e3cb1766b06d8ef.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这三个文字其实是3个按钮，这样写起来虽然有点麻烦，但是可以练手

CoreText是一个文字排版引擎，是不具备将图片或者View也渲染到你要显示的控件上的。但是幸运的是CoreText可以通过设置代理，给需要的地方预留下空间，这样的话就可以以后将View add到相应的位置。


```
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
  //这里self.models的作用是给model一个强引用，否则代理回调时候，model已经销毁了
    [self.models addObject:model];
    CFRelease(runDelegate);
}
```
设置代理后，当排版需要的时候，就会回调下面的代理方法
```
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
```
这样的话就可以你需要添加的View或者图片的地方预留下相应的空间。
***
gif图片的播放大概有两种方式：
1 高内存，低cpu 
demo的方式 :
```   
优点：简单粗暴
缺点：图片较大或者帧数较多，占用内存过大
```
2 低内存 ，高cpu  
 可以读读YYImage： https://github.com/ibireme/YYImage  
或者也可以看看本人写的一个图片浏览器，也是参考了YYImage的处理gif的方式写的
https://github.com/tianliangyihou/LBPhotoBrowser
```
优点：低内存 灵活多变 可控性强
缺点：要想实现较好的效果，需要手动实现，实现复杂。
```
***
最后的那个文字的环形环绕和上面的实现稍微有些不一样,并不是通过代理来预留空间的：
```
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

```
