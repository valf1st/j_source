//
//  JOBrowse1ViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOSendViewController.h"
#import "JOUserViewController.h"
#import "JOMlistViewController.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "JOBrowse2ViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface JOBrowse1ViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
    JOBrowse2ViewController *browse2;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
