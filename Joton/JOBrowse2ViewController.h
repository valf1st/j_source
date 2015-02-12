//
//  JOBrowse2ViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOSendViewController.h"
#import "JOAsyncConnection.h"
#import "JOFunctionsDefined.h"
#import "UIButton+WebCache.h"

@interface JOBrowse2ViewController : UIViewController<JOAsyncConnectionDelegate, UIScrollViewDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
