//
//  JOAsyncConnection.h
//  Joton
//
//  Created by Val F on 13/04/05.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JOAsyncConnectionDelegate;

@interface JOAsyncConnection : NSObject{
    //NSURLRequest *request;
}

//+ (id)instance;

- (void)asyncConnect:(NSURLRequest *)request;

@property (nonatomic, assign) id <JOAsyncConnectionDelegate> delegate;
//@property (nonatomic, retain) NSURLRequest *request;

@end


@protocol JOAsyncConnectionDelegate
- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response;
@end