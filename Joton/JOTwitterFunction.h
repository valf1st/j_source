//
//  JOTwitterFunction.h
//  Joton
//
//  Created by Val F on 2013/05/10.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"

@protocol JOTwitterFunctionDelegate;

@interface JOTwitterFunction : NSObject{
	// OAuth認証オブジェクト
    GTMOAuthAuthentication *twAuth;
}

- (BOOL)isTwitterConnect;
- (void)openTwitterConnect:(UIViewController *)sender;
- (void)deleteTwitterConnect;
- (GTMOAuthAuthentication *)getTwAuth;

@property (nonatomic, assign) id <JOTwitterFunctionDelegate> delegate;

@end


@protocol JOTwitterFunctionDelegate
- (void)didFinishWithTwitterConnect:(BOOL)result;
@end