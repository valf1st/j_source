//
//  JOBankViewController.h
//  Joton
//
//  Created by Val F on 13/04/08.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "JOBank2ViewController.h"

@interface JOBankViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
