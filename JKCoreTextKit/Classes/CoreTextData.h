//
//  CoreTextData.h
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;                       ///< 根据内容计算的frame
@property (nonatomic, assign) CGFloat height;                           ///<  根据内容计算的高度
@property (nonatomic, strong) NSArray <CoreTextImageData *>*imgArray;   ///< 图片信息的数组

@end

NS_ASSUME_NONNULL_END
