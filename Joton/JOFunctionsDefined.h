//
//  JOFunctionsDefined.h
//  Joton
//
//  Created by Val F on 13/04/09.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JOConfig.h"
#import <Foundation/NSString.h>

@interface JOFunctionsDefined : NSObject

+ (NSArray *) httpConnectFromData:(NSString *)data url:(NSURL *)url;

+ (NSURLRequest *)postRequest:(NSString *)data url:(NSURL *)url timeout:(int)time;

+ (NSString *) sinceFromData:(NSString *)data;

+ (BOOL)removeForeign:(NSString *)str;

+ (BOOL)removeEmoji:(NSString *)str;

+ (BOOL)findKatakana:(NSString *)str;

+ (BOOL)validEmail:(NSString *)str;

+ (NSString *)urlencode:(NSString *)plainString;

+ (NSString *)urldecode:(NSString *)escapedUrlString;

@end
