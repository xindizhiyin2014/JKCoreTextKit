//
//  CTFrameParser.h
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParser : NSObject

/* 对整段文字进行排版 */
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;
 
/* 自定义自己的排版 */
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;


/// 自定义数据
/// @param array 待解析数据
/// @param config 配置
+ (CoreTextData *)parseArray:(NSArray<NSDictionary <NSString *,NSString *>*> *)array config:(CTFrameParserConfig *)config;

@end

NS_ASSUME_NONNULL_END
