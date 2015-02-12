//
//  JOConfirmViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "NSData+Base64.h"
#import "JOAsyncConnection.h"
#import "JOAppDelegate.h"
#import "JOToastUtil.h"
#import "JOTwitterFunction.h"

extern UIImage *image1;
extern UIImage *image2;
extern UIImage *image3;

extern NSString *w2;
extern NSString *h2;
extern NSString *w3;
extern NSString *h3;


@interface JOConfirmViewController : UIViewController<JOAsyncConnectionDelegate, FBDialogDelegate, FBRequestDelegate, UIScrollViewDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic,copy) NSString *w1;
@property (nonatomic,copy) NSString *h1;
//@property (nonatomic,copy) UIImage *image2;
//@property (nonatomic,copy) UIImage *image3;
@property (nonatomic,copy) NSString *condition;
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,copy) NSString *means1;
@property (nonatomic,copy) NSString *means2;
@property (nonatomic,copy) NSString *size;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *fb_post;
@property (nonatomic,copy) NSString *tw_post;

@property (atomic,retain) NSString *accountId;

@end
