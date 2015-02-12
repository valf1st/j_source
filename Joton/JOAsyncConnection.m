//
//  JOAsyncConnection.m
//  Joton
//
//  Created by Val F on 13/04/05.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOAsyncConnection.h"

@interface JOAsyncConnection ()

@end

@implementation JOAsyncConnection

@synthesize delegate;
//@synthesize request;

NSURLRequest *req;

- (void)asyncConnect:(NSURLRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    //request.timeoutInterval = 20.0;
	//if (load == YES) {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                // エラー処理を行う。
                req = request;//リトライのため渡しておく
                if (error.code == -1003) {
                    //NSLog(@"not found hostname. targetURL=%@", url);
                    NSLog(@"not found hostname.");
                    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"失敗" message:@"接続できません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"リトライ", nil];
                    alertd.alertViewStyle = UIAlertViewStyleDefault;
                    [alertd show];
                } else if (-1019) {
                    NSLog(@"auth error. reason=%@", error);
                    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"失敗" message:@"接続できません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"リトライ", nil];
                    alertd.alertViewStyle = UIAlertViewStyleDefault;
                    [alertd show];
                } else {
                    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"失敗" message:@"接続できません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"リトライ", nil];
                    alertd.alertViewStyle = UIAlertViewStyleDefault;
                    [alertd show];
                }
                [delegate didFinishWithAsyncConnect:NO value:NULL];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                return;
            } else {
                int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
                if (httpStatusCode == 404) {
                    //NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                    NSLog(@"404 NOT FOUND ERROR.");
                    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"失敗" message:@"接続できません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"リトライ", nil];
                    alertd.alertViewStyle = UIAlertViewStyleDefault;
                    [alertd show];
                    // } else if (・・・) {
                    // 他にも処理したいHTTPステータスがあれば書く。
                    [delegate didFinishWithAsyncConnect:NO value:NULL];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    return;
                } else {
                    NSLog(@"success request!!");
                    NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
                    NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    NSError* jsonError=nil;
                    //jsonデコードしたやつをreturn
                    NSArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    NSLog(@"statuses = %@", res);
                    [delegate didFinishWithAsyncConnect:YES value:res];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    return;
                }
            }
        }];
    //}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1:
            [self asyncConnect:req];
            break;
    }
}

/*+ (id)instance
{
    static id _instance = nil;
    @synchronized(self) {
        if (!_instance){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}*/

@end
