//
//  JOLoginViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOLoginViewController.h"

@interface JOLoginViewController ()

@end

@implementation JOLoginViewController

UITextField *mailtf, *passtf;
NSArray *lires;
NSString *mail;
UIView *lview, *alertview;
UILabel *alert;
UIImageView *mailiv, *passiv;

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

    self.navigationItem.title = @"ログイン";

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *confirm=[[UIBarButtonItem alloc] initWithTitle:@"ログイン" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
    [confirm setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[confirm];

    //ろご
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoLogin.png"]];
    logo.frame = CGRectMake(113, 20, 93, 23);
    [self.view addSubview:logo];

    //枠
    UIView *afv = [[UIView alloc]initWithFrame:CGRectMake(10, 60, 300, 91)];
    afv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.view addSubview:afv];

    mailtf = [[UITextField alloc]initWithFrame:CGRectMake(40, 12, 250, 30)];
    mailtf.borderStyle = UITextBorderStyleNone;
    mailtf.placeholder = @"メールアドレス";
    mailtf.keyboardType = UIKeyboardTypeEmailAddress;
    [afv addSubview:mailtf];
    mailtf.delegate = self;
    mailtf.tag = 0;
    //アイコン
    mailiv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 21, 16)];
    mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    [afv addSubview:mailiv];

    passtf = [[UITextField alloc]initWithFrame:CGRectMake(40, 55, 250, 30)];
    passtf.borderStyle = UITextBorderStyleNone;
    passtf.placeholder = @"パスワード";
    passtf.secureTextEntry = YES;
    [afv addSubview:passtf];
    passtf.delegate = self;
    passtf.tag = 1;
    //アイコン
    passiv = [[UIImageView alloc] initWithFrame:CGRectMake(13, 56, 15, 21)];
    passiv.image = [UIImage imageNamed:@"iconPass.png"];
    [afv addSubview:passiv];

    UIButton *rmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rmbtn.frame = CGRectMake(60, 170, 200, 35);
    [rmbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rmbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rmbtn setTitle:@"パスワードを忘れた場合" forState:UIControlStateNormal];
    rmbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:rmbtn];
    [rmbtn addTarget:self action:@selector(reminder:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *underline = [[UILabel alloc]initWithFrame:CGRectMake(60, 170, 200, 35)];
    underline.backgroundColor = [UIColor clearColor];
    underline.font = [UIFont systemFontOfSize:14];
    underline.textColor = [UIColor darkGrayColor];
    underline.textAlignment = NSTextAlignmentCenter;
    underline.text = @"＿＿＿＿＿＿＿＿＿＿＿";
    [self.view addSubview:underline];

    //通信中のview
    lview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 700)];
    lview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:lview];
    lview.hidden = TRUE;

    //alertview
    alertview = [[UIView alloc]initWithFrame:CGRectMake(0, -33, 320, 30)];
    alertview.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgError.png"]];
    [self.view addSubview:alertview];
    alert = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    alert.textColor = [UIColor whiteColor];
    alert.backgroundColor = [UIColor clearColor];
    [alertview addSubview:alert];

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(pop) name:@"logout" object:nil];
    //[nc addObserver:self selector:@selector(submitted) name:@"submitted" object:nil];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)submitted{
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *myid = [ud stringForKey:@"userid"];
    if(!(myid == nil || [myid isEqual:[NSNull null]])){
        JOLoginViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tbc"];
        //[self presentViewController:tbc animated:NO completion:^{[self dismissViewControllerAnimated:NO completion:nil];}];
        [self presentViewController:tbc animated:NO completion:nil];
    }
}

//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == 0){
        [passtf becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 0){
        mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    }else{
        passiv.image = [UIImage imageNamed:@"iconPass.png"];
    }
    return YES;
}

- (void)login:(id)sender {

    [passtf resignFirstResponder];
    mail = mailtf.text;
    NSString *pass = passtf.text;

    if(mail.length == 0 || pass.length == 0){
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
        if(pass.length == 0){
            alert.text = @"パスワードを入力してください";
            passiv.image = [UIImage imageNamed:@"iconPassError.png"];
        }
        if(mail.length == 0){
            alert.text = @"メールアドレスを入力してください";
            mailiv.image = [UIImage imageNamed:@"iconMailError.png"];
        }
        [UIView animateWithDuration:0.5 animations:^
         {
             alertview.frame = CGRectMake(0, 0, 320, 33);
         }];
    }else{
        lview.hidden = FALSE;
        //通信
        NSString *dataa = [NSString stringWithFormat:@"mail=%@&pass=%@&service=reader", mail, pass];
        NSURL *url = [NSURL URLWithString:URL_LOGIN];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}

//alertバイバイ
- (void)onTimer:(NSTimer *)timer {
    [UIView animateWithDuration:0.5 animations:^
     {
         alertview.frame = CGRectMake(0, -33, 320, 33);
     }];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        lires = response;
        BOOL result = [[lires valueForKeyPath:@"result"] boolValue];

        //ユーザーデフォルトにuser_idを収納
        if(!result){
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            lview.hidden = TRUE;
        }else{
            int match = [[lires valueForKeyPath:@"match"] intValue];
            if(match == 0){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"メールアドレスかパスワードが間違っています" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
                lview.hidden = TRUE;
            }else{
                //ユーザーデフォルトに収納
                NSString *userid = [lires valueForKeyPath:@"user_id"];
                NSString *name = [lires valueForKeyPath:@"user_name"];
                NSString *badge = [lires valueForKeyPath:@"badge"];
                //NSString *mybadge = [lires valueForKeyPath:@"mybadge"];
                NSString *coin = [lires valueForKeyPath:@"coin"];
                NSArray *fb = [lires valueForKeyPath:@"fb"];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:userid forKey:@"userid"];
                [ud setObject:name forKey:@"username"];
                [ud setObject:mail forKey:@"email"];
                [ud setObject:badge forKey:@"badge"];
                //[ud setObject:mybadge forKey:@"mybadge"];
                [ud setObject:coin forKey:@"coin"];
                [ud setObject:fb forKey:@"fbdata"];
                [ud setObject:[lires valueForKeyPath:@"fb_seq_id"] forKey:@"fb_seq_id"];
                [ud setObject:[lires valueForKeyPath:@"tw_seq_id"] forKey:@"tw_seq_id"];
                [ud setObject:[response valueForKeyPath:@"push"] forKey:@"push"];
                [ud setObject:[response valueForKeyPath:@"icon"] forKey:@"user_icon"];
                [ud setObject:[response valueForKeyPath:@"postcode"] forKey:@"postcode"];
                [ud setObject:[response valueForKeyPath:@"county"] forKey:@"county"];
                [ud setObject:[response valueForKeyPath:@"p_address"] forKey:@"address"];
                [ud synchronize]; 
                lview.hidden = TRUE;
                //ページ遷移
                JOLoginViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tbc"];
                [self presentViewController:tbc animated:YES completion:nil];
            }
        }
    }
}

- (void)reminder:(id)sender {
    //ページ遷移
    JOLoginViewController *rem = [self.storyboard instantiateViewControllerWithIdentifier:@"rem"];
    [self.navigationController pushViewController:rem animated:YES];
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
