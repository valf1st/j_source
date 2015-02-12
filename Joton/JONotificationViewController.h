//
//  JONotificationViewController.h
//  Joton
//
//  Created by Val F on 13/04/22.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JONotificationViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@end