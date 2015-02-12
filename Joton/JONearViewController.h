//
//  JONearViewController.h
//  Joton
//
//  Created by Val F on 13/04/09.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "JOSendViewController.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JONearViewController : UIViewController<JOAsyncConnectionDelegate, CLLocationManagerDelegate>{
    JOAsyncConnection *async;
    CLLocationManager *lm;
    double lon;
    double lat;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
