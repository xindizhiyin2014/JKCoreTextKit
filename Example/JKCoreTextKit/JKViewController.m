//
//  JKViewController.m
//  JKCoreTextKit
//
//  Created by xindizhiyin2014 on 11/05/2019.
//  Copyright (c) 2019 xindizhiyin2014. All rights reserved.
//

#import "JKViewController.h"
#import <JKCoreTextKit/JKCoreTextKit.h>
@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	CTDisplayView *ctView = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 200, 300, 0)];
        ctView.backgroundColor = [UIColor whiteColor];
        CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
        config.width = 300;
        config.fontSize = 30.0f;
        config.lineSpace = 8.0f;
       config.bgColor = [UIColor redColor];

        CoreTextData *data = [CTFrameParser parseArray:[self array] config:config];
        ctView.data = data;
        ctView.frame = CGRectMake(0, 200, 300, data.height);
        [self.view addSubview:ctView];
    }


    - (NSArray *)array
    {
        return @[
            @{@"type":@"txt",
              @"content":@"曾经有一份真挚的爱情摆在我面前，我没有珍惜",
              @"bgColor":@"#f1f1f1",
//              @"size":@"16"
//              @"color":@"#000000"
            },
            @{@"type":@"txt",
              @"content":@"知道失去之后才后悔莫及",
              @"size":@"18"
//              @"color":@"#000000"
            },
            @{@"type":@"txt",
              @"content":@"如果上天能给我再来一次的机会的话，我会对那个女孩说三个字：我爱你",
              @"size":@"24"
//              @"color":@"#000000"
            },
            @{@"type":@"txt",
              @"content":@"如果非要在这份爱上加个期限的话：我希望是一万年",
              @"size":@"18"
//              @"color":@"#000000"
            },
            @{
                  @"type":@"img",
                  @"name":@"icon.png",
                  @"width":@"30",
                  @"height":@"20"
            }
        ];
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
