//
//  JOUserViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOUserViewController.h"

@interface JOUserViewController ()

@end

@implementation JOUserViewController

#define T3 14 //いちどにとってくる品物数-3列
#define T1 6 //いちどにとってくる品物数-1列

@synthesize user = _user;

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

    self.navigationItem.title = @"ユーザー詳細";
    ureload = 0;
    upaging3 = 0;
    usort = 3;
    udrawn1 = 0;
    ujl = 0; uj3 = 0;
    uc1 = 0; uc3 = 0;
    uend1 = 0; uend3 = 0;
    ures1 = [NSMutableDictionary dictionary];

    _scroll.delegate = self;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];
}

- (void)viewDidAppear:(BOOL)animated{
    if(ureload == 0){
        ures = NULL;
        upaging3 = 0;
        usort = 3;
        udrawn1 = 0;
        ujl = 0; uj3 = 0;
        uc1 = 0; uc3 = 0;
        uend1 = 0; uend3 = 0;
        [self getuserinfo];
        ureload = 1;
    }
}

- (void)getuserinfo{
    ucnct = 1;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%@&total=%d&myid=%d", _user, T3, myid];
    NSLog(@"user_id = %@", _user);
    NSURL *url = [NSURL URLWithString:URL_USER_ITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSMutableDictionary *)response{
    if(load){
        if(ucnct == 1){
            if([ures count] == 0){
                //初回表示はここ
                ures = response;
                [self draw];
            }else{
                if(usort == 3){
                    if([[response objectForKey:@"end"] intValue] == 1){
                        uend3 = 1;
                    }
                    NSLog(@"again");
                    uc3 = [ures count];
                    for(int i=0 ; i<[response count]-1 ; i++){
                        NSLog(@"i = %d, cm = %d", i, uc3);
                        NSLog(@"object = %@, key = %d", [response objectForKey:[NSString stringWithFormat:@"%d",i]], uc3+i);
                        [ures setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d", uc3+i]];
                    //[myres setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d",cm+i]];
                    }
                    [self draw3];
                }else{
                    if([[response objectForKey:@"end"] intValue] == 1){
                        uend1 = 1;
                    }
                    uc1 = [ures1 count];
                    for(int i=0 ; i<[response count]-1 ; i++){
                        NSLog(@"i = %d, cm = %d", i, uc1);
                        NSLog(@"object = %@, key = %d", [response objectForKey:[NSString stringWithFormat:@"%d",i]], uc1+i);
                        [ures1 setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d", uc1+i]];
                        //[myres setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d",cm+i]];
                    }
                    NSLog(@"myres1 = %@", ures1);
                    [self draw1];
                }
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"通報しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSString *tag = [response valueForKeyPath:@"tag"];
            UIButton *dob = (UIButton *)[self.scroll viewWithTag:[tag intValue]+100000];
            dob.hidden = TRUE;
        }
    }
    upaging3 = 0;
    [aiv stopAnimating];
}

//描画
- (void)draw{
    NSArray *userinfo = [ures valueForKeyPath:@"user_info"];
    uicon = [userinfo valueForKeyPath:@"icon"];
    uname = [userinfo valueForKeyPath:@"user_name"];
    int success = [[userinfo valueForKeyPath:@"no_success"] intValue];
    int failure = [[userinfo valueForKeyPath:@"no_failure"] intValue];

    //枠画像
    UIImageView *fv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, 93)];
    fv.image = [UIImage imageNamed:@"bgProfileOther.png"];
    [self.scroll addSubview:fv];

    //アイコンをはる
    upiv = [[UIImageView alloc] initWithImage:nil];
    if(!(uicon == nil || [uicon isEqual:[NSNull null]])){
        NSString *url_photo=[NSString stringWithFormat:@"%@/%@/%@", URL_ICON, _user, uicon];
        NSURL *urli = [NSURL URLWithString:url_photo];
        //NSData *data = [NSData dataWithContentsOfURL:urli];
        //UIImage *img = [UIImage imageWithData:data];
        UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
        //画像キャッシュ
        __block UIImageView *blockView = upiv;
        [upiv setImageWithURL:urli placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            if(error){
                //[self noimage];
                blockView.image = [UIImage imageNamed:@"itemNoImg.png"];
            }
        }];
    }else{
        upiv.image = [UIImage imageNamed:@"iconUser.png"];
    }
    //UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    upiv.frame = CGRectMake(5, 5, 80, 80);
    [fv addSubview:upiv];

    //ユーザー名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 0, 210, 46)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.text = [NSString stringWithFormat:@"　%@", uname];
    [fv addSubview:nameLabel];

    //実績
    UILabel *sclabel = [[UILabel alloc] init];
    sclabel.frame = CGRectMake(93, 37, 106, 46);
    sclabel.backgroundColor = [UIColor clearColor];
    sclabel.textColor = [UIColor darkGrayColor];
    sclabel.font = [UIFont boldSystemFontOfSize:17];
    sclabel.textAlignment = NSTextAlignmentCenter;
    sclabel.text = [NSString stringWithFormat:@"%d", success];
    [fv addSubview:sclabel];
    //見出し
    UILabel *scl = [[UILabel alloc] init];
    scl.frame = CGRectMake(125, 73, 80, 15);
    scl.backgroundColor = [UIColor clearColor];
    scl.textColor = [UIColor grayColor];
    scl.font = [UIFont systemFontOfSize:12];
    scl.text = @"取引成立数";
    [fv addSubview:scl];
    //にこちゃん
    UIImageView *smile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconSmile.png"]];
    smile.frame = CGRectMake(105, 73, 15, 15);
    [fv addSubview:smile];
    //実績
    UILabel *fllabel = [[UILabel alloc] init];
    fllabel.frame = CGRectMake(200, 37, 105, 46);
    fllabel.backgroundColor = [UIColor clearColor];
    fllabel.textColor = [UIColor darkGrayColor];
    fllabel.font = [UIFont boldSystemFontOfSize:17];
    fllabel.textAlignment = NSTextAlignmentCenter;
    fllabel.text = [NSString stringWithFormat:@"%d", failure];
    [fv addSubview:fllabel];
    //見出し
    UILabel *fll = [[UILabel alloc] init];
    fll.frame = CGRectMake(236, 73, 80, 15);
    fll.backgroundColor = [UIColor clearColor];
    fll.textColor = [UIColor grayColor];
    fll.font = [UIFont systemFontOfSize:12];
    fll.text = @"対応がbad";
    [fv addSubview:fll];
    //ぶー
    UIImageView *boo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconBad.png"]];
    boo.frame = CGRectMake(216, 73, 15, 16);
    [fv addSubview:boo];


    //吹き出し枠
    UIView *bv = [[UIView alloc]initWithFrame:CGRectMake(5, 108, 310, 45)];
    bv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBalloon.png"]];
    [self.scroll addSubview:bv];
    
    UIButton *sBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sBtn.frame = CGRectMake(5, 0, 300, 36);
    [sBtn setTitle:@"この人の出品　　　　　　　　　　　" forState:UIControlStateNormal];
    sBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateHighlighted];
    [bv addSubview:sBtn];
    [sBtn addTarget:self action:@selector(btnswitch:) forControlEvents:UIControlEventTouchUpInside];
    
    usiv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 16, 16)];
    usiv.image = [UIImage imageNamed:@"iconListMypage.png"];
    [sBtn addSubview:usiv];

    if([ures count] <= 1){
        UILabel *niLabel = [[UILabel alloc] init];
        niLabel.frame = CGRectMake(20, 200, 280, 40);
        niLabel.text = @"出品がありません";
        niLabel.backgroundColor = [UIColor clearColor];
        niLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        niLabel.textAlignment = NSTextAlignmentCenter;
        [self.scroll addSubview:niLabel];
    }else{
        int i;
        for(i=0 ; i<[ures count]-1 ; i++){
            NSArray *iteminfo = [ures valueForKeyPath:[NSString stringWithFormat:@"%d",i]];
            int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
            NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
            int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
            int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
            int price = [[iteminfo valueForKeyPath:@"price"] intValue];

            //ボタンの枠
            UIView *fv = [[UIView alloc] init];
            fv.frame = CGRectMake(5+(fmod(i,2)*157), 172*((i-(fmod(i,2)))/2)+151, 152, 167);
            fv.backgroundColor = [UIColor whiteColor];
            fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            fv.layer.borderWidth = 1.0;
            fv.layer.cornerRadius = 5;
            [self.scroll addSubview:fv];

			//商品の画像をはる
            __weak UIButton *itembtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *url_photo=[NSString stringWithFormat:@"%@/%d/s_%@", URL_IMAGE, itemid, photon1];
            NSURL* url = [NSURL URLWithString:url_photo];
            //[[itembtn layer] setCornerRadius:4.0];
            //[itembtn setClipsToBounds:YES];
			UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
            UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(72, 72*p1h/p1w, 20, 20)];
            ai.frame = CGRectMake(140, 148*p1h/p1w, 20, 20);
            ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [itembtn addSubview:ai];
            [ai startAnimating];
			//画像キャッシュ
			[itembtn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    [itembtn setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                }
                [ai stopAnimating];
            }];
			itembtn.frame = CGRectMake(4, 72-72*p1h/p1w+4, 144, 144*p1h/p1w);
			[fv addSubview:itembtn];

			//どのボタンが押されたか判定するためのタグ
			itembtn.tag = i;
			[fv addSubview:itembtn];
			[itembtn addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];

            //コイン画像
            UIImageView *coiniv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 151, 11, 13)];
            coiniv.image = [UIImage imageNamed:@"iconCoin.png"];
            [fv addSubview:coiniv];
            //値段
            UILabel *clabel = [[UILabel alloc] init];
            clabel.frame = CGRectMake(22, 147, 100, 20);
            clabel.backgroundColor = [UIColor clearColor];
            clabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
            clabel.font = [UIFont boldSystemFontOfSize:12];
            clabel.text = [NSString stringWithFormat:@"%d コイン",price];
            [fv addSubview:clabel];
        }
        [self.scroll setScrollEnabled:YES];
        uj3 = 172*((i+1-(fmod(i+1,2)))/2)+142;
        [self.scroll setContentSize:CGSizeMake(320, uj3+50)];
    }

    //表示きりかえ用のviewを作っておく
    usv = [[UIView alloc] initWithFrame:CGRectMake(0, 151, 320, 1000)];
    usv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //usv.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:usv];
    usv.hidden = TRUE;
}

- (void)noimage{
    upiv.image = [UIImage imageNamed:@"itemNoImg.png"];
}

- (void)btnswitch:(id)sender{
    if(usort == 3){
        [self sort1];
        usiv.image = [UIImage imageNamed:@"iconThumbMypage.png"];
    }else{
        [self sort3];
        usiv.image = [UIImage imageNamed:@"iconListMypage.png"];
    }
}

- (void)sort3{
    usv.hidden = TRUE;
    usort = 3;
    [self.scroll setContentSize:CGSizeMake(320, uj3+50)];
}

- (void)sort1{
    usv.hidden = FALSE;
    [_scroll setContentSize:CGSizeMake(320, ujl+280)];
    usort = 1;
    if(udrawn1 == 0){
        [self draw1];
        udrawn1 = 1;
    }
}

- (void)draw1{
    if([ures1 count] <= 1){
        for(int i=0 ; i<T1 ; i++){
            [ures1 setValue:[ures valueForKeyPath:[NSString stringWithFormat:@"%d",i]] forKeyPath:[NSString stringWithFormat:@"%d",i]];
        }
    }
    for(int i=uc1 ; i<[ures1 count] ; i++){
        NSLog(@"i = %d", i);
        NSArray *iteminfo = [ures valueForKeyPath:[NSString stringWithFormat:@"%d",i]];
        int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
        //int userid = [[iteminfo valueForKeyPath:@"user_id"] intValue];
        NSString *photo1 = [iteminfo valueForKeyPath:@"photo1"];
        int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
        int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
        NSString *photo2 = [iteminfo valueForKeyPath:@"photo2"];
        NSString *photo3 = [iteminfo valueForKeyPath:@"photo3"];
        int price = [[iteminfo valueForKeyPath:@"price"] intValue];
        NSString *itemcomment = [iteminfo valueForKeyPath:@"description"];
        int condition = [[iteminfo valueForKeyPath:@"state"] intValue];
        int means1 = [[iteminfo valueForKeyPath:@"ms1"] intValue];
        int means2 = [[iteminfo valueForKeyPath:@"ms2"] intValue];
        int size = [[iteminfo valueForKeyPath:@"dimension"] intValue];
        NSString *dobbing = [iteminfo valueForKeyPath:@"dobbing"];
        //NSString *username = [iteminfo valueForKeyPath:@"user_name"];
        //NSString *icon = [iteminfo valueForKeyPath:@"icon"];

        NSLog(@"ujl = %d", ujl);
        //ボタンの枠
        UIView *fv = [[UIView alloc] init];
        fv.frame = CGRectMake(5, ujl, 310, 505);
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 5;
        [usv addSubview:fv];

        NSString *addtime = [iteminfo valueForKeyPath:@"add_time"];
        NSString *time = [JOFunctionsDefined sinceFromData:addtime];
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
        NSString *un=[NSString stringWithFormat:@"             %@",uname];
        [usbutton setTitle:un forState:UIControlStateNormal];
        [fv addSubview:usbutton];
        //usbutton.tag = myid;
        //[usbutton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];

		//出品者のアイコンをはる
		UIImageView *iv2;
        if(uicon == nil || [uicon isEqual:[NSNull null]]){
            UIImage *imgi = [UIImage imageNamed:@"iconUser.png"];
            iv2 = [[UIImageView alloc] initWithImage:imgi];
        }else{
            NSString *url_icon=[NSString stringWithFormat:@"%@/%@/s_%@", URL_ICON, _user, uicon];
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
		NSString *url_photo=[NSString stringWithFormat:@"%@/%d/%@", URL_IMAGE, itemid, photo1];
		NSURL* url = [NSURL URLWithString:url_photo];
        item.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
        item.layer.borderWidth = 1.0;
		UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(110, 148*p1h/p1w, 20, 20)];
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
            UIScrollView *slide = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 46, 296, 296)];
            [slide setScrollEnabled:NO];
            slide.tag = -(i+1);
            if(!(photo3 == nil || [photo3 isEqual:[NSNull null]] || [photo3 isEqualToString:@""])){
                [slide setContentSize:CGSizeMake(896, 296)];
                //２まいめの写真はる
                __weak UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
                NSString *url_photo2=[NSString stringWithFormat:@"%@/%d/%@", URL_IMAGE, itemid, photo2];
                NSURL* url2 = [NSURL URLWithString:url_photo2];
                item2.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
                item2.layer.borderWidth = 1.0;
                UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
                //画像キャッシュ
                [item2 setBackgroundImageWithURL:url2 forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        [item2 setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                    }
                }];
                item2.frame = CGRectMake(300, 0, 296, 296);
                [slide addSubview:item2];
                [item2 addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
                item2.tag = i;
                //３まいめの写真はる
                __weak UIButton *item3 = [UIButton buttonWithType:UIButtonTypeCustom];
                NSString *url_photo3=[NSString stringWithFormat:@"%@/%d/%@", URL_IMAGE, itemid, photo3];
                NSURL* url3 = [NSURL URLWithString:url_photo3];
                item3.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
                item3.layer.borderWidth = 1.0;
                //画像キャッシュ
                [item3 setBackgroundImageWithURL:url3 forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        [item3 setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                    }
                }];
                item3.frame = CGRectMake(600, 0, 296, 296);
                [slide addSubview:item3];
                [item3 addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
                item3.tag = i;

                //3まい用のボタン
                UIButton *slide3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
                slide3Btn.frame = CGRectMake(250, 344, 55, 30);
                [slide3Btn setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
                [fv addSubview:slide3Btn];
                [slide3Btn addTarget:self action:@selector(slide3:) forControlEvents:UIControlEventTouchUpInside];
                slide3Btn.tag = i+1;
            }else{
                [slide setContentSize:CGSizeMake(600, 296)];
                //２まいめの写真はる
                __weak UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
                NSString *url_photo2=[NSString stringWithFormat:@"%@/%d/%@", URL_IMAGE, itemid, photo2];
                NSURL* url2 = [NSURL URLWithString:url_photo2];
                item2.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
                item2.layer.borderWidth = 1.0;
                UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
                //画像キャッシュ
                [item2 setBackgroundImageWithURL:url2 forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        [item2 setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                    }
                }];
                item2.frame = CGRectMake(300, 0, 296, 296);
                [slide addSubview:item2];
                [item2 addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
                item2.tag = i;
                //2まい用のボタン
                UIButton *slide2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
                slide2Btn.frame = CGRectMake(255, 344, 55, 30);
                [slide2Btn setBackgroundImage:[UIImage imageNamed:@"btnNext2Img1.png"] forState:UIControlStateNormal];
                [fv addSubview:slide2Btn];
                [slide2Btn addTarget:self action:@selector(slide2:) forControlEvents:UIControlEventTouchUpInside];
                slide2Btn.tag = i+1;
            }
            //slide.pagingEnabled = YES;
            slide.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8];
            [fv addSubview:slide];
            slide.delegate = self;

			item.frame = CGRectMake(0, 148-148*p1h/p1w, 296, 296*p1h/p1w);
			[slide addSubview:item];
        }else{
			//１まいはスライドなし
			item.frame = CGRectMake(7, 46, 296, 296*p1h/p1w);
			[fv addSubview:item];
            m = 296-296*p1h/p1w;
        }
		//画像にリンクをつける
        [item addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i;

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
        cdlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cdlabel.layer.borderWidth = 0.5;
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

        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 444+size1.height-m, 310, 43)];
        foot.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgItemListFooter.png"]];
        [fv addSubview:foot];
        //リクエストボタン
        UIButton *btnreq = [UIButton buttonWithType:UIButtonTypeCustom];
        btnreq.frame = CGRectMake(0, 0, 190, 43);
        //[btnreq setBackgroundColor:[UIColor cyanColor]];
        [btnreq setTitle:@"メッセージへ" forState:UIControlStateNormal];
        btnreq.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [btnreq setTitleColor:[UIColor colorWithRed:0.506 green:0.518 blue:0.545 alpha:1.0] forState:UIControlStateNormal];
        [btnreq setTitleColor:[UIColor colorWithRed:0.306 green:0.341 blue:0.388 alpha:1.0] forState:UIControlStateHighlighted];
        [btnreq addTarget:self action:@selector(btnreq:) forControlEvents:UIControlEventTouchUpInside];
        btnreq.tag = i;
        [foot addSubview:btnreq];
        //アイコン
        UIImageView *msg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconListMessage.png"]];
        msg.frame = CGRectMake(42, 15, 13, 12);
        [foot addSubview:msg];

        if(dobbing == nil || [dobbing isEqual:[NSNull null]]){
            //通報ボタン
            UIButton *btndob = [UIButton buttonWithType:UIButtonTypeCustom];
            btndob.frame = CGRectMake(190, 0, 119, 44);
            [btndob setBackgroundImage:[UIImage imageNamed:@"btnWarning.png"] forState:UIControlStateNormal];
            [btndob addTarget:self action:@selector(dob:) forControlEvents:UIControlEventTouchUpInside];
            [foot addSubview:btndob];
            btndob.tag = 100000 + i;
        }
        
        fv.frame = CGRectMake(5, ujl, 310, 486+size1.height-m);

        ujl = ujl + fv.bounds.size.height + 5;
    }

    usv.frame = CGRectMake(0, 151, 320, ujl+20);
    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, ujl+210)];
}

- (void)getmoreinfo1{
    NSLog(@"more1");
    uc1 = uc1+T1;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%@&startnumber=%d&totalnumber=%d", _user, uc1, T1];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_UR_MOREITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    float lp = sender.contentSize.height;
    float sheight = [[UIScreen mainScreen] bounds].size.height;
    float height = sheight - (20+44+50);
    if(usort == 3 && uend3 == 0){
        if(cp > lp-height-20){
            if(upaging3 == 0){
                aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
                aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [aiv startAnimating];
                [self.scroll addSubview:aiv];
                [self getmoreinfo3];
                upaging3 = 1;
            }
        }
    }else if(usort == 1 && uend1 == 0){
        if(cp > lp-height-20){
            if(upaging3 == 0){
                aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
                aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [aiv startAnimating];
                [self.scroll addSubview:aiv];
                [self getmoreinfo1];
                upaging3 = 1;
            }
        }
    }
}

- (void)slide2:(UIButton *)sender{
    UIScrollView *slideview = (UIScrollView *)[self.scroll viewWithTag:-sender.tag];
    float cp = slideview.contentOffset.x;
    if(cp == 0){
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(300, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext2Img2.png"] forState:UIControlStateNormal];
    }else{
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(0, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext2Img1.png"] forState:UIControlStateNormal];
    }
}
- (void)slide3:(UIButton *)sender{
    UIScrollView *slideview = (UIScrollView *)[self.scroll viewWithTag:-sender.tag];
    float cp = slideview.contentOffset.x;
    if(cp == 0){
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(300, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img2.png"] forState:UIControlStateNormal];
    }else if(cp == 300){
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(600, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img3.png"] forState:UIControlStateNormal];
    }else{
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(0, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
    }
}

- (void)getmoreinfo3{
    uc3 = uc3+T3;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%@&startnumber=%d&totalnumber=%d", _user, uc3, T3];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_UR_MOREITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}
- (void)draw3{
    //商品はりまくる
    int i;
    for(i=uc3 ; i<[ures count] ; i++){
        NSArray *iteminfo = [ures objectForKey:[NSString stringWithFormat:@"%d",i]];
        int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
        NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
        int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
        int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
        int price = [[iteminfo valueForKeyPath:@"price"] intValue];

        //ボタンの枠
        UIView *fv = [[UIView alloc] init];
        fv.frame = CGRectMake(5+(fmod(i-uc3,2)*157), 172*((i-uc3-(fmod(i-uc3,2)))/2)+uj3+10, 152, 167);
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 4;
        [self.scroll addSubview:fv];
        
		//商品の画像をはる
		__weak UIButton *itembtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[[itembtn layer] setCornerRadius:4.0];
        //[itembtn setClipsToBounds:YES];
		NSString *url_photo=[NSString stringWithFormat:@"%@/%d/s_%@", URL_IMAGE, itemid, photon1];
		NSURL* url = [NSURL URLWithString:url_photo];
		UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(72, 72*p1h/p1w, 20, 20)];
        ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [itembtn addSubview:ai];
        [ai startAnimating];
		//画像キャッシュ
		[itembtn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            if(error){
                [itembtn setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
            }
            [ai stopAnimating];
        }];
		itembtn.frame = CGRectMake(4, 72-72*p1h/p1w+4, 144, 144*p1h/p1w);

		//どのボタンが押されたか判定するためのタグ
		itembtn.tag = i;
		[fv addSubview:itembtn];
		[itembtn addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];

        //コイン画像
        UIImageView *coiniv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 151, 11, 13)];
        coiniv.image = [UIImage imageNamed:@"iconCoin.png"];
        [fv addSubview:coiniv];
        //値段
        UILabel *clabel = [[UILabel alloc] init];
        clabel.frame = CGRectMake(22, 147, 100, 20);
        clabel.backgroundColor = [UIColor clearColor];
        clabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        clabel.font = [UIFont boldSystemFontOfSize:12];
        clabel.text = [NSString stringWithFormat:@"%d コイン",price];
        [fv addSubview:clabel];
    }
    uj3 = uj3 + 172*((i-uc3-(fmod(i-uc3,2)))/2);
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, uj3+50)];

    //表示きりかえ用のviewをはりなおす
    usv.frame = CGRectMake(0, 151, 320, uj3+50);
    [self.scroll addSubview:usv];
    usv.hidden = TRUE;
}

- (void)itembtn:(UIButton*)sender{
    if(usort == 3){
        NSDictionary *iteminfo = [ures valueForKeyPath:[NSString stringWithFormat:@"%d",sender.tag]];
        [iteminfo setValue:uname forKeyPath:@"user_name"];
        [iteminfo setValue:uicon forKeyPath:@"icon"];
        JOSendViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
        detail.item = [iteminfo valueForKeyPath:@"item_id"];
        detail.itemdata = iteminfo;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        NSArray *iteminfo = [ures valueForKeyPath:[NSString stringWithFormat:@"%d",sender.tag]];
        JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
        send.item = [iteminfo valueForKeyPath:@"item_id"];
        send.photo = [iteminfo valueForKeyPath:@"photo1"];
        send.user = [iteminfo valueForKeyPath:@"user_id"];
        send.seller = @"1";
        [self.navigationController pushViewController:send animated:YES];
    }
}

-(void)dob:(UIButton*)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通報" message:@"この商品を通報します" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"通報", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertTextField = [alertView textFieldAtIndex:0];
    //alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"メッセージ(任意)";
    alertView.tag = sender.tag - 100000;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1://押したボタンがOKなら通報
            //通報
            NSLog(@"");
            NSArray *dobbeditem = [ures valueForKeyPath:[NSString stringWithFormat:@"%d",alertView.tag]];
            int iid = [[dobbeditem valueForKeyPath:@"item_id"] intValue];
            int uid = [[dobbeditem valueForKeyPath:@"user_id"] intValue];
            //通信
            ucnct = 2;
            NSString *dataa = [NSString stringWithFormat:@"item_id=%d&user_id=%d&my_id=%d&msg=%@&tag=%d&service=reader", iid, uid, myid, [alertTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], alertView.tag];
            NSLog(@"postdob = %@", dataa);
            NSURL *url = [NSURL URLWithString:URL_ITEM_DOB];
            NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
            async = [JOAsyncConnection alloc];
            async.delegate = self;
            [async asyncConnect:request];
            break;
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
