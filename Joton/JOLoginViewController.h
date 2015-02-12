//
//  JOLoginViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOLoginViewController : UIViewController<UITextFieldDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@end
