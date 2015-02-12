//
//  JODetail2ViewController.h
//  Joton
//
//  Created by Val F on 13/06/18.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "JOAsyncConnection.h"

@interface JODetail2ViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic,copy) NSString *item;
@property (nonatomic,copy) NSDictionary *itemdata;

@end
