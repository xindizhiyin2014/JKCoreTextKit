//
//  CTFrameParser.m
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config {
    
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    return [self parseAttributedContent:contentString config:config];
}

/* 自定义自己的排版 */
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config {
    NSArray *array = nil;
    NSString *fileExtension = [path pathExtension];
    if ([fileExtension isEqualToString:@"json"]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    } else if ([fileExtension isEqualToString:@"plist"]){
        array = [NSArray arrayWithContentsOfFile:path];
    }
    return [self parseArray:array config:config];
}

+ (CoreTextData *)parseArray:(NSArray<NSDictionary <NSString *,NSString *>*> *)array config:(CTFrameParserConfig *)config
{
  NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    NSMutableArray *imgArray = [NSMutableArray new];
    if (array) {
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *txtAttributeStr = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [content appendAttributedString:txtAttributeStr];
                }else if ([type isEqualToString:@"img"]) {
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    [imgArray addObject:imageData];
                    NSAttributedString *imgAttributeStr = [self parseImageDataFromNSDictionary:dict config:config];
                    [content appendAttributedString:imgAttributeStr];
                }
            }
        }
    }
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imgArray = imgArray;
    return data;
}

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)config.fontName, fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpacing}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    // 获得要绘制区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，并返回
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 内存释放
    CFRelease(frame);
    CFRelease(framesetter);
    
    return data;
}
 
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config {
    NSMutableDictionary *attributes = (NSMutableDictionary *)[self attributesWithConfig:config];
    CGFloat alpha = 1;
    if (dict[@"alpha"]) {
        alpha = [dict[@"alpha"] floatValue];
    }
    NSString *colorHexStr = dict[@"color"];
    UIColor *color = nil;
    if ((colorHexStr && ([colorHexStr hasPrefix:@"0x"] && colorHexStr.length == 8)) || ([colorHexStr hasPrefix:@"#"] && colorHexStr.length == 7)) {
        color = [self jkColorWithHexString:colorHexStr alpha:alpha];
    } else {
       color = config.textColor;
    }
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    CGFloat bgAlpha = 1;
    if (dict[@"bgAlpha"]) {
        bgAlpha = [dict[@"bgAlpha"] floatValue];
    }
    if (@available(iOS 10.0, *)) {
        NSString *bgColorHexStr = dict[@"bgColor"];
        UIColor *bgColor = nil;
        if ((bgColorHexStr && ([bgColorHexStr hasPrefix:@"0x"] && bgColorHexStr.length == 8)) || ([bgColorHexStr hasPrefix:@"#"] && bgColorHexStr.length == 7)) {
            bgColor = [self jkColorWithHexString:bgColorHexStr alpha:bgAlpha];
        } else {
           bgColor = config.bgColor;
        }
        if (bgColor) {
          attributes[(id)kCTBackgroundColorAttributeName] = (id)bgColor.CGColor;
        }
    } else {
        // Fallback on earlier versions
    }
    
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        CTFontRef fontRef = (__bridge CTFontRef)font;
        attributes[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
        CFRelease(fontRef);
    } else {
        CTFontRef fontRef = (__bridge CTFontRef)config.font;
        attributes[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

static CGFloat ascentCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}
 
static CGFloat descentCallback(void *ref) {
    return 0;
}
 
static CGFloat widthCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}
 
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config {
    CTRunDelegateCallbacks callbacks;
    // memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    // 使用0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    
    return space;
}


+ (UIColor *)jkColorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
