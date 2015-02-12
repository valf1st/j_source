//
//  JOBargainViewController.h
//  Joton
//
//  Created by Val F on 13/05/16.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOAsyncConnection.h"
#import "JOFunctionsDefined.h"
#import "JODetailViewController.h"

@interface JOBargainViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
