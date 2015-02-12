//
//  JORegisterViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Base64.h"
#import "JOFunctionsDefined.h"
#import "JOPhotoFunction.h"
#import "JOAsyncConnection.h"
#import "JOAppDelegate.h"


@interface JORegisterViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, JOPhotoFunctionDelegate, JOAsyncConnectionDelegate>{
    JOPhotoFunction *photoFunc;
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic) UIWindow *window;

@end
