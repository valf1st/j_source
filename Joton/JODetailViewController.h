//
//  JODetailViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOUserViewController.h"
#import "JOEditViewController.h"
#import "JOMlistViewController.h"
#import "JOConfig.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "JOToastUtil.h"

@interface JODetailViewController : UIViewController <UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (nonatomic,copy) NSString *item;
@property (nonatomic,copy) NSDictionary *itemdata;
@property (nonatomic,copy) NSString *from;

@end
