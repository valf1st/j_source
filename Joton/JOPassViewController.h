//
//  JOPassViewController.h
//  Joton
//
//  Created by Val F on 13/06/11.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOPassViewController : UIViewController<UITextFieldDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@end
