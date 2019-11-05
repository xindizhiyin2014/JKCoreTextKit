#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CoreTextData.h"
#import "CoreTextImageData.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "JKCoreTextKit.h"

FOUNDATION_EXPORT double JKCoreTextKitVersionNumber;
FOUNDATION_EXPORT const unsigned char JKCoreTextKitVersionString[];

