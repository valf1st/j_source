//
//  JOToastUtil.h
//  Joton
//
//  Created by Val F on 13/05/13.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface JOToastUtil : NSObject

/*
 @method		showToast:
 @abstract		トーストを表示する
 @param         str トーストに表示させたい文字列
 */

+(void)showToast:(NSString *)str;

@end
