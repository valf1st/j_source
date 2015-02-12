//
//  JOConfirmViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOConfirmViewController.h"


@interface JOConfirmViewController ()

@end

@implementation JOConfirmViewController

//@synthesize image1 = _image1;
//@synthesize image2 = _image2;
//@synthesize image3 = _image3;
//@synthesize photo1 = _photo1;
//@synthesize photo2 = _photo2;
//@synthesize photo3 = _photo3;
@synthesize condition = _condition;
@synthesize comment = _comment;
@synthesize means1 = _means1;
@synthesize means2 = _means2;
@synthesize size = _size;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize fb_post = _fb_post;
@synthesize tw_post = _tw_post;
//@synthesize image2 = _image2;
//@synthesize image3 = _image3;

UIView *waiting;
UIActivityIndicatorView *ai;
UIBarButtonItem *backButton, *confirm;
NSMutableArray *jres;
UIImageView *imageView1;
UIScrollView *slide;

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

    self.navigationItem.title = @"確認";

    JOTwitterFunction *twFunc;
    twFunc = [JOTwitterFunction alloc];

    GTMOAuthAuthentication * auth = [twFunc getTwAuth];
    NSLog(@"auth = %@", [auth description]);
    NSLog(@"token = %@", auth.accessToken);

    BOOL isTwConnect = [twFunc isTwitterConnect];
    if(isTwConnect){
        NSLog(@"connected");
    }else{
        NSLog(@"not connected");
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSLog(@"mydefault = %@", [ud description]);
     NSLog(@"%@", ud);

    //ナビゲーションバーにボタンを追加
    confirm=[[UIBarButtonItem alloc] initWithTitle:@"譲渡" style:UIBarButtonItemStyleBordered target:self action:@selector(ga:)];
    [confirm setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[confirm];

    backButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem=backButton;

    UILabel *lbk = [[UILabel alloc] init];
    lbk.frame = CGRectMake(8, 8, 310, 30);
    lbk.backgroundColor = [UIColor clearColor];
    lbk.textColor = [UIColor blackColor];
    lbk.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    lbk.text = @"この内容で譲渡します.内容を確認してください";
    [self.scroll addSubview:lbk];

    //ボタンの枠
    UIView *fv = [[UIView alloc] init];
    fv.frame = CGRectMake(5, 40, 310, 505);
    fv.backgroundColor = [UIColor whiteColor];
    fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    fv.layer.borderWidth = 1.0;
    fv.layer.cornerRadius = 5;
    //fv.layer.shadowOpacity = 0.2;
    //fv.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    [self.scroll addSubview:fv];

    //商品の画像をはる
    imageView1 = [[UIImageView alloc] initWithImage:image1];
    int m = 0;
    if(!(image2 == nil || [image2 isEqual:[NSNull null]])){
        //２まい以上でスライドつける
        slide = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 10, 296, 296)];
        [slide setScrollEnabled:NO];
        if(!(image3 == nil || [image3 isEqual:[NSNull null]])){
            [slide setContentSize:CGSizeMake(896, 296)];
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
            imageView2.frame = CGRectMake(300, 148-148*[h2 intValue]/[w2 intValue], 296, 296*[h2 intValue]/[w2 intValue]);
            [slide addSubview:imageView2];
            UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image3];
            imageView3.frame = CGRectMake(600, 148-148*[h3 intValue]/[w3 intValue], 296, 296*[h3 intValue]/[w3 intValue]);
            [slide addSubview:imageView3];
            //3まい用のボタン
            UIButton *slide3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            slide3Btn.frame = CGRectMake(250, 308, 55, 30);
            [slide3Btn setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
            [fv addSubview:slide3Btn];
            [slide3Btn addTarget:self action:@selector(slide3:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [slide setContentSize:CGSizeMake(580, 286)];
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
            imageView2.frame = CGRectMake(300, 148-148*[h2 intValue]/[w2 intValue], 296, 296*[h2 intValue]/[w2 intValue]);
            [slide addSubview:imageView2];
            //2まい用のボタン
            UIButton *slide2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            slide2Btn.frame = CGRectMake(255, 308, 55, 30);
            [slide2Btn setBackgroundImage:[UIImage imageNamed:@"btnNext2Img1.png"] forState:UIControlStateNormal];
            [fv addSubview:slide2Btn];
            [slide2Btn addTarget:self action:@selector(slide2:) forControlEvents:UIControlEventTouchUpInside];
        }
        //slide.pagingEnabled = YES;
        slide.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8];
        [fv addSubview:slide];
        slide.delegate = self;

        imageView1.frame = CGRectMake(0, 148-148*[_h1 intValue]/[_w1 intValue], 296, 296*[_h1 intValue]/[_w1 intValue]);
        [slide addSubview:imageView1];
    }else{
        //１まいはスライドなし
        imageView1.frame = CGRectMake(7, 10, 296, 296*[_h1 intValue]/[_w1 intValue]);
        [fv addSubview:imageView1];
        m = 296-296*[_h1 intValue]/[_w1 intValue];
    }

    //コイン画像
    UIImageView *coiniv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 315-m, 11, 13)];
    coiniv.image = [UIImage imageNamed:@"iconCoin.png"];
    [fv addSubview:coiniv];
    //値段
    UILabel *clabel = [[UILabel alloc] init];
    clabel.frame = CGRectMake(22, 312-m, 100, 20);
    clabel.backgroundColor = [UIColor clearColor];
    clabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    clabel.font = [UIFont boldSystemFontOfSize:13];
    clabel.text = [NSString stringWithFormat:@"%d コイン",1];
    [fv addSubview:clabel];

    //コメント表示
    //UIFont *font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13.5];
    UIFont *font = [UIFont systemFontOfSize:14.3];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(295, 600);
    
    NSString *cmtitle = _comment;
    CGSize size1 = [cmtitle sizeWithFont:font constrainedToSize:bounds lineBreakMode:mode];
    UILabel *cmlabel = [[UILabel alloc] init];
    cmlabel.backgroundColor = [UIColor clearColor];
    cmlabel.textColor = [UIColor colorWithWhite:0.17 alpha:1.0];
    cmlabel.font = font;
    cmlabel.numberOfLines = 100;
    cmlabel.lineBreakMode = mode;
    cmlabel.frame = CGRectMake(7, 339-m, 295, size1.height);
    cmlabel.text = cmtitle;
    [fv addSubview:cmlabel];


    //配送方法表示
    UILabel *hslabel = [[UILabel alloc] init];
    hslabel.frame = CGRectMake(0, 346.5+size1.height-m, 310, 31);
    hslabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    hslabel.layer.borderWidth = 0.5;
    hslabel.backgroundColor = [UIColor clearColor];
    hslabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    hslabel.font = [UIFont systemFontOfSize:13];
    hslabel.text = @"  配送方法：";
    [fv addSubview:hslabel];
    //なかみ
    UILabel *hs = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, 150, 31)];
    hs.backgroundColor = [UIColor clearColor];
    if([_means1 intValue] == 1 && [_means2 intValue] == 1){
        hs.text = @"手渡し／着払いの両方可";
    }else if([_means1 intValue] == 1 && [_means2 intValue] == 0){
        hs.text = @"手渡しのみ可";
    }else if([_means1 intValue] == 0 && [_means2 intValue] == 1){
        hs.text = @"着払いのみ可";
    }else{
        hs.text = @"-";
    }
    hs.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    hs.font = [UIFont systemFontOfSize:13];
    [hslabel addSubview:hs];

    NSArray *conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    NSArray *sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];

    //コンディション表示
    UILabel *cdlabel = [[UILabel alloc] init];
    cdlabel.frame = CGRectMake(0, 377+size1.height-m, 310, 31);
    //cdlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //cdlabel.layer.borderWidth = 0.5;
    cdlabel.backgroundColor = [UIColor clearColor];
    cdlabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    cdlabel.font = [UIFont systemFontOfSize:13];
    cdlabel.text = @"  状　態　：";
    [fv addSubview:cdlabel];
    UILabel *cd = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, 120, 31)];
    cd.text = [conditions objectAtIndex:[_condition intValue]];
    cd.backgroundColor = [UIColor clearColor];
    cd.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    cd.font = [UIFont systemFontOfSize:13];
    [cdlabel addSubview:cd];

    //大きさ
    UILabel *szlabel = [[UILabel alloc] init];
    szlabel.frame = CGRectMake(180, 377+size1.height-m, 130, 31);
    szlabel.backgroundColor = [UIColor clearColor];
    szlabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    szlabel.font = [UIFont systemFontOfSize:13];
    szlabel.text = @"  大きさ：";
    [fv addSubview:szlabel];
    UILabel *sz = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 120, 31)];
    sz.text = [sizes objectAtIndex:[_size intValue]];
    sz.backgroundColor = [UIColor clearColor];
    sz.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    sz.font = [UIFont systemFontOfSize:13];
    [szlabel addSubview:sz];

    fv.frame = CGRectMake(5, 40, 310, 411+size1.height-m);

    //ボタンの枠
    UILabel *lclabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 455+size1.height-m, 310, 35)];
    lclabel.backgroundColor = [UIColor whiteColor];
    lclabel.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    lclabel.layer.borderWidth = 1.0;
    lclabel.layer.cornerRadius = 5;
    //lclabel.layer.shadowOpacity = 0.2;
    //lclabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    lclabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    lclabel.font = [UIFont systemFontOfSize:13];
    lclabel.text = @"  位置情報：";
    [self.scroll addSubview:lclabel];
    UILabel *lc = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 120, 35)];
    if([_latitude intValue] != 0 || [_longitude intValue] != 0){
        lc.text = @"取得済み";
    }else{
        lc.text = @"-";
    }
    [lclabel addSubview:lc];

    //シェア
    UIView *sv = [[UIView alloc] init];
    sv.frame = CGRectMake(5, 495+size1.height-m, 310, 70);
    sv.backgroundColor = [UIColor whiteColor];
    sv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    sv.layer.borderWidth = 1.0;
    sv.layer.cornerRadius = 5;
    //sv.layer.shadowOpacity = 0.2;
    //sv.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    [self.scroll addSubview:sv];
    //fb
    UILabel *fblabel = [[UILabel alloc] init];
    fblabel.frame = CGRectMake(0, 0, 310, 36);
    //fblabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //fblabel.layer.borderWidth = 1.0;
    fblabel.backgroundColor = [UIColor clearColor];
    fblabel.textColor = [UIColor darkGrayColor];
    fblabel.font = [UIFont boldSystemFontOfSize:14];
    if([_fb_post intValue] == 0){
        fblabel.text = @"　Facebookにポストしません";
        UIImage *fb = [UIImage imageNamed:@"iconFbEdit.png"];
        UIImageView *fbiv = [[UIImageView alloc] initWithImage:fb];
        fbiv.frame = CGRectMake(282, 8, 20, 20);
        [sv addSubview:fbiv];
    }else{
        fblabel.text = @"　Facebookにポストします";
        UIImage *fb = [UIImage imageNamed:@"iconFbEditOn.png"];
        UIImageView *fbiv = [[UIImageView alloc] initWithImage:fb];
        fbiv.frame = CGRectMake(282, 8, 20, 20);
        [sv addSubview:fbiv];
    }
    [sv addSubview:fblabel];
    //tw
    UILabel *twlabel = [[UILabel alloc] init];
    twlabel.frame = CGRectMake(0, 35, 310, 35);
    //twlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //twlabel.layer.borderWidth = 1.0;
    twlabel.backgroundColor = [UIColor clearColor];
    twlabel.textColor = [UIColor darkGrayColor];
    twlabel.font = [UIFont boldSystemFontOfSize:14];
    if([_tw_post intValue] == 0){
        twlabel.text = @"　Twitterにポストしません";
        UIImage *tw = [UIImage imageNamed:@"iconTwEdit.png"];
        UIImageView *twiv = [[UIImageView alloc] initWithImage:tw];
        twiv.frame = CGRectMake(282, 42, 20, 20);
        [sv addSubview:twiv];
    }else{
        twlabel.text = @"　Twitterにポストします";
        UIImage *tw = [UIImage imageNamed:@"iconTwEditOn.png"];
        UIImageView *twiv = [[UIImageView alloc] initWithImage:tw];
        twiv.frame = CGRectMake(282, 42, 20, 20);
        [sv addSubview:twiv];
    }
    [sv addSubview:twlabel];
    //線
    UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    border.backgroundColor = [UIColor lightGrayColor];
    [twlabel addSubview:border];


    UILabel *alabel = [[UILabel alloc] init];
    alabel.frame = CGRectMake(50, 575+size1.height-m, 220, 30);
    alabel.textColor = [UIColor redColor];
    alabel.backgroundColor = [UIColor clearColor];
    alabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    alabel.text = @"　 出品後7日間は削除できません";
    [self.scroll addSubview:alabel];

    //出品ボタン
    /*UIButton *gabutton = [UIButton buttonWithType:UIButtonTypeCustom];
    gabutton.frame = CGRectMake(120, 605+size1.height, 80, 40);
    gabutton.backgroundColor = [UIColor redColor];
    [[gabutton layer] setCornerRadius:10.0];
    [gabutton setClipsToBounds:YES];
    [gabutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gabutton setTitle:@"譲　渡" forState:UIControlStateNormal];
    gabutton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    gabutton.layer.borderWidth = 2.0;
    [self.scroll addSubview:gabutton];
    [gabutton addTarget:self action:@selector(ga:) forControlEvents:UIControlEventTouchUpInside];*/

    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, 615+size1.height-m)];

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
}

- (void)slide2:(UIButton *)sender{
    float cp = slide.contentOffset.x;
    if(cp == 0){
        //スクロールさせる
        [slide setContentOffset:CGPointMake(300, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext2Img2.png"] forState:UIControlStateNormal];
    }else{
        //スクロールさせる
        [slide setContentOffset:CGPointMake(0, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext2Img1.png"] forState:UIControlStateNormal];
    }
}
- (void)slide3:(UIButton *)sender{
    float cp = slide.contentOffset.x;
    if(cp == 0){
        //スクロールさせる
        [slide setContentOffset:CGPointMake(300, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img2.png"] forState:UIControlStateNormal];
    }else if(cp == 300){
        //スクロールさせる
        [slide setContentOffset:CGPointMake(600, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img3.png"] forState:UIControlStateNormal];
    }else{
        //スクロールさせる
        [slide setContentOffset:CGPointMake(0, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
    }
}

//出品ボタンで
- (void)ga:(id)sender {
    if(image1 == nil || image1 == NULL){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"写真を選んでください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{

        //連打大作
        NSDate *submitTime = [NSDate date];
        NSLog(@"submitTime = %@", submitTime);
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDate *lastTime = [ud objectForKey:@"last_submit"];
        if(!(lastTime == nil || [lastTime isEqual:[NSNull null]])){
            NSLog(@"lastTime = %@", lastTime);
            NSTimeInterval since = [submitTime timeIntervalSinceDate:lastTime];
            NSLog(@"since = %f", since);
            if(since > 1){
                NSLog(@"ok");
                [ud setObject:submitTime forKey:@"last_submit"];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                backButton.enabled = NO;
                confirm.enabled = NO;
                //通信まちの間，半透明viewで覆っておく
                waiting.hidden = FALSE;
                [ai startAnimating];
                [self connect];
            }else{
                NSLog(@"no");
            }
        }else{
            NSLog(@"1ok");
            [ud setObject:submitTime forKey:@"last_submit"];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            backButton.enabled = NO;
            confirm.enabled = NO;
            //通信まちの間，半透明viewで覆っておく
            waiting.hidden = FALSE;
            [ai startAnimating];
            [self connect];
        }
    }
}

- (void)connect{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSString *photo1 = [data1 base64EncodedString];
    NSString *photo2, *photo3;
    if(image2 == nil){
        photo2 = NULL;
        w2 = @"0";
        h2 = @"0";
    }else{
        NSData *data2 = UIImagePNGRepresentation(image2);
        photo2 = [data2 base64EncodedString];
    }
    if(image3 == nil){
        photo3 = NULL;
        w3 = @"0";
        h3 = @"0";
    }else{
        NSData *data3 = UIImagePNGRepresentation(image3);
        photo3 = [data3 base64EncodedString];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];    
    //自分のuserid
    int myid = [[ud stringForKey:@"userid"] intValue];


    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //通信
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&photo1=%@&w1=%@&h1=%@&photo2=%@&w2=%@&h2=%@&photo3=%@&w3=%@&h3=%@&price=%d&comment=%@&condition=%@&ms1=%@&ms2=%@&size=%@&lon=%@&lat=%@&fb_post=%@&tw_post=%@&service=reader", myid, photo1, _w1, _h1, photo2, w2, h2, photo3, w3, h3, 1, [_comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _condition, _means1, _means2, _size, _longitude, _latitude, _fb_post, _tw_post];
    NSURL *url = [NSURL URLWithString:URL_ITEM_SUBMIT];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:60];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSMutableArray *)response{
    if(load){
        jres = response;
        int result = [[jres valueForKeyPath:@"result"]intValue];

        if(result == 1){

            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            //自分のuserid
            NSString *myname = [ud stringForKey:@"username"];
            //fbに投稿
            if([_fb_post intValue] == 1){
                NSLog(@"gonna post to facebook");
                int item_id = [[jres valueForKeyPath:@"item_id"] intValue];
                NSString *photo1png = [jres valueForKeyPath:@"photo1"];
                NSString *postcomment = [NSString stringWithFormat:@"%@さんはJotonに品物を出品しました。\n無料でゆずってもらえるアプリ http://joton.jp/", myname];

                NSString *description;
                if(_comment.length == 0){
                    description = @"品物詳細はこちら";
                }else{
                    description = _comment;
                }

                JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![appDelegate.facebook isSessionValid]) {
                    NSArray *permissions = [NSArray arrayWithObjects:@"user_about_me", @"publish_stream",nil];
                    [appDelegate.facebook authorize:permissions];
                    //[appDelegate.facebook authorize:nil];
                    NSLog(@"not valid");
                }else{
                    NSLog(@"valid");
                }

                /*NSArray* permissions =  [NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil];
                [appDelegate.facebook authorize:permissions];*/

                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%d", URL_WEB, item_id], @"link", [NSString stringWithFormat:@"%@/%d/s_%@", URL_IMAGE, item_id, photo1png], @"picture", @"無料でゆずってもらえるアプリ", @"caption", description, @"description", postcomment, @"message", nil];
                [appDelegate.facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:appDelegate];
            }
            //twに投稿
            if([_tw_post intValue] == 1){
                int item_id = [[jres valueForKeyPath:@"item_id"] intValue];

				JOTwitterFunction *twFunc;
				twFunc = [JOTwitterFunction alloc];

				GTMOAuthAuthentication * auth = [twFunc getTwAuth];
                NSLog(@"auth = %@", [auth description]);
                NSLog(@"token = %@", auth.accessToken);

                /*ACAccountStore *accountStore = [[ACAccountStore alloc]init];
                ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                ACAccount *account = [accountStore accountWithIdentifier:self.accountId];

                [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                    if(granted)
                    {
                        NSLog(@"granted");
                        NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                        if([accounts count] > 0)
                        {
                            NSLog(@"accounts");
                            ACAccount *account = accounts[0];
                            self.accountId = account.identifier;
                        }
                    }
                }];*/

				NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];

				//NSString *twComment = _comment;
                NSString *twComment = [NSString stringWithFormat:@"%@さんはJotonに品物を出品しました。\n品物詳細はこちら", myname];
				NSString *twLink = [NSString stringWithFormat:@"%@%d", URL_WEB, item_id];

				//140ギリギリだとエラーになるから130文字
				if(twComment.length + twLink.length > 130){
					//140文字を超える場合はコメント部をけずる
					twComment = [twComment substringWithRange:NSMakeRange(0, 130 - twLink.length)];
				}

				//コメントとリンクの結合
				NSString *twCommentOriginal = [NSString stringWithFormat:@"%@ %@",twComment, twLink];
				NSLog(@"count=%d", twCommentOriginal.length);

				//URLエンコード
				NSString *twCommentEncode = [JOFunctionsDefined urlencode:twCommentOriginal];
				//整形
				NSString *twContent = [NSString stringWithFormat:@"status=%@",twCommentEncode];

				//NSLog(@"エンコードされた文字列 = %@", twContent);

				NSData *body = [twContent dataUsingEncoding:NSUTF8StringEncoding];
				NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
				[request setHTTPMethod: @"POST"];
				[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
				[request setHTTPBody: body];
                //[request setAccount:account];

                //TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:tweetMessage　forKey:@"status"] requestMethod:TWRequestMethodPOST];

				[auth authorizeRequest:request];
				NSLog(@"%@",auth.accessToken);

				NSError *error;
				NSURLResponse *response;
				NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

				NSLog(@"error = %@", error);
				NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
				NSLog(@"responseText = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
			}

            [JOToastUtil showToast:@"出品しました"];
            image2 = NULL;
            image3 = NULL;
            // 通知
            NSNotification *n = [NSNotification notificationWithName:@"submit" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:n];
            JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.myflag = @"1";
            //モーダルバイバイ
            [self dismissViewControllerAnimated:YES completion:nil];

        }else{
            int mcd = [[jres valueForKeyPath:@"message_cd"]intValue];
            if(mcd == 5){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"しばらくたってからやり直してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
                waiting.hidden = TRUE;
            }else{
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"出品できませんでした" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
                waiting.hidden = TRUE;
            }
        }
        [jres removeAllObjects];
        backButton.enabled = YES;
        confirm.enabled = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


//backボタン
-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    //JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.facebook = nil;
}

@end
