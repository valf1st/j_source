//
//  JOMlistViewController.h
//  Joton
//
//  Created by Val F on 13/03/27.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOSendViewController.h"
#import "JOAsyncConnection.h"

@interface JOMlistViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSString *photo;

@end
