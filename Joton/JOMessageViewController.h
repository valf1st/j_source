//
//  JOMessageViewController.h
//  Joton
//
//  Created by Val F on 13/03/21.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOSendViewController.h"
#import "JOAsyncConnection.h"
#import "JOMessage2ViewController.h"

@interface JOMessageViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
    JOMessage2ViewController *msg2;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end