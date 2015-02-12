//
//  JOBrowse1ViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOBrowse1ViewController.h"

@interface JOBrowse1ViewController ()

@end

@implementation JOBrowse1ViewController

#define T 6

NSArray *conditions, *sizes;
UIScrollView *slide;
NSArray *res;
UIActivityIndicatorView *aiv;
UITextField *alertTextField;
int load, myid, sp, j, c, connect, paging, end;
//load:view did appearで読み込み関数が走るため，ページ遷移するたびに読み直すことがないように１回呼んだら1にする。myid:ユーザーのid　sp:とってくる商品の最初の番号。最初は0でn回目はT(n-1)になる。j:fvをはる高さ。c:商品をはる最初の番号。connect:通信の種別。1は商品読み込み, 2は通報。paging:もっと見るの連打（連続読み込み）対策。通信中は1になっていて呼ばれない。end:とってきた品物数がTより少なかったら1にしてもっと見るを無効にする。
UIView *barView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    load = 0;
    j = 0;
    sp = 0; end = 0;

    browse2 = [self.storyboard instantiateViewControllerWithIdentifier:@"browse2"];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    _scroll.delegate = self;
    _scroll.tag = 1;

    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
    NSString *badge = [ud stringForKey:@"badge"];
    NSLog(@"badge = %@", badge);
    //NSLog(@"mybadge = %@", mybadge);

    UIImage *selectedImage0 = [UIImage imageNamed:@"browseOn.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"browse.png"];
    //タブバー情報を取得
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0]; //1番左のタブが0、順に増やして下さい
    //タブバー選択・非選択時の画像を設定
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    //タブバーの文字色を設定(選択前)
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //タブバーの文字色を設定(選択中)
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateSelected];

    UIImage *selectedImage2 = [UIImage imageNamed:@"messageOn.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"message.png"];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    if(![badge isEqualToString:@"0"]){
        [[[tabBar items] objectAtIndex:1] setBadgeValue:badge];
    }

    UIImage *selectedImage3 = [UIImage imageNamed:@"myPageOn.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"myPage.png"];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    /*if(![mybadge isEqualToString:@"0"]){
        [[[tabBar items] objectAtIndex:2] setBadgeValue:mybadge];
    }*/

    UIImage *selectedImage1 = [UIImage imageNamed:@"giveOn.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"give.png"];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:3];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //[item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    [[tabBar.items objectAtIndex:3] setImageInsets:UIEdgeInsetsMake(7.5, 0, -7.5, 0)];

    //ナビゲーションバーにロゴを
    UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame=CGRectMake(0,0,74,19);
    self.navigationItem.titleView=logo;

    //ナビゲーションバーにボタンを追加
    UIButton *thumb = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 40, 44)];
    [thumb setBackgroundImage:[UIImage imageNamed:@"iconList.png"]
                      forState:UIControlStateNormal];
    [thumb addTarget:self action:@selector(thumb:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* thumbbtn = [[UIBarButtonItem alloc] initWithCustomView:thumb];
    self.navigationItem.leftBarButtonItems = @[thumbbtn];

    //バー
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, -440, 320, 480)];
    UIImage *bar = [UIImage imageNamed:@"subNavBack.png"];
    barView.backgroundColor = [UIColor colorWithPatternImage:bar];
    [self.scroll addSubview:barView];
    barView.tag = 1;

    //近くの商品ボタン
    UIButton *near = [UIButton buttonWithType:UIButtonTypeCustom];
    [near setBackgroundImage:[UIImage imageNamed:@"btnNear.png"] forState:UIControlStateNormal];
    near.frame = CGRectMake(10, 446, 146, 30);
    [barView addSubview:near];
    near.tag = 1;
    [near addTarget:self action:@selector(near:) forControlEvents:UIControlEventTouchUpInside];

    //掘り出し物ボタン
    UIButton *bargain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bargain.frame = CGRectMake(163, 446, 146, 30);
    [bargain setBackgroundImage:[UIImage imageNamed:@"btnBargain.png"] forState:UIControlStateNormal];
    [barView addSubview:bargain];
    bargain.tag = 1;
    [bargain addTarget:self action:@selector(bargain:) forControlEvents:UIControlEventTouchUpInside];

    conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(reload:) name:@"submit" object:nil];
    [nc addObserver:self selector:@selector(pushed:) name:@"pushed0" object:nil];
    [nc addObserver:self selector:@selector(moveTab:) name:@"backFromSend" object:nil];
    [nc addObserver:self selector:@selector(scrollUp) name:@"scrollUp" object:nil];
}

- (void)pushed:(id)sender{
    //pushされた時の
    [self.tabBarController setSelectedIndex:1];
}

- (void)scrollUp{
    // 一番上までスクロール
    [self.scroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

- (void)moveTab:(id)sender{
    NSNotification *n = [NSNotification notificationWithName:@"moveTab" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    [self.tabBarController setSelectedIndex:1];
}

- (void)viewWillAppear:(BOOL)animated{
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(232, 0, 45, 44);
    [search setBackgroundImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:search];
    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    search.tag = 1;

    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh.frame = CGRectMake(276, 0, 45, 44);
    [refresh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:refresh];
    [refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    refresh.tag = 1;
}

- (void)viewDidAppear:(BOOL)animated{
    if(load == 0 || res == nil || [res isEqual:[NSNull null]]){
        res = nil;
        [self getitems];
        load = 1;
    }
}

//通信して品物とってくる関数
- (void) getitems {
    connect = 1;
    NSString *dataa = [NSString stringWithFormat:@"startnumber=%d&totalnumber=%d&user_id=%d", sp, T, myid];
    NSURL *url = [NSURL URLWithString:URL_ITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
    sp = sp + T;
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if(connect == 1){
            if([response count] < T){
                end = 1;
            }
            if([res count] == 0){
                NSLog(@"here1");
                res = response;
                c = 0;
            }else{
                NSLog(@"here2");
                c = [res count];
                res = [res arrayByAddingObjectsFromArray:response];
            }
            [self draw];
        }else{
            if([response valueForKeyPath:@"result"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"通報しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                NSString *tag = [response valueForKeyPath:@"tag"];
                UIButton *dob = (UIButton *)[self.scroll viewWithTag:[tag intValue]];
                dob.hidden = TRUE;
            }
        }
    }
    paging = 0;
    [aiv stopAnimating];
}

//描画する
- (void)draw{

    for(int i=c ; i<[res count] ; i++){

        NSString *iteminfo = [res objectAtIndex:i];
        int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
        int userid = [[iteminfo valueForKeyPath:@"user_id"] intValue];
        NSString *photo1 = [iteminfo valueForKeyPath:@"photo1"];
        int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
        int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
        int p2w = [[iteminfo valueForKeyPath:@"photo2w"] intValue];
        int p2h = [[iteminfo valueForKeyPath:@"photo2h"] intValue];
        int p3w = [[iteminfo valueForKeyPath:@"photo3w"] intValue];
        int p3h = [[iteminfo valueForKeyPath:@"photo3h"] intValue];
        NSString *photo2 = [iteminfo valueForKeyPath:@"photo2"];
        NSString *photo3 = [iteminfo valueForKeyPath:@"photo3"];
        int price = [[iteminfo valueForKeyPath:@"price"] intValue];
        NSString *itemcomment = [iteminfo valueForKeyPath:@"description"];
        int condition = [[iteminfo valueForKeyPath:@"state"] intValue];
        int means1 = [[iteminfo valueForKeyPath:@"ms1"] intValue];
        int means2 = [[iteminfo valueForKeyPath:@"ms2"] intValue];
        int size = [[iteminfo valueForKeyPath:@"dimension"] intValue];
        NSString *username = [iteminfo valueForKeyPath:@"user_name"];
        NSString *icon = [iteminfo valueForKeyPath:@"icon"];
        NSString *dobbing = [iteminfo valueForKeyPath:@"dobbing"];


        //ボタンの枠
        UIView *fv = [[UIView alloc] init];
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 5;
        //fv.layer.shadowOpacity = 0.2;
        //fv.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        [self.scroll addSubview:fv];
        fv.tag = -100000;

        NSString *addtime = [iteminfo valueForKeyPath:@"item_add_time"];
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
        NSString *un=[NSString stringWithFormat:@"             %@",username];
        [usbutton setTitle:un forState:UIControlStateNormal];
        [fv addSubview:usbutton];
        usbutton.tag = userid;
        if(userid != myid){
            [usbutton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [usbutton addTarget:self action:@selector(mypage:) forControlEvents:UIControlEventTouchUpInside];
        }

        //アイコンをはる
        UIImageView *iv2 = [[UIImageView alloc] initWithImage:nil];
        if(!(icon == nil || [icon isEqual:[NSNull null]])){
            NSString *url_photo=[NSString stringWithFormat:@"%@/%d/%@", URL_ICON, userid, icon];
            NSURL *urli = [NSURL URLWithString:url_photo];
            //NSData *data = [NSData dataWithContentsOfURL:urli];
            //UIImage *img = [UIImage imageWithData:data];
            UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
            //画像キャッシュ
            __block UIImageView *blockView = iv2;
            [iv2 setImageWithURL:urli placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    blockView.image = [UIImage imageNamed:@"itemNoImg.png"];
                }
            }];
        }else{
            iv2.image = [UIImage imageNamed:@"iconUser.png"];
        }
        //UIImageView *iv = [[UIImageView alloc] initWithImage:img];
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
                item2.frame = CGRectMake(300, 148-148*p2h/p2w, 296, 296*p2h/p2w);
                [slide addSubview:item2];
                if(myid != userid){
                    [item2 addTarget:self action:@selector(btnreq:) forControlEvents:UIControlEventTouchUpInside];
                    item2.tag = i;
                }else{
                    [item2 addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
                    item2.tag = i;
                }
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
                item3.frame = CGRectMake(600, 148-148*p3h/p3w, 296, 296*p3h/p3w);
                [slide addSubview:item3];
                if(myid != userid){
                    [item3 addTarget:self action:@selector(btnreq:) forControlEvents:UIControlEventTouchUpInside];
                    item3.tag = i;
                }else{
                    [item3 addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
                    item3.tag = i;
                }

                //3まい用のボタン
                UIButton *slide3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
                slide3Btn.frame = CGRectMake(250, 344, 55, 30);
                [slide3Btn setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
                [fv addSubview:slide3Btn];
                [slide3Btn addTarget:self action:@selector(slide3:) forControlEvents:UIControlEventTouchUpInside];
                slide3Btn.tag = i+1;
            }else{
                [slide setContentSize:CGSizeMake(613, 296)];
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
                item2.frame = CGRectMake(300, 148-148*p2h/p2w, 296, 296*p2h/p2w);
                [slide addSubview:item2];
                if(myid != userid){
                    [item2 addTarget:self action:@selector(btnreq:) forControlEvents:UIControlEventTouchUpInside];
                    item2.tag = i;
                }else{
                    [item2 addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
                    item2.tag = i;
                }
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
		if(myid != userid){
			[item addTarget:self action:@selector(btnreq:) forControlEvents:UIControlEventTouchUpInside];
			item.tag = i;
		}else{
            [item addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = i;
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


        //自分のかどうか判定
        if(myid != userid){
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
                btndob.frame = CGRectMake(190, 0, 119, 39);
                [btndob setBackgroundImage:[UIImage imageNamed:@"btnWarning.png"] forState:UIControlStateNormal];
                [btndob addTarget:self action:@selector(dob:) forControlEvents:UIControlEventTouchUpInside];
                [foot addSubview:btndob];
                btndob.tag = 100000 + i;
            }

            fv.frame = CGRectMake(5, j+45, 310, 486+size1.height-m);
        }else{
            fv.frame = CGRectMake(5, j+45, 310, 443+size1.height-m);
        }

        j = j + fv.bounds.size.height + 5;
    }

    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, j+90)];
    /* }else{
     UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
     [alert show];
     }*/
}

-(void)btnreq:(UIButton*)sender{
    /*NSLog(@"res = %@", res);
    NSLog(@"sender = %d", sender.tag);
    NSDictionary *iteminfo = [res objectAtIndex:sender.tag];
    NSLog(@"iteminfo = %@", iteminfo);
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = [iteminfo valueForKeyPath:@"item_id"];
    send.photo = [iteminfo valueForKeyPath:@"photo1"];
    send.user = [iteminfo valueForKeyPath:@"user_id"];
    send.itemdata = iteminfo;
    NSLog(@"user = %@", [iteminfo valueForKeyPath:@"user_id"]);
    send.seller = @"1";
    [self.navigationController pushViewController:send animated:YES];*/
    UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"" message:@"メッセージへ" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    alerts.alertViewStyle = UIAlertViewStyleDefault;
    [alerts show];
    alerts.tag = sender.tag;
}
-(void)myitem:(UIButton*)sender{
    /*NSDictionary *iteminfo = [res objectAtIndex:sender.tag];
    JODetailViewController *detail= [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.item = [iteminfo valueForKeyPath:@"item_id"];
    detail.itemdata = iteminfo;
    NSLog(@"user = %@", [iteminfo valueForKeyPath:@"user_id"]);
    [self.navigationController pushViewController:detail animated:YES];*/

    /*NSDictionary *iteminfo = [res objectAtIndex:sender.tag];
    JOMlistViewController *mlist= [self.storyboard instantiateViewControllerWithIdentifier:@"mlist"];
    mlist.item = [iteminfo valueForKeyPath:@"item_id"];
    mlist.photo = [iteminfo valueForKeyPath:@"photo1"];
    NSLog(@"user = %@", [iteminfo valueForKeyPath:@"user_id"]);
    [self.navigationController pushViewController:mlist animated:YES];*/

    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"" message:@"あなたの品物です" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alertd.alertViewStyle = UIAlertViewStyleDefault;
    [alertd show];
}

-(void)dob:(UIButton*)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通報" message:@"この商品を通報します" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"通報", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertTextField = [alertView textFieldAtIndex:0];
    //alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"メッセージ(任意)";
    alertView.tag = sender.tag;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag >= 100000){
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1://押したボタンがOKなら通報
                //通報
                NSLog(@"");
                NSArray *dobbeditem = [res objectAtIndex:alertView.tag-100000];
                int iid = [[dobbeditem valueForKeyPath:@"item_id"] intValue];
                int uid = [[dobbeditem valueForKeyPath:@"user_id"] intValue];
                //通信
                connect = 2;
                NSString *dataa = [NSString stringWithFormat:@"item_id=%d&user_id=%d&my_id=%d&msg=%@&tag=%d&service=reader", iid, uid, myid, [alertTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], alertView.tag];
                NSLog(@"postdob = %@", dataa);
                NSURL *url = [NSURL URLWithString:URL_ITEM_DOB];
                NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
                async = [JOAsyncConnection alloc];
                async.delegate = self;
                [async asyncConnect:request];
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1:
                NSLog(@"res = %@", res);
                NSLog(@"sender = %d", alertView.tag);
                NSDictionary *iteminfo = [res objectAtIndex:alertView.tag];
                NSLog(@"iteminfo = %@", iteminfo);
                JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
                send.item = [iteminfo valueForKeyPath:@"item_id"];
                send.photo = [iteminfo valueForKeyPath:@"photo1"];
                send.user = [iteminfo valueForKeyPath:@"user_id"];
                send.itemdata = iteminfo;
                NSLog(@"user = %@", [iteminfo valueForKeyPath:@"user_id"]);
                send.seller = @"1";
                [self.navigationController pushViewController:send animated:YES];
                break;
        }
    }
}

- (void)thumb:(UIBarButtonItem*)sender {
    //JOBrowse2ViewController *browse2 = [self.storyboard instantiateViewControllerWithIdentifier:@"browse2"];
    [self.navigationController pushViewController:browse2 animated:NO];
}

- (void)reload:(UIBarButtonItem*)sender {
    if(paging == 0){
        res = NULL;
        for (UIView *subview in [self.scroll subviews]) {
            if(subview.tag == -100000){
                [subview removeFromSuperview];
            }
        }
        j = 0; end = 0;
        sp = 0;
        //itemcheck = [NSMutableArray array];
        [self getitems];
        [self.scroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    }
}

- (void)search:(UIBarButtonItem*)sender {
    JOBrowse1ViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)near:(UIBarButtonItem*)sender {
    JOBrowse1ViewController *near = [self.storyboard instantiateViewControllerWithIdentifier:@"near"];
    [self.navigationController pushViewController:near animated:YES];
}
- (void)bargain:(UIBarButtonItem*)sender {
    JOBrowse1ViewController *bargain = [self.storyboard instantiateViewControllerWithIdentifier:@"bargain"];
    [self.navigationController pushViewController:bargain animated:YES];
}

- (void)user:(UIButton*)sender{
    NSString* tagtag=[NSString stringWithFormat:@"%d",sender.tag];
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = tagtag;
    [self.navigationController pushViewController:user animated:YES];
}

- (void)mypage:(id)sender{
    JOBrowse1ViewController *mypage = [self.storyboard instantiateViewControllerWithIdentifier:@"mypage"];
    [self.navigationController pushViewController:mypage animated:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    if(sender.tag == 1){
        float cp = sender.contentOffset.y;
        float lp = sender.contentSize.height;
        float sheight = [[UIScreen mainScreen] bounds].size.height;
        float height = sheight - (20+44+50);
        if(cp > lp-height-20){
            if(paging == 0 && end == 0){
                NSLog(@"more!");
                aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
                aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [aiv startAnimating];
                [self.scroll addSubview:aiv];
                [self getitems];
                paging = 1;
            }
        }
        if(cp < 0){
            barView.frame = CGRectMake(0, -440+cp, 320, 480);
        }
    }
}

- (void)more:(id)sender{
    [self getitems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    for (UIView *subview in [[self.navigationController navigationBar] subviews]) {
        if(subview.tag == 1){
            [subview removeFromSuperview];
        }
    }
}

@end
