//
//  JOMyeditViewController.h
//  Joton
//
//  Created by Val F on 13/04/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"
#import "JOPhotoFunction.h"
#import "JOAppDelegate.h"
#import "JOToastUtil.h"
#import "JOTwitterFunction.h"

@interface JOMyeditViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, JOPhotoFunctionDelegate, JOAsyncConnectionDelegate, JOTwitterFunctionDelegate>{
    JOPhotoFunction *photoFunc;
    JOAsyncConnection *async;
    JOTwitterFunction *twFunc;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
