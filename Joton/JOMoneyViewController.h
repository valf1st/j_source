//
//  JOMoneyViewController.h
//  Joton
//
//  Created by Val F on 13/04/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOBankViewController.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "JOAppDelegate.h"

@interface JOMoneyViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;

    UIButton *cxBtn, *mxBtn, *m2Btn, *m3Btn;
    UILabel *d3label;
    UIView *cxpop, *mv1, *mv2, *mv3;
    UIImageView *iv1, *iv2, *iv3;
    int myid, connect, mnreload, mj, mt, mj2, mt2, m1, m2, m3;
    NSArray *hres;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
