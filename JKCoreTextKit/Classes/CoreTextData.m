//
//  CoreTextData.m
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import "CoreTextData.h"

@implementation CoreTextData
- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if(_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)setImgArray:(NSArray<CoreTextImageData *> *)imgArray
{
    _imgArray = imgArray;
    [self fillImagePosition];
}

- (void)fillImagePosition {
    if (self.imgArray.count == 0) return;
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    int lineCount = (int)lines.count;
    // 每行的起始坐标
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imageIndex = 0;
    CoreTextImageData *imageData = self.imgArray[0];
    for (int i = 0; i < lineCount; i++) {
        if (!imageData) break;
        
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        NSArray *runObjectArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObject in runObjectArray) {
            CTRunRef run = (__bridge CTRunRef)(runObject);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes valueForKey:(id)kCTRunDelegateAttributeName]);
            // 如果delegate是空，表明不是图片
            if (!delegate) continue;
            
            NSDictionary *metaDict = CTRunDelegateGetRefCon(delegate);
            if (![metaDict isKindOfClass:[NSDictionary class]]) continue;
            
            /* 确定图片run的frame */
            CGRect runBounds;
            CGFloat ascent,descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            // 计算出图片相对于每行起始位置x方向上面的偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
    
            imageData.imagePosition = runBounds;
            imageIndex++;
            if (imageIndex == self.imgArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imgArray[imageIndex];
            }
        }
    }
}
 
- (void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end
