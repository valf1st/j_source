//
//  JOAppDelegate.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOAppDelegate.h"

@implementation JOAppDelegate

@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //[appDelegate SwitchToTab:index];

    // 灰色で不透明なスタイル
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 黒色で不透明なスタイル←これで。
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    // 黒色で半透明なスタイル
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;

    //ナビゲーションバー設定
    UIImage *nav = [UIImage imageNamed:@"nav.png"];
    [[UINavigationBar appearance] setBackgroundImage:nav forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.80 green:0.71 blue:0.51 alpha:1.0]];

    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], //タイトルの文字色
      UITextAttributeTextColor, [UIColor colorWithRed:0.7 green:0.5 blue:0.1 alpha:1.0], //シャドウの色
      UITextAttributeTextShadowColor, [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], //シャドウの強さ
      UITextAttributeTextShadowOffset, nil, UITextAttributeFont, nil]];

    //タブバー設定
    UIImage *tabback = [UIImage imageNamed:@"tabBack.png"];
    UIImage *currenttab= [UIImage imageNamed:@"currentTab.png"];
    [[UITabBar appearance] setBackgroundImage:tabback];
    [[UITabBar appearance] setSelectionIndicatorImage:currenttab];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
    bundle: nil];
    UIViewController *start = [storyboard instantiateViewControllerWithIdentifier:@"start"];
    [self.window setRootViewController:start];

    //背景
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    //push
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //FB
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    facebook = [[Facebook alloc] initWithAppId:@"138531592997429" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    //NSArray* permissions =  [NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil];
    //[facebook authorize:permissions];
    [self.window makeKeyAndVisible];//必要っぽい

    //落ちてるときのpushからの立ち上げ
    if(launchOptions){
        NSArray *options = [[launchOptions valueForKeyPath:@"UIApplicationLaunchOptionsRemoteNotificationKey"]valueForKeyPath:@"aps"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:options forKey:@"pushed"];

        //notification
        NSNotification *n = [NSNotification notificationWithName:@"pushed0" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"立ち上げたよ");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)fbDidLogin {
    NSLog(@"facebook did Login!!!aaaaa");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    NSLog(@"expiration = %@", [facebook expirationDate]);

    // Get the user's info.
    [facebook requestWithGraphPath:@"me/?fields=name,email,picture" andDelegate:self];
}
- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"did not log in");
}
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {
    NSLog(@"did extend token");
}
- (void)fbDidLogout {
    NSLog(@"did log out");
}
- (void)fbSessionInvalidated {
    NSLog(@"session invalid");
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"called? 1");
    JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.facebook handleOpenURL:url];
    //return [FBSession.activeSession handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"called? 2");
    return 0;
}



-(void)request:(FBRequest *)request didLoad:(id)result{
    // With this method we’ll get any Facebook response in the form of an array.
    // In this example the method will be used twice. Once to get the user’s name to
    // when showing the welcome message and next to get the ID of the published post.
    // Inside the result array there the data is stored as a NSDictionary.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:result forKey:@"fbdata"];
    [defaults synchronize];

    if ([result isKindOfClass:[NSData class]])
    {
        NSLog(@"Profile Picture");
        //imageView.image = [UIImage imageWithData:result];
    }
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]]) {
        // If the current result contains the "first_name" key then it's the user's data that have been returned.
    }
    if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	if ([result objectForKey:@"owner"]) {
		NSLog(@"Photo upload Success");
	} else {
		NSLog(@"result name:%@",[result objectForKey:@"name"]);
	}

     NSLog(@"ud = %@", [defaults dictionaryRepresentation]);
    NSNotification *n = [NSNotification notificationWithName:@"fbrequested" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"1didFailWithError:%@", error);
};

- (void)dialogDidComplete:(FBDialog *)dialog {
	NSLog(@"publish successfully");
    [self.window makeKeyAndVisible];//よばれてない
}

- (void)didFinishLaunchingWithOptions{
    NSLog(@"publish successfully 2");
    [self.window makeKeyAndVisible];//よばれてない
}

// デバイストークンを受信した際の処理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog( @"deviceToken : %@", deviceToken );
    // 自サーバーへ deviceToken を登録
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:token forKey:@"device_token"];

    //ユーザーデフォルトが入ってたらユーザーの最新情報とってきてlast_access入れる
    NSString *myid = [ud stringForKey:@"userid"];
    if(!(myid == nil || [myid isEqual:[NSNull null]])){
        [self launched_device:myid device:token];
    }
}

// デバイストークンの取得に失敗
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog( @"deviceToken Error : %@", [NSString stringWithFormat:@"%@", error] );
    
    //ユーザーデフォルトが入ってたらユーザーの最新情報とってきてlast_access入れる
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *myid = [ud stringForKey:@"userid"];
    if(!(myid == nil || [myid isEqual:[NSNull null]])){
        [self launched:myid];
    }
}

// 自サーバーからデータを受信
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog( @"RemoteNotification : %@", userInfo );
    NSArray *aps = [userInfo valueForKeyPath:@"aps"];
    NSLog(@"aps = %@", aps);
    int receiver = [[aps valueForKeyPath:@"receiver_id"]intValue];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int myid = [[ud stringForKey:@"userid"] intValue];
    if(receiver == myid){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"！" message:@"メッセージが来ました" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}

- (void)launched_device:(NSString*)myid device:(NSString*)device_token{
    //通信
    NSLog(@"device = %@", device_token);
    NSString *dataa = [NSString stringWithFormat:@"user_id=%@&device_token=%@", myid, device_token];
    NSURL *url = [NSURL URLWithString:URL_LAUNCHED_DEVICE];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)launched:(NSString*)myid{
    //通信
    NSString *dataa = [NSString stringWithFormat:@"user_id=%@", myid];
    NSURL *url = [NSURL URLWithString:URL_LAUNCHED];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        NSString *badge = [response valueForKeyPath:@"badge"];
        //NSString *mybadge = [response valueForKeyPath:@"mybadge"];
        NSString *coin = [response valueForKeyPath:@"coin"];
        NSArray *fb = [response valueForKeyPath:@"fb"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:badge forKey:@"badge"];
        //[ud setObject:mybadge forKey:@"mybadge"];
        [ud setObject:coin forKey:@"coin"];
        [ud setObject:fb forKey:@"fbdata"];
        NSString *fb_seq_id = [response valueForKeyPath:@"fb_seq_id"];
        if([fb_seq_id isEqual:[NSNull null]] || [fb_seq_id intValue] == 0){
            [ud setObject:@"0" forKey:@"fb_seq_id"];
        }else{
            [ud setObject:fb_seq_id forKey:@"fb_seq_id"];
        }
        [ud setObject:[response valueForKeyPath:@"email"] forKey:@"email"];
        [ud setObject:[response valueForKeyPath:@"user_name"] forKey:@"username"];
        [ud setObject:[response valueForKeyPath:@"tw_seq_id"] forKey:@"tw_seq_id"];
        [ud setObject:[response valueForKeyPath:@"county"] forKey:@"county"];
        [ud setObject:[response valueForKeyPath:@"p_address"] forKey:@"paddress"];
        [ud setObject:[response valueForKeyPath:@"postcode"] forKey:@"postcode"];
        [ud setObject:[response valueForKeyPath:@"push"] forKey:@"push"];
        [ud setObject:[response valueForKeyPath:@"icon"] forKey:@"user_icon"];
        [ud setObject:[response valueForKeyPath:@"postcode"] forKey:@"postcode"];
        [ud setObject:[response valueForKeyPath:@"county"] forKey:@"county"];
        [ud setObject:[response valueForKeyPath:@"p_address"] forKey:@"address"];
        [ud synchronize];
        NSLog(@"res fb = %@", [response valueForKeyPath:@"fb_seq_id"]);
        NSLog(@"fb = %@", [ud valueForKeyPath:@"fb_seq_id"]);
    }
}

@end
