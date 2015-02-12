//
//  JOMyeditViewController.m
//  Joton
//
//  Created by Val F on 13/04/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOMyeditViewController.h"

@interface JOMyeditViewController ()

@end

@implementation JOMyeditViewController

UIView *pv, *numberpad, *waiting;
UIActivityIndicatorView *ai, *fai;
UIPickerView *picker;
UIImagePickerController *ppicker;
CGFloat sheight;
int myid, mereload, stag, row1, county, postcode, p, cnct, fbc, fbcb, twc, twcb, cancelenabled;
NSString *myname, *email, *address;
UIImageView *iconView, *fbiv, *twiv;
UITextField *nametf, *mailtf, *pctf, *patv;
UIButton *areaBtn, *fbBtn, *twBtn;
UILabel *fbLabel, *twLabel;
NSArray *pickerData, *ores, *countyarray, *fbdata;
NSString *icondata;
UIBarButtonItem *cancel, *done;

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

    NSLog(@"myedit!!!!");
    mereload = 0;
    cancelenabled = 0;//1なら押せない
    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, 600)];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    self.navigationItem.title = @"ユーザー情報編集";

    //ナビゲーションバーにボタンを追加
    cancel = [[UIBarButtonItem alloc]
                                initWithTitle:@"キャンセル"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(cancelBtn:)];
    self.navigationItem.leftBarButtonItems = @[cancel];
    //ナビゲーションバーにボタンを追加
    done = [[UIBarButtonItem alloc]
                             initWithTitle:@"更新"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(go:)];
    [done setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[done];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    sheight = screenSize.height;

    //ユーザーデフォルトから基本情報取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [ud stringForKey:@"userid"];
    myid = [user_id intValue];
    myname = [ud stringForKey:@"username"];
    email = [ud stringForKey:@"email"];
    NSLog(@"email = %@", email);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];



    fai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(151, 115, 17, 17)];
    fai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [fai startAnimating];
    [self.view addSubview:fai];


    done.enabled = NO;



    //半透明view
    waiting = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,835)];
    waiting.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:waiting];

    UIView *lv = [[UIView alloc]initWithFrame:CGRectMake(90, 160, 140, 80)];
    lv.backgroundColor = [UIColor whiteColor];
    lv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    lv.layer.borderWidth = 1.0;
    lv.layer.cornerRadius = 5;
    [waiting addSubview:lv];

    UILabel *load = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 140, 30)];
    load.text = @"　読み込み中です...";
    load.font = [UIFont systemFontOfSize:14];
    [lv addSubview:load];

    ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(61, 15, 17, 17)];
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [ai startAnimating];
    [lv addSubview:ai];
    waiting.hidden = TRUE;


    countyarray = [[NSArray alloc] initWithObjects:@"-",@"北海道",@"青森県",@"秋田県",@"岩手県",@"山形県",@"宮城県",@"福島県",@"群馬県",@"栃木県",@"茨城県",@"埼玉県",@"千葉県",@"東京都",@"神奈川県",@"新潟県",@"富山県",@"石川県",@"福井県",@"山梨県",@"長野県",@"岐阜県",@"静岡県",@"愛知県",@"三重県",@"滋賀県",@"京都府",@"大阪府",@"兵庫県",@"奈良県",@"和歌山県",@"鳥取県",@"島根県",@"岡山県",@"広島県",@"山口県",@"徳島県",@"香川県",@"愛媛県",@"高知県",@"福岡県",@"佐賀県",@"長崎県",@"熊本県",@"大分県",@"宮崎県",@"鹿児島県",@"沖縄県",@"その他", nil];
    pickerData = countyarray;

    //都道府県pickerを置くview
    pv = [[UIView alloc] initWithFrame:CGRectMake(0, sheight, 320, 264)];
    [self.view addSubview:pv];
    //navbar直接貼っちゃう
    UIImage *navimg = [UIImage imageNamed:@"bgHeader.png"];
    UIImageView *navbar = [[UIImageView alloc] initWithImage:navimg];
    navbar.frame = CGRectMake(0, 0, 320, 48);
    [pv addSubview:navbar];
    //doneボタン
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(250, 10, 56, 30);
    [doneBtn setImage:[UIImage imageNamed:@"btnSelectArea.png"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(areadone:) forControlEvents:UIControlEventTouchUpInside];
    [pv addSubview:doneBtn];
    //pickerおく
    picker = [[UIPickerView alloc] init];
    picker.frame = CGRectMake(0, 48, 320, 216);
    picker.showsSelectionIndicator = YES;
    [pv addSubview:picker];
    picker.delegate = self;


    twFunc = [JOTwitterFunction alloc];
	twFunc.delegate = self;


    //numberpadview
    numberpad = [[UIView alloc] init];
    numberpad.frame = CGRectMake(0, sheight, 320, 48);
    numberpad.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgHeader.png"]];
    [self.view addSubview:numberpad];
    //検索ボタン
    UIButton *pcs = [UIButton buttonWithType:UIButtonTypeCustom];
    pcs.frame = CGRectMake(185, 10, 56, 30);
    [pcs setImage:[UIImage imageNamed:@"btnSearchPost.png"] forState:UIControlStateNormal];
    [numberpad addSubview:pcs];
    [pcs addTarget:self action:@selector(pcs_pushed:) forControlEvents:UIControlEventTouchUpInside];
    //決定ボタン
    UIButton *pcd = [UIButton buttonWithType:UIButtonTypeCustom];
    pcd.frame = CGRectMake(252, 10, 56, 30);
    [pcd setImage:[UIImage imageNamed:@"btnSubmitPost.png"] forState:UIControlStateNormal];
    [numberpad addSubview:pcd];
    [pcd addTarget:self action:@selector(pcd_pushed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated{
    if(mereload == 0){
        [self getmyinfo];
        mereload = 1;
    }
}

- (void)getmyinfo{
    cnct = 0;
    //通信
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&service=reader", myid];
    NSURL *url = [NSURL URLWithString:URL_USER_CONNECT];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if(cnct == 0){
            ores = response;
            [self draw];
        }else if(cnct == 1){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[response valueForKeyPath:@"fb_seq_id"] forKey:@"fb_seq_id"];
            [defaults setObject:[response valueForKeyPath:@"tw_seq_id"] forKey:@"tw_seq_id"];
            BOOL result = [[response valueForKeyPath:@"result"] boolValue];
            if(result){
                [JOToastUtil showToast:@"更新しました"];
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
                [ud setObject:[response valueForKeyPath:@"tw_seq_id"] forKey:@"tw_seq_id"];
                [ud setObject:[response valueForKeyPath:@"county"] forKey:@"county"];
                [ud setObject:[response valueForKeyPath:@"p_address"] forKey:@"paddress"];
                [ud setObject:[response valueForKeyPath:@"postcode"] forKey:@"postcode"];
                [ud setObject:[response valueForKeyPath:@"push"] forKey:@"push"];
                [ud setObject:[response valueForKeyPath:@"icon"] forKey:@"user_icon"];
                [ud setObject:[response valueForKeyPath:@"postcode"] forKey:@"postcode"];
                [ud setObject:[response valueForKeyPath:@"p_address"] forKey:@"address"];
                NSString *name = [response valueForKeyPath:@"user_name"];
                [ud setObject:name forKey:@"username"];
                [ud setObject:[response valueForKeyPath:@"email"] forKey:@"email"];
                [ud synchronize];
                NSLog(@"response = %@", [response description]);
                NSLog(@"new email = %@", [response valueForKeyPath:@"email"]);
                // 通知を作成する
                NSNotification *n = [NSNotification notificationWithName:@"myupdated" object:self];
                // 通知実行！
                [[NSNotificationCenter defaultCenter] postNotification:n];
                //モーダルバイバイ
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                int mcd = [[response valueForKeyPath:@"message_cd"] intValue];
                if(mcd == 1){
                    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"メールアドレスを変更できませんでした" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                    [alert show];
                }else{
                    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                    [alert show];
                }
            }
            cancel.enabled = YES;
            done.enabled = YES;
            waiting.hidden = TRUE;
        }else{
            [self postcode:response];
        }
    }
    cancelenabled = 0;
}

- (void)draw{

    [fai stopAnimating];
    fai.hidden = TRUE;

    //プロフィール
    UILabel *prlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    prlabel.text = @"プロフィール";
    prlabel.font = [UIFont boldSystemFontOfSize:14];
    prlabel.backgroundColor = [UIColor clearColor];
    prlabel.textColor = [UIColor grayColor];
    [self.scroll addSubview:prlabel];
    //枠
    UIView *prv = [[UIView alloc]initWithFrame:CGRectMake(10, 30, 300, 137)];
    prv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgProfile.png"]];
    [self.scroll addSubview:prv];
    //入力欄
    nametf = [[UITextField alloc]initWithFrame:CGRectMake(40, 13, 250, 30)];
    nametf.borderStyle = UITextBorderStyleNone;
    nametf.placeholder = @"ユーザー名";
    nametf.text = myname;
    nametf.textColor = [UIColor colorWithWhite:0.17 alpha:1.0];
    [prv addSubview:nametf];
    nametf.delegate = self;
    nametf.tag = 1;
    //アイコン
    UIImageView *nameiv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    nameiv.image = [UIImage imageNamed:@"iconUsername.png"];
    [prv addSubview:nameiv];
    //アイコンボタン
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 80, 80)];
    iconView.image = [UIImage imageNamed:@"iconUser.png"];
    [prv addSubview:iconView];
    //ボタン
    UIButton *iconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconbtn.frame = CGRectMake(5, 50, 290, 90);
    [iconbtn setTitle:@"　　　アイコンを選択" forState:UIControlStateNormal];
    [iconbtn setBackgroundColor:[UIColor clearColor]];
    [iconbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [iconbtn setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [prv addSubview:iconbtn];
    [iconbtn addTarget:self action:@selector(iconBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //アカウント
    UILabel *aclabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, 200, 20)];
    aclabel.text = @"アカウント";
    aclabel.font = [UIFont boldSystemFontOfSize:14];
    aclabel.backgroundColor = [UIColor clearColor];
    aclabel.textColor = [UIColor grayColor];
    [self.scroll addSubview:aclabel];
    //枠
    UIView *afv = [[UIView alloc]initWithFrame:CGRectMake(10, 200, 300, 91)];
    afv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:afv];
    //編集欄
    mailtf = [[UITextField alloc]initWithFrame:CGRectMake(40, 12, 250, 30)];
    mailtf.borderStyle = UITextBorderStyleNone;
    mailtf.textColor = [UIColor colorWithWhite:0.17 alpha:1.0];
    mailtf.font = [UIFont systemFontOfSize:14.3];
    mailtf.placeholder = @"メールアドレス(ログインID)";
    mailtf.text = email;
    mailtf.keyboardType = UIKeyboardTypeEmailAddress;
    [afv addSubview:mailtf];
    mailtf.delegate = self;
    mailtf.tag = 0;
    //アイコン
    UIImageView *mailiv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 21, 16)];
    mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    [afv addSubview:mailiv];
    //アイコン
    UIImageView *passiv = [[UIImageView alloc] initWithFrame:CGRectMake(13, 56, 15, 21)];
    passiv.image = [UIImage imageNamed:@"iconPass.png"];
    [afv addSubview:passiv];
    //パスワード変更ぼたん
    UIButton *passbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passbtn.frame = CGRectMake(40, 250, 270, 35);
    [passbtn setBackgroundColor:[UIColor clearColor]];
    [passbtn setTitleColor:[UIColor colorWithWhite:0.17 alpha:1.0] forState:UIControlStateNormal];
    [passbtn setTitle:@"　パスワードを変更" forState:UIControlStateNormal];
    passbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    passbtn.titleLabel.font = [UIFont systemFontOfSize:14.3];
    [self.scroll addSubview:passbtn];
    [passbtn addTarget:self action:@selector(pass:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *parrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconArrow.png"]];
    parrow.frame = CGRectMake(245, 10, 11, 17);
    [passbtn addSubview:parrow];

    //アカウント
    UILabel *adlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 300, 200, 20)];
    adlabel.text = @"配送先";
    adlabel.font = [UIFont boldSystemFontOfSize:14];
    adlabel.backgroundColor = [UIColor clearColor];
    adlabel.textColor = [UIColor grayColor];
    [self.scroll addSubview:adlabel];
    //枠
    UIView *adv = [[UIView alloc]initWithFrame:CGRectMake(10, 320, 300, 135)];
    adv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAddress.png"]];
    [self.scroll addSubview:adv];
    //地域はる
    pctf = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 160, 30)];
    pctf.borderStyle = UITextBorderStyleNone;
    pctf.placeholder = @"郵便番号";
    pctf.textColor = [UIColor colorWithWhite:0.17 alpha:1.0];
    pctf.font = [UIFont systemFontOfSize:14.3];
    pctf.keyboardType = UIKeyboardTypeNumberPad;
    [adv addSubview:pctf];
    pctf.delegate = self;
    pctf.tag = 3;
    [picker selectRow:county inComponent:0 animated:NO];
    //編集ボタン
    areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    areaBtn.frame = CGRectMake(10, 50, 280, 35);
    [areaBtn setTitle:@"都道府県" forState:UIControlStateNormal];
    [areaBtn setTitleColor:[UIColor colorWithWhite:0.17 alpha:1.0] forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:14.3];
    areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [adv addSubview:areaBtn];
    [areaBtn addTarget:self action:@selector(area:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconArrow.png"]];
    arrow.frame = CGRectMake(275, 60, 11, 17);
    [adv addSubview:arrow];
    //編集欄
    patv = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 280, 30)];
    patv.borderStyle = UITextBorderStyleNone;
    patv.placeholder = @"住所";
    patv.textColor = [UIColor colorWithWhite:0.17 alpha:10];
    patv.font = [UIFont systemFontOfSize:14.3];
    [adv addSubview:patv];
    patv.delegate = self;
    patv.tag = 2;

    //シェア
    UILabel *shlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 465, 200, 20)];
    shlabel.text = @"シェア設定";
    shlabel.font = [UIFont boldSystemFontOfSize:14];
    shlabel.backgroundColor = [UIColor clearColor];
    shlabel.textColor = [UIColor grayColor];
    [self.scroll addSubview:shlabel];
    //枠
    UIView *shv = [[UIView alloc]initWithFrame:CGRectMake(10, 485, 300, 91)];
    shv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:shv];



    NSString *icon = [ores valueForKeyPath:@"icon"];
    county = [[ores valueForKeyPath:@"county"] intValue];
    postcode = [[ores valueForKeyPath:@"postcode"] intValue];
    address = [ores valueForKeyPath:@"p_address"];
    NSString *fb = [ores valueForKeyPath:@"fb_seq_id"];
    NSString *tw = [ores valueForKeyPath:@"tw_seq_id"];
    row1 = county;

    //アイコンをはる
    if(!(icon == nil || [icon isEqual:[NSNull null]])){
        NSString *url_photo=[NSString stringWithFormat:@"%@/%d/%@", URL_ICON, myid, icon];
        NSURL *urli = [NSURL URLWithString:url_photo];
        NSData *data = [NSData dataWithContentsOfURL:urli];
        UIImage *img = [UIImage imageWithData:data];
        iconView.image = img;
    }
    /*iv = [[UIImageView alloc] initWithImage:img];
    iv.frame = CGRectMake(185, 15, 120, 120);
    [self.scroll addSubview:iv];*/

    //地域をはる
    if(postcode != 0){
        pctf.text = [NSString stringWithFormat:@"%d",postcode];
    }
    [picker selectRow:county inComponent:0 animated:NO];
    if(county == 0){
        [areaBtn setTitle:@"都道府県" forState:UIControlStateNormal];
    }else{
        NSString *area = [countyarray objectAtIndex:county];
        [areaBtn setTitle:area forState:UIControlStateNormal];
    }
    if(!(address == nil || [address isEqual:[NSNull null]])){
        patv.text = address;
    }


    //fbコネクト
    fbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fbBtn.frame = CGRectMake(10, 490, 300, 36);
    fbBtn.backgroundColor = [UIColor clearColor];
    [fbBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    fbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    fbBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    fbLabel = [[UILabel alloc] init];
    fbLabel.frame = CGRectMake(0, 0, 190, 36);
    fbLabel.backgroundColor = [UIColor clearColor];
    fbLabel.font = [UIFont boldSystemFontOfSize:15];
    fbLabel.text = @" 　　　facebook";
    [fbBtn addSubview:fbLabel];
    fbiv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    [fbBtn addSubview:fbiv];
    if(fb == nil || [fb isEqual:[NSNull null]]){
        fbc = 1; fbcb = 1;
        [fbBtn setTitle:@"-　" forState:UIControlStateNormal];
        [fbBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        fbLabel.textColor = [UIColor grayColor];
        fbiv.image = [UIImage imageNamed:@"iconFbEdit.png"];
    }else{
        fbc = 2; fbcb = 2;
        fbdata = [ores valueForKeyPath:@"fb"];
        [fbBtn setTitle:[fbdata valueForKeyPath:@"name"] forState:UIControlStateNormal];
        [fbBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        fbLabel.textColor = [UIColor blackColor];
        fbiv.image = [UIImage imageNamed:@"iconFbEditOn.png"];
    }
    [self.scroll addSubview:fbBtn];
    [fbBtn addTarget:self action:@selector(fb:) forControlEvents:UIControlEventTouchUpInside];


    //twコネクト
    twBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twBtn.frame = CGRectMake(10, 535, 300, 36);
    twBtn.backgroundColor = [UIColor clearColor];
    [twBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [twBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    twBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    twBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.scroll addSubview:twBtn];
    [twBtn addTarget:self action:@selector(tw:) forControlEvents:UIControlEventTouchUpInside];
    twLabel = [[UILabel alloc] init];
    twLabel.frame = CGRectMake(0, 0, 190, 36);
    twLabel.backgroundColor = [UIColor clearColor];
    twLabel.textColor = [UIColor grayColor];
    twLabel.font = [UIFont boldSystemFontOfSize:15];
    twLabel.text = @" 　　　twitter";
    twiv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    [twBtn addSubview:twiv];
    if(tw == nil || [tw isEqual:[NSNull null]]){
        twc = 1; twcb = 1;
        [twBtn setTitle:@"-　" forState:UIControlStateNormal];
        [twBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        twLabel.textColor = [UIColor grayColor];
        twiv.image = [UIImage imageNamed:@"iconTwEdit.png"];
    }else{
        //twのなまえはる
        twc = 2; twcb = 2;
        NSArray *twdata = [ores valueForKeyPath:@"tw"];
        [twBtn setTitle:[twdata valueForKeyPath:@"screen_name"] forState:UIControlStateNormal];
        [twBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        twLabel.textColor = [UIColor blackColor];
        twiv.image = [UIImage imageNamed:@"iconTwEditOn.png"];
    }
    [twBtn addSubview:twLabel];

    cancel.enabled = YES;
    done.enabled = YES;
}

- (void)iconBtn:(id)sender{
    [self.scroll endEditing:YES];
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = @"";
    [as addButtonWithTitle:@"写真を撮る"];
    [as addButtonWithTitle:@"既存から選ぶ"];
    [as addButtonWithTitle:@"キャンセル"];
    as.cancelButtonIndex = 2;
    //    as.destructiveButtonIndex = 0;
    [as showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        p = 1;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            // カメラかライブラリからの読み込み指定。カメラを指定
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            // トリミングなどを行うか否か
            [imagePickerController setAllowsEditing:YES];
            // Delegateをセット
            imagePickerController.delegate = self;
            // アニメーションをしてカメラUIを起動
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if (buttonIndex == 1) {
        p = 2;
        ppicker = [[UIImagePickerController alloc] init];
        ppicker.delegate = self;
        ppicker.allowsEditing = YES;
        //        picker.sourceType = (sender == takePictureButton) ?    UIImagePickerControllerSourceTypeCamera :
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController: ppicker animated:YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    photoFunc = [JOPhotoFunction alloc];
    photoFunc.delegate = self;
    [photoFunc photoFunction:info size:320.0f camera:p];
    NSLog(@"go!");
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion: nil];
}

- (void)didFinishWithPhotoFunction:(UIImage *)aImage width:(int)w height:(int)h{
    NSLog(@"back1");
    iconView.image = aImage;
    NSData *data2 = UIImagePNGRepresentation(aImage);
    icondata = [data2 base64EncodedString];
}

- (void)pass:(id)sender{
    JOMyeditViewController *pass = [self.storyboard instantiateViewControllerWithIdentifier:@"pass"];
    [self.navigationController pushViewController:pass animated:YES];
}

- (void)hideKeyboard{
    [self.scroll endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^
     {
         numberpad.frame = CGRectMake(0, sheight, 320, 80);
     }];
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, 0, 320, self.scroll.bounds.size.height);
     }];
    pv.frame = CGRectMake(0, sheight, 320, 260);
}

- (void)area:(id)sender {
    [self.scroll endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^
     {
         numberpad.frame = CGRectMake(0, sheight, 320, 80);
     }];
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, -70, 320, self.scroll.bounds.size.height);
     }];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pv.frame = CGRectMake(0, sheight-278-44, 320, 260);
    [UIView commitAnimations];
}

- (void)areadone:(id)sender {
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, 0, 320, self.scroll.bounds.size.height);
     }];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pv.frame = CGRectMake(0, sheight, 320, 260);
    [UIView commitAnimations];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger) pickerView: (UIPickerView*)pView
 numberOfRowsInComponent:(NSInteger) component {
    return 49;
}
- (NSString*)pickerView: (UIPickerView*)pView
            titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    if (component==0) {
        for(int j=0 ; j<=48 ; j++){
            if(row == j){
                return [pickerData objectAtIndex:j];
                NSLog(@"j = %d", j);
            }
        }
    }
    return [NSString stringWithFormat:@"0"];
}
- (void) pickerView: (UIPickerView*)pView
       didSelectRow:(NSInteger) row inComponent:(NSInteger)component {

    row1 = [picker selectedRowInComponent:0];//0列目が選択されているindex
    NSString *selected = [pickerData objectAtIndex:row1];
    [areaBtn setTitle:selected forState:UIControlStateNormal];
}

//もしtextfieldが郵便番号だったらヘッダーだす
-(void)textFieldDidBeginEditing:(UITextField *)sender{
    [UIView setAnimationDuration:0.3];
    pv.frame = CGRectMake(0, sheight, 320, 260);
    [UIView commitAnimations];
    if(sender.tag == 3){
        NSLog(@"numberpad!");
        [UIView animateWithDuration:0.3 animations:^
         {
             numberpad.frame = CGRectMake(0, sheight-326, 320, 80);
         }];
        [UIView animateWithDuration:0.3 animations:^
         {
             self.scroll.frame = CGRectMake(0, -50, 320, self.scroll.bounds.size.height);
         }];
        [self.scroll setContentOffset:CGPointMake(0.0f, self.scroll.contentSize.height - self.scroll.bounds.size.height) animated:NO];
        stag = 3;
    }else if(sender.tag == 2){
        stag = sender.tag;
        [UIView animateWithDuration:0.3 animations:^
         {
             self.scroll.frame = CGRectMake(0, -80, 320, self.scroll.bounds.size.height);
         }];
        numberpad.frame = CGRectMake(0, sheight, 320, 80);
    }else{
        stag = sender.tag;
        numberpad.frame = CGRectMake(0, sheight, 320, 80);
    }
}
- (BOOL)textField:(UITextField *)tfpc shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(stag == 3){
        NSUInteger newLength = [tfpc.text length] + [string length] - range.length;
        return (newLength > 7) ? NO : YES;
    }else{
        return YES;
    }
}
//郵便番号から住所検索
- (void)pcs_pushed:(id)sender {
    [self pcsearch];
    //キーボードかくす
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^
     {
         numberpad.frame = CGRectMake(0, sheight, 320, 80);
     }];
}
- (void)pcsearch{
    cnct = 3;
    NSString *dataa = [NSString stringWithFormat:@"postcode=%d&service=reader", [pctf.text intValue]];
    NSURL *url = [NSURL URLWithString:URL_POSTCODE];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}
- (void)postcode:(NSArray*)addresses{
    int error = [[addresses valueForKeyPath:@"error"]intValue];
    NSString *address = [addresses valueForKeyPath:@"address"];
    NSString *city = [addresses valueForKeyPath:@"city"];
    NSString *state = [addresses valueForKeyPath:@"state"];
    if(error == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"郵便番号は7桁の半角数字を入力してください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }else if((state == nil || [state isEqual:[NSNull null]])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"該当の住所が見つかりません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    //住所を入力
    if(!(state == nil || [state isEqual:[NSNull null]])){
        [areaBtn setTitle:state forState:UIControlStateNormal];
        [picker selectRow:[countyarray indexOfObject:state] inComponent:0 animated:NO];
        row1 = [countyarray indexOfObject:state];
    }
    if(!(city == nil || [city isEqual:[NSNull null]])){
        patv.text = city;
    }
    if(!(address == nil || [address isEqual:[NSNull null]])){
        patv.text = [NSString stringWithFormat:@"%@ %@", patv.text, address];
    }
}

- (void)pcd_pushed:(id)sender {
    [self.view endEditing:YES];
    numberpad.frame = CGRectMake(0, sheight, 320, 80);
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, 0, 320, self.scroll.bounds.size.height);
     }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, 0, 320, self.scroll.bounds.size.height);
     }];
    [textField resignFirstResponder];
    return YES;
}
//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//fbコネクト
- (void)fb:(id)sender{
    if(fbc == 1){
        JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];

        if (![appDelegate.facebook isSessionValid]) {
            [appDelegate.facebook authorize:nil];
        }else{
            [appDelegate fbDidLogin];
        }
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(fbconnected) name:@"fbrequested" object:nil];
    }else{
        UIAlertView *alertd = [[UIAlertView alloc]
                               initWithTitle:@"確認"
                               message:@"facebook連携をはずします"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"OK", nil];
        alertd.alertViewStyle = UIAlertViewStyleDefault;
        alertd.tag = 2;
        [alertd show];
    }
}
- (void)fbconnected{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    fbdata = [defaults valueForKeyPath:@"fbdata"];
    if(fbdata){
        NSLog(@"yeeaaaaaaah");
        [fbBtn setTitle:[fbdata valueForKeyPath:@"name"] forState:UIControlStateNormal];
        [fbBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        fbLabel.textColor = [UIColor blackColor];
        fbiv.image = [UIImage imageNamed:@"iconFbEditOn.png"];
        fbc = 2;
    }
}

//fbコネクト
- (void)tw:(id)sender{
    if(twc == 1){
        BOOL isTwConnect = [twFunc isTwitterConnect];
		if(!isTwConnect){
			//TwitterコネクトOPEN
            twBtn.enabled = NO;
		    [twFunc openTwitterConnect:self];
		}else{
			// 認証済みの処理
			twc = 2; twcb = 2;
            NSArray *twdata = [ores valueForKeyPath:@"tw"];
            [twBtn setTitle:[twdata valueForKeyPath:@"screen_name"] forState:UIControlStateNormal];
            [twBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            twLabel.textColor = [UIColor blackColor];
            twiv.image = [UIImage imageNamed:@"iconTwEditOn.png"];
		}
    }else{
        UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"確認" message:@"twitter連携をはずします" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertd.alertViewStyle = UIAlertViewStyleDefault;
        alertd.tag = 3;
        [alertd show];
    }
}
- (void)didFinishWithTwitterConnect:(BOOL)result{
    NSLog(@"welcome back.");
	//Twitter認証の戻り先
    if (result) {
		// 認証に成功したときの処理
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tw_name = [defaults stringForKey:@"TWScreenName"];

		[twBtn setTitle:tw_name forState:UIControlStateNormal];
        [twBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        twLabel.textColor = [UIColor blackColor];
        twiv.image = [UIImage imageNamed:@"iconTwEditOn.png"];
        twc = 2;
    }else{
        // 認証に失敗したときの処理
        [twBtn setTitle:@"-　" forState:UIControlStateNormal];
        [twBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        twLabel.textColor = [UIColor grayColor];
        twiv.image = [UIImage imageNamed:@"iconTwEdit.png"];
        twc = 1;
	}
    twBtn.enabled = YES;
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)go:(id)sender{
    [self.scroll endEditing:YES];
    NSString *icon = icondata;
    NSString *name = nametf.text;
    NSString *mail = mailtf.text;
    NSString *paddress = patv.text;
    //int area = row1;
    int pcode = [pctf.text intValue];
    if((icon == nil || [icon isEqual:[NSNull null]] || [icon isEqualToString:@""]) && [name isEqualToString:myname] && [mail isEqualToString:email] && [paddress isEqualToString:address] && row1 == county && pcode == postcode && fbc == fbcb && twc == twcb){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *fb = [ud valueForKeyPath:@"fbdata"];
        NSLog(@"%@", [fbdata description]);
        NSLog(@"%@, %@", [fbdata valueForKeyPath:@"name"], [fb valueForKeyPath:@"name"]);
        if(fbc == 2 && [[fbdata valueForKeyPath:@"name"] isEqualToString:[fb valueForKeyPath:@"name"]]){
            //更新しないのでそのまま閉じる
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if(fbc == 1){
            //更新しないのでそのまま閉じる
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            if(name.length == 0 || mail.length == 0){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"空欄" message:@"必須項目を入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else if(![JOFunctionsDefined validEmail:mail]){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"有効なメールアドレスを入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else if([JOFunctionsDefined removeForeign:name] || (paddress.length != 0 && [JOFunctionsDefined removeForeign:paddress])){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"絵文字は入力できません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"この内容で登録します" message:@"確認" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                alertd.alertViewStyle = UIAlertViewStyleDefault;
                alertd.tag = 1;
                [alertd show];
            }
        }
    }else{
        /*if([email isEqualToString:mail]){
            mail = NULL;
        }*/
        if(name.length == 0 || mail.length == 0){
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"空欄" message:@"必須項目を入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }else if(mail.length > 0 && (![JOFunctionsDefined validEmail:mail])){
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"有効なメールアドレスを入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }else if([JOFunctionsDefined removeForeign:name] || (paddress.length != 0 && [JOFunctionsDefined removeForeign:paddress])){
            NSLog(@"name = %@, paddress = %@", name, paddress);
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"絵文字は入力できません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"この内容で登録します" message:@"確認" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alertd.alertViewStyle = UIAlertViewStyleDefault;
            alertd.tag = 1;
            [alertd show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1){
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1:
                if(fbc == fbcb){
                    NSArray *fb = [ores valueForKeyPath:@"fb"];
                    if(fbc == 2 && [[fbdata valueForKeyPath:@"name"] isEqualToString:[fb valueForKeyPath:@"name"]]){
                        //更新しないので０にする
                        fbc = 0;
                    }
                    NSLog(@"%@, %@", [fbdata valueForKeyPath:@"name"], [fb valueForKeyPath:@"name"]);
                }
                if(twc == 1){
                    //Twitterキーチェインの削除
                    [twFunc deleteTwitterConnect];
                }
                if(twc == twcb){
                    twc = 0;
                }
                if([email isEqualToString:mailtf.text]){
                    mailtf.text = NULL;
                }
                cancel.enabled = NO;
                done.enabled = NO;
                waiting.hidden = FALSE;
                cancelenabled = 1;//キャンセルボタン押せない
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *p_code = pctf.text;
                if(pctf.text.length == 0){
                    p_code = @"(null)";
                }
                NSLog(@"postcode = %@", pctf.text);
                NSLog(@"p_code = %@", p_code);
                //通信
                NSString *dataa = [NSString stringWithFormat:@"user_id=%d&icon=%@&name=%@&mail=%@&address=%@&county=%d&postcode=%@&fb=%d&fb_name=%@&fb_mail=%@&fb_token=%@&tw=%d&tw_name=%@&tw_token=%@&tw_secret=%@&service=reader", myid, icondata, [nametf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], mailtf.text, [patv.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], row1, p_code, fbc, [[fbdata valueForKeyPath:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [fbdata valueForKeyPath:@"email"], [ud valueForKeyPath:@"FBAccessTokenKey"], twc, [ud valueForKeyPath:@"TWScreenName"], [ud valueForKeyPath:@"TWAccessTokenKey"], [ud valueForKeyPath:@"TWAccessTokenSecret"]];
                NSURL *url = [NSURL URLWithString:URL_USER_UPDATE];
                //通信
                cnct = 1;
                NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:45];
                async = [JOAsyncConnection alloc];
                async.delegate = self;
                [async asyncConnect:request];
                break;
        }
    }else if(alertView.tag == 2){
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1://fb連携を切る
                fbc = 1;
                [fbBtn setTitle:@"-　" forState:UIControlStateNormal];
                [fbBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                fbLabel.textColor = [UIColor grayColor];
                fbiv.image = [UIImage imageNamed:@"iconFbEdit.png"];
                break;
        }
    }else if(alertView.tag == 3){
        switch(buttonIndex){
            case 0:
                break;
            case 1:
                twc = 1;
                [twBtn setTitle:@"-　" forState:UIControlStateNormal];
                [twBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                twLabel.textColor = [UIColor grayColor];
                twiv.image = [UIImage imageNamed:@"iconTwEdit.png"];
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelBtn:(id)sender {
    if(cancelenabled == 0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
}

@end