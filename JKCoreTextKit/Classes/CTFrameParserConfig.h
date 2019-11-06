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

@property (nonatomic, assign) CGFloat width;                ///< 文字区域宽度
@property (nonatomic, assign) CGFloat fontSize;             ///< 字体大小
@property (nonatomic, copy, nonnull) NSString *fontName;    ///< 字体名字
@property (nonatomic, strong, nonnull) UIFont *font;        ///< 默认字体，由fontSize、fontName进行初始化，也可以单独初始化
@property (nonatomic, assign) CGFloat lineSpace;            ///< 行间距
@property (nonatomic, strong, nonnull) UIColor *textColor;  ///< 文字颜色
@property (nonatomic, strong, nullable) UIColor *bgColor;   ///< 文字的背景颜色

@end

NS_ASSUME_NONNULL_END
