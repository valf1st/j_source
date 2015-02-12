//
//  JOEnterViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "JOAsyncConnection.h"
#import "JOPhotoViewController.h"
#import "JOConfirmViewController.h"
#import "JOTwitterFunction.h"

extern UIImage *image1;
extern UIImage *image2;
extern NSString *h2;
extern NSString *w2;
extern UIImage *image3;
extern NSString *h3;
extern NSString *w3;

@interface JOEnterViewController : UIViewController<UITextViewDelegate, CLLocationManagerDelegate, JOAsyncConnectionDelegate, JOTwitterFunctionDelegate>{
    CLLocationManager *lm;
    double lon;
    double lat;
    JOAsyncConnection *async;
    JOTwitterFunction *twFunc;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic,copy) NSString *w1;
@property (nonatomic,copy) NSString *h1;

//@property (strong, nonatomic) IBOutlet UITextView *cmtv;

@end