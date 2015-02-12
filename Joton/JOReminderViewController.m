//
//  JOReminderViewController.m
//  Joton
//
//  Created by Val F on 13/04/22.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOReminderViewController.h"

@interface JOReminderViewController ()

@end

@implementation JOReminderViewController

UITextField *rmailtf;
UIButton *sendBtn;
UIView *alertview;
UIImageView *mailiv;
UILabel *alert;

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

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *confirm=[[UIBarButtonItem alloc] initWithTitle:@"送信" style:UIBarButtonItemStyleBordered target:self action:@selector(remind:)];
    [confirm setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[confirm];

    //らべる
    UILabel *exLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 50)];
    exLabel.text = @"登録したメールアドレスを入力してください";
    exLabel.font = [UIFont systemFontOfSize:14];
    exLabel.textColor = [UIColor grayColor];
    exLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:exLabel];

    //枠
    UIView *mlv = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 300, 47)];
    mlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgFB.png"]];
    [self.view addSubview:mlv];
    //メアド記入欄
    rmailtf = [[UITextField alloc] initWithFrame:CGRectMake(40, 12, 250, 35)];
    rmailtf.borderStyle = UITextBorderStyleNone;
    rmailtf.placeholder = @"メールアドレス";
    rmailtf.keyboardType = UIKeyboardTypeEmailAddress;
    [mlv addSubview:rmailtf];
    rmailtf.delegate = self;
    //アイコン
    mailiv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 21, 16)];
    mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    [mlv addSubview:mailiv];

    //alertview
    alertview = [[UIView alloc]initWithFrame:CGRectMake(0, -33, 320, 30)];
    alertview.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgError.png"]];
    [self.view addSubview:alertview];
    alert = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    alert.textColor = [UIColor whiteColor];
    alert.backgroundColor = [UIColor clearColor];
    [alertview addSubview:alert];
}

//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    return YES;
}

//alertバイバイ
- (void)onTimer:(NSTimer *)timer {
    [UIView animateWithDuration:0.5 animations:^
     {
         alertview.frame = CGRectMake(0, -33, 320, 33);
     }];
}

- (void)remind:(id)sender{
    [self.view endEditing:YES];
    if(rmailtf.text.length == 0){
        alert.text = @"入力してください";
        [UIView animateWithDuration:0.5 animations:^
         {
             alertview.frame = CGRectMake(0, 0, 320, 33);
         }];
        mailiv.image = [UIImage imageNamed:@"iconMailError.png"];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES '^[0-9a-zA-Z][0-9a-zA-Z_+-.]+@[0-9a-zA-Z][0-9a-zA-Z_.-]+.[a-zA-Z]+$'", rmailtf.text];
        BOOL matched = [predicate evaluateWithObject:nil];
        if(!matched){
            alert.text = @"有効なメールアドレスを入力してください";
            [UIView animateWithDuration:0.5 animations:^
             {
                 alertview.frame = CGRectMake(0, 0, 320, 33);
             }];
            mailiv.image = [UIImage imageNamed:@"iconMailError.png"];
            [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
        }else{
            sendBtn.enabled = NO;
            //通信
            NSString *dataa = [NSString stringWithFormat:@"mail=%@&service=reader", rmailtf.text];
            NSURL *url = [NSURL URLWithString:URL_REMINDER];
            //通信
            NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
            async = [JOAsyncConnection alloc];
            async.delegate = self;
            [async asyncConnect:request];
        }
    }
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        BOOL result = [[response valueForKeyPath:@"result"] boolValue];
        if(result){
            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"成功" message:@"メールを送信しました" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"メールを送信できませんでした" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            sendBtn.enabled = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
