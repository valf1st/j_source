//
//  JOSendViewController.m
//  Joton
//
//  Created by Val F on 13/03/21.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOSendViewController.h"

@interface JOSendViewController ()

@end

@implementation JOSendViewController

#define T 15

@synthesize item = _item;
@synthesize itemdata = _itemdata;
@synthesize photo = _photo;
@synthesize user = _user;//このuserは相手のことなのでbuyerかsellerかは不明
@synthesize seller = _seller;//自分の出品ならseller=0
@synthesize from = _from;//無限ループ回避

UIView *msgView, *btnView, *popView, *pv, *numberpad, *yet;
UITextView *msgTV;
UIButton *reqBtn, *proBtn, *yetBtn, *msgBtn, *actBtn, *adrBtn, *iconButton, *userButton, *areaBtn;
CGRect rect;
CGFloat sheight;
int myid, nego_id, mycoin, k, l, reload, price, ctag, reqtag, protag, kh, kb, paging, ends, sv, up, stag, prevmonth, prevdate, stage;
NSString *uname, *icon, *myicon, *myname, *maddress;
UITextField *pctf, *patf;
UILabel *nmlabel, *btntext, *ncbar;
UITapGestureRecognizer *tap;
UIPickerView *picker;
NSArray *countyarray, *pickerData;

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

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgStripe.png"]]];

    reload = 0; sv = 1; paging = 0; ends = 0; up = 0;
    //self.navigationItem.title = @"個別メッセージ";

    _scroll.delegate = self;

    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem=backButton;

    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
    mycoin = [[ud stringForKey:@"coin"] intValue];
    myicon = [ud stringForKey:@"user_icon"];
    myname = [ud stringForKey:@"username"];

    [ud removeObjectForKey:@"pushed"];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    sheight = screenSize.height;

    //バー
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
    barView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSubNavi.png"]];
    [self.view addSubview:barView];
    //左にユーザーアイコン
    iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(5, 5, 33, 33);
    UIImage *imgi = [UIImage imageNamed:@"iconUser.png"];
    [iconButton setBackgroundImage:imgi forState:UIControlStateNormal];
    [self.view addSubview:iconButton];
    [iconButton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];

    //ユーザー名
    userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.frame = CGRectMake(10, 5, 160, 35);
    //[userButton setTitle:_uname forState:UIControlStateNormal];
    [userButton setTitleColor:[UIColor colorWithRed:0.18 green:0.36 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
    [userButton setTitleColor: [UIColor colorWithRed:0.32 green:0.59 blue:0.82 alpha:1.0] forState:UIControlStateHighlighted];
    userButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    userButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    userButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userButton];
    [userButton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
    userButton.userInteractionEnabled = NO;

	//右に品物
	UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
	itemButton.frame = CGRectMake(282, 5, 33, 33);
    NSString *url_photo=[NSString stringWithFormat:@"%@/%@/s_%@", URL_IMAGE, _item, _photo];
    NSURL* urlp = [NSURL URLWithString:url_photo];
	[itemButton addTarget:self action:@selector(item:) forControlEvents:UIControlEventTouchUpInside];
	UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
	//画像キャッシュ
	[itemButton setBackgroundImageWithURL:urlp forState:UIControlStateNormal placeholderImage:placeholderImage];
    [self.view addSubview:itemButton];


    //上にバーだす
    ncbar = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 43)];
    ncbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgMypageSubnav.png"]];
    ncbar.lineBreakMode = NSLineBreakByWordWrapping;
    ncbar.text = @"あなたはコインを持っていません。\nまずはコインをゲットしよう！";
    ncbar.numberOfLines = 2;
    ncbar.textAlignment = NSTextAlignmentCenter;
    ncbar.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:ncbar];
    ncbar.hidden = TRUE;


    //アクションボタン用のview
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, sheight-173, 320, 65)];
    btnView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgRequest.png"]];
    //[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [self.view addSubview:btnView];
    //文章
    btntext = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 320, 40)];
    btntext.textColor = [UIColor whiteColor];
    btntext.font = [UIFont systemFontOfSize:10];
    btntext.textAlignment = NSTextAlignmentCenter;
    btntext.backgroundColor = [UIColor clearColor];
    [btnView addSubview:btntext];
    //btnView.hidden = TRUE;


    //入力欄
    msgView = [[UIView alloc]initWithFrame:CGRectMake(0, sheight-109, 320, 288)];
    msgView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgInputForm"]];
    [self.view addSubview:msgView];

    actBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    actBtn.frame = CGRectMake(5, 5, 32, 36);
    [actBtn setBackgroundImage:[UIImage imageNamed:@"btnArrowClose.png"] forState:UIControlStateNormal];
    [msgView addSubview:actBtn];
    [actBtn addTarget:self action:@selector(actup:) forControlEvents:UIControlEventTouchUpInside];

    adrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adrBtn.frame = CGRectMake(40, 5, 32, 36);
    [adrBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [adrBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    adrBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    adrBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [adrBtn setBackgroundImage:[UIImage imageNamed:@"btnAddress.png"] forState:UIControlStateNormal];
    [msgView addSubview:adrBtn];
    [adrBtn addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];

    msgTV = [[UITextView alloc] initWithFrame:CGRectMake(75, 5, 185, 35)];
    //msgtv.borderStyle = UITextBorderStyleRoundedRect;
    msgTV.layer.cornerRadius = 5;
    [msgTV.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [msgTV.layer setBorderWidth: 1.0];
    msgTV.clipsToBounds = YES;
    msgTV.font = [UIFont systemFontOfSize:15];
    [msgView addSubview:msgTV];
    msgTV.delegate = self;

    msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(265, 5, 51, 36);
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"btnSend.png"] forState:UIControlStateNormal];
    [msgView addSubview:msgBtn];
    [msgBtn addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];

    //悪評ボタンの下に押された後のボタン跡をおいとく
    yet = [[UIView alloc] initWithFrame:CGRectMake(0, sheight-173, 65, 65)];
    yet.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btnBadOn.png"]];
    [self.view addSubview:yet];
    yet.hidden = TRUE;
    //悪評ボタン
    yetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yetBtn.frame = CGRectMake(0, 0, 65, 65);
    [yetBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [yetBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yetBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    [yetBtn setBackgroundImage:[UIImage imageNamed:@"btnBad.png"] forState:UIControlStateNormal];
    [yet addSubview:yetBtn];
    [yetBtn addTarget:self action:@selector(actionb:) forControlEvents:UIControlEventTouchUpInside];
    yetBtn.hidden = TRUE;

    [self addpop];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changekeyboard:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [self hideTabBar];
    if(reload == 0){
        //自分の出品ならseller=0
        if([_seller intValue] == 1){
            [self findnego];
            NSLog(@"findnego");
        }else{
            [self findmynego];
            NSLog(@"findmynego");
        }
    }
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if(ctag == 0){
            if(sv == 1){NSLog(@"sv1");
                NSArray *info = [response valueForKeyPath:@"info"];
                icon = [info valueForKeyPath:@"icon"];
                uname = [info valueForKeyPath:@"user_name"];
                price = [[info valueForKeyPath:@"price"]intValue];
                int resigned = [[info valueForKeyPath:@"resigned"]intValue];
                nego_id = [[info valueForKeyPath:@"nego_id"] intValue];
                stage = [[info valueForKeyPath:@"stage"] intValue];
                NSLog(@"nego_id = %d", nego_id);
                //相手のusernameはる
                self.navigationItem.title = uname;
                NSLog(@"userid = %@", _user);
                //出品者のアイコンをはる
                if([_seller intValue] == 1){
                    [userButton setTitle:[NSString stringWithFormat:@"　　　%@", uname] forState:UIControlStateNormal];
                    if(!(icon == nil || [icon isEqual:[NSNull null]])){
                        NSString *url_icon=[NSString stringWithFormat:@"%@/%@/s_%@", URL_ICON, _user, icon];
                        NSURL* urli = [NSURL URLWithString:url_icon];
                        UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
                        //画像キャッシュ
                        [iconButton setBackgroundImageWithURL:urli forState:UIControlStateNormal placeholderImage:placeholderImage];
                    }
                    userButton.userInteractionEnabled = YES;
                }else{
                    [userButton setTitle:[NSString stringWithFormat:@"　　　%@", myname] forState:UIControlStateNormal];
                    NSString *url_icon=[NSString stringWithFormat:@"%@/%d/s_%@", URL_ICON, myid, myicon];
                    NSURL* urli = [NSURL URLWithString:url_icon];
                    UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
                    //画像キャッシュ
                    [iconButton setBackgroundImageWithURL:urli forState:UIControlStateNormal placeholderImage:placeholderImage];
                    userButton.userInteractionEnabled = NO;
                    if([_user intValue] == 0){
                        self.navigationItem.title = @"運営事務局";
                        actBtn.enabled = NO;
                        adrBtn.enabled = NO;
                        msgBtn.enabled = NO;
                        iconButton.enabled = NO;
                        userButton.enabled = NO;
                        msgTV.editable = NO;
                        tap.enabled = NO;
                    }
                }
                if([_seller intValue] == 1){
                    NSLog(@"i am a buyer");
                    //if([response valueForKeyPath:@"0"]){
                        [self draw:response];
                    //}
                    NSString *badge = [response valueForKeyPath:@"badge"];
                    NSLog(@"badge1 = %@", badge);
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:badge forKey:@"badge"];
                    UITabBar *tabBar = self.tabBarController.tabBar;
                    if(![[ud stringForKey:@"badge"] isEqualToString:@"0"]){
                        [[[tabBar items] objectAtIndex:1] setBadgeValue:[ud stringForKey:@"badge"]];
                    }else{
                        [[[tabBar items] objectAtIndex:1] setBadgeValue:nil];
                    }
                    //コインが足りなかったらリクエストボタンをdisableしてコインゲットボタンをだす
                    if(mycoin < price){
                        if([[info valueForKeyPath:@"stage"] intValue] != 1){
                            btnView.hidden = TRUE;
                            reqBtn.hidden = TRUE;
                        }
                        /*//コインゲットボタン
                         UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                         getBtn.frame = CGRectMake(75, 200+k-64, 170, 30);
                         [getBtn setTitle:@"コインを手に入れる" forState:UIControlStateNormal];
                         [self.scroll addSubview:getBtn];
                         [getBtn addTarget:self action:@selector(getcoin:) forControlEvents:UIControlEventTouchUpInside];*/
                        ncbar.hidden = FALSE;
                    }
                }else{
                    if([response valueForKeyPath:@"0"]){
                        [self mydraw:response];
                    }
                    NSString *badge = [response valueForKeyPath:@"badge"];
                    NSLog(@"badge2 = %@", badge);
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:badge forKey:@"badge"];
                    UITabBar *tabBar = self.tabBarController.tabBar;
                    if(![[ud stringForKey:@"badge"] isEqualToString:@"0"]){
                        [[[tabBar items] objectAtIndex:1] setBadgeValue:[ud stringForKey:@"badge"]];
                    }else{
                        [[[tabBar items] objectAtIndex:1] setBadgeValue:nil];
                    }
                }
                if(resigned == 1){
                    actBtn.enabled = NO;
                    adrBtn.enabled = NO;
                    msgBtn.enabled = NO;
                    iconButton.enabled = NO;
                    userButton.enabled = NO;
                    msgTV.editable = NO;
                    tap.enabled = NO;
                    reqBtn.hidden = YES;
                    btntext.hidden = YES;
                }
            }else{
                NSLog(@"yes, just returned");
                [self msgdraw:response];
                if(![response valueForKeyPath:@"0"]){
                    ends = 1;
                }
            }
        }else if([response valueForKeyPath:@"ignore"] == nil || [[response valueForKeyPath:@"ignore"] isEqual:[NSNull null]]){
            if(ctag == -1){
                [self addmsg:response];
            }else if(ctag == -2){
                BOOL result = [[response valueForKeyPath:@"result"] boolValue];
                NSLog(@"result = %c", result);
                if(result){
                    stage = [[response valueForKeyPath:@"stage"] intValue];
                    [self addreq:response];
                }else{
                    NSString *mcd = [response valueForKeyPath:@"message_cd"];
                    if([mcd intValue] == 1){
                        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"残高が足りません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                        [alert show];
                    }else{
                        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                        [alert show];
                    }
                }
            }else if(ctag == -3){
                stage = [[response valueForKeyPath:@"stage"] intValue];
                [self addpro:response];
            }else if(ctag == -4){
                stage = [[response valueForKeyPath:@"stage"] intValue];
                [self postcode:response];
            }else if(ctag == -5){
                popView.hidden = TRUE;
                [self addmsg:response];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[response valueForKeyPath:@"postcode"] forKey:@"postcode"];
                [ud setObject:[response valueForKeyPath:@"county"] forKey:@"county"];
                [ud setObject:[response valueForKeyPath:@"address"] forKey:@"address"];
            }
        }else{
            NSLog(@"連打されたレスが帰って来たので無視。");
        }
        reload = 1;
    }
    paging = 0;
    msgBtn.enabled = YES;
    reqBtn.enabled = YES;
    proBtn.enabled = YES;
    yetBtn.enabled = YES;
}

-(void)item:(UIButton*)sender{
    if([_from intValue] == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        JODetail2ViewController *detail2 = [self.storyboard instantiateViewControllerWithIdentifier:@"detail2"];
        detail2.item = _item;
        detail2.itemdata = _itemdata;
        NSLog(@"itemdata = %@", [_itemdata description]);
        //detail2.from = @"1";
        [self.navigationController pushViewController:detail2 animated:YES];
    }
}

-(void)user:(UIButton*)sender{
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = _user;
    [self.navigationController pushViewController:user animated:YES];
}

- (void) findnego {
    //通信して情報とってくる(itemとbuyerから該当するnegoさがす)
    NSString *dataa = [NSString stringWithFormat:@"item_id=%d&my_id=%d&user_id=%@&tn=%d", [_item intValue], myid, _user, T];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_FIND_NEGO];
    //通信
    ctag = 0;
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

//描画
- (void)draw:(NSArray *)sres{

    [self msgdraw:sres];

    //アクションボタン
    NSArray *info = [sres valueForKeyPath:@"info"];
    int stage = [[info valueForKeyPath:@"stage"] intValue];
    int boo = [[info valueForKeyPath:@"buyer_boo"] intValue];
    if(boo == 0){
        yetBtn.hidden = FALSE;
    }
    if(stage == 0 || stage == 5){
        //リクエスト前
        //ゆずってくださいボタン
        if(mycoin >= price){
            NSLog(@"requestable3");
            reqBtn.hidden = FALSE;
            //btnView.hidden = FALSE;
        }
        reqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reqBtn.frame = CGRectMake(135, 2, 52, 48);
        [reqBtn setBackgroundImage:[UIImage imageNamed:@"btnButton.png"] forState:UIControlStateNormal];
        //[reqBtn setTitle:@"ゆずってください" forState:UIControlStateNormal];
        [reqBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        reqBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        [reqBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
        [btnView addSubview:reqBtn];
        [reqBtn addTarget:self action:@selector(actionl:) forControlEvents:UIControlEventTouchUpInside];
        reqBtn.tag = 1;
        btntext.text = @"　　この品物が欲しい方は、上記のボタンを押してね♪\n※1コイン消費します";
        btntext.lineBreakMode = NSLineBreakByWordWrapping;
        btntext.numberOfLines = 2;

        //コインが足りなかったらリクエストボタンをdisableしてコインゲットボタンをだす
        if(mycoin < price){
            reqBtn.enabled = NO;
        /*//コインゲットボタン
        UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        getBtn.frame = CGRectMake(75, 200+k-64, 170, 30);
        [getBtn setTitle:@"コインを手に入れる" forState:UIControlStateNormal];
        [self.scroll addSubview:getBtn];
        [getBtn addTarget:self action:@selector(getcoin:)forControlEvents:UIControlEventTouchUpInside];*/
        }
    }else if(stage == 1){
        yet.hidden = FALSE;
        //自分がリクエスト中
        if(mycoin >= price){
            NSLog(@"requestable1");
            reqBtn.hidden = FALSE;
            //btnView.hidden = FALSE;
        }
        reqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reqBtn.frame = CGRectMake(135, 2, 52, 48);
        //[reqBtn setTitle:@"リクエストキャンセル" forState:UIControlStateNormal];
        [reqBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
        [reqBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        reqBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        reqBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [reqBtn setBackgroundImage:[UIImage imageNamed:@"btnButton.png"] forState:UIControlStateNormal];
        [btnView addSubview:reqBtn];
        [reqBtn addTarget:self action:@selector(actionl:) forControlEvents:UIControlEventTouchUpInside];
        reqBtn.tag = 5;
        btntext.text = @"リクエストキャンセル";

        //btnView.hidden = FALSE;
    }else if(stage == 2){
        //yet.hidden = FALSE;
        //他の人からリクエストされてロックされちゃった
        reqBtn.hidden = TRUE;
    }else if(stage == 3){
        yet.hidden = FALSE;
        //発送されたので，到着待ち
        proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        proBtn.frame = CGRectMake(135, 2, 52, 48);
        [proBtn setBackgroundImage:[UIImage imageNamed:@"btnButton.png"] forState:UIControlStateNormal];
        [proBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        proBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        [proBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
        [btnView addSubview:proBtn];
        [proBtn addTarget:self action:@selector(actionp:) forControlEvents:UIControlEventTouchUpInside];
        proBtn.tag = 4;
        btntext.text = @"到着しました";
        //btnView.hidden = FALSE;
        //発送日
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormater dateFromString:[info valueForKeyPath:@"dispatch_time"]];
        NSTimeInterval since = [now timeIntervalSinceDate:date];
        NSLog(@"now = %@", now);
        NSLog(@"then = %@", [info valueForKeyPath:@"dispatch_time"]);
        NSLog(@"then = %@", date);
        NSLog(@"since = %f", since);
        //NSString *time;
        if(7*86400 <= since){
            proBtn.frame = CGRectMake(135, 2, 52, 48);
            //[proBtn setTitle:@"到着しました" forState:UIControlStateNormal];
            [proBtn setBackgroundImage:[UIImage imageNamed:@"btnButton.png"] forState:UIControlStateNormal];
            proBtn.tag = 4;

            btntext.text = @"到着しました";
        }
    }else if(stage == 4){
        yet.hidden = FALSE;
        //到着したので，成立。
        proBtn.hidden = TRUE;
    }else if(stage == 7){
        //届きませんボタン押された後なので到着ボタンだけ出しとく
        proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        proBtn.frame = CGRectMake(135, 2, 52, 48);
        [proBtn setBackgroundImage:[UIImage imageNamed:@"btnButton.png"] forState:UIControlStateNormal];
        [proBtn setTitle:@"到着しました" forState:UIControlStateNormal];
        [btnView addSubview:proBtn];
        btntext.text = @"到着しました";
        [proBtn addTarget:self action:@selector(actionp:) forControlEvents:UIControlEventTouchUpInside];
        proBtn.tag = 4;
    }
    NSLog(@"price = %d", price);
}

- (void)findmynego{
    //通信して情報とってくる(itemとbuyerから該当するnegoさがす)
    NSString *dataa = [NSString stringWithFormat:@"item_id=%d&user_id=%@&tn=%d", [_item intValue], _user, T];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_FIND_MYNEGO];
    //通信
    ctag = 0;
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

//描画(自分の商品)
- (void)mydraw:(NSArray *)sres{
    [self msgdraw:sres];
    //アクションボタン
    NSArray *info = [sres valueForKeyPath:@"info"];
    int stage = [[info valueForKeyPath:@"stage"] intValue];
    int boo = [[info valueForKeyPath:@"seller_boo"] intValue];
    if(boo == 0){
        yetBtn.hidden = FALSE;
    }
    if(stage == 0){
        //リクエスト前なのでボタンなし
        btnView.hidden = TRUE;
    }else if(stage == 1){
        yet.hidden = FALSE;
        //相手からリクエストされてる状態なので発送ボタンだすよ
        proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        proBtn.frame = CGRectMake(135, 2, 52, 48);
        //[proBtn setTitle:@"発送" forState:UIControlStateNormal];
        [proBtn setBackgroundImage:[UIImage imageNamed:@"btnButton.png"] forState:UIControlStateNormal];
        [proBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        proBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        [proBtn setTitleColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
        [btnView addSubview:proBtn];
        [proBtn addTarget:self action:@selector(actionp:) forControlEvents:UIControlEventTouchUpInside];
        proBtn.tag = 3;
        btntext.text = @"発送";
        //btnView.hidden = FALSE;
    }else if(stage == 2){
        //yet.hidden = FALSE;
        //ロック中
        reqBtn.hidden = TRUE;
    }else if(stage == 3){
        yet.hidden = FALSE;
        //発送したので相手が到着押してくれるの待ってます
        reqBtn.hidden = TRUE;
        //btnView.hidden = TRUE;
    }else if(stage == 4){
        yet.hidden = FALSE;
        //到着しました。成立。
        btnView.hidden = TRUE;
    }else if(stage == 5){
        btnView.hidden = TRUE;
    }
}

- (void)msgdraw:(NSArray *)res{
    //上にスクロールを足すためにviewをつくる
    UIView *subView = [[UIView alloc] init];
    subView.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:subView];
    //メッセージはりまくる
    int j = 0;
    prevmonth = 0, prevdate = 0;
    if([res count] > 2){
        int start = 0;
        NSArray *msginfo = [res valueForKeyPath:[NSString stringWithFormat:@"%d",0]];
        int stage = [[msginfo valueForKeyPath:@"message_stage"] intValue];
        if(stage == 8){
            start = 1;
        }

        for(int i=start ; i<[res count]-2 ; i++){
            NSArray *msginfo = [res valueForKeyPath:[NSString stringWithFormat:@"%d",i]];
            NSString *msgbody = [msginfo valueForKeyPath:@"message"];
            int msgtype = [[msginfo valueForKeyPath:@"message_stage"] intValue];
            int sender = [[msginfo valueForKeyPath:@"sender_user_id"] intValue];

            //msgの送信日時
            NSString *datetime = [msginfo valueForKeyPath:@"add_time"];
            NSLog(@"datetime = %@", datetime);
            //日付を抽出，前日と同じならスルー，違うならはる
            int month = [[datetime substringWithRange:NSMakeRange(5, 2)] intValue];
            int date = [[datetime substringWithRange:NSMakeRange(8, 2)] intValue];
            //日時を抽出してはる
            NSString *hour = [datetime substringWithRange:NSMakeRange(11, 2)];
            if([[hour substringToIndex:1]intValue] == 0){
                hour =  [hour substringFromIndex:1];
            }
            NSString *minute = [datetime substringWithRange:NSMakeRange(14, 2)];
            UILabel *hourminute = [[UILabel alloc] init];
            hourminute.backgroundColor = [UIColor clearColor];
            hourminute.textColor = [UIColor darkGrayColor];
            hourminute.font = [UIFont systemFontOfSize:11];
            hourminute.text = [NSString stringWithFormat:@"%@:%@", hour, minute];
            [subView addSubview:hourminute];
            if(month != prevmonth || date != prevdate){
                UIImageView *border = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgDate.png"]];
                border.frame = CGRectMake(0, 23+j+38, 320, 2);
                [subView addSubview:border];
                UILabel *monthdate = [[UILabel alloc] init];
                monthdate.frame = CGRectMake(135, 15+j+38, 50, 20);
                //monthdate.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
                monthdate.backgroundColor = [UIColor clearColor];
                monthdate.textAlignment = NSTextAlignmentCenter;
                monthdate.textColor = [UIColor darkGrayColor];
                monthdate.font = [UIFont systemFontOfSize:11];
                monthdate.text = [NSString stringWithFormat:@"%d月%d日", month, date];
                [subView addSubview:monthdate];
                prevmonth = month;
                prevdate = date;
                j = j+38;
            }
            //messageを画面上に追加
            UILabel *mlabel = [[UILabel alloc] init];
            UILabel *mlayer = [[UILabel alloc] init];
            UIImageView *ar;
            UIFont *font = [UIFont systemFontOfSize:14];
            CGSize bounds = CGSizeMake(230, 300);
            UILineBreakMode mode = NSLineBreakByWordWrapping;
            CGSize size = [[NSString stringWithFormat:@" %@ ", msgbody] sizeWithFont:font constrainedToSize:bounds lineBreakMode:mode];
            NSMutableArray *gradarray = [[NSMutableArray alloc] init];
            if(sender == 0){
                //ロック系は相手からじゃないので真ん中に配置
                if([msgbody isEqualToString:@"locked"] || [msgbody isEqualToString:@"ロックされました"]){
                    mlabel.frame = CGRectMake(60, 35+j+10, 197, 35);
                    mlabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"requestLock.png"]];
                    hourminute.frame = CGRectMake(230, 38+j+40, 30, 20);
                    msgbody = @"";
                }else if([msgbody isEqualToString:@"unlocked"] || [msgbody isEqualToString:@"ロック解除されました"]){
                    mlabel.frame = CGRectMake(50, 35+j+10, 216, 35);
                    mlabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"requestCancel.png"]];
                    hourminute.frame = CGRectMake(240, 38+j+40, 30, 20);
                    msgbody = @"";
                }else if([msgbody isEqualToString:@"通報により削除されました"] || [msgbody isEqualToString:@"商品が削除されました"]){
                    mlabel.frame = CGRectMake(60, 35+j+10, 197, 35);
                    mlabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"warningDelete.png"]];
                    hourminute.frame = CGRectMake(240, 38+j+40, 30, 20);
                    msgbody = @"";
                }else{
                    mlabel.frame = CGRectMake(60, 35+j+10, 197, 35);
                    mlabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userResign.png"]];
                    hourminute.frame = CGRectMake(240, 38+j+40, 30, 20);
                    msgbody = @"";
                }
            j = j+40;
        }else if(sender == myid){
            //自分からのmsgなら右側に配置
            hourminute.frame = CGRectMake(262-size.width+5, 38+j+10, 30, 20);
            mlabel.frame = CGRectMake(305-size.width, 35+j+10, size.width+5, size.height+5);
            mlayer.frame = CGRectMake(295-size.width, 35+j+10, size.width+15, size.height+5);
            mlayer.layer.cornerRadius = 5;
            mlayer.layer.borderColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.3 alpha:1.0].CGColor;
            mlayer.layer.borderWidth = 1;

            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = mlayer.bounds;
            int gr = mlabel.bounds.size.height/10;
            //NSLog(@"gr = %d", gr);
            if(msgtype == 0){
                for(int g=0 ; g<gr; g++){
                    [gradarray addObject:(id)[[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0] CGColor]];
                }
                [gradarray addObject:(id)[[UIColor colorWithRed:1.0 green:0.9 blue:0.4 alpha:1.0] CGColor]];
            }else{
                for(int g=0 ; g<gr; g++){
                    [gradarray addObject:(id)[[UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0] CGColor]];
                }
                [gradarray addObject:(id)[[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] CGColor]];
            }
            gradient.colors = gradarray;
            [subView addSubview:mlayer];
            [mlayer.layer insertSublayer:gradient atIndex:0];
            //吹き出し
            ar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowMe.png"]];
            ar.frame = CGRectMake(309, 52+j, 7, 10);
            [subView addSubview:ar];
            j = j+10;
        }else{
            //相手から自分へなら左側に配置
            mlabel.frame = CGRectMake(56, 30+j+30, size.width+5, size.height+5);
            hourminute.frame = CGRectMake(56+size.width+5, 38+j+30, 30, 20);
            mlayer.frame = CGRectMake(46, 30+j+30, size.width+15, size.height+5);;
            mlayer.layer.cornerRadius = 5;
            mlayer.layer.borderColor =  [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            mlayer.layer.borderWidth = 1;

            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = mlayer.bounds;
            int gr = mlabel.bounds.size.height/10;
            //NSLog(@"gr = %d", gr);
            if(msgtype == 0){
                for(int g=0 ; g<gr; g++){
                    [gradarray addObject:(id)[[UIColor whiteColor] CGColor]];
                }
                [gradarray addObject:(id)[[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.0] CGColor]];
            }else{
                for(int g=0 ; g<gr; g++){
                    [gradarray addObject:(id)[[UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0] CGColor]];
                }
                [gradarray addObject:(id)[[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] CGColor]];
            }
            gradient.colors = gradarray;
            [subView addSubview:mlayer];
            [mlayer.layer insertSublayer:gradient atIndex:0];
            //吹き出し
            ar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowYou.png"]];
            ar.frame = CGRectMake(40, 67+j, 7, 10);
            [subView addSubview:ar];

            //なまえはる
            UILabel *nlabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 12+j+30, 100, 20)];
            nlabel.font = [UIFont systemFontOfSize:12];
            nlabel.textColor = [UIColor darkGrayColor];
            nlabel.backgroundColor = [UIColor clearColor];
            nlabel.text = uname;
            [subView addSubview:nlabel];
            //アイコンをはる
            NSString *url_photo=[NSString stringWithFormat:@"%@/%@/%@", URL_ICON, _user, icon];
            NSURL *urli = [NSURL URLWithString:url_photo];
            //NSData *data = [NSData dataWithContentsOfURL:urli];
            //UIImage *img = [UIImage imageWithData:data];
            UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
            UIImageView *piv = [[UIImageView alloc] initWithImage:nil];
            //画像キャッシュ
            [piv setImageWithURL:urli placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                if(error){
                    [self noimage:-i];
                }
            }];
            //UIImageView *iv = [[UIImageView alloc] initWithImage:img];
            piv.frame = CGRectMake(3, 15+j+30, 35, 35);
            piv.tag = -i;
            [subView addSubview:piv];
            j = j + 30;
        }

        mlabel.textColor = [UIColor blackColor];
        if(sender != 0){
            mlabel.backgroundColor = [UIColor clearColor];
        }
        //mlabel.textAlignment = NSTextAlignmentCenter;
        mlabel.text = msgbody;
        mlabel.numberOfLines = 10;
        mlabel.lineBreakMode = NSLineBreakByWordWrapping;
        mlabel.font = font;
        //アクション系メッセージなら枠色かえる
        if(msgtype == 0){
            /*//mlabel.backgroundColor = [UIColor whiteColor];
             CAGradientLayer *gradient = [CAGradientLayer layer];
             //gradient.frame = mlabel.bounds;
             //gradient.frame = CGRectMake(mlabel.bounds, 0, 0, 0);
             gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
             [mlabel.layer insertSublayer:gradient atIndex:10];*/
        }else{
            if(sender != 0){
                //mlabel.textAlignment = NSTextAlignmentCenter;
                mlayer.layer.cornerRadius = 5;
                mlayer.layer.borderColor =  [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0].CGColor;
                mlayer.layer.borderWidth = 1;
                //吹き出し
                UIImageView *arr;
                if(sender == myid){
                    arr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"requestArrowMe.png"]];
                }else{
                    arr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"requestArrowYou.png"]];
                }
                arr.frame = ar.frame;
                [subView addSubview:arr];
            }
        }
        [subView addSubview:mlabel];

        j = j+size.height;
    }
    }else if(sv == 1){
        nmlabel = [[UILabel alloc] init];
        nmlabel.frame = CGRectMake(10, 100, 300, 40);
        nmlabel.text = @"ゆずってほしいなら\nメッセージを送ろう！";
        nmlabel.numberOfLines = 2;
        nmlabel.backgroundColor = [UIColor clearColor];
        nmlabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        nmlabel.textAlignment = NSTextAlignmentCenter;
        [self.scroll addSubview:nmlabel];
        ends = 1;
        k = 10;
    }
    if(sv == 1){
        k = j-5;
        subView.frame = CGRectMake(0, 0, 320, 100+k);
        subView.tag = sv;
        sv = sv+1;

        [self.scroll setScrollEnabled:YES];
        [self.scroll setContentSize:CGSizeMake(320, 145+k)];
        NSLog(@"content - height = %f", self.scroll.contentSize.height - self.scroll.bounds.size.height);
        // 一番下までスクロール
        if(self.scroll.contentSize.height - self.scroll.bounds.size.height > 0){
            [self.scroll setContentOffset:CGPointMake(0.0f, self.scroll.contentSize.height - self.scroll.bounds.size.height) animated:NO];
        }
        l = k;
    }else{
        k = j-5;
        subView.frame = CGRectMake(0, 0, 320, k);
        subView.tag = sv;
        sv = sv+1;

        for(int s=sv-2 ; s>0 ; s--){
            UIView *sub = (UIView *)[self.scroll viewWithTag:s];
            float h = sub.bounds.size.height;
            sub.frame = CGRectMake(0, k, 320, h);
            [self.scroll setContentSize:CGSizeMake(320, k+h+100)];
            k = k+h;
        }
    }
    NSLog(@"mycoin = %d, price = %d", mycoin, price);
}

- (void)noimage:(int)tag{
    UIImageView *piv = (UIImageView *)[self.scroll viewWithTag:tag];
    piv.image = [UIImage imageNamed:@"itemNoImg.png"];
}

-(void)actup:(id)sender{
    if(up == 0){
        //msgView.frame = CGRectMake(0, sheight-145-msgTV.contentSize.height, 320, 90+msgTV.contentSize.height);
        btnView.frame = CGRectMake(0, sheight, 320, 90);
        [UIView commitAnimations];
        [actBtn setBackgroundImage:[UIImage imageNamed:@"btnArrowOpen.png"] forState:UIControlStateNormal];
        up = 1;
        //msgTV.editable = NO;
    }else{
        float h;
        if(msgTV.contentSize.height < 35){
            h = 35;
        }else{
            h = msgTV.contentSize.height;
        }
        rect.size.height = h-3;
        //msgView.frame = CGRectMake(0, sheight-74-h, 320, 110+h);
        btnView.frame = CGRectMake(0, sheight-173, 320, 90);
        [actBtn setBackgroundImage:[UIImage imageNamed:@"btnArrowClose.png"] forState:UIControlStateNormal];
        up = 0;
        //msgTV.editable = YES;
    }
}

//textviewタップでviewあげる
-(void)textViewDidBeginEditing:(UITextField *)sender{
    kb = 1;
    actBtn.enabled = NO;
    adrBtn.enabled = NO;
    msgView.frame = CGRectMake(0, sheight-286-msgTV.contentSize.height, 320, 90+msgTV.contentSize.height);
    [UIView commitAnimations];
    NSLog(@"height = %f", self.scroll.contentSize.height);
    if(k > 100){
        [UIView animateWithDuration:0.4 animations:^
         {
             self.scroll.frame = CGRectMake(0, -140, 320, self.scroll.bounds.size.height);
         }];
    }
}
-(void)dismissKeyboard {
    if(up == 0){
        kb = 0;
        [msgTV resignFirstResponder];
    }
    float h;
    if(msgTV.contentSize.height < 35){
        h = 35;
    }else{
        h = msgTV.contentSize.height;
    }
    rect.size.height = h-3;
    //btnView.frame = CGRectMake(0, sheight, 320, 90);
    //[actBtn setBackgroundImage:[UIImage imageNamed:@"btnArrowOpen.png"] forState:UIControlStateNormal];
    up = 0;
    msgTV.editable = YES;
    msgView.frame = CGRectMake(0, sheight-74-h, 320, 110+h);
    actBtn.enabled = YES;
    adrBtn.enabled = YES;
    [UIView animateWithDuration:0.4 animations:^
     {
         self.scroll.frame = CGRectMake(0, 44, 320, self.scroll.bounds.size.height);
     }];
}
-(void)changekeyboard:(NSNotification*)notification{
    if(kb == 1){
        // get the size of the keyboard
        NSValue* eboundsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize ekeyboardSize = [eboundsValue CGRectValue].size;
        kh = ekeyboardSize.height;
        msgView.frame = CGRectMake(0, sheight-70-kh-msgTV.contentSize.height, 320, 90+msgTV.contentSize.height);
        [UIView commitAnimations];
    }
}

//文章の長さにあわせてmsg viewをひろげる
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    rect = msgTV.frame;
    rect.size.height = msgTV.contentSize.height-3;
    msgTV.frame = rect;
    msgView.frame = CGRectMake(0, sheight-70-kh-msgTV.contentSize.height, 320, 90+msgTV.contentSize.height);
    msgBtn.frame = CGRectMake(265, msgTV.contentSize.height-33, 51, 36);
    actBtn.frame = CGRectMake(5, msgTV.contentSize.height-33, 32, 36);
    adrBtn.frame = CGRectMake(40, msgTV.contentSize.height-33, 32, 36);

    /*if([text isEqualToString:@"\n"]) {
        msgView.frame = CGRectMake(0, sheight-124-msgTV.contentSize.height, 320, 110+msgTV.contentSize.height);
        msgTV.frame   = rect;
        [textView resignFirstResponder];
        return NO;
    }*/
    return YES;
}

- (void)message:(id)sender{
    if(msgTV.text.length > 0){
        msgBtn.enabled = NO;
        NSString *msgbody = msgTV.text;
        NSLog(@"msg = %@", msgbody);

        //通信!!
        NSString *dataa = [NSString stringWithFormat:@"item_id=%@&sender_id=%d&receiver_id=%@&message=%@&service=reader", _item, myid, _user, [msgbody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url;
        if([_seller intValue] == 1){
            url = [NSURL URLWithString:URL_MESSAGE];
        }else{
            url = [NSURL URLWithString:URL_MYMESSAGE];
        }
        //通信
        ctag = -1;
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
        //keyboardさげる
        kb = 0;
        float h;
        if(msgTV.contentSize.height < 35){
            h = 35;
        }else{
            h = msgTV.contentSize.height;
        }
        rect.size.height = h-3;
        msgView.frame = CGRectMake(0, sheight-74-h, 320, 110+h);
        [msgTV resignFirstResponder];
        [self dismissKeyboard];
    }
}

- (void)addmsg:(NSArray *)smres{
    NSString *msgbody = [smres valueForKeyPath:@"message"];
    int mid = [[smres valueForKeyPath:@"msg_id"] intValue];
    NSLog(@"smres = %@", [smres description]);

    if(mid > 0){
        NSLog(@"送信できたよ!!");
        NSLog(@"sv = %d", sv);
        UIView *sub = (UIView *)[self.scroll viewWithTag:1];
        /*if(sv > 2){
            k = k-200;
        }*/
        //msgの送信日時
        NSString *datetime = [smres valueForKeyPath:@"add_time"];
        NSLog(@"datetime = %@", datetime);
        //日付を抽出，前日と同じならスルー，違うならはる
        int month = [[datetime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[datetime substringWithRange:NSMakeRange(8, 2)] intValue];
        if(month != prevmonth || date != prevdate){
            UIImageView *border = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgDate.png"]];
            border.frame = CGRectMake(0, 23+l+38, 320, 2);
            [sub addSubview:border];
            UILabel *monthdate = [[UILabel alloc] init];
            monthdate.frame = CGRectMake(135, 15+l+38, 50, 20);
            //monthdate.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
            monthdate.backgroundColor = [UIColor clearColor];
            monthdate.textAlignment = NSTextAlignmentCenter;
            monthdate.textColor = [UIColor darkGrayColor];
            monthdate.font = [UIFont systemFontOfSize:11];
            monthdate.text = [NSString stringWithFormat:@"%d月%d日", month, date];
            [sub addSubview:monthdate];
            prevmonth = month;
            prevdate = date;
            l = l+38;
        }
        //画面上にメッセージを追加
        UILabel *mlabel = [[UILabel alloc] init];
        UILabel *mlayer = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize bounds = CGSizeMake(250, 300);
        UILineBreakMode mode = NSLineBreakByWordWrapping;
        CGSize size2 = [msgbody sizeWithFont:font constrainedToSize:bounds lineBreakMode:mode];
        mlabel.frame = CGRectMake(305-size2.width, l+50, size2.width+5, size2.height+5);
        mlabel.backgroundColor = [UIColor clearColor];
        mlabel.textColor = [UIColor blackColor];
        mlabel.text = msgbody;
        mlabel.numberOfLines = 10;
        mlabel.lineBreakMode = NSLineBreakByWordWrapping;
        mlabel.font = font;
        //ぐらで
        mlayer.frame = CGRectMake(295-size2.width, l+50, size2.width+15, size2.height+5);;
        mlayer.layer.cornerRadius = 5;
        mlayer.layer.borderColor =  [UIColor colorWithRed:0.9 green:0.8 blue:0.3 alpha:1.0].CGColor;
        mlayer.layer.borderWidth = 1;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = mlayer.bounds;
        int gr = mlabel.bounds.size.height/10;
        NSMutableArray *gradarraya = [[NSMutableArray alloc]init];
        for(int g=0 ; g<gr; g++){
            [gradarraya addObject:(id)[[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0] CGColor]];
        }
        [gradarraya addObject:(id)[[UIColor colorWithRed:1.0 green:0.9 blue:0.4 alpha:1.0] CGColor]];
        gradient.colors = gradarraya;
        [sub addSubview:mlayer];
        [mlayer.layer insertSublayer:gradient atIndex:0];
        [sub addSubview:mlabel];
        //吹き出し
        UIImageView *ar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowMe.png"]];
        ar.frame = CGRectMake(309, 57+l, 7, 10);
        [sub addSubview:ar];

        //日時
        //NSString *datetime = [smres valueForKeyPath:@"add_time"];
        NSLog(@"datetime = %@", datetime);
        //日時を抽出してはる
        NSString *hour = [datetime substringWithRange:NSMakeRange(11, 2)];
        if([[hour substringToIndex:1]intValue] == 0){
            hour =  [hour substringFromIndex:1];
        }
        NSString *minute = [datetime substringWithRange:NSMakeRange(14, 2)];
        UILabel *hourminute = [[UILabel alloc] initWithFrame:CGRectMake(262-size2.width+5, l+53, 30, 20)];
        hourminute.backgroundColor = [UIColor clearColor];
        hourminute.textColor = [UIColor darkGrayColor];
        hourminute.font = [UIFont systemFontOfSize:11];
        hourminute.text = [NSString stringWithFormat:@"%@:%@", hour, minute];
        [sub addSubview:hourminute];

        //sub.bounds.size.height = sub.bounds.size.height + size2.height;
        CGRect frame = sub.frame;
        frame.size.height = sub.bounds.size.height + size2.height;
        sub.frame = frame;
        [self.scroll setContentSize:CGSizeMake(320, 140+k+size2.height+20)];
        // 一番下までスクロール
        if(self.scroll.contentSize.height - self.scroll.bounds.size.height > 0){
            [self.scroll setContentOffset:CGPointMake(0.0f, self.scroll.contentSize.height - self.scroll.bounds.size.height) animated:NO];
        }

        k = k+size2.height+10;
        l = l+size2.height+10;
        //入力欄を空にする
        msgTV.text = @"";
        msgTV.frame = CGRectMake(75, 5, 185, 35);
        msgView.frame = CGRectMake(0, sheight-109, 320, 288);
        actBtn.frame = CGRectMake(5, 5, 32, 36);
        adrBtn.frame = CGRectMake(40, 5, 32, 36);
        msgBtn.frame = CGRectMake(265, 5, 51, 36);                                                                                                                                                                                                        

        nmlabel.hidden = TRUE;

    }else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }

    msgBtn.enabled = YES;
}

- (void)actionl:(UIButton *)sender{
    reqBtn.enabled = NO;
    reqtag = sender.tag;
    //tagが1ならリクエスト送信，他をロック
    NSString *msgbody;
    if(reqtag == 1){
        msgbody = @"リクエストを送信しました";
    }else{
        msgbody = @"リクエストをキャンセルしました";
        ncbar.hidden = TRUE;
    }
    //通信!!
    NSString *dataa = [NSString stringWithFormat:@"item_id=%@&sender_id=%d&receiver_id=%@&message=%@&type=%d&price=%d&service=reader", _item, myid, _user, [msgbody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sender.tag, price];
    NSURL *url = [NSURL URLWithString:URL_REQ_ACTION];
    //通信
    ctag = -2;
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)addreq:(NSArray *)reqres{
    //画面上にメッセージを追加
    NSString *msgbody;
    if(reqtag == 1){
        msgbody = @"リクエストを送信しました";
        yet.hidden = FALSE;
        yetBtn.hidden = FALSE;
        //トーストで何コインになったか表示
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[reqres valueForKeyPath:@"coin"] forKey:@"coin"];
        [JOToastUtil showToast:[NSString stringWithFormat:@"1コイン消費しました。\n残り%@コインです", [reqres valueForKeyPath:@"coin"]]];
    }else{
        msgbody = @"リクエストをキャンセルしました";
        yet.hidden = TRUE;
        yetBtn.hidden = TRUE;
        //トーストで何コインになったか表示
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[reqres valueForKeyPath:@"coin"] forKey:@"coin"];
        [JOToastUtil showToast:[NSString stringWithFormat:@"1コイン返還されました。\n残り%@コインです", [reqres valueForKeyPath:@"coin"]]];
    }

    int mid = [[reqres valueForKeyPath:@"msg_id"] intValue];
    UIView *sub = (UIView *)[self.scroll viewWithTag:1];
    if(mid > 0){
        JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.myflag = @"1";
        NSLog(@"送信できたよ!!");
        UILabel *mlabel = [[UILabel alloc] init];
        UILabel *mlayer = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize bounds = CGSizeMake(250, 300);
        UILineBreakMode mode = NSLineBreakByWordWrapping;
        nmlabel.hidden = TRUE;
        //全体のサイズを取得
        CGSize size2 = [msgbody sizeWithFont:font constrainedToSize:bounds lineBreakMode:mode];
        mlabel.frame = CGRectMake(305-size2.width, 50+l, size2.width+5, size2.height+5);
        mlabel.textColor = [UIColor blackColor];
        mlabel.text = msgbody;
        mlabel.backgroundColor = [UIColor clearColor];
        mlabel.numberOfLines = 10;
        mlabel.lineBreakMode = NSLineBreakByWordWrapping;
        mlabel.font = font;
        mlabel.layer.cornerRadius = 8;
        //ぐらで
        mlayer.frame = CGRectMake(295-size2.width, 50+l, size2.width+15, size2.height+5);;
        mlayer.layer.cornerRadius = 5;
        mlayer.layer.borderColor =  [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0].CGColor;
        mlayer.layer.borderWidth = 1;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = mlayer.bounds;
        int gr = mlabel.bounds.size.height/10;
        NSMutableArray *gradarraya = [[NSMutableArray alloc]init];
        for(int g=0 ; g<gr; g++){
            [gradarraya addObject:(id)[[UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0] CGColor]];
        }
        [gradarraya addObject:(id)[[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] CGColor]];
        gradient.colors = gradarraya;
        [sub addSubview:mlayer];
        [mlayer.layer insertSublayer:gradient atIndex:0];
        [sub addSubview:mlabel];
        //吹き出し
        UIImageView *ar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"requestArrowMe.png"]];
        ar.frame = CGRectMake(309, 57+l, 7, 10);
        [sub addSubview:ar];

        //日時
        NSString *datetime = [reqres valueForKeyPath:@"add_time"];
        NSLog(@"datetime = %@", datetime);
        //日時を抽出してはる
        NSString *hour = [datetime substringWithRange:NSMakeRange(11, 2)];
        if([[hour substringToIndex:1]intValue] == 0){
            hour =  [hour substringFromIndex:1];
        }
        NSString *minute = [datetime substringWithRange:NSMakeRange(14, 2)];
        UILabel *hourminute = [[UILabel alloc] initWithFrame:CGRectMake(262-size2.width+5, l+53, 30, 20)];
        hourminute.backgroundColor = [UIColor clearColor];
        hourminute.textColor = [UIColor darkGrayColor];
        hourminute.font = [UIFont systemFontOfSize:11];
        hourminute.text = [NSString stringWithFormat:@"%@:%@", hour, minute];
        [sub addSubview:hourminute];

        CGRect frame = sub.frame;
        frame.size.height = sub.bounds.size.height + size2.height;
        sub.frame = frame;
        [self.scroll setContentSize:CGSizeMake(320, 140+k+size2.height+20)];
        // 一番下までスクロール
        if(self.scroll.contentSize.height - self.scroll.bounds.size.height > 0){
            [self.scroll setContentOffset:CGPointMake(0.0f, self.scroll.contentSize.height - self.scroll.bounds.size.height) animated:NO];
        }

        k = k+size2.height+10;
        l = l+size2.height+10;

        if(reqtag == 1){
            //[reqBtn setTitle:@"リクエストキャンセル" forState:UIControlStateNormal];
            //reqBtn.frame = CGRectMake(130, 0, 65, 62);
            reqBtn.tag = 5;
            btntext.text = @"リクエストキャンセル";
        }else{
            //[reqBtn setTitle:@"ゆずってください" forState:UIControlStateNormal];
            //reqBtn.frame = CGRectMake(130, 0, 65, 62);
            reqBtn.tag = 1;
            btntext.text = @"　　この品物が欲しい方は、上記のボタンを押してね♪\n※1コイン消費します";
            btntext.lineBreakMode = NSLineBreakByWordWrapping;
            btntext.numberOfLines = 2;
        }
        nmlabel.hidden = TRUE;
        reqBtn.enabled = YES;

        // 通知を作成する
        NSNotification *n = [NSNotification notificationWithName:@"myupdated" object:self];
        // 通知実行！
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
        reqBtn.enabled = YES;
    }
}

- (void)actionp:(UIButton *)sender{
    proBtn.enabled = NO;
    yetBtn.enabled = NO;
    protag = sender.tag;
    //tagが3なら発送(from seller), 4なら到着(from buyer)
    NSString *msgbody;
    if(protag == 3){
        msgbody = @"発送しました";
    }else if(protag == 4){
        msgbody = @"到着しました";
    }
    //通信!!
    ctag = -3;
    NSString *dataa = [NSString stringWithFormat:@"item_id=%@&sender_id=%d&receiver_id=%@&message=%@&type=%d&seller=%@&service=reader", _item, myid, _user, [msgbody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sender.tag, _seller];
    NSURL *url = [NSURL URLWithString:URL_DISPATCH];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)actionb:(UIButton *)sender{
    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"悪評をつけます。" message:maddress delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    alert.tag = 7;
}

- (void)addpro:(NSArray *)prres{
    int mid = [[prres valueForKeyPath:@"msg_id"] intValue];
    NSString *msgbody;
    if(protag == 3){
        msgbody = @"発送しました";
        btntext.text = @"";
        //btnView.hidden = TRUE;
    }else if(protag == 4){
        msgbody = @"到着しました";
        btntext.text = @"";
    }else if(protag == 7){
        msgbody = @"届きません";
        yetBtn.hidden = TRUE;
    }

    if(mid > 0){
        JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.myflag = @"1";
        NSLog(@"送信できたよ!!");
        UIView *sub = (UIView *)[self.scroll viewWithTag:1];
        if(sv > 2){
            k = k-100;
        }
        //画面上にメッセージを追加
        UILabel *mlabel = [[UILabel alloc] init];
        UILabel *mlayer = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize bounds = CGSizeMake(250, 300);
        UILineBreakMode mode = NSLineBreakByWordWrapping;
        //全体のサイズを取得
        CGSize size2 = [msgbody sizeWithFont:font constrainedToSize:bounds lineBreakMode:mode];
        mlabel.frame = CGRectMake(305-size2.width, 50+l, size2.width+5, size2.height+5);
        mlabel.textColor = [UIColor blackColor];
        mlabel.text = msgbody;
        mlabel.backgroundColor = [UIColor clearColor];
        mlabel.numberOfLines = 10;
        mlabel.lineBreakMode = NSLineBreakByWordWrapping;
        mlabel.font = font;
        mlabel.layer.cornerRadius = 8;
        //ぐらで
        mlayer.frame = CGRectMake(295-size2.width, 50+l, size2.width+15, size2.height+5);
        mlayer.layer.cornerRadius = 5;
        mlayer.layer.borderColor =  [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0].CGColor;
        mlayer.layer.borderWidth = 1;

        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = mlayer.bounds;
        int gr = mlabel.bounds.size.height/10;
        NSMutableArray *gradarraya = [[NSMutableArray alloc]init];
        for(int g=0 ; g<gr; g++){
            [gradarraya addObject:(id)[[UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0] CGColor]];
        }
        [gradarraya addObject:(id)[[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] CGColor]];
        gradient.colors = gradarraya;
        [sub addSubview:mlayer];
        [mlayer.layer insertSublayer:gradient atIndex:0];
        [sub addSubview:mlabel];
        //吹き出し
        UIImageView *ar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"requestArrowMe.png"]];
        ar.frame = CGRectMake(309, 57+l, 7, 10);
        [sub addSubview:ar];

        //日時
        NSString *datetime = [prres valueForKeyPath:@"add_time"];
        NSLog(@"datetime = %@", datetime);
        //日時を抽出してはる
        NSString *hour = [datetime substringWithRange:NSMakeRange(11, 2)];
        if([[hour substringToIndex:1]intValue] == 0){
            hour =  [hour substringFromIndex:1];
        }
        NSString *minute = [datetime substringWithRange:NSMakeRange(14, 2)];
        UILabel *hourminute = [[UILabel alloc] initWithFrame:CGRectMake(262-size2.width+5, l+53, 30, 20)];
        hourminute.backgroundColor = [UIColor clearColor];
        hourminute.textColor = [UIColor darkGrayColor];
        hourminute.font = [UIFont systemFontOfSize:11];
        hourminute.text = [NSString stringWithFormat:@"%@:%@", hour, minute];
        [sub addSubview:hourminute];

        CGRect frame = sub.frame;
        frame.size.height = sub.bounds.size.height + size2.height;
        sub.frame = frame;
        [self.scroll setContentSize:CGSizeMake(320, 140+k+size2.height+20)];
        // 一番下までスクロール
        if(self.scroll.contentSize.height - self.scroll.bounds.size.height > 0){
            [self.scroll setContentOffset:CGPointMake(0.0f, self.scroll.contentSize.height - self.scroll.bounds.size.height) animated:NO];
        }

        k = k+size2.height+10;
        l = l+size2.height+10;

        proBtn.hidden = TRUE;
    }else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}

- (void)getcoin:(id)sender{
    NSLog(@"コインを手に入れる");
}

- (void)address:(id)sender{
    NSLog(@"stage = %d", stage);
    if(stage == 0 || stage == 5){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"まだ取引が開始されていません。" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else if(stage == 6){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"この品物は削除されています" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        /*//自分の情報
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        int postcode = [[ud stringForKey:@"postcode"] intValue];
        int county = [[ud stringForKey:@"county"] intValue];
        NSString *address = [ud stringForKey:@"address"];
        maddress = [NSString stringWithFormat:@"%d\n%@ %@", postcode, [pickerData objectAtIndex:county], address];

        if(postcode == 0 || county == 0 || address == nil || address.length == 0){
            popView.hidden = FALSE;
        }else{
            UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"この住所を送信します。" message:maddress delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
            [alert show];
            alert.tag = 10;
        }*/
        popView.hidden = FALSE;
    }
}
//-------------------ここから住所入力popup----------------
- (void)addpop{
    //住所入力用のpop
    popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    popView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:popView];
    UIView *wv = [[UIView alloc]initWithFrame:CGRectMake(10, 50, 300, 233)];
    wv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDeliPop.png"]];
    [popView addSubview:wv];
    UILabel *xl = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 220, 23)];
    xl.backgroundColor = [UIColor clearColor];
    xl.text = @"住所を入力してください";
    [wv addSubview:xl];
    //入力枠
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(7.5, 38, 285, 135)];
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDeliAdd.png"]];
    [wv addSubview:fv];
    //入力欄
    pctf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 260, 35)];
    pctf.placeholder = @"郵便番号(数字のみ)";
    pctf.borderStyle = UITextBorderStyleNone;
    pctf.keyboardType = UIKeyboardTypeNumberPad;
    [fv addSubview:pctf];
    pctf.tag = 3;
    pctf.delegate = self;
    //都道府県
    areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    areaBtn.frame = CGRectMake(10, 50, 260, 35);
    [areaBtn setTitle:@"都道府県　　　　　　　　　　　　　" forState:UIControlStateNormal];
    [areaBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    areaBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [fv addSubview:areaBtn];
    [areaBtn addTarget:self action:@selector(area:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *aiv = [[UIImageView alloc] initWithFrame:CGRectMake(255, 10, 11, 17)];
    aiv.image = [UIImage imageNamed:@"iconArrow.png"];
    [areaBtn addSubview:aiv];
    //入力欄
    patf = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 260, 35)];
    patf.borderStyle = UITextBorderStyleNone;
    patf.placeholder = @"住所";
    [fv addSubview:patf];
    patf.delegate = self;
    patf.tag = 2;
    //ボタン
    UIButton *sb = [UIButton buttonWithType:UIButtonTypeCustom];
    [sb setBackgroundImage:[UIImage imageNamed:@"bgDeliSend.png"] forState:UIControlStateNormal];
    sb.frame = CGRectMake(7.5, 182, 83, 43);
    [wv addSubview:sb];
    [sb addTarget:self action:@selector(sendaddress:) forControlEvents:UIControlEventTouchUpInside];
    //ボタン
    UIButton *cb = [UIButton buttonWithType:UIButtonTypeCustom];
    [cb setBackgroundImage:[UIImage imageNamed:@"btnDeliCancel"] forState:UIControlStateNormal];
    cb.frame = CGRectMake(210.5, 182, 83, 43);
    [wv addSubview:cb];
    [cb addTarget:self action:@selector(canceladdress:) forControlEvents:UIControlEventTouchUpInside];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int postcode = [[ud stringForKey:@"postcode"] intValue];
    int county = [[ud stringForKey:@"county"] intValue];
    NSString *address = [ud stringForKey:@"address"];
    //地域をはる
    if(postcode != 0){
        pctf.text = [NSString stringWithFormat:@"%d",postcode];
    }
    if(county == 0){
        [areaBtn setTitle:@"都道府県" forState:UIControlStateNormal];
    }else{
        NSString *area = [countyarray objectAtIndex:county];
        [areaBtn setTitle:area forState:UIControlStateNormal];
    }
    if(!(address == nil || [address isEqual:[NSNull null]])){
        patf.text = address;
    }

    popView.hidden = TRUE;

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
    [picker selectRow:county inComponent:0 animated:NO];
    picker.delegate = self;


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

- (void)sendaddress:(id)sender{
    if(patf.text.length == 0){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"入力してください" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else if([JOFunctionsDefined removeForeign:patf.text]){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"エラー" message:@"絵文字は入力できません" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{
        maddress = [NSString stringWithFormat:@"%@\n%@ %@", pctf.text, [countyarray objectAtIndex:[picker selectedRowInComponent:0]], patf.text];
        NSLog(@"message = %@", maddress);
        ctag = -5;
        NSString *dataa = [NSString stringWithFormat:@"item_id=%@&sender_id=%d&receiver_id=%@&message=%@&postcode=%d&county=%d&address=%@&service=reader", _item,  myid, _user, [maddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [pctf.text intValue], [picker selectedRowInComponent:0], [patf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"dataa = %@", dataa);
        NSURL *url = [NSURL URLWithString:URL_MSG_ADDRESS];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}
- (void)canceladdress:(id)sender{
    popView.hidden = TRUE;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag == 2){
        [UIView animateWithDuration:0.4 animations:^
         {
             popView.frame = CGRectMake(0, 0, 320, 800);
         }];
    }
    return YES;
}

- (void)area:(id)sender {
    numberpad.frame = CGRectMake(0, sheight, 320, 80);
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pv.frame = CGRectMake(0, sheight-278-44, 320, 260);
    [UIView commitAnimations];
}
- (void)areadone:(id)sender {
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
    
    //row1 = [picker selectedRowInComponent:0];//0列目が選択されているindex
    NSString *selected = [pickerData objectAtIndex:[picker selectedRowInComponent:0]];
    [areaBtn setTitle:selected forState:UIControlStateNormal];
}

//もしtextfieldが郵便番号だったらヘッダーだす
-(void)textFieldDidBeginEditing:(UITextField *)sender{
    if(sender.tag == 3){
        NSLog(@"numberpad!");
        numberpad.frame = CGRectMake(0, sheight-326, 320, 100);
        [UIView commitAnimations];
        [UIView setAnimationDuration:0.3];
        stag = 3;
    }else{
        stag = sender.tag;
        [UIView animateWithDuration:0.4 animations:^
         {
             popView.frame = CGRectMake(0, -50, 320, 800);
         }];
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
    numberpad.frame = CGRectMake(0, sheight, 320, 80);
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}
- (void)pcsearch{
    ctag = -4;
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
    }
    if(!(city == nil || [city isEqual:[NSNull null]])){
        patf.text = city;
    }
    if(!(address == nil || [address isEqual:[NSNull null]])){
        patf.text = [NSString stringWithFormat:@"%@ %@", patf.text, address];
    }
}

- (void)pcd_pushed:(id)sender {
    [self.view endEditing:YES];
    numberpad.frame = CGRectMake(0, sheight, 320, 80);
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10){
        switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1://押したボタンがOKなら通信
            NSLog(@"");
            //通信!!
            NSString *dataa = [NSString stringWithFormat:@"item_id=%@&sender_id=%d&receiver_id=%@&message=%@&service=reader", _item, myid, _user, [maddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURL *url;
            if([_seller intValue] == 1){
                url = [NSURL URLWithString:URL_MESSAGE];
            }else{
                url = [NSURL URLWithString:URL_MYMESSAGE];
            }
            //通信
            ctag = -1;
            NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
            async = [JOAsyncConnection alloc];
            async.delegate = self;
            [async asyncConnect:request];
            break;
        }
    }else if(alertView.tag == 7){
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1://押したボタンがOKなら通信
                proBtn.enabled = NO;
                yetBtn.enabled = NO;
                NSString *msgbody = @"届きません";
                //通信!!
                ctag = -3;
                NSString *dataa = [NSString stringWithFormat:@"item_id=%@&sender_id=%d&receiver_id=%@&message=%@&type=%d&seller=%@&service=reader", _item, myid, _user, [msgbody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 7, _seller];
                NSURL *url = [NSURL URLWithString:URL_DISPATCH];
                NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
                async = [JOAsyncConnection alloc];
                async.delegate = self;
                [async asyncConnect:request];
                break;
        }
    }
}
//-------------------ここまで住所入力popup----------------
BOOL isTabBarHidden;
- (void)hideTabBar {
    if (!isTabBarHidden) {
        UITabBar *tabBar = self.tabBarController.tabBar;
        UIView *parent = tabBar.superview; // UILayoutContainerView
        UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
        UIView *window = parent.superview;

        [UIView animateWithDuration:0.4 animations:^{
                             CGRect tabFrame = tabBar.frame;
                             tabFrame.origin.y = CGRectGetMaxY(window.bounds);
                             tabBar.frame = tabFrame;
                             content.frame = window.bounds;
                         }];
        isTabBarHidden = YES;
    }
}

- (void)showTabBar {
    if (isTabBarHidden) {
        UITabBar *tabBar = self.tabBarController.tabBar;
        UIView *parent = tabBar.superview; // UILayoutContainerView
        UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
        UIView *window = parent.superview;

        [UIView animateWithDuration:0.4
                         animations:^{
                             CGRect tabFrame = tabBar.frame;
                             tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame);
                             tabBar.frame = tabFrame;

                             CGRect contentFrame = content.frame;
                             contentFrame.size.height -= tabFrame.size.height;
                             content.frame = contentFrame;
                         }];
        isTabBarHidden = NO;
    }
}

//上までスクロールでもっとみる
- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    //NSLog(@"cp = %f", cp);
    if(cp < 0){
        if(paging == 0 && ends == 0){
            [self getmore];
            paging = 1;
        }
    }
}

- (void)getmore{
    NSLog(@"more!!");
    //通信して情報とってくる(itemとbuyerから該当するnegoさがす)
    NSString *dataa = [NSString stringWithFormat:@"nego_id=%d&sn=%d&tn=%d", nego_id, (sv-1)*T, T];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_MORE_MSG];
    //通信
    ctag = 0;
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

-(void)backButtonClicked{
    if([_seller intValue] == 1){
        NSNotification *n = [NSNotification notificationWithName:@"backFromSend" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }else{
        NSNotification *n = [NSNotification notificationWithName:@"reload" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    [self showTabBar];
    //[super viewWillDisappear:YES];
    // this will show the Tabbar
    //[self.tabBarController.tabBar setHidden:NO];
}

@end
