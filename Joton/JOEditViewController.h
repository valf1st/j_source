//
//  JOEditViewController.h
//  Joton
//
//  Created by Val F on 13/04/10.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "JOPhotoViewController.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "JOToastUtil.h"

extern UIImage *image1;
extern UIImage *image2;
extern NSInteger p2;
extern UIImage *image3;
extern NSInteger p3;

@interface JOEditViewController : UIViewController<CLLocationManagerDelegate, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,  JOAsyncConnectionDelegate>{
    CLLocationManager *lm;
    double lon;
    double lat;
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic,copy) NSString *item;
@property (nonatomic,copy) NSString *photo1;
@property (nonatomic,copy) NSString *p1h;
@property (nonatomic,copy) NSString *p1w;
@property (nonatomic,copy) NSString *photo2;
@property (nonatomic,copy) NSString *photo3;
@property (nonatomic,copy) NSString *cd;
@property (nonatomic,copy) NSString *ms1;
@property (nonatomic,copy) NSString *ms2;
@property (nonatomic,copy) NSString *sz;
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,copy) NSData *location;
@property (nonatomic,copy) NSString *from;

@end
