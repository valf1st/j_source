//
//  JOResignViewController.m
//  Joton
//
//  Created by Val F on 13/04/17.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOResignViewController.h"

@interface JOResignViewController ()

@end

@implementation JOResignViewController

int myid;

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

    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    self.navigationItem.title = @"退会";

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float sheight = screenBound.size.height;
    //5は548で4sは480でござるよ
    if(sheight > 500){
        [self draw5];
    }else{
        [self draw4];
    }
}

- (void)draw5{
    //てきすと
    UILabel *exl = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 60)];
    exl.backgroundColor = [UIColor clearColor];
    exl.font = [UIFont systemFontOfSize:14.5];
    exl.lineBreakMode = NSLineBreakByWordWrapping;
    exl.numberOfLines = 5;
    exl.text = @"再度ご利用いただくには、新規登録が必要となりますので、注意事項をよく読んでいただいたうえで手続きを進めてください";
    exl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [self.view addSubview:exl];

    //枠
    UIView *fv = [[UIView alloc]initWithFrame:CGRectMake(10, 85, 300, 231)];
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgResign.png"]];
    [self.view addSubview:fv];
    //赤文字
    UILabel *rl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 270, 50)];
    rl.backgroundColor = [UIColor clearColor];
    rl.font = [UIFont boldSystemFontOfSize:18];
    rl.lineBreakMode = NSLineBreakByWordWrapping;
    rl.numberOfLines = 5;
    rl.text = @"退会するとすべての登録データが削除されます";
    rl.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    [fv addSubview:rl];
    //箇条書き
    UILabel *gl = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 270, 230)];
    gl.backgroundColor = [UIColor clearColor];
    gl.font = [UIFont systemFontOfSize:15];
    gl.lineBreakMode = NSLineBreakByWordWrapping;
    gl.numberOfLines = 10;
    gl.text = @"・退会すると出品報酬が削除されます\n\n・退会後、再登録は可能ですが、退会\n　時点の出品報酬は引き継がれません\n\n・削除されたデータを復元することは\n　できません";
    gl.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [fv addSubview:gl];

    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resignBtn.frame = CGRectMake(9, 340, 303, 43);
    [resignBtn setImage:[UIImage imageNamed:@"btnResign.png"] forState:UIControlStateNormal];
    [self.view addSubview:resignBtn];
    [resignBtn addTarget:self action:@selector(resign:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)draw4{
    //てきすと
    UILabel *exl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 290, 60)];
    exl.backgroundColor = [UIColor clearColor];
    exl.font = [UIFont systemFontOfSize:14.5];
    exl.lineBreakMode = NSLineBreakByWordWrapping;
    exl.numberOfLines = 5;
    exl.text = @"再度ご利用いただくには、新規登録が必要となりますので、注意事項をよく読んでいただいたうえで手続きを進めてください";
    exl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [self.view addSubview:exl];

    //枠
    UIView *fv = [[UIView alloc]initWithFrame:CGRectMake(10, 85, 300, 200)];
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgResign4.png"]];
    [self.view addSubview:fv];
    //赤文字
    UILabel *rl = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 270, 50)];
    rl.backgroundColor = [UIColor clearColor];
    rl.font = [UIFont boldSystemFontOfSize:18];
    rl.lineBreakMode = NSLineBreakByWordWrapping;
    rl.numberOfLines = 5;
    rl.text = @"退会するとすべての登録データが削除されます";
    rl.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    [fv addSubview:rl];
    //箇条書き
    UILabel *gl = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, 270, 200)];
    gl.backgroundColor = [UIColor clearColor];
    gl.font = [UIFont systemFontOfSize:15];
    gl.lineBreakMode = NSLineBreakByWordWrapping;
    gl.numberOfLines = 10;
    gl.text = @"・退会すると出品報酬が削除されます\n\n・退会後、再登録は可能ですが、退会\n　時点の出品報酬は引き継がれません\n\n・削除されたデータを復元することは\n　できません";
    gl.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [fv addSubview:gl];

    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resignBtn.frame = CGRectMake(9, 310, 303, 43);
    [resignBtn setImage:[UIImage imageNamed:@"btnResign.png"] forState:UIControlStateNormal];
    [self.view addSubview:resignBtn];
    [resignBtn addTarget:self action:@selector(resign:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)resign:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"退会しますか?"
                          message:@"確認"
                          delegate:self
                          cancelButtonTitle:@"キャンセル"
                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (alertView.tag == firstAlertTag)  {
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1://押したボタンがOKなら画面遷移(リクエストは次ページで送信)
            NSLog(@"");
            
            [self connect];
            break;
            //}
    }
}

- (void)connect{
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&service=reader", myid];
    NSURL *url = [NSURL URLWithString:URL_RESIGN];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        BOOL result = [[response valueForKeyPath:@"result"] boolValue];
        if(result){
            //ユーザーデフォルトを空にする
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
            [ud setObject:nil forKey:@"userid"];
            [ud setObject:nil forKey:@"username"];
            [ud setObject:nil forKey:@"password"];
            [ud setObject:nil forKey:@"email"];
            [ud setObject:nil forKey:@"icon"];

            // 通知を作成する
            NSNotification *n = [NSNotification notificationWithName:@"logout" object:self];
            // 通知実行！
            [[NSNotificationCenter defaultCenter] postNotification:n];

            //JOSettingViewController *testVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"start"];
            //[self.navigationController presentViewController:testVC2 animated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
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
