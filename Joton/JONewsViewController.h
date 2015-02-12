//
//  JONewsViewController.h
//  Joton
//
//  Created by Val F on 13/04/16.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JONewsViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
