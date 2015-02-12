//
//  JOSearchViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JODetailViewController.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOSearchViewController : UIViewController<UITextFieldDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
