//
//  JOPhotoFunction.h
//  Joton
//
//  Created by Val F on 13/04/08.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Base64.h"

@protocol JOPhotoFunctionDelegate;

@interface JOPhotoFunction : NSObject{
    //NSDictionary *info;
}

+ (id)instance;

- (void)photoFunction:(NSDictionary *)info size:(float)size camera:(int)p;
- (UIImage*)rotateImage:(UIImage*)img angle:(int)angle;

@property (nonatomic, assign) id <JOPhotoFunctionDelegate> delegate;

@end


@protocol JOPhotoFunctionDelegate
//- (void)didFinishWithPhotoFunction:(NSString *)str image:(UIImage *)aImage;
- (void)didFinishWithPhotoFunction:(UIImage *)aImage width:(int)w height:(int)h;
@end
