//
//  JOAppDelegate.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../src/FBConnect.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate, JOAsyncConnectionDelegate>{
    Facebook *facebook;
    JOAsyncConnection *async;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Facebook *facebook;

@property (nonatomic, retain) NSString *myflag;//mypageを更新するフラグ

@end
