//
//  JOEditViewController.m
//  Joton
//
//  Created by Val F on 13/04/10.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOEditViewController.h"

@interface JOEditViewController ()

@end

@implementation JOEditViewController

@synthesize item = _item;
@synthesize photo1 = _photo1;
@synthesize photo2 = _photo2;
@synthesize photo3 = _photo3;
@synthesize cd = _cd;
@synthesize ms1 = _ms1;
@synthesize ms2 = _ms2;
@synthesize sz = _sz;
@synthesize comment = _comment;
UIImagePickerController *picker;
UIButton *p1Btn, *p2Btn, *p3Btn, *cd1Btn, *cd2Btn, *cd3Btn, *cd4Btn, *sz1Btn, *sz2Btn, *sz3Btn, *sz4Btn;
UIView *waiting;
UITextView *cmttv;
UIImageView *ms1iv, *ms2iv, *lciv;
int p, w, reload;
NSString *newphoto1, *newphoto2, *newphoto3;
int newcd, newms1, newms2, newsz, newlocation, oldlocation;
UIActivityIndicatorView *ai, *fai;

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

    reload = 0;

    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"編集"];

    //ナビゲーションバーにボタンを追加
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                             initWithTitle:@"キャンセル"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(cancel:)];
    navigationItem.leftBarButtonItems = @[cancel];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]
                             initWithTitle:@"更新"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(update:)];
    [done setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    navigationItem.rightBarButtonItems = @[done];

    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];

    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, 590)];

    fai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(151, 115, 17, 17)];
    fai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [fai startAnimating];
    [self.view addSubview:fai];

    NSLog(@"latlon = %@", _location);
    NSLog(@"latlon = %@", [_location description]);
    if([_location isEqual:[NSNull null]]){
        oldlocation = 1;
    }else{
        oldlocation = 0;
    }

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scroll addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
}

- (void)viewDidAppear:(BOOL)animated{
    if(reload == 0){
        [self draw];
        reload = 1;
    }

    //store pictures when coming back
    if(!(image1 == nil || [image1 isEqual:[NSNull null]] || image1 == NULL)){
        [p1Btn setBackgroundImage:image1 forState:UIControlStateNormal];
        NSData *data1 = UIImagePNGRepresentation(image1);
        p1Btn.frame = CGRectMake(20, 62.5-42.5*[h1 intValue]/[w1 intValue], 85, 85*[h1 intValue]/[w1 intValue]);
        newphoto1 = [data1 base64EncodedString];
    }else{
        //img2.image = [UIImage imageNamed:@"iconAddPhoto.png"];
        NSString *url_photo=[NSString stringWithFormat:@"%@/%@/s_%@", URL_IMAGE, _item, _photo1];
        NSURL* url = [NSURL URLWithString:url_photo];
        UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
        [p1Btn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage];
    }
    //[p1Btn setBackgroundImage:image1 forState:UIControlStateNormal];
    if(!(image2 == nil || [image2 isEqual:[NSNull null]] || image2 == NULL)){
        NSLog(@"image2 = %@", image2);
        [p2Btn setBackgroundImage:image2 forState:UIControlStateNormal];
        NSData *data2 = UIImagePNGRepresentation(image2);
        p2Btn.frame = CGRectMake(28, 49.5-42.5*[h2 intValue]/[w2 intValue], 85, 85*[h2 intValue]/[w2 intValue]);
        newphoto2 = [data2 base64EncodedString];
    }else{
        if(p2 == 1){
            NSLog(@"no image2");
            newphoto2 = @"delete";
            [p2Btn setBackgroundImage:[UIImage imageNamed:@"iconAddPhoto.png"] forState:UIControlStateNormal];
        }else{
            newphoto2 = NULL;
        }
    }
    if(!(image3 == nil || [image3 isEqual:[NSNull null]] || image3 == NULL)){
        //img3.image = image3;
        [p3Btn setBackgroundImage:image3 forState:UIControlStateNormal];
        NSData *data3 = UIImagePNGRepresentation(image3);
        p3Btn.frame = CGRectMake(177, 49.5-42.5*[h3 intValue]/[w3 intValue], 85, 85*[h3 intValue]/[w3 intValue]);
        newphoto3 = [data3 base64EncodedString];
    }else{
        if(p3 == 1){
            NSLog(@"no image3");
            newphoto3 = @"delete";
            //img3.image = [UIImage imageNamed:@"iconAddPhoto.png"];
            [p3Btn setBackgroundImage:[UIImage imageNamed:@"iconAddPhoto.png"] forState:UIControlStateNormal];
        }else{
            newphoto3 = NULL;
        }
    }
}

//描画
- (void)draw{

    [fai stopAnimating];
    fai.hidden = TRUE;

    //変更があったか分かるように
    newcd = [_cd intValue];
    newms1 = [_ms1 intValue];
    newms2 = [_ms2 intValue];
    newsz = [_sz intValue];
    newphoto1 = NULL;
    newphoto2 = NULL;
    newphoto3 = NULL;
    newlocation = oldlocation;


    //写真欄
    UILabel *lbbg = [[UILabel alloc] init];
    lbbg.frame = CGRectMake(10, 10, 300, 110);
    lbbg.backgroundColor = [UIColor whiteColor];
    lbbg.layer.cornerRadius = 5;
    lbbg.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    lbbg.layer.borderWidth = 1.0;
    [self.scroll addSubview:lbbg];
    //photo1
	p1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    p1Btn.frame = CGRectMake(15, 65-45*[_p1h intValue]/[_p1w intValue], 90, 90*[_p1h intValue]/[_p1w intValue]);
    NSString *url_photo=[NSString stringWithFormat:@"%@/%@/s_%@", URL_IMAGE, _item, _photo1];
    NSURL* url = [NSURL URLWithString:url_photo];
	UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
	//画像キャッシュ
	[p1Btn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        if(error){
            [p1Btn setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
        }
    }];
	[self.scroll addSubview:p1Btn];
	//どのボタンが押されたか判定するためのタグ
    [p1Btn addTarget:self action:@selector(photo1:) forControlEvents:UIControlEventTouchUpInside];
    //入力欄
    cmttv = [[UITextView alloc] initWithFrame:CGRectMake(110, 20, 193, 90)];
    //tft.borderStyle = UITextBorderStyleRoundedRect;
    cmttv.textColor = [UIColor blueColor];
    cmttv.text = _comment;
    cmttv.layer.borderWidth = 1.0f;
    cmttv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.scroll addSubview:cmttv];
    cmttv.delegate = self;

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
    cd1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cd1Btn.frame = CGRectMake(8, 5, 65, 32);
    [cd1Btn setTitle:@"新品" forState:UIControlStateNormal];
    if([_cd intValue] == 1){
        [cd1Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [cd1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [cd1Btn setBackgroundColor:[UIColor clearColor]];
    //cd1button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cd1Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd1Btn addTarget:self action:@selector(cd1:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd1Btn];
    //コンディション２
    cd2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cd2Btn.frame = CGRectMake(82, 5, 65, 32);
    //cd2button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cd2Btn setTitle:@"新品同様" forState:UIControlStateNormal];
    if([_cd intValue] == 2){
        [cd2Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [cd2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [cd2Btn setBackgroundColor:[UIColor clearColor]];
    //cd2button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cd2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd2Btn addTarget:self action:@selector(cd2:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd2Btn];
    //コンディション３
    cd3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cd3Btn.frame = CGRectMake(160, 5, 60, 32);
    [cd3Btn setTitle:@"普通" forState:UIControlStateNormal];
    if([_cd intValue] == 3){
        [cd3Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [cd3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [cd3Btn setBackgroundColor:[UIColor clearColor]];
    cd3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd3Btn addTarget:self action:@selector(cd3:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd3Btn];
    //コンディション４
    cd4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cd4Btn.frame = CGRectMake(230, 5, 65, 32);
    [cd4Btn setTitle:@"劣る" forState:UIControlStateNormal];
    if([_cd intValue] == 4){
        [cd4Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [cd4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [cd4Btn setBackgroundColor:[UIColor clearColor]];
    cd4Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cd4Btn addTarget:self action:@selector(cd4:) forControlEvents:UIControlEventTouchUpInside];
    [cdv addSubview:cd4Btn];
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
    [ms1button setTitle:@"手渡し " forState:UIControlStateNormal];
    [ms1button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    ms1button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    ms1button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [ms1button addTarget:self action:@selector(ms1:) forControlEvents:UIControlEventTouchUpInside];
    [msv addSubview:ms1button];
    if([_ms1 intValue] == 0){
        ms1iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBox.png"]];
    }else{
        ms1iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBoxSelect.png"]];
    }
    ms1iv.frame = CGRectMake(15, 10, 24, 24);
    [msv addSubview:ms1iv];
    //元払い
    UIButton *ms2button = [UIButton buttonWithType:UIButtonTypeCustom];
    ms2button.frame = CGRectMake(180, 5, 100, 35);
    [ms2button setTitle:@"着払い " forState:UIControlStateNormal];
    [ms2button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    ms2button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    ms2button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [ms2button addTarget:self action:@selector(ms2:) forControlEvents:UIControlEventTouchUpInside];
    [msv addSubview:ms2button];
    if([_ms2 intValue] == 0){
        ms2iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBox.png"]];
    }else{
        ms2iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBoxSelect.png"]];
    }
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
    sz1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    sz1Btn.frame = CGRectMake(3, 5, 75, 32);
    [sz1Btn setTitle:@"持てない" forState:UIControlStateNormal];
    sz1Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    if([_sz intValue] == 1){
        [sz1Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [sz1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [sz1Btn setBackgroundColor:[UIColor clearColor]];
    [sz1Btn addTarget:self action:@selector(sz1:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz1Btn];
    //2
    sz2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    sz2Btn.frame = CGRectMake(84, 5, 60, 32);
    [sz2Btn setTitle:@"大きめ" forState:UIControlStateNormal];
    sz2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    if([_sz intValue] == 2){
        [sz2Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [sz2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [sz2Btn setBackgroundColor:[UIColor clearColor]];
    [sz2Btn addTarget:self action:@selector(sz2:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz2Btn];
    //3
    sz3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    sz3Btn.frame = CGRectMake(160, 5, 60, 32);
    [sz3Btn setTitle:@"普通" forState:UIControlStateNormal];
    sz3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    if([_sz intValue] == 3){
        [sz3Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [sz3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [sz3Btn setBackgroundColor:[UIColor clearColor]];
    [sz3Btn addTarget:self action:@selector(sz3:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz3Btn];
    //4
    sz4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    sz4Btn.frame = CGRectMake(235, 5, 60, 32);
    [sz4Btn setTitle:@"小さい" forState:UIControlStateNormal];
    sz4Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    if([_sz intValue] == 4){
        [sz4Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [sz4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [sz4Btn setBackgroundColor:[UIColor clearColor]];
    [sz4Btn addTarget:self action:@selector(sz4:) forControlEvents:UIControlEventTouchUpInside];
    [szv addSubview:sz4Btn];
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
    lclabel.frame = CGRectMake(15, 335, 300, 45);
    lclabel.backgroundColor = [UIColor clearColor];
    lclabel.textColor = [UIColor grayColor];
    lclabel.font = [UIFont boldSystemFontOfSize:15];
    lclabel.text = @" 地域";
    [self.scroll addSubview:lclabel];
    //地域選択
    UIButton *lcbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lcbutton.frame = CGRectMake(10, 375, 300, 45);
    [lcbutton setTitle:@" 　現在地を取得" forState:UIControlStateNormal];
    lcbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    lcbutton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [lcbutton addTarget:self action:@selector(lc:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:lcbutton];
    if(oldlocation == 1){
        lciv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBoxSelect.png"]];
    }else{
        lciv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkBox.png"]];
    }
    lciv.frame = CGRectMake(260, 10, 24, 24);
    [lcbutton addSubview:lciv];



    //写真を追加
    UILabel *mplabel = [[UILabel alloc] init];
    mplabel.frame = CGRectMake(15, 440, 200, 30);
    mplabel.backgroundColor = [UIColor clearColor];
    mplabel.textColor = [UIColor grayColor];
    mplabel.font = [UIFont boldSystemFontOfSize:15];
    mplabel.text = @" 写真を追加";
    [self.scroll addSubview:mplabel];
    //枠
    UIView *mpv = [[UIView alloc] init];
    mpv.backgroundColor = [UIColor whiteColor];
    mpv.frame = CGRectMake(10, 470, 300, 110);
    mpv.backgroundColor = [UIColor whiteColor];
    mpv.layer.cornerRadius = 5;
    mpv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    mpv.layer.borderWidth = 1.0;
    [self.scroll addSubview:mpv];
    //photo2
    p2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    p2Btn.frame = CGRectMake(28, 7, 95, 95);
    if(!(_photo2 == nil || [_photo2 isEqual:[NSNull null]])){
        NSString *url_photo2=[NSString stringWithFormat:@"%@/%@/s_%@", URL_IMAGE, _item, _photo2];
        NSURL* url2 = [NSURL URLWithString:url_photo2];
        image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
		UIImage *placeholderImage = [UIImage imageNamed:@"iconAddPhoto.png"];
		//画像キャッシュ
		[p2Btn setBackgroundImageWithURL:url2 forState:UIControlStateNormal placeholderImage:placeholderImage];
		[mpv addSubview:p2Btn];
		//どのボタンが押されたか判定するためのタグ
		[p2Btn addTarget:self action:@selector(photo2:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIImage *img2 = [UIImage imageNamed:@"iconAddPhoto.png"];
        [p2Btn setBackgroundImage:img2 forState:UIControlStateNormal];
        [self.scroll addSubview:p2Btn];
        [p2Btn addTarget:self action:@selector(photo2:) forControlEvents:UIControlEventTouchUpInside];
        [mpv addSubview:p2Btn];
    }
    //photo3
    p3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    p3Btn.frame = CGRectMake(177, 7, 95, 95);
    if(!(_photo3 == nil || [_photo3 isEqual:[NSNull null]])){
        NSString *url_photo3=[NSString stringWithFormat:@"%@/%@/s_%@", URL_IMAGE, _item, _photo3];
        NSURL* url3 = [NSURL URLWithString:url_photo3];
        image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
		UIImage *placeholderImage = [UIImage imageNamed:@"iconAddPhoto.png"];
		//画像キャッシュ
		[p3Btn setBackgroundImageWithURL:url3 forState:UIControlStateNormal placeholderImage:placeholderImage];
		[mpv addSubview:p3Btn];
		//どのボタンが押されたか判定するためのタグ
		[p3Btn addTarget:self action:@selector(photo3:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIImage *img3 = [UIImage imageNamed:@"iconAddPhoto.png"];
        [p3Btn setBackgroundImage:img3 forState:UIControlStateNormal];
        [mpv addSubview:p3Btn];
        [p3Btn addTarget:self action:@selector(photo3:) forControlEvents:UIControlEventTouchUpInside];
    }
    //たてせん
    UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 1, 110)];
    line9.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [mpv addSubview:line9];
}

- (void)hideKeyboard {
    [cmttv resignFirstResponder];
}

//photo1ボタン
- (void)photo1:(id)sender{
    JOPhotoViewController *nphoto = [self.storyboard instantiateViewControllerWithIdentifier:@"photo"];
    nphoto.wphoto = @"1";
    [self presentViewController:nphoto animated:YES completion:nil];
}

//photo2ボタン
- (void)photo2:(id)sender{
    JOPhotoViewController *nphoto = [self.storyboard instantiateViewControllerWithIdentifier:@"photo"];
    nphoto.wphoto = @"2";
    if(!(image2 == nil || [image2 isEqual:[NSNull null]])){
        nphoto.exist = @"1";
    }
    [self presentViewController:nphoto animated:YES completion:nil];
}

//photo3ボタン
- (void)photo3:(id)sender{
    JOPhotoViewController *nphoto = [self.storyboard instantiateViewControllerWithIdentifier:@"photo"];
    nphoto.wphoto = @"3";
    if(!(image3 == nil || [image3 isEqual:[NSNull null]])){
        nphoto.exist = @"1";
    }
    [self presentViewController:nphoto animated:YES completion:nil];
}

//コンディション
- (void)cd1:(id)sender {
    if (newcd != 1) {
        [cd1Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cd2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 1;
    }
    else {
        [cd1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 0;
    }
}
- (void)cd2:(id)sender {
    if (newcd != 2) {
        [cd1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd2Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cd3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 2;
    }
    else {
        [cd2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 0;
    }
}
- (void)cd3:(id)sender {
    if (newcd != 3) {
        [cd1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd3Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cd4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 3;
    }
    else {
        [cd3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 0;
    }
}
- (void)cd4:(id)sender {
    if (newcd != 4) {
        [cd1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cd4Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        newcd = 4;
    }
    else {
        [cd4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newcd = 0;
    }
}

//手渡し
- (void)ms1:(id)sender {
    if (newms1 != 1) {
        ms1iv.image = [UIImage imageNamed:@"checkBoxSelect.png"];
        newms1 = 1;
    }
    else {
        ms1iv.image = [UIImage imageNamed:@"checkBox.png"];
        newms1 = 0;
    }
}
//着払い
- (void)ms2:(id)sender {
    if (newms2 != 1) {
        ms2iv.image = [UIImage imageNamed:@"checkBoxSelect.png"];
        newms2 = 1;
    }
    else {
        ms2iv.image = [UIImage imageNamed:@"checkBox.png"];
        newms2 = 0;
    }
}

//大きさ
- (void)sz1:(id)sender {
    if (newsz != 1) {
        [sz1Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sz2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 1;
    }
    else {
        [sz1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 0;
    }
}
- (void)sz2:(id)sender {
    if (newsz != 2) {
        [sz1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz2Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sz3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 2;
    }
    else {
        [sz2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 0;
    }
}
- (void)sz3:(id)sender {
    if (newsz != 3) {
        [sz1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz3Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sz4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 3;
    }
    else {
        [sz3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 0;
    }
}
- (void)sz4:(id)sender {
    if (newsz != 4) {
        [sz1Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz2Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz3Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [sz4Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        newsz = 4;
    }
    else {
        [sz4Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        newsz = 0;
    }
}

//現在地取得
- (void)lc:(id)sender {
    if(newlocation == 0){
        lm = [[CLLocationManager alloc] init];
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [lm startUpdatingLocation];
    }else{
        newlocation = 0;
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
    newlocation = 1;
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


//更新ボタン
- (void)update:(id)sender{
    [self.scroll endEditing:YES];
    if(newphoto1 == NULL && newphoto2 == NULL && newphoto3 == NULL && [cmttv.text isEqualToString:_comment] && newcd == [_cd intValue] && newms1 == [_ms1 intValue] && newms2 == [_ms2 intValue] && newsz == [_sz intValue] && (oldlocation == newlocation && lon == 0)){
        //変更がなかったらそのまま閉じる
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"変更なし");
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //通信まちの間，半透明viewで覆っておく
        waiting = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,835)];
        waiting.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
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

        [self connect];
    }
}
//通信する
- (void)connect {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //通信
    NSString *dataa = [NSString stringWithFormat:@"item_id=%@&photo1=%@&photo2=%@&photo3=%@&price=%d&comment=%@&condition=%d&ms1=%d&ms2=%d&size=%d&lon=%f&lat=%f", _item, newphoto1, newphoto2, newphoto3, 1, [cmttv.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], newcd, newms1, newms2, newsz, lon, lat];
    NSURL *url = [NSURL URLWithString:URL_ITEM_UPDATE];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:60];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        image1 = NULL; image2 = NULL; image3 = NULL;
        NSString *result = [response valueForKeyPath:@"result"];

        if(result){
            [JOToastUtil showToast:@"更新しました"];
            if([_from intValue] == 1){
                // 通知を作成する
                NSNotification *n1 = [NSNotification notificationWithName:@"updated1" object:self];
                // 通知実行！
                [[NSNotificationCenter defaultCenter] postNotification:n1];
            }else{
                // 通知を作成する
                NSNotification *n = [NSNotification notificationWithName:@"updated" object:self];
                // 通知実行！
                [[NSNotificationCenter defaultCenter] postNotification:n];
            }
            //ページせんい
            [self dismissViewControllerAnimated:YES completion: nil];

        }else{
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"更新できませんでした" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            waiting.hidden = TRUE;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)cancel:(id)sender {
    image1 = NULL; image2 = NULL; image3 = NULL;
    [self dismissViewControllerAnimated:YES completion:nil];
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