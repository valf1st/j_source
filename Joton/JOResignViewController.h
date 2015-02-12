//
//  JOResignViewController.h
//  Joton
//
//  Created by Val F on 13/04/17.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOResignViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@end
