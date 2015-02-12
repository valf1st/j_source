//
//  JOCoinViewController.h
//  Joton
//
//  Created by Val F on 13/04/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "JODetailViewController.h"
#import "JOAsyncConnection.h"

@interface JOCoinViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;

    int myid, m1, m2, m3, cj, ct, cj2, ct2, reloadc;
    NSArray *cres;
    UIView *cv1, *cv2, *cv3;
    UIImageView *iv1, *iv2, *iv3;
    UIButton *m2btn, *m3btn;
    UILabel *d3label;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
