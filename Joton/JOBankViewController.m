//
//  JOBankViewController.m
//  Joton
//
//  Created by Val F on 13/04/08.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOBankViewController.h"

@interface JOBankViewController ()

@end

@implementation JOBankViewController

UITextField *sntf, *fntf, *bktf, *bntf, *antf, *tatf;
UIView *dd, *numberpad;
UIButton *baBtn, *rkBtn;
int reload, type, sheight, rakuten, stag, mbalance;

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

    self.navigationItem.title = @"お振り込み";

    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                               initWithTitle:@"キャンセル"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(cancelBtn:)];
    self.navigationItem.leftBarButtonItems = @[cancel];
    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *done = [[UIBarButtonItem alloc]
                             initWithTitle:@"確認"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(go:)];
    [done setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[done];

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 780)];

    type = 3; rakuten = 0; reload = 0;

    //枠
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(10, 13, 300, 61)];
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSumCoin.png"]];
    [self.scroll addSubview:fv];
    //見出し
    UILabel *iLabel = [[UILabel alloc] init];
    iLabel.frame = CGRectMake(0, 5, 300, 20);
    iLabel.backgroundColor = [UIColor clearColor];
    iLabel.textColor = [UIColor grayColor];
    iLabel.font = [UIFont systemFontOfSize:12];
    iLabel.text = @"　出品報酬";
    [fv addSubview:iLabel];

    //注意書き枠
    UIView *nfv = [[UIView alloc] initWithFrame:CGRectMake(10, 95, 300, 138)];
    nfv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgCaution.png"]];
    [self.scroll addSubview:nfv];
    //注意書きてきすと
    UILabel *c1label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 15)];
    c1label.backgroundColor = [UIColor clearColor];
    c1label.textColor = [UIColor grayColor];
    c1label.font = [UIFont systemFontOfSize:13];
    c1label.text = @" 振り込み可能金額　  1000円〜";
    [nfv addSubview:c1label];
    UILabel *c2label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 300, 70)];
    c2label.backgroundColor = [UIColor clearColor];
    c2label.textColor = [UIColor grayColor];
    c2label.font = [UIFont systemFontOfSize:13];
    c2label.lineBreakMode = NSLineBreakByWordWrapping;
    c2label.numberOfLines = 10;
    c2label.text = @" 振り込み予定日　　  毎月1日〜14日申請分を末日\n　　　　　　　　　   振り込み\n　　　　　　　　　   15日〜末日申請分を翌月15\n　　　　　　　　　   日に振り込み";
    [nfv addSubview:c2label];
    UILabel *c3label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 300, 70)];
    c3label.backgroundColor = [UIColor clearColor];
    c3label.textColor = [UIColor grayColor];
    c3label.font = [UIFont systemFontOfSize:13];
    c3label.lineBreakMode = NSLineBreakByWordWrapping;
    c3label.numberOfLines = 10;
    c3label.text = @" 手数料　　　　　　  楽天銀行：100円\n　　　　　　　　　   その他全国金融機関：160円";
    [nfv addSubview:c3label];

    //注意書きラベル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 237, 280, 80)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor redColor];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 10;
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.text = @"※振り込み先の入力に誤りがある場合、お振り込みできません。保有している出品報酬もなくなってしまいます。";
    [self.scroll addSubview:textLabel];

    //換金金額枠
    UIView *amlv = [[UIView alloc]initWithFrame:CGRectMake(10, 325, 300, 47)];
    amlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgFB.png"]];
    [self.scroll addSubview:amlv];
    //振込金額
    UILabel *taLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    taLabel.backgroundColor = [UIColor clearColor];
    taLabel.text = @"換金金額";
    [amlv addSubview:taLabel];
    tatf = [[UITextField alloc] initWithFrame:CGRectMake(110, 15, 185, 30)];
    tatf.borderStyle = UITextBorderStyleNone;
    tatf.keyboardType = UIKeyboardTypeNumberPad;
    tatf.placeholder = @"　　　　　半角数字";
    [amlv addSubview:tatf];
    tatf.delegate = self;
    tatf.tag = 1;

    //口座名義枠
    UIView *nlv = [[UIView alloc]initWithFrame:CGRectMake(10, 385, 300, 91)];
    nlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:nlv];
    //口座名義姓
    UILabel *snLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    snLabel.backgroundColor = [UIColor clearColor];
    snLabel.text = @"口座名義(姓)";
    [nlv addSubview:snLabel];
    sntf = [[UITextField alloc] initWithFrame:CGRectMake(110, 15, 185, 30)];
    sntf.borderStyle = UITextBorderStyleNone;
    sntf.placeholder = @"　　　　（全角カナ）";
    [nlv addSubview:sntf];
    sntf.delegate = self;

    //口座名義名
    UILabel *fnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 100, 30)];
    fnLabel.backgroundColor = [UIColor clearColor];
    fnLabel.text = @"口座名義(名)";
    [nlv addSubview:fnLabel];
    fntf = [[UITextField alloc] initWithFrame:CGRectMake(110, 58, 185, 30)];
    fntf.borderStyle = UITextBorderStyleNone;
    fntf.placeholder = @"　　　　（全角カナ）";
    [nlv addSubview:fntf];
    fntf.delegate = self;

    //楽天枠
    UIView *rklv = [[UIView alloc]initWithFrame:CGRectMake(10, 490, 300, 47)];
    rklv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgFB.png"]];
    [self.scroll addSubview:rklv];
    //楽天
    UILabel *rkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 260, 30)];
    rkLabel.text = @"楽天銀行の方はこちらにチェック";
    rkLabel.backgroundColor = [UIColor clearColor];
    [rklv addSubview:rkLabel];
    rkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rkBtn.frame = CGRectMake(270, 10, 24, 24);
    [rkBtn setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [rklv addSubview:rkBtn];
    [rkBtn addTarget:self action:@selector(rakuten:) forControlEvents:UIControlEventTouchUpInside];

    //金融機関枠
    UIView *blv = [[UIView alloc]initWithFrame:CGRectMake(10, 550, 300, 91)];
    blv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:blv];
    //金融機関名
    UILabel *bkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    bkLabel.backgroundColor = [UIColor clearColor];
    bkLabel.text = @"金融機関名";
    [blv addSubview:bkLabel];
    bktf = [[UITextField alloc] initWithFrame:CGRectMake(110, 15, 185, 30)];
    bktf.borderStyle = UITextBorderStyleNone;
    bktf.placeholder = @"　　　　　　（全角）";
    [blv addSubview:bktf];
    bktf.delegate = self;

    //支店名
    UILabel *bnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 100, 30)];
    bnLabel.backgroundColor = [UIColor clearColor];
    bnLabel.text = @"支店名";
    [blv addSubview:bnLabel];
    bntf = [[UITextField alloc] initWithFrame:CGRectMake(110, 58, 185, 30)];
    bntf.borderStyle = UITextBorderStyleNone;
    bntf.placeholder = @"　　　　　　（全角）";
    [blv addSubview:bntf];
    bntf.delegate = self;
    bntf.tag = 2;

    //口座枠
    UIView *alv = [[UIView alloc]initWithFrame:CGRectMake(10, 655, 300, 91)];
    alv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:alv];
    //口座種別
    UILabel *baLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    baLabel.backgroundColor = [UIColor clearColor];
    baLabel.text = @"口座種別";
    [alv addSubview:baLabel];
    baBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    baBtn.frame = CGRectMake(0, 5, 300, 40);
    [baBtn setBackgroundColor:[UIColor clearColor]];
    [baBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alv addSubview:baBtn];
    [baBtn addTarget:self action:@selector(ba:) forControlEvents:UIControlEventTouchUpInside];
    type = 0;
    UIImageView *aiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 11, 11, 17)];
    aiv.image = [UIImage imageNamed:@"iconArrow.png"];
    [baBtn addSubview:aiv];

    //口座番号
    UILabel *anLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 53, 100, 30)];
    anLabel.backgroundColor = [UIColor clearColor];
    anLabel.text = @"口座番号";
    [alv addSubview:anLabel];
    antf = [[UITextField alloc] initWithFrame:CGRectMake(110, 58, 185, 30)];
    antf.borderStyle = UITextBorderStyleNone;
    antf.keyboardType = UIKeyboardTypeNumberPad;
    antf.placeholder = @"　　　　半角数字7桁";
    [alv addSubview:antf];
    antf.delegate = self;
    antf.tag = 3;



    CGRect screenBound = [[UIScreen mainScreen] bounds];
    sheight = screenBound.size.height;

    //numberpadview
    numberpad = [[UIView alloc] init];
    numberpad.frame = CGRectMake(0, sheight, 320, 48);
    numberpad.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgHeader.png"]];
    [self.view addSubview:numberpad];
    //決定ボタン
    UIButton *pcd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pcd.frame = CGRectMake(252, 8, 56, 30);
    [pcd setBackgroundImage:[UIImage imageNamed:@"btnSubmitPost.png"] forState:UIControlStateNormal];
    [numberpad addSubview:pcd];
    [pcd addTarget:self action:@selector(pcd_pushed:) forControlEvents:UIControlEventTouchUpInside];

    /*//その他
    UIButton *ba3Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ba3Btn.frame = CGRectMake(0, 60, 100, 30);
    [ba3Btn setTitle:@"その他" forState:UIControlStateNormal];
    [dd addSubview:ba3Btn];
    [ba3Btn addTarget:self action:@selector(ba3:) forControlEvents:UIControlEventTouchUpInside];*/
}

- (void)viewDidAppear:(BOOL)animated{
    if(reload == 0){
        [self getbank];
        reload = 1;
    }
}

- (void)getbank{
    //ユーザーデフォルトからid取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int myid = [[ud stringForKey:@"userid"] intValue];
    //通信
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d", myid];
    NSURL *url = [NSURL URLWithString:URL_USER_BANK];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:60];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}
- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        mbalance = [[response valueForKeyPath:@"balance"]intValue];
        UILabel *talabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 150, 30)];
        talabel.text = [NSString stringWithFormat:@"%d 円", mbalance];
        [self.scroll addSubview:talabel];

        NSArray *bankinfo = [response valueForKeyPath:@"bank_info"];
        if([bankinfo count] > 0){
            sntf.text = [bankinfo valueForKeyPath:@"sir_name"];
            fntf.text = [bankinfo valueForKeyPath:@"first_name"];
            bktf.text = [bankinfo valueForKeyPath:@"bank"];
            bntf.text = [bankinfo valueForKeyPath:@"branch"];
            antf.text = [bankinfo valueForKeyPath:@"account_number"];
            int rktn = [[bankinfo valueForKeyPath:@"rakuten"]intValue];
            int tp = [[bankinfo valueForKeyPath:@"type"]intValue];
            if(rktn == 1){
                rakuten = 1;
                [rkBtn setBackgroundImage:[UIImage imageNamed:@"checkBoxSelect.png"] forState:UIControlStateNormal];
                bktf.text = @"楽天銀行";
                bktf.enabled = NO;
            }
            if(tp == 1){
                [baBtn setTitle:@"普通" forState:UIControlStateNormal];
                type = 1;
            }else{
                [baBtn setTitle:@"当座" forState:UIControlStateNormal];
                type = 2;
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//もしtextfieldが郵便番号だったらヘッダーだす
-(void)textFieldDidBeginEditing:(UITextField *)sender{
    stag = sender.tag;
    if(sender.tag == 3){
        NSLog(@"numberpad!");
        numberpad.frame = CGRectMake(0, sheight-104, 320, 100);
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.3];
    }else if(sender.tag == 1){
        NSLog(@"numberpad!");
        numberpad.frame = CGRectMake(0, sheight-324, 320, 100);
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.3];
    }
}
- (void)pcd_pushed:(id)sender {
    //キーボードかくす
    [self.view endEditing:YES];
    numberpad.frame = CGRectMake(0, sheight, 320, 80);
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}

- (void)ba:(id)sender{
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = @"";
    [as addButtonWithTitle:@"普通"];
    [as addButtonWithTitle:@"当座"];
    //as.cancelButtonIndex = 2;
    //    as.destructiveButtonIndex = 0;
    [as showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [baBtn setTitle:@"普通" forState:UIControlStateNormal];
        type = 1;
    }else{
        [baBtn setTitle:@"当座" forState:UIControlStateNormal];
        type = 2;
    }
}

- (void)rakuten:(id)sender{
    if(rakuten == 0){
        rakuten = 1;
        [rkBtn setBackgroundImage:[UIImage imageNamed:@"checkBoxSelect.png"] forState:UIControlStateNormal];
        bktf.text = @"楽天銀行";
        bktf.enabled = NO;
    }else{
        rakuten = 0;
        [rkBtn setBackgroundImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        bktf.text = @"";
        bktf.enabled = YES;
    }
}

- (void)go:(id)sender{
    //入力されてるかチェック
    if(sntf.text.length == 0 || fntf.text.length == 0 || bktf.text.length == 0 || bntf.text.length == 0 || antf.text.length == 0 || type == 3 || tatf.text.length == 0){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"空欄" message:@"入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if([tatf.text intValue]>mbalance){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"金額" message:@"入力された金額が所持金学を越えています" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if([tatf.text intValue]<1000){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"金額" message:@"1000円以上入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if(![JOFunctionsDefined findKatakana:sntf.text] || ![JOFunctionsDefined findKatakana:fntf.text]){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"名前" message:@"全角カタカナで入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{
        JOBank2ViewController *bank2 = [self.storyboard instantiateViewControllerWithIdentifier:@"bank2"];
        bank2.sname = sntf.text;
        bank2.fname = fntf.text;
        bank2.rakuten = [NSString stringWithFormat:@"%d", rakuten];
        bank2.type = [NSString stringWithFormat:@"%d", type];
        bank2.bank = bktf.text;
        bank2.branch = bntf.text;
        bank2.number = antf.text;
        bank2.amount = tatf.text;
        [self.navigationController pushViewController:bank2 animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}
//keyboard出るときに画面あげるやつ
#define kOFFSET_FOR_KEYBOARD 220.0
-(void)keyboardWillShow {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
        NSLog(@"keyboardwillshow1");
        //pv.frame = CGRectMake(0, sheight, 320, 261);
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
        NSLog(@"keyboardwillhide1");
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
        NSLog(@"keyboardwillhide2");
    }
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    if(stag == 3 || stag == 2){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3]; // if you want to slide up the view
        CGRect rect = self.view.frame;
        if (movedUp){
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            [_scroll setContentSize:CGSizeMake(320, 1050)];
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
            NSLog(@"setviewmoveup1");
            //[UIView commitAnimations];
        }else{
            // revert back to the normal state.
            [_scroll setContentSize:CGSizeMake(320, 780)];
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            rect.size.height -= kOFFSET_FOR_KEYBOARD;
            NSLog(@"setviewmoveup2");
        }
        self.view.frame = rect;
        [UIView commitAnimations];
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

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
}

@end
