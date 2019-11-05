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
        self.fontName = [UIFont systemFontOfSize:12].fontName;
    }
    return self;
}
@end
