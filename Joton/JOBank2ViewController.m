//
//  JOBank2ViewController.m
//  Joton
//
//  Created by Val F on 13/06/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOBank2ViewController.h"

@interface JOBank2ViewController ()

@end

@implementation JOBank2ViewController

UIView *waiting;
UIBarButtonItem *done, *cancel;

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

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    self.navigationItem.title = @"お振り込み確認";

    //ナビゲーションバーにボタンを追加
    cancel = [[UIBarButtonItem alloc]
                               initWithTitle:@"キャンセル"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(cancelBtn:)];
    self.navigationItem.leftBarButtonItems = @[cancel];
    //ナビゲーションバーにボタンを追加
    done = [[UIBarButtonItem alloc]
                             initWithTitle:@"振り込む"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(go:)];
    [done setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[done];

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 480)];

    //せつめい
    UILabel *nlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 300, 20)];
    nlabel.text = @"以下の内容でお振り込みしてもよろしいですか?";
    nlabel.textColor = [UIColor darkGrayColor];
    nlabel.font = [UIFont systemFontOfSize:12.5];
    nlabel.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:nlabel];

    //手数料計算
    int fee;
    if([_rakuten intValue] == 1){
        fee = 100;
    }else{
        fee = 160;
    }

    //金額枠
    UIView *amlv = [[UIView alloc]initWithFrame:CGRectMake(10, 50, 300, 47)];
    amlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgFB.png"]];
    [self.scroll addSubview:amlv];
    //欄　グレー
    UILabel *glabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 30)];
    glabel.text = @"受取金額　　　　　- 　　 =";
    [amlv addSubview:glabel];
    UILabel *g2label = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 70, 30)];
    g2label.text = [NSString stringWithFormat:@"%@", _amount];
    g2label.textAlignment = NSTextAlignmentRight;
    g2label.backgroundColor = [UIColor clearColor];
    [amlv addSubview:g2label];
    //欄　赤
    UILabel *rlabel = [[UILabel alloc] initWithFrame:CGRectMake(176, 10, 100, 30)];
    rlabel.text = [NSString stringWithFormat:@"%d", fee];
    rlabel.backgroundColor = [UIColor clearColor];
    rlabel.textColor = [UIColor redColor];
    [amlv addSubview:rlabel];
    //欄　青
    UILabel *blabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 100, 30)];
    blabel.text = [NSString stringWithFormat:@"%d", [_amount intValue] - fee];
    blabel.backgroundColor = [UIColor clearColor];
    blabel.textColor = [UIColor blueColor];
    [amlv addSubview:blabel];

    //口座名義枠
    UIView *nlv = [[UIView alloc]initWithFrame:CGRectMake(10, 110, 300, 91)];
    nlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:nlv];
    //口座名義姓
    UILabel *snLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    snLabel.backgroundColor = [UIColor clearColor];
    snLabel.text = [NSString stringWithFormat:@"口座名義(姓)　　%@", _sname];
    [nlv addSubview:snLabel];
    //口座名義名
    UILabel *fnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 300, 30)];
    fnLabel.backgroundColor = [UIColor clearColor];
    fnLabel.text = [NSString stringWithFormat:@"口座名義(名)　　%@", _fname];
    [nlv addSubview:fnLabel];

    //金融機関枠
    UIView *blv = [[UIView alloc]initWithFrame:CGRectMake(10, 215, 300, 91)];
    blv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:blv];
    //金融機関名
    UILabel *bkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    bkLabel.backgroundColor = [UIColor clearColor];
    bkLabel.text = [NSString stringWithFormat:@"金融機関名　 　 %@", _bank];
    [blv addSubview:bkLabel];
    //支店名
    UILabel *bnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 300, 30)];
    bnLabel.backgroundColor = [UIColor clearColor];
    bnLabel.text = [NSString stringWithFormat:@"支店名　　　 　 %@", _branch];
    [blv addSubview:bnLabel];

    //口座枠
    UIView *alv = [[UIView alloc]initWithFrame:CGRectMake(10, 320, 300, 91)];
    alv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:alv];
    //口座種別
    UILabel *baLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    baLabel.backgroundColor = [UIColor clearColor];
    if([_type intValue] == 1){
        baLabel.text = @"口座種別　　　  普通";
    }else{
        baLabel.text = @"口座種別　　　  当座";
    }
    [alv addSubview:baLabel];
    //口座番号
    UILabel *anLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 300, 30)];
    anLabel.backgroundColor = [UIColor clearColor];
    anLabel.text = [NSString stringWithFormat:@"口座番号  　　　%@", _number];
    [alv addSubview:anLabel];

    //せつめい
    UILabel *exlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 415, 290, 50)];
    exlabel.text = @"※換金金額から振り込み手数料を引いた金額が実際に振り込まれます";
    exlabel.textColor = [UIColor lightGrayColor];
    exlabel.lineBreakMode = NSLineBreakByWordWrapping;
    exlabel.numberOfLines = 3;
    exlabel.font = [UIFont systemFontOfSize:12.5];
    exlabel.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:exlabel];



    //半透明view
    waiting = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,835)];
    waiting.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:waiting];
    waiting.hidden = TRUE;
}

- (void)go:(id)sender{
    //ユーザーデフォルトからid取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int myid = [[ud stringForKey:@"userid"] intValue];

    //通信まちの間，半透明viewで覆っておく
    cancel.enabled = NO;
    done.enabled = NO;
    waiting = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,835)];
    waiting.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:0.5];
    [self.view addSubview:waiting];
    //通信
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&sir_name=%@&first_name=%@&rakuten=%d&bank=%@&account_type=%d&branch=%@&account_number=%@&total_amount=%@&service=reader", myid, [_sname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_fname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_rakuten intValue], [_bank stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_type intValue], [_branch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _number, _amount];
    NSURL *url = [NSURL URLWithString:URL_MONEY_BANK];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:60];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        NSArray *bres = response;
        BOOL result = [[bres valueForKeyPath:@"result"] boolValue];
        if(result){
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"成功" message:@"送信しました" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            // 通知を作成する
            NSNotification *n = [NSNotification notificationWithName:@"moneyupdated" object:self];
            // 通知実行！
            [[NSNotificationCenter defaultCenter] postNotification:n];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *mcd = [bres valueForKeyPath:@"message_cd"];
            if([mcd intValue] == 1){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"残高が足りません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else if([mcd intValue] == 2){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"この口座はすでに登録されています" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else if([mcd intValue] == 3){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"入力エラー" message:@"入力内容を確認してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else if([mcd intValue] == 4){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"入力エラー" message:@"1000円以上でないと振り込みできません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }
            waiting.hidden = TRUE;
        }
    }
    done.enabled = YES;
    cancel.enabled = YES;
    waiting.hidden = TRUE;
}

- (void)cancelBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
