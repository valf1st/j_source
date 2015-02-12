//
//  JOEnterViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOEnterViewController.h"


@interface JOEnterViewController ()

@end

@implementation JOEnterViewController

UITextView *cmtv;
UIButton *cd1button, *cd2button, *cd3button, *cd4button, *sz1button, *sz2button, *sz3button, *sz4button, *lcbutton , *fbbutton, *twbutton, *pt1button, *pt2button, *pt3button;
int cd, ms1, ms2, sz, fb, tw, connect;
UIImageView *ms1iv, *ms2iv, *fbiv, *twiv, *img2, *img3, *lciv;
NSString *placeholder = @"コメントを入力してください";

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

    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, 680)];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self.navigationController setNavigationBarHidden:NO animated:NO];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];

    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *confirm=[[UIBarButtonItem alloc] initWithTitle:@"確認へ" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonnext:)];
    [confirm setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[confirm];

    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem=backButton;

    //写真欄
    UILabel *lbbg = [[UILabel alloc] init];
    lbbg.frame = CGRectMake(10, 10, 300, 105);
    lbbg.backgroundColor = [UIColor whiteColor];
    lbbg.layer.cornerRadius = 5;
    lbbg.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    lbbg.layer.borderWidth = 1.0;
    [self.scroll addSubview:lbbg];
    //photo1
    pt1button = [UIButton buttonWithType:UIButtonTypeCustom];
    [pt1button setBackgroundImage:image1 forState:UIControlStateNormal];
    pt1button.frame = CGRectMake(20, 62.5-42.5*[_h1 intValue]/[_w1 intValue], 85, 85*[_h1 intValue]/[_w1 intValue]);
    [self.scroll addSubview:pt1button];
    [pt1button addTarget:self action:@selector(morephoto:) forControlEvents:UIControlEventTouchUpInside];
    pt1button.tag = 1;
    //入力欄
    cmtv = [[UITextView alloc] initWithFrame:CGRectMake(110, 20, 188, 85)];
    //tft.borderStyle = UITextBorderStyleRoundedRect;
    cmtv.textColor = [UIColor blueColor];
    cmtv.text = placeholder;
    cmtv.textColor = [UIColor lightGrayColor];
    cmtv.layer.borderWidth = 1.0f;
    cmtv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.scroll addSubview:cmtv];
    cmtv.delegate = self;


    //コンディションラベル
    UILabel *cdl = [[UILabel alloc] initWithFrame:CGRectMake(15, 115, 50, 40)];
    cdl.backgroundColor = [UIColor clearColor];
    cdl.textColor = [UIColor grayColor];
    cdl.font = [UIFont boldSystemFontOfSize:15];
    cdl.text = @" 状態";
    [self.scroll addSubview:cdl];
    //コンディション枠
    UIView *cdv = [[UIView alloc] init];
    cdv.frame = CGRectMake(10, 150, 300, 40);
    cdv.backgroundColor = [UIColor whiteColor];
    cdv.layer.cornerRadius = 5;
    cdv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    cdv.layer.borderWidth = 1.0;
    [self.scroll addSubview:cdv];

    //コンディション１
    cd1button = [UIButton buttonWithType:UIButtonTypeCustom];
    cd1button.frame = CGRectMake(8, 5, 65, 32);
    [cd1button setTitle:@"新品" forState:UIControlStateNormal];
    [cd1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cd1button setBackgroundColor:[UIColor clearColor]];
    //cd1button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cd1button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd1button addTarget:self action:@selector(cd1:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd1button];
    //コンディション２
    cd2button = [UIButton buttonWithType:UIButtonTypeCustom];
    cd2button.frame = CGRectMake(82, 5, 65, 32);
    //cd2button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cd2button setTitle:@"新品同様" forState:UIControlStateNormal];
    [cd2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cd2button setBackgroundColor:[UIColor clearColor]];
    //cd2button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cd2button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd2button addTarget:self action:@selector(cd2:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd2button];
    //コンディション３
    cd3button = [UIButton buttonWithType:UIButtonTypeCustom];
    cd3button.frame = CGRectMake(160, 5, 60, 32);
    [cd3button setTitle:@"普通" forState:UIControlStateNormal];
    [cd3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cd3button setBackgroundColor:[UIColor clearColor]];
    //cd3button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cd3button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd3button addTarget:self action:@selector(cd3:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd3button];
    //コンディション４
    cd4button = [UIButton buttonWithType:UIButtonTypeCustom];
    cd4button.frame = CGRectMake(230, 5, 65, 32);
    [cd4button setTitle:@"劣る" forState:UIControlStateNormal];
    [cd4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cd4button setBackgroundColor:[UIColor clearColor]];
    //cd4button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cd4button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd4button addTarget:self action:@selector(cd4:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd4button];
    //たてせん
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 1, 40)];
    line1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [cdv addSubview:line1];
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 1, 40)];
    line2.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [cdv addSubview:line2];
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(225, 0, 1, 40)];
    line3.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [cdv addSubview:line3];



    //配送方法ラベル
    UILabel *msl = [[UILabel alloc] initWithFrame:CGRectMake(15, 185, 100, 45)];
    msl.textColor = [UIColor grayColor];
    msl.backgroundColor = [UIColor clearColor];
    msl.font = [UIFont boldSystemFontOfSize:15];
    msl.text = @" 配送方法";
    [self.scroll addSubview:msl];

    //配送方法枠
    UIView *msv = [[UIView alloc] init];
    msv.backgroundColor = [UIColor whiteColor];
    msv.frame = CGRectMake(10, 220, 300, 45);
    msv.backgroundColor = [UIColor whiteColor];
    msv.layer.cornerRadius = 5;
    msv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    msv.layer.borderWidth = 1.0;
    [self.scroll addSubview:msv];
    //手渡し
    UIButton *ms1button = [UIButton buttonWithType:UIButtonTypeCustom];
    ms1button.frame = CGRectMake(30, 5, 100, 35);
    [ms1button setTitle:@"手渡し 　　" forState:UIControlStateNormal];
    [ms1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    ms1button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    ms1button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [ms1button addTarget:self action:@selector(ms1:) forControlEvents:UIControlEventTouchUpInside];
    [msv addSubview:ms1button];
    ms1iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBox.png"]];
    ms1iv.frame = CGRectMake(15, 10, 24, 24);
    [msv addSubview:ms1iv];
    //元払い
    UIButton *ms2button = [UIButton buttonWithType:UIButtonTypeCustom];
    ms2button.frame = CGRectMake(180, 5, 100, 35);
    [ms2button setTitle:@"着払い 　　" forState:UIControlStateNormal];
    [ms2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    ms2button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    ms2button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [ms2button addTarget:self action:@selector(ms2:) forControlEvents:UIControlEventTouchUpInside];
    [msv addSubview:ms2button];
    ms2iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBox.png"]];
    ms2iv.frame = CGRectMake(165, 10, 24, 24);
    [msv addSubview:ms2iv];
    //たてせん
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 1, 45)];
    line4.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [msv addSubview:line4];

    //大きさの目安ラベル
    UILabel *szlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 265, 100, 41)];
    szlabel.textColor = [UIColor grayColor];
    szlabel.backgroundColor = [UIColor clearColor];
    szlabel.font = [UIFont boldSystemFontOfSize:15];
    szlabel.text = @" サイズ";
    [self.scroll addSubview:szlabel];
    //大きさの目安枠
    UIView *szv = [[UIView alloc] init];
    szv.frame = CGRectMake(10, 300, 300, 41);
    szv.layer.cornerRadius = 5;
    szv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    szv.layer.borderWidth = 1.0;
    szv.backgroundColor = [UIColor whiteColor];
    [self.scroll addSubview:szv];
    //1
    sz1button = [UIButton buttonWithType:UIButtonTypeCustom];
    sz1button.frame = CGRectMake(3, 5, 75, 32);
    [sz1button setTitle:@"持てない" forState:UIControlStateNormal];
    sz1button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sz1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sz1button setBackgroundColor:[UIColor clearColor]];
    [sz1button addTarget:self action:@selector(sz1:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz1button];
    //2
    sz2button = [UIButton buttonWithType:UIButtonTypeCustom];
    sz2button.frame = CGRectMake(84, 5, 60, 32);
    [sz2button setTitle:@"大きめ" forState:UIControlStateNormal];
    sz2button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sz2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sz2button setBackgroundColor:[UIColor clearColor]];
    [sz2button addTarget:self action:@selector(sz2:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz2button];
    //3
    sz3button = [UIButton buttonWithType:UIButtonTypeCustom];
    sz3button.frame = CGRectMake(160, 5, 60, 32);
    [sz3button setTitle:@"普通" forState:UIControlStateNormal];
    sz3button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sz3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sz3button setBackgroundColor:[UIColor clearColor]];
    [sz3button addTarget:self action:@selector(sz3:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz3button];
    //4
    sz4button = [UIButton buttonWithType:UIButtonTypeCustom];
    sz4button.frame = CGRectMake(235, 5, 60, 32);
    [sz4button setTitle:@"小さい" forState:UIControlStateNormal];
    sz4button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sz4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sz4button setBackgroundColor:[UIColor clearColor]];
    [sz4button addTarget:self action:@selector(sz4:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz4button];
    //たてせん
    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 1, 40)];
    line5.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [szv addSubview:line5];
    UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 1, 40)];
    line6.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [szv addSubview:line6];
    UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(225, 0, 1, 40)];
    line7.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [szv addSubview:line7];


    //地域
    UILabel *lclabel = [[UILabel alloc] init];
    lclabel.frame = CGRectMake(15, 338, 300, 45);
    lclabel.backgroundColor = [UIColor clearColor];
    lclabel.textColor = [UIColor grayColor];
    lclabel.font = [UIFont boldSystemFontOfSize:15];
    lclabel.text = @" 地域";
    [self.scroll addSubview:lclabel];
    //地域選択
    lcbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lcbutton.frame = CGRectMake(10, 375, 300, 45);
    [lcbutton setTitle:@" 　現在地を取得" forState:UIControlStateNormal];
    [lcbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    lcbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    lcbutton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [lcbutton addTarget:self action:@selector(lc:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:lcbutton];
    lciv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBox.png"]];
    lciv.frame = CGRectMake(260, 10, 24, 24);
    [lcbutton addSubview:lciv];


    //シェア
    UILabel *plabel = [[UILabel alloc] init];
    plabel.frame = CGRectMake(15, 430, 200, 30);
    plabel.backgroundColor = [UIColor clearColor];
    plabel.textColor = [UIColor grayColor];
    plabel.font = [UIFont boldSystemFontOfSize:15];
    plabel.text = @"シェア";
    [self.scroll addSubview:plabel];
    //大きさの目安ラベル
    UIView *shv = [[UILabel alloc] initWithFrame:CGRectMake(10, 460, 300, 41)];
    shv.layer.cornerRadius = 5;
    shv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    shv.layer.borderWidth = 1.0;
    shv.backgroundColor = [UIColor whiteColor];
    [self.scroll addSubview:shv];
    //fb
    fbbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbbutton.frame = CGRectMake(10, 460, 150, 40);
    [fbbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [fbbutton setTitle:@"Facebook " forState:UIControlStateNormal];
    fbbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    fbbutton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [fbbutton addTarget:self action:@selector(btnfb_pushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:fbbutton];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"fb = %@", [defaults valueForKeyPath:@"fb_seq_id"]);
    if([[defaults valueForKeyPath:@"fb_seq_id"] intValue]>0){
        fb = 1;
        fbiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconFbEditOn.png"]];
    }else{
        fb = 0;
        fbiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconFbEdit.png"]];
    }
    fbiv.frame = CGRectMake(10, 10, 20, 20);
    [fbbutton addSubview:fbiv];
    //tw
	twFunc = [JOTwitterFunction alloc];
	twFunc.delegate = self;
    twbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    twbutton.frame = CGRectMake(160, 460, 150, 40);
    [twbutton setTitle:@"Twitter " forState:UIControlStateNormal];
    twbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    twbutton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [twbutton addTarget:self action:@selector(btntw_pushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:twbutton];
    NSLog(@"tw = %@", [defaults valueForKeyPath:@"tw_seq_id"]);
	if([[defaults valueForKeyPath:@"tw_seq_id"] intValue]>0){
		tw = 1;
		twiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconTwEditOn.png"]];
	}else{
		tw = 0;
		twiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconTwEdit.png"]];
	}
    twiv.frame = CGRectMake(10, 10, 20, 20);
    [twbutton addSubview:twiv];
    //たてせん
    UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 1, 45)];
    line8.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [shv addSubview:line8];


    //写真追加欄
    /*UIButton *ptbutton = [UIButton buttonWithType:UIButtonTypeCustom];;
    ptbutton.frame = CGRectMake(10, 520, 300, 105);
    ptbutton.backgroundColor = [UIColor whiteColor];
    [ptbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ptbutton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    ptbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ptbutton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [ptbutton setTitle:@"　写真を追加" forState:UIControlStateNormal];
    [ptbutton addTarget:self action:@selector(morephoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:ptbutton];*/
    //写真を追加
    UILabel *mplabel = [[UILabel alloc] init];
    mplabel.frame = CGRectMake(15, 510, 200, 30);
    mplabel.backgroundColor = [UIColor clearColor];
    mplabel.textColor = [UIColor grayColor];
    mplabel.font = [UIFont boldSystemFontOfSize:15];
    mplabel.text = @"写真を追加";
    [self.scroll addSubview:mplabel];
    //枠
    UIView *mpv = [[UIView alloc] init];
    mpv.backgroundColor = [UIColor whiteColor];
    mpv.frame = CGRectMake(10, 540, 300, 110);
    mpv.backgroundColor = [UIColor whiteColor];
    mpv.layer.cornerRadius = 5;
    mpv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    mpv.layer.borderWidth = 1.0;
    [self.scroll addSubview:mpv];
    UIImage *np = [UIImage imageNamed:@"iconAddPhoto.png"];
    //追加ボタン２
    pt2button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pt2button.frame = CGRectMake(28, 7, 95, 95);
    [pt2button setBackgroundImage:np forState:UIControlStateNormal];
    [mpv addSubview:pt2button];
    [pt2button addTarget:self action:@selector(morephoto:) forControlEvents:UIControlEventTouchUpInside];
    pt2button.tag = 2;
    //追加ボタン3
    pt3button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pt3button.frame = CGRectMake(177, 7, 95, 95);
    [pt3button setBackgroundImage:np forState:UIControlStateNormal];
    [mpv addSubview:pt3button];
    [pt3button addTarget:self action:@selector(morephoto:) forControlEvents:UIControlEventTouchUpInside];
    pt3button.tag = 3;
    //たてせん
    UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 1, 110)];
    line9.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [mpv addSubview:line9];
    //画像
    /*img2 = [[UIImageView alloc] initWithImage:np];
    img2.frame = CGRectMake(28, 5, 95, 95);
    [pt2button addSubview:img2];
    img3 = [[UIImageView alloc] initWithImage:np];
    img3.frame = CGRectMake(27, 5, 95, 95);
    [pt3button addSubview:img3];*/

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scroll addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
}

/*//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //titlelength = (tft.text.length - range.length) + text.length;
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    //[self confirmbtn];
    return YES;
}*/
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([cmtv.text isEqualToString:placeholder]){
        cmtv.text = @"";
        cmtv.textColor = [UIColor blackColor];
        return YES;
    }
    NSLog(@"1111");
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(cmtv.text.length == 0){
        cmtv.textColor = [UIColor lightGrayColor];
        cmtv.text = placeholder;
        //[cmtv resignFirstResponder];
    }
    if([cmtv.text isEqualToString:placeholder]){
        cmtv.text = @"";
        cmtv.textColor = [UIColor blackColor];
    }
}
- (void)hideKeyboard {
    [cmtv resignFirstResponder];
    if(cmtv.text.length == 0){
        cmtv.text = placeholder;
        cmtv.textColor = [UIColor grayColor];
    }
}

//コンディション
- (void)cd1:(id)sender {
    if (cd != 1) {
        [cd1button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cd2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 1;
    }
    else {
        [cd1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 0;
    }
}
- (void)cd2:(id)sender {
    if (cd != 2) {
        [cd1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd2button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cd3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 2;
    }
    else {
        [cd2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 0;
    }
}
- (void)cd3:(id)sender {
    if (cd != 3) {
        [cd1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd3button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cd4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 3;
    }
    else {
        [cd3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 0;
    }
}
- (void)cd4:(id)sender {
    if (cd != 4) {
        [cd1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd4button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cd = 4;
    }
    else {
        [cd4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        cd = 0;
    }
}

//手渡し
- (void)ms1:(id)sender {
    if (ms1 != 1) {
        ms1iv.image = [UIImage imageNamed:@"checkBoxSelect.png"];
        ms1 = 1;
    }
    else {
        ms1iv.image = [UIImage imageNamed:@"checkBox.png"];
        ms1 = 0;
    }
}
//着払い
- (void)ms2:(id)sender {
    if (ms2 != 1) {
        ms2iv.image = [UIImage imageNamed:@"checkBoxSelect.png"];
        ms2 = 1;
    }
    else {
        ms2iv.image = [UIImage imageNamed:@"checkBox.png"];
        ms2 = 0;
    }
}

//大きさ
- (void)sz1:(id)sender {
    if (sz != 1) {
        [sz1button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sz2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 1;
    }
    else {
        [sz1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 0;
    }
}
- (void)sz2:(id)sender {
    if (sz != 2) {
        [sz1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz2button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sz3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 2;
    }
    else {
        [sz2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 0;
    }
}
- (void)sz3:(id)sender {
    if (sz != 3) {
        [sz1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz3button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sz4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 3;
    }
    else {
        [sz3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 0;
    }
}
- (void)sz4:(id)sender {
    if (sz != 4) {
        [sz1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz3button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz4button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        sz = 4;
    }
    else {
        [sz4button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        sz = 0;
    }
}

//現在地取得
- (void)lc:(id)sender {
    if(lon == 0 && lat == 0){
        lm = [[CLLocationManager alloc] init];
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [lm startUpdatingLocation];
    }else{
        lon = 0;
        lat = 0;
        lciv.image = [UIImage imageNamed:@"checkBox.png"];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    lon = newLocation.coordinate.longitude;
    lat = newLocation.coordinate.latitude;
    [lm stopUpdatingLocation];

    lciv.image = [UIImage imageNamed:@"checkBoxSelect.png"];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == 1){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"プライバシー設定" message:@"位置情報を取得できませんでした。設定よりプライバシー設定を変更してください。" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"オフラインです" message:@"位置情報を取得できませんでした" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}

- (void)btnfb_pushed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults valueForKeyPath:@"fb_seq_id"] intValue]>0){
        if (fb != 1) {
            fbiv.image = [UIImage imageNamed:@"iconFacebookOn.png"];
            fb = 1;
        }
        else {
            fbiv.image = [UIImage imageNamed:@"iconFacebook.png"];
            fb = 0;
        }
    }else{
        //fbコネクト
        fbbutton.enabled = NO;
        JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];

        if (![appDelegate.facebook isSessionValid]) {
            [appDelegate.facebook authorize:nil];
        }else{
            [appDelegate fbDidLogin];
        }
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(fbconnected) name:@"fbrequested" object:nil];
    }
}
- (void)fbconnected{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int myid = [[defaults stringForKey:@"userid"] intValue];
    NSArray *fbdata = [defaults valueForKeyPath:@"fbdata"];
    if(fbdata){
        NSLog(@"yeeaaaaaaah");
        //通信
        connect = 1;
        NSString *dataa = [NSString stringWithFormat:@"user_id=%d&fbname=%@&fbmail=%@&access_token=%@&service=reader", myid, [fbdata valueForKeyPath:@"name"], [fbdata valueForKeyPath:@"email"], [defaults valueForKeyPath:@"FBAccessTokenKey"]];
        NSURL *url = [NSURL URLWithString:URL_ADD_FB];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}
- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(connect == 1){
            NSLog(@"fb connected");
            fbiv.image = [UIImage imageNamed:@"iconFacebookOn.png"];
            fb = 1;
            fbbutton.enabled = YES;
            [defaults setObject:[response valueForKeyPath:@"fb"] forKey:@"fb_seq_id"];
        }else{
            NSLog(@"tw connected");
            twiv.image = [UIImage imageNamed:@"iconTwitterOn.png"];
            tw = 1;
            twbutton.enabled = YES;
            [defaults setObject:[response valueForKeyPath:@"tw"] forKey:@"tw_seq_id"];
        }
    }
}

- (void)btntw_pushed:(id)sender {
    if (tw != 1) {
		BOOL isTwConnect = [twFunc isTwitterConnect];
		if(!isTwConnect){
			//TwitterコネクトOPEN
            twbutton.enabled = NO;
		    [twFunc openTwitterConnect:self];
		}else{
			// 認証済みの処理
			twiv.image = [UIImage imageNamed:@"iconTwitterOn.png"];
			tw = 1;
		}
	} else {
        twiv.image = [UIImage imageNamed:@"iconTwitter.png"];
        tw = 0;
    }
}

- (void)didFinishWithTwitterConnect:(BOOL)result{
	//Twitter認証の戻り先
    if (result) {
		// 認証に成功したときの処理
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int myid = [[defaults stringForKey:@"userid"] intValue];
        NSString *tw_name = [defaults stringForKey:@"TWScreenName"];
        NSString *accessToken = [defaults stringForKey:@"TWAccessTokenKey"];
        NSString *secretToken = [defaults stringForKey:@"TWAccessTokenSecret"];
        //通信
        connect = 2;
        NSString *dataa = [NSString stringWithFormat:@"user_id=%d&tw_name=%@&access_token=%@&secret=%@&service=reader", myid, tw_name, accessToken, secretToken];
        NSURL *url = [NSURL URLWithString:URL_ADD_TW];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];

		twiv.image = [UIImage imageNamed:@"iconTwitterOn.png"];
        tw = 1;
    } else {
        // 認証に失敗したときの処理
        twiv.image = [UIImage imageNamed:@"iconTwitter.png"];
        tw = 0;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)morephoto:(UIButton *)sender{
    JOPhotoViewController *nphoto = [self.storyboard instantiateViewControllerWithIdentifier:@"photo"];
    if(sender.tag == 1){
        nphoto.wphoto = @"1";
        nphoto.exist = @"0";
    }else if(sender.tag == 2){
        nphoto.wphoto = @"2";
        if(!(image2 == nil || [image2 isEqual:[NSNull null]])){
            nphoto.exist = @"1";
        }
    }else{
        nphoto.wphoto = @"3";
        if(!(image3 == nil || [image3 isEqual:[NSNull null]])){
            nphoto.exist = @"1";
        }
    }
    [self presentViewController:nphoto animated:YES completion:nil];
}

//store pictures when coming back
- (void)viewDidAppear:(BOOL)animated{
    [pt1button setBackgroundImage:image1 forState:UIControlStateNormal];
    if(!(image2 == nil || [image2 isEqual:[NSNull null]] || image2 == NULL)){
        //img2.image = image2;
        [pt2button setBackgroundImage:image2 forState:UIControlStateNormal];
        pt2button.frame = CGRectMake(28, 54.5-47.5*[h2 intValue]/[w2 intValue], 95, 95*[h2 intValue]/[w2 intValue]);
    }else{
        //img2.image = [UIImage imageNamed:@"iconAddPhoto.png"];
        [pt2button setBackgroundImage:[UIImage imageNamed:@"iconAddPhoto.png"] forState:UIControlStateNormal];
        pt2button.frame = CGRectMake(28, 7, 95, 95);
    }
    if(!(image3 == nil || [image3 isEqual:[NSNull null]] || image3 == NULL)){
        //img3.image = image3;
        [pt3button setBackgroundImage:image3 forState:UIControlStateNormal];
        pt3button.frame = CGRectMake(177, 54.5-47.5*[h3 intValue]/[w3 intValue], 95, 95*[h3 intValue]/[w3 intValue]);
    }else{
        //img3.image = [UIImage imageNamed:@"iconAddPhoto.png"];
        [pt3button setBackgroundImage:[UIImage imageNamed:@"iconAddPhoto.png"] forState:UIControlStateNormal];
        pt3button.frame = CGRectMake(177, 7, 95, 95);
    }
}

//backボタンで画像けす
-(void)backButtonClicked{
    UIAlertView *alertd = [[UIAlertView alloc]
                           initWithTitle:@"入力した内容は破棄されます。"
                           message:@"確認"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:@"OK", nil];
    alertd.alertViewStyle = UIAlertViewStyleDefault;
    [alertd show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1:
            image2 = NULL;
            [self.navigationController popViewControllerAnimated:YES];
            image3 = NULL;
            break;
    }
}

- (void)buttonnext:(id)sender {
    if([JOFunctionsDefined removeEmoji:cmtv.text]){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"絵文字" message:@"絵文字は入力できません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if([cmtv.text lengthOfBytesUsingEncoding:NSShiftJISStringEncoding] > 801){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"文字数" message:@"全角400文字以内で入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{
        JOConfirmViewController *confirm = [self.storyboard instantiateViewControllerWithIdentifier:@"confirm"];
        //入力した内容つれてく
        confirm.condition = [NSString stringWithFormat:@"%d",cd];
        confirm.means1 = [NSString stringWithFormat:@"%d",ms1];
        confirm.means2 = [NSString stringWithFormat:@"%d",ms2];
        confirm.size = [NSString stringWithFormat:@"%d",sz];
        confirm.longitude = [NSString stringWithFormat:@"%f",lon];
        confirm.latitude = [NSString stringWithFormat:@"%f",lat];
        confirm.fb_post = [NSString stringWithFormat:@"%d",fb];
        confirm.tw_post = [NSString stringWithFormat:@"%d",tw];
        if([cmtv.text isEqualToString:placeholder]){
            confirm.comment = @"";
        }else{
            confirm.comment = cmtv.text;
        }
        confirm.w1 = _w1;
        confirm.h1 = _h1;
        if(!(image2 == nil || [image2 isEqual:[NSNull null]] || image2 == NULL)){
            //confirm.image2 = image2;
            if(!(image3 == nil || [image3 isEqual:[NSNull null]] || image3 == NULL)){
                //confirm.image3 = image3;
            }
        }else if(!(image3 == nil || [image3 isEqual:[NSNull null]] || image3 == NULL)){
            //confirm.image2 = image3;
            //confirm.image3 = NULL;
        }

        [self.navigationController pushViewController:confirm animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
