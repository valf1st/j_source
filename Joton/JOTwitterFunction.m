//
//  JOTwitterFunction.m
//  Joton
//
//  Created by Val F on 2013/05/10.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOTwitterFunction.h"

// OAuth keys
static NSString *const myConsumerKey = @"iotgdMVeTxRyQ15znQbYYw";
static NSString *const myConsumerSecret = @"KjZUy3aV08eJLv70ut62KVmMsevQDDgk92F8PZMM";
static NSString *const appServiceName = @"Joton"; //キーチェイン名称
static NSString *const callBackURL = @"http://joton.jp/OAuthCallback"; //ダミーURL(存在しないURLならなんでもよい)

@implementation JOTwitterFunction

@synthesize delegate;

- (BOOL)isTwitterConnect{
	//Twitterコネクトされているかどうか？
	//キーチェインより確認
	return [GTMOAuthViewControllerTouch authorizeFromKeychainForName:appServiceName authentication:twAuth];
}

- (void)openTwitterConnect:(UIViewController *)sender
{NSLog(@"here!!");

	twAuth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
														 consumerKey:myConsumerKey
														  privateKey:myConsumerSecret];
	
	NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
	NSURL *accessURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
	NSURL *authorizeURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
	NSString *scope = @"http://api.twitter.com/oauth/request_token";
	
	twAuth.serviceProvider = @"Twitter";
	[twAuth setCallback:callBackURL];
	
	// Display the autentication view
	GTMOAuthViewControllerTouch *viewController;
	viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
															   language:nil
														requestTokenURL:requestURL
													  authorizeTokenURL:authorizeURL
														 accessTokenURL:accessURL
														 authentication:twAuth
														 appServiceName:appServiceName
															   delegate:self
													   finishedSelector:@selector(viewController:finishedWithAuth:error:sender:)];
	
	//ナビゲーションコントローラーをかます
	UINavigationController *naviController = [[UINavigationController alloc] init];
	
	//ナビゲーションコントローラーにTwitterビューをセット
	[naviController pushViewController:viewController animated:NO];
	
	[sender presentViewController:naviController animated:YES completion:nil];
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
				sender:(UIViewController *)sender{
	
	BOOL result;
    if (error != nil) {
        // 認証に失敗したときの処理
		NSLog(@"%@",@"認証失敗");
		result = NO;
    } else {
        // 認証に成功したときの処理
		NSLog(@"%@",@"認証成功");
		NSLog(@"%@",twAuth.accessToken);
        NSLog(@"%@",twAuth.tokenSecret);

        //twitter screen_nameを取得する
		NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/settings.json"];
		//screen_name以外も取得したいならこっち
		//NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
		[auth authorizeRequest:request];
		
		NSError *error;
		NSURLResponse *response;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		NSLog(@"error = %@", error);
		NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
		NSLog(@"responseText = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        
		id decodeData = [NSJSONSerialization JSONObjectWithData:responseData
														options:NSJSONReadingMutableContainers error:&error];
		NSString *screen_name = [decodeData objectForKey:@"screen_name"];
		NSLog(@"screen_name = %@", screen_name);

        //ユーザーデフォルトにしまっとく
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:screen_name forKey:@"TWScreenName"];
        [defaults setObject:twAuth.accessToken forKey:@"TWAccessTokenKey"];
        [defaults setObject:twAuth.tokenSecret forKey:@"TWAccessTokenSecret"];
    
		result = YES;

	}
    
	[delegate didFinishWithTwitterConnect:result];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}

- (void)deleteTwitterConnect{
	//Twitterキーチェインの削除
	[GTMOAuthViewControllerTouch removeParamsFromKeychainForName:appServiceName];
}

- (GTMOAuthAuthentication *)getTwAuth{
	//認証済みのAuthを返す（キーチェインから読み込み）
	GTMOAuthAuthentication *auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
																			   consumerKey:myConsumerKey
																				privateKey:myConsumerSecret];
	
	[GTMOAuthViewControllerTouch authorizeFromKeychainForName:appServiceName authentication:auth];
	return auth;
}
@end
