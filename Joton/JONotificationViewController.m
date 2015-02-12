//
//  JONotificationViewController.m
//  Joton
//
//  Created by Val F on 13/04/22.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JONotificationViewController.h"

@interface JONotificationViewController ()

@end

@implementation JONotificationViewController

UIActivityIndicatorView *ai;
int myid, p1, enabled;
UIView *pv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationItem.title = @"プッシュ通知設定";

    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
    int push = [[ud stringForKey:@"push"] intValue];

    //枠
    UIView *mlv = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 47)];
    mlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgFB.png"]];
    [self.view addSubview:mlv];

    if(push == 1){
        enabled = 1;
    }else{
        enabled = 0;
    }

    [self draw];

    //端末の設定で許可されてるかチェック←とりあえずいらない
    /*UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone){
        NSLog(@"disabled");
        enabled = 0;
    }else{
        NSLog(@"enabled");
        enabled = 1;
    }*/

    //更新中のview
    pv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    pv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pv];
    //popview
    UIView *popview =[[UIView alloc] initWithFrame:CGRectMake(60, 200, 200, 100)];
    popview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    popview.layer.cornerRadius = 5.0;
    [pv addSubview:popview];
    //らべる
    UILabel *xl = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 180, 30)];
    xl.text = @"更新中です";
    xl.textColor = [UIColor whiteColor];
    xl.backgroundColor = [UIColor clearColor];
    xl.textAlignment = NSTextAlignmentCenter;
    [popview addSubview:xl];
    //くるくる
    ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(92, 20, 17, 17)];
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [ai startAnimating];
    [popview addSubview:ai];
    pv.hidden = TRUE;
}

- (void)draw{
    //ラベル
    UILabel *exLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 150, 30)];
    exLabel.text = @"プッシュ通知";
    [self.view addSubview:exLabel];

    //スイッチ
    UISwitch *push1 = [[UISwitch alloc] initWithFrame:CGRectMake(220, 25, 90, 30)];
    if(enabled == 1){
        push1.on = YES;
        p1 = 1;
    }else{
        push1.on = NO;
        p1 = 0;
    }
    [push1 addTarget:self action:@selector(push1:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:push1];

    /*//更新ボタン
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 300, 120, 40);
    [button setTitle:@"更新" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];*/
}

- (void)push1:(id)sender{
    //if(enabled == 1){
        if(p1 == 1){
            p1 = 0;
        }else{
            p1 = 1;
        }
    /*}else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"利用できません" message:@"プライバシー設定を確認してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }*/
    [self button];
}

- (void)button{
    pv.hidden = FALSE;
    NSLog(@"p1 = %d", p1);
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&push=%d&service=reader", myid, p1];
    NSURL *url = [NSURL URLWithString:URL_USER_PUSH];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        BOOL result = [[response valueForKeyPath:@"result"]boolValue];
        if(result){
            /*NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[response valueForKeyPath:@"push"] forKey:@"push"];
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"成功" message:@"更新しました" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];*/
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[response valueForKeyPath:@"push"] forKey:@"push"];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
    }
    pv.hidden = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
}

@end