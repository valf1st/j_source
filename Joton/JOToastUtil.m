//
//  JOToastUtil.m
//  Joton
//
//  Created by Val F on 13/05/13.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOToastUtil.h"

static UIView *toastView;

@implementation JOToastUtil

+(void)showToast:(NSString *)str{
	if (toastView) {
		[toastView removeFromSuperview];
		toastView = nil;
	}
	toastView = [[UIView alloc] init];
	UILabel *toast = [[UILabel alloc] init];
	toast.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
	toast.font = [UIFont systemFontOfSize:15.0f];
	toast.textAlignment = NSTextAlignmentCenter;
	[[toast layer] setCornerRadius:10.0];
	[toast setClipsToBounds:YES];
	toast.textColor = [UIColor whiteColor];
	toast.numberOfLines = 0;
	CGSize strSize = [str sizeWithFont:[UIFont systemFontOfSize:15.0f]];
	if(strSize.width < 280.0f){
		toast.frame = CGRectMake((320.0f - strSize.width - 20.0f) / 2, 292.0f, strSize.width + 20.0f, 40.0f);
	}else{
		toast.frame = CGRectMake(20, 292.0f, 280.0f, 60.0f);
	}
	toast.text = str;
	[toastView addSubview:toast];
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	[window addSubview:toastView];
	[NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(exitView) userInfo:(id)nil repeats:NO];
}
+(void)exitView{
	[toastView removeFromSuperview];
	toastView = nil;
}

@end
