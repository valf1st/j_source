//
//  JOMessage2ViewController.h
//  Joton
//
//  Created by Val F on 13/06/12.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOAsyncConnection.h"
#import "JOFunctionsDefined.h"
#import "JOSendViewController.h"
#import "UIImageView+WebCache.h"

@interface JOMessage2ViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
