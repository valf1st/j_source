//
//  JODetail2ViewController.m
//  Joton
//
//  Created by Val F on 13/06/18.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JODetail2ViewController.h"

@interface JODetail2ViewController ()

@end

@implementation JODetail2ViewController

@synthesize item = _item;
@synthesize itemdata = _itemdata;

int reload, myid;
CGFloat sheight;
NSArray *sizes, *conditions;
UIScrollView *slide;

- (void)viewWillAppear:(BOOL)animated{
    if(reload == 0){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

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
    NSLog(@"itemdata = %@", [_itemdata description]);
    reload = 0;
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
    
    self.navigationItem.title = @"品物詳細";
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    sheight = screenSize.height;
    
    [_scroll setScrollEnabled:YES];
    
    conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];
    
    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(update) name:@"updated" object:nil];
}

- (void)update{
    for (UIView *subview in [self.scroll subviews]) {
        if(subview.tag != 1){
            [subview removeFromSuperview];
        }
    }
    [self getitem];
}

- (void)viewDidAppear:(BOOL)animated{
    if(reload == 0){
        if(![_itemdata valueForKeyPath:@"item_id"]){
            NSLog(@"no data. gonna go fetch.");
            [self getitem];
        }else{
            NSLog(@"data exist. gonna draw.");
            [self draw];
        }
        reload = 1;
    }else{
        NSLog(@"loaded already.");
    }
}

- (void) getitem {
    //通信してとってくる
    NSString *dataa = [NSString stringWithFormat:@"item_id=%d", [_item intValue]];
    NSURL *url = [NSURL URLWithString:URL_ITEM];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSDictionary *)response{
    if(load){
        _itemdata = response;
        [self draw];
    }
}

//描画
- (void)draw{
    NSDictionary *dict = _itemdata;
    
    NSString *photo1 = [dict valueForKeyPath:@"photo1"];
    int p1w = [[dict valueForKeyPath:@"photo1w"] intValue];
    int p1h = [[dict valueForKeyPath:@"photo1h"] intValue];
    NSString *photo2 = [dict valueForKeyPath:@"photo2"];
    NSString *photo3 = [dict valueForKeyPath:@"photo3"];
    int price = [[dict valueForKeyPath:@"price"] intValue];
    int means1 = [[dict valueForKeyPath:@"ms1"] intValue];
    int means2 = [[dict valueForKeyPath:@"ms2"] intValue];
    NSString *itemcomment = [dict valueForKeyPath:@"description"];
    int size = [[dict valueForKeyPath:@"dimension"] intValue];
    int condition = [[dict valueForKeyPath:@"state"] intValue];
    NSString *username = [dict valueForKeyPath:@"user_name"];
    int userid = [[dict valueForKeyPath:@"user_id"] intValue];
    NSString *icon = [dict valueForKeyPath:@"icon"];
    NSString *add_date = [dict valueForKeyPath:@"add_time"];
    //int nego = [[dict valueForKeyPath:@"nego"] intValue];
    //int unchecked = [[dict valueForKeyPath:@"unchecked"] intValue];
    //NSData *location = [dict valueForKeyPath:@"lat_lon"];
    
    //ボタンの枠
    UIView *fv = [[UIView alloc] init];
    fv.frame = CGRectMake(5, 10, 310, 500);
    fv.backgroundColor = [UIColor whiteColor];
    fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    fv.layer.borderWidth = 1.0;
    fv.layer.cornerRadius = 5;;
    [self.scroll addSubview:fv];
    
    //NSString *addtime = [dres valueForKeyPath:@"add_time"];
    NSString *time = [JOFunctionsDefined sinceFromData:add_date];
    UIFont *fontt = [UIFont boldSystemFontOfSize:13];
    UILineBreakMode modet = NSLineBreakByWordWrapping;
    CGSize boundst = CGSizeMake(90, 20);
    CGSize sizet = [time sizeWithFont:fontt constrainedToSize:boundst lineBreakMode:modet];
    //時間
    UILabel *dlabel = [[UILabel alloc] init];
    dlabel.frame = CGRectMake(302-sizet.width, 14, sizet.width, 20);
    dlabel.backgroundColor = [UIColor clearColor];
    dlabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    dlabel.textAlignment = NSTextAlignmentRight;
    dlabel.font = fontt;
    dlabel.text = time;
    [fv addSubview:dlabel];
    //時計マーク
    UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time.png"]];
    clock.frame = CGRectMake(285-sizet.width, 18, 12, 12);
    [fv addSubview:clock];
    
    //出品者のユーザーネームをはる(ラベルと見せかけたボタンです)
    UIButton *usbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    usbutton.frame = CGRectMake(0, 7, 250, 32);
    usbutton.backgroundColor = [UIColor clearColor];
    [usbutton setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
    [usbutton setTitleColor: [UIColor colorWithRed:0.32 green:0.59 blue:0.82 alpha:1.0] forState:UIControlStateHighlighted];
    usbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    usbutton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    NSString *un=[NSString stringWithFormat:@"             %@",username];
    [usbutton setTitle:un forState:UIControlStateNormal];
    [fv addSubview:usbutton];
    //[usbutton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
    
    if(userid == myid){
        usbutton.enabled = NO;
    }
    
    //出品者のアイコンをはる
    UIImageView *iv2;
    if(icon == nil || [icon isEqual:[NSNull null]]){
        UIImage *imgi = [UIImage imageNamed:@"iconUser.png"];
        iv2 = [[UIImageView alloc] initWithImage:imgi];
    }else{
        //UIImageView *iv2;
        NSString *url_icon=[NSString stringWithFormat:@"%@/%d/s_%@", URL_ICON, userid, icon];
        NSURL* urli = [NSURL URLWithString:url_icon];
        UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
        iv2 = [[UIImageView alloc] initWithImage:nil];
        //画像キャッシュ
        [iv2 setImageWithURL:urli placeholderImage:placeholderImage];
    }
    iv2.frame = CGRectMake(7, 7, 33, 33);
    [fv addSubview:iv2];
    
    //商品の画像をはる
    __weak UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    item.layer.borderWidth = 1.0;
    item.userInteractionEnabled = NO;
    NSString *url_photo=[NSString stringWithFormat:@"%@/%@/%@", URL_IMAGE, _item, photo1];
    NSURL* url = [NSURL URLWithString:url_photo];
    UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(110, 148*p1h/p1w, 20, 20)];
    ai.frame = CGRectMake(140, 148*p1h/p1w, 20, 20);
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [item addSubview:ai];
    [ai startAnimating];
    //画像キャッシュ
    [item setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        if(error){
            [item setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
        }
        [ai stopAnimating];
    }];

    int m = 0;
    if(!(photo2 == nil || [photo2 isEqual:[NSNull null]] || [photo2 isEqualToString:@""])){
        //２まい以上でスライドつける
        slide = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 46, 296, 296)];
        [slide setScrollEnabled:NO];
        if(!(photo3 == nil || [photo3 isEqual:[NSNull null]] || [photo3 isEqualToString:@""])){
            [slide setContentSize:CGSizeMake(896, 296)];
            //２まいめの写真はる
            __weak UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
            item2.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
            item2.layer.borderWidth = 1.0;
            //item2.userInteractionEnabled = NO;
            NSString *url_photo2=[NSString stringWithFormat:@"%@/%@/%@", URL_IMAGE, _item, photo2];
            NSURL* url2 = [NSURL URLWithString:url_photo2];
            UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
            //画像キャッシュ
            [item2 setBackgroundImageWithURL:url2 forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    [item2 setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                }
            }];
            item2.frame = CGRectMake(300, 0, 296, 296);
            [slide addSubview:item2];
            if(myid == userid){
                //[item2 addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //[item2 addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            }
            //３まいめの写真はる
            __weak UIButton *item3 = [UIButton buttonWithType:UIButtonTypeCustom];
            item3.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
            item3.layer.borderWidth = 1.0;
            //item3.userInteractionEnabled = NO;
            NSString *url_photo3=[NSString stringWithFormat:@"%@/%@/%@", URL_IMAGE, _item, photo3];
            NSURL* url3 = [NSURL URLWithString:url_photo3];
            //画像キャッシュ
            [item3 setBackgroundImageWithURL:url3 forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    [item3 setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                }
            }];
            item3.frame = CGRectMake(600, 0, 296, 296);
            [slide addSubview:item3];
            if(myid == userid){
                //[item3 addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //[item3 addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            }
            //3まい用のボタン
            UIButton *slide3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            slide3Btn.frame = CGRectMake(240, 342, 55, 30);
            [slide3Btn setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
            [fv addSubview:slide3Btn];
            [slide3Btn addTarget:self action:@selector(slide3:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [slide setContentSize:CGSizeMake(600, 296)];
            //２まいめの写真はる
            __weak UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
            item2.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
            item2.layer.borderWidth = 1.0;
            //item2.userInteractionEnabled = NO;
            NSString *url_photo2=[NSString stringWithFormat:@"%@/%@/%@", URL_IMAGE, _item, photo2];
            NSURL* url2 = [NSURL URLWithString:url_photo2];
            UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
            //画像キャッシュ
            [item2 setBackgroundImageWithURL:url2 forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    [item2 setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                }
            }];
            item2.frame = CGRectMake(300, 0, 296, 296);
            [slide addSubview:item2];
            if(myid == userid){
                //[item2 addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //[item2 addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            }
            //2まい用のボタン
            UIButton *slide2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            slide2Btn.frame = CGRectMake(240, 342, 55, 30);
            [slide2Btn setBackgroundImage:[UIImage imageNamed:@"btnNext2Img1.png"] forState:UIControlStateNormal];
            [fv addSubview:slide2Btn];
            [slide2Btn addTarget:self action:@selector(slide2:) forControlEvents:UIControlEventTouchUpInside];
        }
        slide.pagingEnabled = YES;
        slide.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8];
        [fv addSubview:slide];
        slide.delegate = self;
        
        item.frame = CGRectMake(0, 148-148*p1h/p1w, 296, 296*p1h/p1w);
        [slide addSubview:item];
        //m = 286-286*p1h/p1w;
    }else{
        //１まいはスライドなし
        item.frame = CGRectMake(7, 46, 296, 296*p1h/p1w);
        [fv addSubview:item];
        m = 296-296*p1h/p1w;
    }

    //コイン画像
    UIImageView *coiniv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 351-m, 11, 13)];
    coiniv.image = [UIImage imageNamed:@"iconCoin.png"];
    [fv addSubview:coiniv];
    //値段
    UILabel *clabel = [[UILabel alloc] init];
    clabel.frame = CGRectMake(22, 348-m, 100, 20);
    clabel.backgroundColor = [UIColor clearColor];
    clabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    clabel.font = [UIFont boldSystemFontOfSize:13];
    clabel.text = [NSString stringWithFormat:@"%d コイン",price];
    [fv addSubview:clabel];

    //コメント表示
    //UIFont *font = [UIFont fontWithName:@"STHeitiTC-Medium" size:13.5];
    UIFont *font = [UIFont systemFontOfSize:14.3];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(295, 600);
    
    NSString *cmtitle = itemcomment;
    CGSize size1 = [cmtitle sizeWithFont:font constrainedToSize:bounds lineBreakMode:mode];
    UILabel *cmlabel = [[UILabel alloc] init];
    cmlabel.backgroundColor = [UIColor clearColor];
    cmlabel.textColor = [UIColor colorWithWhite:0.17 alpha:1.0];
    cmlabel.font = font;
    cmlabel.numberOfLines = 100;
    cmlabel.lineBreakMode = mode;
    cmlabel.frame = CGRectMake(7, 375-m, 295, size1.height);
    cmlabel.text = cmtitle;
    [fv addSubview:cmlabel];


    //配送方法表示
    UILabel *hslabel = [[UILabel alloc] init];
    hslabel.frame = CGRectMake(0, 382.5+size1.height-m, 310, 31);
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
    if(means1 == 1 && means2 == 1){
        hs.text = @"手渡し／着払いの両方可";
    }else if(means1 == 1 && means2 == 0){
        hs.text = @"手渡しのみ可";
    }else if(means1 == 0 && means2 == 1){
        hs.text = @"着払いのみ可";
    }else{
        hs.text = @"-";
    }
    hs.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    hs.font = [UIFont systemFontOfSize:13];
    [hslabel addSubview:hs];
    
    
    //コンディション表示
    UILabel *cdlabel = [[UILabel alloc] init];
    cdlabel.frame = CGRectMake(0, 413+size1.height-m, 310, 31);
    /*if(userid != myid){
        cdlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cdlabel.layer.borderWidth = 0.5;
    }*/
    cdlabel.backgroundColor = [UIColor clearColor];
    cdlabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    cdlabel.font = [UIFont systemFontOfSize:13];
    cdlabel.text = @"  状　態　：";
    [fv addSubview:cdlabel];
    UILabel *cd = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, 120, 31)];
    cd.text = [conditions objectAtIndex:condition];
    cd.backgroundColor = [UIColor clearColor];
    cd.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    cd.font = [UIFont systemFontOfSize:13];
    [cdlabel addSubview:cd];
    
    //大きさ
    UILabel *szlabel = [[UILabel alloc] init];
    szlabel.frame = CGRectMake(180, 413+size1.height-m, 130, 31);
    szlabel.backgroundColor = [UIColor clearColor];
    szlabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    szlabel.font = [UIFont systemFontOfSize:13];
    szlabel.text = @"  大きさ：";
    [fv addSubview:szlabel];
    UILabel *sz = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 120, 31)];
    sz.text = [sizes objectAtIndex:size];
    sz.backgroundColor = [UIColor clearColor];
    sz.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    sz.font = [UIFont systemFontOfSize:13];
    [szlabel addSubview:sz];

    fv.frame = CGRectMake(5, 10, 310, 445+size1.height-m);

    [self.scroll setContentSize:CGSizeMake(320, 20 + fv.bounds.size.height)];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    }else if(cp == 290){
        //スクロールさせる
        [slide setContentOffset:CGPointMake(600, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img3.png"] forState:UIControlStateNormal];
    }else{
        //スクロールさせる
        [slide setContentOffset:CGPointMake(0, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
	//itemcheck = [NSMutableArray array];
}


@end
