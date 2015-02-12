//
//  JOPassViewController.m
//  Joton
//
//  Created by Val F on 13/06/11.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOPassViewController.h"

@interface JOPassViewController ()

@end

@implementation JOPassViewController

UITextField *current, *new1, *new2;
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

    self.navigationItem.title = @"パスワード";

    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *done = [[UIBarButtonItem alloc]
                               initWithTitle:@"変更"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(doneBtn:)];
    [done setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[done];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"]intValue];

    //らべる
    UILabel *clabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    clabel.text = @"パスワードを変更";
    clabel.font = [UIFont boldSystemFontOfSize:14];
    clabel.backgroundColor = [UIColor clearColor];
    clabel.textColor = [UIColor grayColor];
    [self.view addSubview:clabel];
    //いまの枠
    UIView *mlv = [[UIView alloc]initWithFrame:CGRectMake(10, 30, 300, 47)];
    mlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgFB.png"]];
    [self.view addSubview:mlv];
    //いまの欄
    current = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, 270, 30)];
    current.borderStyle = UITextBorderStyleNone;
    current.placeholder = @"現在のパスワード";
    current.secureTextEntry = YES;
    [mlv addSubview:current];
    current.tag = 0;
    current.delegate = self;
    UIImageView *passivc = [[UIImageView alloc] initWithFrame:CGRectMake(13, 11, 15, 21)];
    passivc.image = [UIImage imageNamed:@"iconPass.png"];
    [mlv addSubview:passivc];

    //新しい枠
    UIView *afv = [[UIView alloc]initWithFrame:CGRectMake(10, 85, 300, 91)];
    afv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.view addSubview:afv];
    //new1
    new1 = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, 270, 30)];
    new1.borderStyle = UITextBorderStyleNone;
    new1.placeholder = @"新しいパスワード";
    new1.secureTextEntry = YES;
    [afv addSubview:new1];
    new1.delegate = self;
    new1.tag = 1;
    UIImageView *passiv1 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 11, 15, 21)];
    passiv1.image = [UIImage imageNamed:@"iconPass.png"];
    [afv addSubview:passiv1];

    //new2
    new2 = [[UITextField alloc] initWithFrame:CGRectMake(40, 55, 270, 30)];
    new2.borderStyle = UITextBorderStyleNone;
    new2.placeholder = @"新しいパスワード（確認）";
    new2.secureTextEntry = YES;
    [afv addSubview:new2];
    new2.delegate = self;
    new2.tag = 2;
    //アイコン
    UIImageView *passiv2 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 56, 15, 21)];
    passiv2.image = [UIImage imageNamed:@"iconPass.png"];
    [afv addSubview:passiv2];
}

//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == 0){
        [new1 becomeFirstResponder];
    }else if(textField.tag == 1){
        [new2 becomeFirstResponder];
        //[self setViewMovedUp:YES];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)doneBtn:(id)sender{
    if(current.text.length == 0){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"現在のパスワードを入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if(![new1.text isEqualToString:new2.text]){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"新しいパスワードを正しく入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if(new1.text.length < 6){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"パスワードは６文字以上入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{
        NSString *dataa = [NSString stringWithFormat:@"user_id=%d&current=%@&new=%@&service=reader", myid, current.text, new1.text];
        NSURL *url = [NSURL URLWithString:URL_USER_PASS];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        NSLog(@"%@", [response valueForKeyPath:@"result"]);
        BOOL result = [[response valueForKeyPath:@"result"]boolValue];
        if(result){
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"成功" message:@"更新しました" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"現在のパスワードが一致しません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
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
