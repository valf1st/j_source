//
//  JOSendViewController.h
//  Joton
//
//  Created by Val F on 13/03/21.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JODetail2ViewController.h"
#import "JOUserViewController.h"
#import "JOAsyncConnection.h"
#import "JOAppDelegate.h"
#import "JOToastUtil.h"


@interface JOSendViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSDictionary *itemdata;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *seller;
@property (nonatomic, copy) NSString *from;

@end