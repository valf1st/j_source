//
//  JOHistory2ViewController.h
//  Joton
//
//  Created by Val F on 13/06/14.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "JOSendViewController.h"
#import "UIImageView+WebCache.h"

@interface JOHistory2ViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
