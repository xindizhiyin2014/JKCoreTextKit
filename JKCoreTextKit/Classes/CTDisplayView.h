//
//  CTDisplayView.h
//  JKCoreTextKit
//
//  Created by JackLee on 2019/11/4.
//  Copyright © 2019 JackLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTDisplayView : UIView

@property (nonatomic, strong) CoreTextData *data;

@end

NS_ASSUME_NONNULL_END
