//
//  CTFrameParserConfig.m
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        _fontName = [UIFont systemFontOfSize:14].fontName;
        _fontSize = 14;
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    self.font = [UIFont fontWithName:fontName size:self.fontSize];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
   self.font = [self.font fontWithSize:fontSize];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _fontName = font.fontName;
    _fontSize = font.pointSize;
}


@end
