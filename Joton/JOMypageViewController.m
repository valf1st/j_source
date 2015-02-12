//
//  JOMypageViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOMypageViewController.h"

@interface JOMypageViewController ()

@end

@implementation JOMypageViewController

#define T3 14 //いちどにとってくる品物数-3列
#define T1 6 //いちどにとってくる品物数-1列

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

    mypagevc = [NSMutableDictionary dictionary];

    reload = 0; mcnct = 0;
    mjl = 0; mj3 = 0;
    mc3 = 0; mc1 = 0;
    mypaging = 0;
    mysort = 3;
    myend3 = 0; myend1 = 0;
    mydrawn1 = 0;
    myres1 = [NSMutableDictionary dictionary];

    _myscroll.delegate = self;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    self.navigationItem.title = @"マイページ";

    //ナビゲーションバーにボタンを追加
    /*UIBarButtonItem *reload = [[UIBarButtonItem alloc]
                               initWithTitle:@"更新"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(reload)];
    UIBarButtonItem *setting = [[UIBarButtonItem alloc]
                                initWithTitle:@"設定"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(setting:)];
    self.navigationItem.rightBarButtonItems = @[reload, setting];*/

    conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(update) name:@"myupdated" object:nil];
    //[nc addObserver:self selector:@selector(update) name:@"updated" object:nil];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(submit) name:@"submit" object:nil];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(update1) name:@"updated1" object:nil];
    [nc addObserver:self selector:@selector(scrollUp) name:@"scrollUp" object:nil];
}

- (void)scrollUp{
    // 一番上までスクロール
    [self.myscroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *myflag = appDelegate.myflag;
    if([myflag intValue] == 1){
        [self update];
        appDelegate.myflag = @"0";
    }
    /*NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"pushed"]){
        NSArray *option = [ud objectForKey:@"pushed"];
        NSLog(@"option = %@", option);

        JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
        send.item = [option valueForKeyPath:@"item_id"];
        //send.photo = [iteminfo valueForKeyPath:@"photo"];
        send.user = [option valueForKeyPath:@"sender_id"];
        send.seller = @"0";
        send.photo = [option valueForKeyPath:@"photo"];
        [self.navigationController pushViewController:send animated:NO];
    }*/
}

- (void)submit{
    [self.tabBarController setSelectedIndex:0];
}

- (void)update{
    mc3 = 0; mc1 = 0; mjl = 0; mj3 = 0;
    [myres removeAllObjects];
    myres = NULL;
    mupdate = 0;
    for (UIView *subview in [self.myscroll subviews]) {
        if(subview.tag == -100000){
            [subview removeFromSuperview];
        }
    }
    [self viewDidLoad];
    //[self getmyinfo];
}

- (void)update1{
    mc1 = 0; mc3 = 0; mjl = 0; mj3 = 0;
    [myres removeAllObjects];
    myres = NULL;
    [self.myscroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    mupdate = 1;
    //[self getmyinfo];
    for (UIView *subview in [self.myscroll subviews]) {
        if(subview.tag == -100000){
            [subview removeFromSuperview];
        }
    }
    [self viewDidLoad];
}

- (void)reload{
    if(mypaging == 0){
        if(mysort == 3){
            mjl = 0; mj3 = 0;
            mc3 = 0; mc1 = 0;
            mypaging = 0;
            mysort = 3;
            myend3 = 0; myend1 = 0;
            mydrawn1 = 0;
            for (UIView *subview in [self.myscroll subviews]) {
                if(subview.tag == -100000){
                    [subview removeFromSuperview];
                }
            }
            [myres removeAllObjects];
            [self getmyinfo];
            reload = 1;
        }else{
            [self update1];
            [self getmyinfo];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    mysetting = [UIButton buttonWithType:UIButtonTypeCustom];
    mysetting.frame = CGRectMake(232, 0, 45, 44);
    [mysetting setBackgroundImage:[UIImage imageNamed:@"iconSetting.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:mysetting];
    [mysetting addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    
    myrefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    myrefresh.frame = CGRectMake(276, 0, 45, 44);
    [myrefresh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:myrefresh];
    [myrefresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];

    if(reload == 0 || myres == nil || [myres isEqual:[NSNull null]]){
        [myres removeAllObjects];
        [self getmyinfo];
        reload = 1;
    }

    if(openedOnBrowseTab == 1){
        [self reload];
        openedOnBrowseTab = 0;
    }
    if(self.tabBarController.selectedIndex == 0){
        openedOnBrowseTab = 1;
    }
}

- (void)setting:(id)sender {
    JOMypageViewController *setting = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)getmyinfo{
    mcnct = 0;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&total=%d&service=reader", myid, T3];
    NSURL *url = [NSURL URLWithString:URL_MY_ITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSMutableDictionary *)response{
    if(load){
        if(mcnct == 0){
            //初回表示はここ
            myres = response;
            mc3 = 0;
            [self draw];
        }else if(mcnct == 1){
            if(mysort == 3){
                if([[response objectForKey:@"end"] intValue] == 1){
                    myend3 = 1;
                }
                mc3 = [myres count];
                //myres = [myres addEntriesFromDictionary:response];
                NSLog(@"myres = %@", myres);
                NSLog(@"response = %@", response);
                for(int i=0 ; i<[response count]-1 ; i++){
                    NSLog(@"i = %d, cm = %d", i, mc3);
                    NSLog(@"object = %@, key = %d", [response objectForKey:[NSString stringWithFormat:@"'%d'",i]], mc3+i);
                    [myres setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d", mc3+i]];
                    //[myres setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d",cm+i]];
                }
                [self draw3];
            }else{
                if([[response objectForKey:@"end"] intValue] == 1){
                    myend1 = 1;
                }
                mc1 = [myres1 count];
                for(int i=0 ; i<[response count]-1 ; i++){
                    NSLog(@"i = %d, cm = %d", i, mc1);
                    NSLog(@"object = %@, key = %d", [response objectForKey:[NSString stringWithFormat:@"'%d'",i]], mc1+i);
                    [myres1 setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d", mc1+i]];
                    //[myres setObject:[response objectForKey:[NSString stringWithFormat:@"'%d'",i]] forKey:[NSString stringWithFormat:@"%d",cm+i]];
                }
                [self draw1];
            }
        }else if(mcnct == 2){
            NSLog(@"削除したで");
            mwaiting.hidden = TRUE;
            [self update1];
            [self getmyinfo];
        }
    }
    [aiv stopAnimating];
    mypaging = 0;
}

//描画
- (void)draw{
    NSArray *userinfo = [myres valueForKeyPath:@"user_info"];
    icon = [userinfo valueForKeyPath:@"icon"];
    myname = [userinfo valueForKeyPath:@"user_name"];
    int success = [[userinfo valueForKeyPath:@"no_success"] intValue];
    int failure = [[userinfo valueForKeyPath:@"no_failure"] intValue];
    int money = [[userinfo valueForKeyPath:@"money"] intValue];
    int coin = [[userinfo valueForKeyPath:@"coin"] intValue];
    //ユーザーデフォルトに追加
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%d",coin] forKey:@"coin"];
    [ud setObject:[NSString stringWithFormat:@"%d",money] forKey:@"money"];

    //枠背景
    UIView *fv = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 310, 145)];
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgProfileMe.png"]];
    [self.myscroll addSubview:fv];
    fv.tag = -100000;

    //待ち画像
    myiiv = [[UIImageView alloc] init];
    //アイコンをはる
    if(!(icon == nil || [icon isEqual:[NSNull null]])){
        NSString *url_photo=[NSString stringWithFormat:@"%@/%d/%@", URL_ICON, myid, icon];
        NSURL *urli = [NSURL URLWithString:url_photo];
		UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
		//画像キャッシュ
        __block UIImageView *blockView = myiiv;
		[myiiv setImageWithURL:urli placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            if(error){
                blockView.image = [UIImage imageNamed:@"itemNoImg.png"];
            }
        }];
    }else{
        myiiv.image = [UIImage imageNamed:@"iconUser.png"];
    }
    myiiv.frame = CGRectMake(5.5, 5.5, 80, 80);
    [fv addSubview:myiiv];

    //ユーザー名
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.frame = CGRectMake(95, 0, 210, 46);
    nameBtn.backgroundColor = [UIColor clearColor];
    [nameBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [nameBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateHighlighted];
    nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    NSString *un = [NSString stringWithFormat:@"　%@",myname];
    [nameBtn setTitle:un forState:UIControlStateNormal];
    [fv addSubview:nameBtn];
    [nameBtn addTarget:self action:@selector(myedit:) forControlEvents:UIControlEventTouchUpInside];
    //やじるし
    UIImageView *arv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconArrow2.png"]];
    arv1.frame = CGRectMake(191, 15, 11, 17);
    [nameBtn addSubview:arv1];

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
    scl.frame = CGRectMake(125, 70, 80, 15);
    scl.backgroundColor = [UIColor clearColor];
    scl.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    scl.font = [UIFont systemFontOfSize:12];
    scl.text = @"取引成立数";
    [fv addSubview:scl];
    //にこちゃん
    UIImageView *smile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconSmile.png"]];
    smile.frame = CGRectMake(105, 70, 15, 15);
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
    fll.frame = CGRectMake(236, 70, 80, 15);
    fll.backgroundColor = [UIColor clearColor];
    fll.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    fll.font = [UIFont systemFontOfSize:12];
    fll.text = @"対応がbad";
    [fv addSubview:fll];
    //ぶー
    UIImageView *boo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconBad.png"]];
    boo.frame = CGRectMake(216, 70, 15, 16);
    [fv addSubview:boo];

    //枠
    /*UIView *fv2 = [[UIView alloc]initWithFrame:CGRectMake(5, 108, 310, 48)];
    fv2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgReward.png"]];
    [self.myscroll addSubview:fv2];
    fv2.tag = -100000;*/
    //コイン数
    UIButton *moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyBtn.frame = CGRectMake(0, 90, 155, 45);
    moneyBtn.backgroundColor = [UIColor clearColor];
    [moneyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [moneyBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateHighlighted];
    //btnc.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    moneyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [moneyBtn setTitle:[NSString stringWithFormat:@"%d 円", money] forState:UIControlStateNormal];
    [fv addSubview:moneyBtn];
    [moneyBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
    //やじるし
    UIImageView *arv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconArrow2.png"]];
    arv2.frame = CGRectMake(130, 13, 11, 17);
    [moneyBtn addSubview:arv2];
    //見出し
    UILabel *mlabel = [[UILabel alloc] init];
    mlabel.frame = CGRectMake(52, 123, 100, 15);
    mlabel.backgroundColor = [UIColor clearColor];
    mlabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    mlabel.font = [UIFont systemFontOfSize:12];
    mlabel.text = @"出品報酬";
    [fv addSubview:mlabel];

    //現金残高
    UIButton *coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coinBtn.frame = CGRectMake(155, 90, 155, 45);
    coinBtn.backgroundColor = [UIColor clearColor];
    [coinBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [coinBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateHighlighted];
    //btnm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    coinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [coinBtn setTitle:[NSString stringWithFormat:@"%d コイン", coin] forState:UIControlStateNormal];
    [fv addSubview:coinBtn];
    [coinBtn addTarget:self action:@selector(coin:) forControlEvents:UIControlEventTouchUpInside];
    //やじるし
    UIImageView *arv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconArrow2.png"]];
    arv3.frame = CGRectMake(130, 13, 11, 17);
    [coinBtn addSubview:arv3];
    //見出し
    UILabel *clabel = [[UILabel alloc] init];
    clabel.frame = CGRectMake(187, 123, 300, 15);
    clabel.backgroundColor = [UIColor clearColor];
    clabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    clabel.font = [UIFont systemFontOfSize:12];
    clabel.text = @"利用可能コイン数";
    [fv addSubview:clabel];

/*
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getBtn.frame = CGRectMake(50, 155, 220, 30);
    [getBtn setTitle:@"コインを手に入れる" forState:UIControlStateNormal];
    [self.scroll addSubview:getBtn];
    [getBtn addTarget:self action:@selector(getcoin:) forControlEvents:UIControlEventTouchUpInside];
*/

    //吹き出し枠
    UIView *bv = [[UIView alloc]initWithFrame:CGRectMake(5, 162, 310, 45)];
    bv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBalloon.png"]];
    [self.myscroll addSubview:bv];
    bv.tag = -100000;
    //線
    UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(155, 1, 1, 34)];
    bar.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [bv addSubview:bar];

    UIButton *sBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sBtn.frame = CGRectMake(5, 0, 161, 36);
    [sBtn setTitle:@"自分の出品" forState:UIControlStateNormal];
    sBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateHighlighted];
    [bv addSubview:sBtn];
    [sBtn addTarget:self action:@selector(btnswitch:) forControlEvents:UIControlEventTouchUpInside];

    siv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 16, 16)];
    siv.image = [UIImage imageNamed:@"iconListMypage.png"];
    [sBtn addSubview:siv];


    //譲渡履歴ラベルとみせかけたボタン
    UIButton *htlabel = [UIButton buttonWithType:UIButtonTypeCustom];
    htlabel.frame = CGRectMake(155, 0, 160, 36);
    [htlabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [htlabel setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateHighlighted];
    htlabel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    htlabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [htlabel setTitle:@"リクエスト履歴　　" forState:UIControlStateNormal];
    [bv addSubview:htlabel];
    [htlabel addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    //やじるし
    UIImageView *arv4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconArrow2.png"]];
    arv4.frame = CGRectMake(130, 10, 11, 17);
    [htlabel addSubview:arv4];

    if(![myres valueForKeyPath:@"0"]){
        UILabel *niLabel = [[UILabel alloc] init];
        niLabel.frame = CGRectMake(20, 260, 280, 40);
        niLabel.text = @"出品がありません";
        niLabel.backgroundColor = [UIColor clearColor];
        niLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        niLabel.textAlignment = NSTextAlignmentCenter;
        [self.myscroll addSubview:niLabel];
        sBtn.enabled = NO;
        myend3 = 1; myend1 = 1;
    }else{
        //商品はりまくる
        int i;
        for(i=0 ; i<[myres count]-1 ; i++){
            NSArray *iteminfo = [myres valueForKeyPath:[NSString stringWithFormat:@"%d",i]];
            int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
            NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
            int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
            int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
            int people = [[iteminfo valueForKeyPath:@"nego"] intValue];
            int price = [[iteminfo valueForKeyPath:@"price"] intValue];
            //int unchecked = [[iteminfo valueForKeyPath:@"unchecked"] intValue];
            
            //ボタンの枠
            UIView *fv = [[UIView alloc] init];
            fv.frame = CGRectMake(5+(fmod(i,2)*157), 172*((i-(fmod(i,2)))/2)+205, 152, 167);
            fv.backgroundColor = [UIColor whiteColor];
            fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            fv.layer.borderWidth = 1.0;
            fv.layer.cornerRadius = 5;
            [self.myscroll addSubview:fv];
            fv.tag = -100000;
            
			//商品の画像をはる
            __weak UIButton *itembtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *url_photo=[NSString stringWithFormat:@"%@/%d/s_%@", URL_IMAGE, itemid, photon1];
            NSURL* url = [NSURL URLWithString:url_photo];
			UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
            UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(72, 72*p1h/p1w, 20, 20)];
            ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [itembtn addSubview:ai];
            [ai startAnimating];
			//画像キャッシュ
			[itembtn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    [itembtn setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                }
                if(people > 0){
                    UIImageView *pmsg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconThumbInterest.png"]];
                    pmsg.frame = CGRectMake(100, 100, 45, 45);
                    [fv addSubview:pmsg];
                }
                [ai stopAnimating];
            }];
            //[[itembtn layer] setCornerRadius:4.0];
            //[itembtn setClipsToBounds:YES];
			itembtn.frame = CGRectMake(4, 72-72*p1h/p1w+4, 144, 144*p1h/p1w);

			//どのボタンが押されたか判定するためのタグ
			itembtn.tag = i;
			[fv addSubview:itembtn];
            if(people > 0){
                UIImageView *pmsg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconThumbInterest.png"]];
                pmsg.frame = CGRectMake(100, 100, 45, 45);
                [fv addSubview:pmsg];
            }
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

        mj3 = 172*((i-1-(fmod(i-1,2)))/2)+372;
        [self.myscroll setScrollEnabled:YES];
        [self.myscroll setContentSize:CGSizeMake(320, mj3+50)];
    }

    //表示きりかえ用のviewを作っておく
    ssv = [[UIView alloc] initWithFrame:CGRectMake(0, 205, 320, 1000)];
    ssv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //ssv.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.myscroll addSubview:ssv];
    ssv.hidden = TRUE;
    ssv.tag = -100000;

    reload = 1;

    if(mupdate == 1){
        [self sort1];
        siv.image = [UIImage imageNamed:@"iconThumbMypage.png"];//
        mupdate = 0;
    }
}

- (void)icon:(id)sender{
    
}

- (void)btnswitch:(id)sender{
    if(mysort == 3){
        [self sort1];
        siv.image = [UIImage imageNamed:@"iconThumbMypage.png"];//
    }else{
        [self sort3];
        siv.image = [UIImage imageNamed:@"iconListMypage.png"];
    }
}

- (void)myedit:(id)sender{
    JOMypageViewController *myedit = [self.storyboard instantiateViewControllerWithIdentifier:@"myedit0"];
    [self presentViewController:myedit animated:YES completion:nil];
}

- (void)money:(id)sender{
    JOMypageViewController *money = [self.storyboard instantiateViewControllerWithIdentifier:@"money"];
    [self.navigationController pushViewController:money animated:YES];
}

- (void)coin:(id)sender{
    JOMypageViewController *coin = [self.storyboard instantiateViewControllerWithIdentifier:@"coin"];
    [self.navigationController pushViewController:coin animated:YES];
}

- (void)getcoin:(id)sender{
    
}

- (void)edit:(UIButton *)sender{
    JOEditViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    NSArray *iteminfo = [myres1 valueForKeyPath:[NSString stringWithFormat:@"%d",sender.tag]];
    edit.item = [iteminfo valueForKeyPath:@"item_id"];
    edit.photo1 = [iteminfo valueForKeyPath:@"photo1"];
    edit.photo2 = [iteminfo valueForKeyPath:@"photo2"];
    edit.photo3 = [iteminfo valueForKeyPath:@"photo3"];
    edit.comment = [iteminfo valueForKeyPath:@"description"];
    edit.cd = [iteminfo valueForKeyPath:@"state"];
    edit.ms1 = [iteminfo valueForKeyPath:@"ms1"];
    edit.ms2 = [iteminfo valueForKeyPath:@"ms2"];
    edit.sz = [iteminfo valueForKeyPath:@"dimension"];
    edit.location = [iteminfo valueForKeyPath:@"lat_lon"];
    edit.from = @"1";
    [self presentViewController:edit animated:YES completion:nil];
}


- (void)notdelete:(UIButton *)sender{
    NSString *message = [NSString stringWithFormat:@"あと %d日間は削除できません", sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出品後７日間は削除できません" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}
- (void)delete:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"削除します" message:@"確認" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    alert.tag = sender.tag;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1:
            //通信まちの間，半透明viewで覆っておく
            mwaiting = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,835)];
            mwaiting.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            [self.view addSubview:mwaiting];
            [self dconnect:alertView.tag];
            break;
    }
}
//通信して削除
- (void)dconnect:(int)iid {
    mcnct = 2;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //通信
    NSString *dataa = [NSString stringWithFormat:@"item_id=%d&user_id=%d", iid, myid];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_ITEM_DELETE];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}


- (void)sort3{
    NSLog(@"sort3");
    ssv.hidden = TRUE;
    [_myscroll setContentSize:CGSizeMake(320, mj3+50)];
    mysort = 3;
}

- (void)sort1{
    NSLog(@"sort1");
    ssv.hidden = FALSE;
    [_myscroll setContentSize:CGSizeMake(320, mjl+280)];
    mysort = 1;
    if(mydrawn1 == 0){
        [self draw1];
        mydrawn1 = 1;
    }
}

- (void)more3:(id)sender{
    [self getmoreinfo3];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    float lp = sender.contentSize.height;
    float sheight = [[UIScreen mainScreen] bounds].size.height;
    float height = sheight - (20+44+50);
    if(mysort == 3 && myend3 == 0 && mupdate == 0){
        if(cp > lp-height-20){
            if(mypaging == 0){
                mypaging = 1;
                aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
                aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [aiv startAnimating];
                [self.myscroll addSubview:aiv];
                [self getmoreinfo3];
            }
        }
    }else if(mysort == 1 && myend1 == 0 && mupdate == 0){
        if(cp > lp-height-20){
            if(mypaging == 0){
                mypaging = 1;
                aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
                aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [aiv startAnimating];
                [self.myscroll addSubview:aiv];
                [self getmoreinfo1];
            }
        }
    }
}

- (void)getmoreinfo3{
    mcnct = 1;
    mc3 = mc3+T3;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&startnumber=%d&totalnumber=%d", myid, mc3, T3];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_MY_MOREITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)draw3{
    //商品はりまくる
    int i;
    for(i=mc3 ; i<[myres count] ; i++){
        NSArray *iteminfo = [myres objectForKey:[NSString stringWithFormat:@"%d",i]];
        int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
        NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
        int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
        int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
        int people = [[iteminfo valueForKeyPath:@"nego"] intValue];
        int price = [[iteminfo valueForKeyPath:@"price"] intValue];
        //int unchecked = [[iteminfo valueForKeyPath:@"unchecked"] intValue];

        //ボタンの枠
        UIView *fv = [[UIView alloc] init];
        fv.frame = CGRectMake(5+(fmod(i-mc3,2)*157), 172*((i-mc3-(fmod(i-mc3,2)))/2)+mj3+5, 152, 167);
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 5;
        [self.myscroll addSubview:fv];
        fv.tag = -100000;

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
		[itembtn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            if(error){
                [itembtn setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
            }
            if(people > 0){
                UIImageView *pmsg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconThumbInterest.png"]];
                pmsg.frame = CGRectMake(100, 100, 45, 45);
                [fv addSubview:pmsg];
            }
            [ai stopAnimating];
        }];
		itembtn.frame = CGRectMake(4, 72-72*p1h/p1w+4, 144, 144*p1h/p1w);

		//どのボタンが押されたか判定するためのタグ
		itembtn.tag = i;
		[fv addSubview:itembtn];
        if(people > 0){
            UIImageView *pmsg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconThumbInterest.png"]];
            pmsg.frame = CGRectMake(100, 100, 45, 45);
            [fv addSubview:pmsg];
        }
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
    mj3 = mj3 + 172*((i-mc3-(fmod(i-mc3,2)))/2);
    [self.myscroll setScrollEnabled:YES];
    [self.myscroll setContentSize:CGSizeMake(320, mj3+50)];

    //表示きりかえ用のviewをはりなおす
    ssv.frame = CGRectMake(0, 205, 320, mj3+50);
    [self.myscroll addSubview:ssv];
    ssv.hidden = TRUE;
}

- (void)draw1{
    /*int t;
    if([myres1 count] == 0){
        t = c1;
    }else{
        t = [myres1 count];
    }*/
    if([myres1 count] <= 1){
        for(int i=0 ; i<T1 ; i++){
            [myres1 setValue:[myres valueForKeyPath:[NSString stringWithFormat:@"%d",i]] forKeyPath:[NSString stringWithFormat:@"%d",i]];
        }
    }
    for(int i=mc1 ; i<[myres1 count] ; i++){
        NSLog(@"i = %d", i);
        NSArray *iteminfo = [myres1 valueForKeyPath:[NSString stringWithFormat:@"%d",i]];
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
        int stage = [[iteminfo valueForKeyPath:@"stage"] intValue];
        int people = [[iteminfo valueForKeyPath:@"nego"] intValue];
        //NSString *username = [iteminfo valueForKeyPath:@"user_name"];
        //NSString *icon = [iteminfo valueForKeyPath:@"icon"];

        //ボタンの枠
        UIView *fv = [[UIView alloc] init];
        fv.frame = CGRectMake(5, mjl, 310, 505);
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 5;
        [ssv addSubview:fv];
        fv.tag = -100000;

            
        UIButton *plist = [UIButton buttonWithType:UIButtonTypeCustom];
        plist.frame = CGRectMake(0, 0, 310, 36);
        plist.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [plist setTitle:[NSString stringWithFormat:@"　　%d人が興味を持っています", people] forState:UIControlStateNormal];
        [plist setTitleColor:[UIColor colorWithRed:0.60 green:0.62 blue:0.63 alpha:1.0] forState:UIControlStateNormal];
        [plist setBackgroundImage:[UIImage imageNamed:@"bgInterest.png"] forState:UIControlStateNormal];
        plist.titleLabel.font = [UIFont systemFontOfSize:15];
        [fv addSubview:plist];
        [plist addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
        plist.tag = i;
        int pp = 36;
        UIImageView *ar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconArrow2.png" ]];
        ar.frame = CGRectMake(285, 10, 11, 17);
        [plist addSubview:ar];
        if(people == 0){
            plist.userInteractionEnabled = NO;
        }
        UIImageView *msg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconListMessage.png"]];
        msg.frame = CGRectMake(13, 13, 13, 12);
        [plist addSubview:msg];

        NSString *addtime = [iteminfo valueForKeyPath:@"add_time"];
        NSString *time = [JOFunctionsDefined sinceFromData:addtime];
        UIFont *fontt = [UIFont boldSystemFontOfSize:13];
        UILineBreakMode modet = NSLineBreakByWordWrapping;
        CGSize boundst = CGSizeMake(90, 20);
        CGSize sizet = [time sizeWithFont:fontt constrainedToSize:boundst lineBreakMode:modet];
        //時間
        UILabel *dlabel = [[UILabel alloc] init];
        dlabel.frame = CGRectMake(302-sizet.width, 14+pp, sizet.width, 20);
        dlabel.backgroundColor = [UIColor clearColor];
        dlabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
        dlabel.textAlignment = NSTextAlignmentRight;
        dlabel.font = fontt;
        dlabel.text = time;
        [fv addSubview:dlabel];
        //時計マーク
        UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time.png"]];
        clock.frame = CGRectMake(285-sizet.width, 18+pp, 12, 12);
        [fv addSubview:clock];

        //出品者のユーザーネームをはる(ラベルと見せかけたボタンです)
        UIButton *usbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        usbutton.frame = CGRectMake(0, 7+pp, 250, 32);
        usbutton.backgroundColor = [UIColor clearColor];
        [usbutton setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
        [usbutton setTitleColor: [UIColor colorWithRed:0.32 green:0.59 blue:0.82 alpha:1.0] forState:UIControlStateHighlighted];
        usbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        usbutton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        NSString *un=[NSString stringWithFormat:@"             %@",myname];
        [usbutton setTitle:un forState:UIControlStateNormal];
        [fv addSubview:usbutton];
        usbutton.userInteractionEnabled = NO;
        //usbutton.tag = myid;
        //[usbutton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];

		//出品者のアイコンをはる
		UIImageView *iv2;
        if(icon == nil || [icon isEqual:[NSNull null]]){
            UIImage *imgi = [UIImage imageNamed:@"iconUser.png"];
            iv2 = [[UIImageView alloc] initWithImage:imgi];
        }else{
            NSString *url_icon=[NSString stringWithFormat:@"%@/%d/s_%@", URL_ICON, myid, icon];
            NSURL* urli = [NSURL URLWithString:url_icon];
			UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
			iv2 = [[UIImageView alloc] initWithImage:nil];
			//画像キャッシュ
			[iv2 setImageWithURL:urli placeholderImage:placeholderImage];
        }
		iv2.frame = CGRectMake(7, 7+pp, 33, 33);
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
            UIScrollView *slide = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 46+pp, 296, 296)];
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
                slide3Btn.frame = CGRectMake(250, 342+pp, 55, 30);
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
                item2.frame = CGRectMake(300, 0, 296, 296);
                [slide addSubview:item2];
                [item2 addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
                item2.tag = i;
                //2まい用のボタン
                UIButton *slide2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
                slide2Btn.frame = CGRectMake(255, 342+pp, 55, 30);
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
			item.frame = CGRectMake(7, 46+pp, 296, 296*p1h/p1w);
			[fv addSubview:item];
            m = 296-296*p1h/p1w;
        }
		//画像にリンクをつける
		//if(myid != userid){
			[item addTarget:self action:@selector(itembtn1:) forControlEvents:UIControlEventTouchUpInside];
			item.tag = i;
		//}

        //コイン画像
        UIImageView *coiniv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 351-m+pp, 11, 13)];
        coiniv.image = [UIImage imageNamed:@"iconCoin.png"];
        [fv addSubview:coiniv];
        //値段
        UILabel *clabel = [[UILabel alloc] init];
        clabel.frame = CGRectMake(22, 348-m+pp, 100, 20);
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
        cmlabel.frame = CGRectMake(7, 375-m+pp, 295, size1.height);
        cmlabel.text = cmtitle;
        [fv addSubview:cmlabel];


        //配送方法表示
        UILabel *hslabel = [[UILabel alloc] init];
        hslabel.frame = CGRectMake(0, 382.5+size1.height-m+pp, 310, 31);
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
        cdlabel.frame = CGRectMake(0, 413+size1.height-m+pp, 310, 31);
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
        szlabel.frame = CGRectMake(180, 413+size1.height-m+pp, 130, 31);
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

        if(stage == 1 || stage == 0){
            //編集
            UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            editBtn.frame = CGRectMake(5, 450+size1.height-m+pp, 113, 27);
            [editBtn setBackgroundImage:[UIImage imageNamed:@"btnEdit.png"] forState:UIControlStateNormal];
            [fv addSubview:editBtn];
            [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
            editBtn.tag = i;
            //削除
            UIButton *dltBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            dltBtn.frame = CGRectMake(192, 450+size1.height-m+pp, 113, 27);
            [dltBtn setBackgroundImage:[UIImage imageNamed:@"btnDelete.png"] forState:UIControlStateNormal];
            [fv addSubview:dltBtn];
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormater dateFromString:addtime];
            NSTimeInterval since = [now timeIntervalSinceDate:date];
            if(since >= 604800){
                [dltBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                dltBtn.tag = itemid;
            }else{
                int dd = 7 - (int)since/86400;
                [dltBtn addTarget:self action:@selector(notdelete:) forControlEvents:UIControlEventTouchUpInside];
                dltBtn.tag = dd;
            }
        }else if(stage == 3){
            UIImageView *dispatch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deal.png"]];
            dispatch.frame = CGRectMake(87, 448+size1.height-m+pp, 135, 28);
            [fv addSubview:dispatch];
        }else if(stage == 4){
            UIImageView *delivered = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dealFinish.png"]];
            delivered.frame = CGRectMake(87, 448+size1.height-m+pp, 135, 28);
            [fv addSubview:delivered];
        }

        fv.frame = CGRectMake(5, mjl, 310, 483+size1.height-m+pp);

        mjl = mjl + fv.bounds.size.height + 5;
    }

    ssv.frame = CGRectMake(0, 205, 320, mjl+50);
    [_myscroll setScrollEnabled:YES];
    [_myscroll setContentSize:CGSizeMake(320, mjl+280)];
}

- (void)getmoreinfo1{
    mcnct = 1;
    NSLog(@"more1");
    mc1 = mc1+T1;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&startnumber=%d&totalnumber=%d", myid, mc1, T1];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_MY_MOREITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)history:(id)sender{
    JOMypageViewController *history = [self.storyboard instantiateViewControllerWithIdentifier:@"history"];
    [self.navigationController pushViewController:history animated:YES];
}

- (void)itembtn:(UIButton *)sender{
    NSMutableDictionary *iteminfo = [myres valueForKeyPath:[NSString stringWithFormat:@"%d",sender.tag]];
    if(mysort == 3){
        [iteminfo setObject:myname forKey:@"user_name"];
        [iteminfo setObject:icon forKey:@"icon"];
        JODetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
        detail.item = [iteminfo valueForKeyPath:@"item_id"];
        detail.itemdata = iteminfo;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        JOMlistViewController *mlist = [self.storyboard instantiateViewControllerWithIdentifier:@"mlist"];
        mlist.item = [iteminfo valueForKeyPath:@"item_id"];
        mlist.photo = [iteminfo valueForKeyPath:@"photo1"];
        [self.navigationController pushViewController:mlist animated:YES];
    }
}
- (void)itembtn1:(id)sender{
    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"" message:@"あなたの品物です" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alertd.alertViewStyle = UIAlertViewStyleDefault;
    [alertd show];
}
/*- (void)itembtnm:(UIButton *)sender{
 NSMutableDictionary *iteminfo = [myres objectForKey:[NSString stringWithFormat:@"%d",sender.tag]];
 [iteminfo setObject:myname forKey:@"user_name"];
 [iteminfo setObject:icon forKey:@"icon"];
 JODetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
 detail.item = [iteminfo valueForKeyPath:@"item_id"];
 detail.itemdata = iteminfo;
 [self.navigationController pushViewController:detail animated:YES];
 }*/

- (void)slide2:(UIButton *)sender{
    UIScrollView *slideview = (UIScrollView *)[self.myscroll viewWithTag:-sender.tag];
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
    UIScrollView *slideview = (UIScrollView *)[self.myscroll viewWithTag:-sender.tag];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    mysetting.hidden = TRUE;
    myrefresh.hidden = TRUE;
    /*if(self.tabBarController.selectedIndex == 2){
        [mypagevc setObject:[NSString stringWithFormat:@"%d", mjl] forKey:@"mjl"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", mj3] forKey:@"mj3"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", mc1] forKey:@"mc1"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", mc3] forKey:@"mc3"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", sort] forKey:@"sort"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", end3] forKey:@"end3"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", end1] forKey:@"end1"];
        [mypagevc setObject:[NSString stringWithFormat:@"%d", drawn1] forKey:@"drawn1"];
    }else{
        //[self.view dealloc];
        UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        // add subviews
        self.view = view;
    }*/
    //[self.view removeFromSuperview];//to release the controller's view
    //[imageViewControllers replaceOjectAtIndex:page withObject:[NSNull null]];//to release the actual controller which should lead to it being dealocated
}

@end
