//
//  CTFrameParserConfig.h
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;         ///< 文字区域宽度
@property (nonatomic, assign) CGFloat fontSize;      ///< 字体大小
@property (nonatomic, copy)   NSString *fontName;    ///< 字体名字
@property (nonatomic, assign) CGFloat lineSpace;     ///< 行间距
@property (nonatomic, strong) UIColor *textColor;    ///< 文字颜色

@end

NS_ASSUME_NONNULL_END
