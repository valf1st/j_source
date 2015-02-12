//
//  JOHistoryViewController.h
//  Joton
//
//  Created by Val F on 13/03/28.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "JOSendViewController.h"
#import "JOAsyncConnection.h"
#import "JOHistory2ViewController.h"

@interface JOHistoryViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
    JOHistory2ViewController *history2;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
