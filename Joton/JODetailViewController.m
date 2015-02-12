//
//  JODetailViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JODetailViewController.h"

@interface JODetailViewController ()

@end

@implementation JODetailViewController

@synthesize item = _item;
@synthesize itemdata = _itemdata;
@synthesize from = _from;//無限ループ回避
UIScrollView *scroll, *slide;
NSArray *sizes, *conditions;
UIView *waiting;
UIImageView *newiv;
NSString *photo1, *photo2, *photo3, *itemcomment;
NSData *location;
NSMutableArray *itemcheck;
int myid, userid, reload, condition, means1, means2, size, update, dcnct, p1h, p1w;
CGFloat sheight;
NSMutableDictionary *dres;
UITextField *dalertTextField;
UIButton *btnddob;

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

    reload = 0; update = 0;
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    self.navigationItem.title = @"品物詳細";

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    sheight = screenSize.height;

    scroll = [[UIScrollView alloc] init];
    scroll.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    scroll.frame = CGRectMake(0, 0, 320, sheight);
    [self.view addSubview:scroll];

    [scroll setScrollEnabled:YES];

    conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(update) name:@"updated" object:nil];
}

- (void)update{
    update = 1;
    for (UIView *subview in [scroll subviews]) {
        if(subview.tag != 1){
            [subview removeFromSuperview];
        }
    }
    [self getitem];
    // 通知を作成する
    NSNotification *n = [NSNotification notificationWithName:@"myupdated" object:self];
    // 通知実行！
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)viewDidAppear:(BOOL)animated{
    if(reload == 0){
        NSLog(@"itemid = %@", _item);
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
    dcnct = 1;
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
        if(dcnct == 1){
            _itemdata = response;
            [self draw];
        }else if(dcnct == 2){
            [JOToastUtil showToast:@"削除しました"];
            // 通知を作成する
            NSNotification *n = [NSNotification notificationWithName:@"myupdated" object:self];
            // 通知実行！
            [[NSNotificationCenter defaultCenter] postNotification:n];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"通報しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            btnddob.hidden = TRUE;
        }
    }
}

//描画
- (void)draw{
    NSDictionary *dict = _itemdata;

    photo1 = [dict valueForKeyPath:@"photo1"];
    p1w = [[dict valueForKeyPath:@"photo1w"] intValue];
    p1h = [[dict valueForKeyPath:@"photo1h"] intValue];
    photo2 = [dict valueForKeyPath:@"photo2"];
    photo3 = [dict valueForKeyPath:@"photo3"];
    int price = [[dict valueForKeyPath:@"price"] intValue];
    means1 = [[dict valueForKeyPath:@"ms1"] intValue];
    means2 = [[dict valueForKeyPath:@"ms2"] intValue];
    itemcomment = [dict valueForKeyPath:@"description"];
    size = [[dict valueForKeyPath:@"dimension"] intValue];
    condition = [[dict valueForKeyPath:@"state"] intValue];
    NSString *username = [dict valueForKeyPath:@"user_name"];
    userid = [[dict valueForKeyPath:@"user_id"] intValue];
    NSString *icon = [dict valueForKeyPath:@"icon"];
    NSString *add_date = [dict valueForKeyPath:@"item_add_time"];
    int deleted = [[dict valueForKeyPath:@"is_del"] intValue];
    //int purchased = [[dict valueForKeyPath:@"stage"] intValue];
    int nego = [[dict valueForKeyPath:@"nego"] intValue];
    int stage = [[dict valueForKeyPath:@"stage"] intValue];
    NSString *dobbing = [dict valueForKeyPath:@"dobbing"];
    //int unchecked = [[dict valueForKeyPath:@"unchecked"] intValue];
    location = [dict valueForKeyPath:@"lat_lon"];

    //ボタンの枠
    UIView *fv = [[UIView alloc] init];
    fv.frame = CGRectMake(5, 10, 310, 500);
    fv.backgroundColor = [UIColor whiteColor];
    fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    fv.layer.borderWidth = 1.0;
    fv.layer.cornerRadius = 5;
    [scroll addSubview:fv];

    int pp = 0;
    if(userid == myid){
        UIButton *plist = [UIButton buttonWithType:UIButtonTypeCustom];
        plist.frame = CGRectMake(0, 0, 310, 36);
        plist.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [plist setTitle:[NSString stringWithFormat:@"　　%d人が興味を持っています", nego] forState:UIControlStateNormal];
        [plist setTitleColor:[UIColor colorWithRed:0.60 green:0.62 blue:0.63 alpha:1.0] forState:UIControlStateNormal];
        [plist setBackgroundImage:[UIImage imageNamed:@"bgInterest.png"] forState:UIControlStateNormal];
        plist.titleLabel.font = [UIFont systemFontOfSize:15];
        [fv addSubview:plist];
        [plist addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
        //plist.tag = i;
        pp = 36;
        UIImageView *ar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconArrow2.png" ]];
        ar.frame = CGRectMake(285, 10, 11, 17);
        [plist addSubview:ar];
        if(nego == 0){
            plist.userInteractionEnabled = NO;
        }
        UIImageView *msg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconListMessage.png"]];
        msg.frame = CGRectMake(13, 13, 13, 12);
        [plist addSubview:msg];
    }

    //NSString *addtime = [iteminfo valueForKeyPath:@"item_add_time"];
    NSString *time = [JOFunctionsDefined sinceFromData:add_date];
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
    NSString *un=[NSString stringWithFormat:@"             %@",username];
    [usbutton setTitle:un forState:UIControlStateNormal];
    [fv addSubview:usbutton];
    [usbutton addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];

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
    iv2.frame = CGRectMake(7, 7+pp, 33, 33);
    [fv addSubview:iv2];

    //商品の画像をはる
    __weak UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    item.layer.borderWidth = 1.0;
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
        slide = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 46+pp, 296, 296)];
        [slide setScrollEnabled:NO];
        if(!(photo3 == nil || [photo3 isEqual:[NSNull null]] || [photo3 isEqualToString:@""])){
            [slide setContentSize:CGSizeMake(896, 296)];
            //２まいめの写真はる
            __weak UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
            item2.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
            item2.layer.borderWidth = 1.0;
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
                item2.userInteractionEnabled = YES;
                [item2 addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [item2 addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            }
            //３まいめの写真はる
            __weak UIButton *item3 = [UIButton buttonWithType:UIButtonTypeCustom];
            item3.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
            item3.layer.borderWidth = 1.0;
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
                [item3 addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [item3 addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            }
            //3まい用のボタン
            UIButton *slide3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            slide3Btn.frame = CGRectMake(250, 344+pp, 55, 30);
            [slide3Btn setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
            [fv addSubview:slide3Btn];
            [slide3Btn addTarget:self action:@selector(slide3:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [slide setContentSize:CGSizeMake(600, 296)];
            //２まいめの写真はる
            __weak UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
            item2.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
            item2.layer.borderWidth = 1.0;
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
                [item2 addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //[item2 addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            }
            //2まい用のボタン
            UIButton *slide2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            slide2Btn.frame = CGRectMake(255, 344+pp, 55, 30);
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
        item.frame = CGRectMake(7, 46+pp, 296, 296*p1h/p1w);
        [fv addSubview:item];
        m = 296-296*p1h/p1w;
    }
    if(myid == userid){
        item.userInteractionEnabled = YES;
        [item addTarget:self action:@selector(myitem:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //[item addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    }

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
    if(userid != myid){
        cdlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cdlabel.layer.borderWidth = 0.5;
    }
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

    //自分のだったら
    if(myid == userid){
        //メッセージ
        /*UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        msgBtn.frame = CGRectMake(125, 450+size1.height-m, 80, 25);
        [msgBtn setTitle:@"メッセージ" forState:UIControlStateNormal];
        [scroll addSubview:msgBtn];
        [msgBtn addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];

        [item addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
        //未読あればbadge
        if(unchecked != 0){
            newiv = [[UIImageView alloc] initWithFrame:CGRectMake(70, -5, 15, 15)];
            newiv.image = [UIImage imageNamed:@"red.png"];
            [msgBtn addSubview:newiv];
        }*/

        //item.userInteractionEnabled = NO;
        fv.frame = CGRectMake(5, 10, 310, 475+size1.height-m+pp);

        //削除されてなかったら編集と削除ボタンは出す
        if(stage == 1 || stage == 0){
            //編集
            UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            editBtn.frame = CGRectMake(5, 450+size1.height-m+pp, 137, 32);
            [editBtn setBackgroundImage:[UIImage imageNamed:@"btnEdit.png"] forState:UIControlStateNormal];
            [fv addSubview:editBtn];
            [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];

            //削除
            UIButton *dltBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            dltBtn.frame = CGRectMake(168, 450+size1.height-m+pp, 137, 32);
            [dltBtn setBackgroundImage:[UIImage imageNamed:@"btnDelete.png"] forState:UIControlStateNormal];
            [fv addSubview:dltBtn];

            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormater dateFromString:add_date];
            NSTimeInterval since = [now timeIntervalSinceDate:date];
            if(since >= 604800){
             [dltBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
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
        cdlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cdlabel.layer.borderWidth = 0.5;
        fv.frame = CGRectMake(5, 10, 310, 483+size1.height-m+pp);
        [scroll setContentSize:CGSizeMake(320, 504+size1.height-m+pp)];

    }else{
        if([_from intValue] != 1){
            cdlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cdlabel.layer.borderWidth = 0.5;
            //メッセージページにとぶ(send)
            /*UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            msgBtn.frame = CGRectMake(6, 454+size1.height-m, 129, 27);
            [msgBtn setBackgroundImage:[UIImage imageNamed:@"btnWant.png"] forState:UIControlStateNormal];
            [fv addSubview:msgBtn];
            [msgBtn addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            fv.frame = CGRectMake(5, 10, 310, 487+size1.height-m);
            //[scroll setContentSize:CGSizeMake(320, 614+size1.height-m)];*/
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
            [btnreq addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
            //btnreq.tag = i;
            [foot addSubview:btnreq];
            //アイコン
            UIImageView *msg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconListMessage.png"]];
            msg.frame = CGRectMake(42, 15, 13, 12);
            [foot addSubview:msg];

            if(dobbing == nil || [dobbing isEqual:[NSNull null]]){
                //通報ボタン
                btnddob = [UIButton buttonWithType:UIButtonTypeCustom];
                btnddob.frame = CGRectMake(190, 0, 119, 44);
                [btnddob setBackgroundImage:[UIImage imageNamed:@"btnWarning.png"] forState:UIControlStateNormal];
                [btnddob addTarget:self action:@selector(dob:) forControlEvents:UIControlEventTouchUpInside];
                [foot addSubview:btnddob];
                //btndob.tag = 100000 + i;
            }

            fv.frame = CGRectMake(5, 10, 310, 486+size1.height-m);
        }else{
            fv.frame = CGRectMake(5, 10, 310, 445+size1.height-m);
            //[scroll setContentSize:CGSizeMake(320, 570+size1.height-m)];
        }
        [item addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    }

    if(deleted == 1){
        //削除されてたら上あける
        CGRect frame = fv.frame;
        frame.origin.y = 50.0;
        fv.frame = frame;
        UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
        dlabel.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgMypageSubnav.png"]];
        dlabel.text = @"この商品は削除されました";
        dlabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:dlabel];
    }
    /*if(purchased != 0 && myid == userid){
        //交渉中なら上あける
        CGRect frame = fv.frame;
        frame.origin.y = 50.0;
        fv.frame = frame;
        if(purchased == 1){
            //ボタンにする
            UIButton *pbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pbtn.frame = CGRectMake(0, 0, 320, 43);
            [pbtn setBackgroundImage:[UIImage imageNamed:@"bgMypageSubnav.png"] forState:UIControlStateNormal];
            [pbtn setTitle:@"この商品は交渉中です" forState:UIControlStateNormal];
            [pbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.view addSubview:pbtn];
            [pbtn addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
            //item.userInteractionEnabled = NO;
        }else{
            UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
            dlabel.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgMypageSubnav.png"]];
            dlabel.text = @"この商品は譲渡されました";
            dlabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:dlabel];
        }
    }else if(nego > 0){
        //上あける
        CGRect frame = fv.frame;
        frame.origin.y = 50.0;
        fv.frame = frame;
        //ボタンにする
        UIButton *pbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pbtn.frame = CGRectMake(0, 0, 320, 43);
        [pbtn setBackgroundImage:[UIImage imageNamed:@"bgMypageSubnav.png"] forState:UIControlStateNormal];
        [pbtn setTitle:@"メッセージが来ています" forState:UIControlStateNormal];
        [pbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.view addSubview:pbtn];
        [pbtn addTarget:self action:@selector(mymessagelist:) forControlEvents:UIControlEventTouchUpInside];
        //item.userInteractionEnabled = NO;
    }*/
    CGRect frame = fv.frame;
    NSLog(@"origin = %f", frame.origin.y);
    NSLog(@"height = %f", fv.bounds.size.height);
    [scroll setContentSize:CGSizeMake(320, frame.origin.y + fv.bounds.size.height + 130)];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)user:(UIButton*)sender{
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = [NSString stringWithFormat:@"%d",userid];
    [self.navigationController pushViewController:user animated:YES];
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


- (void)edit:(id)sender{
    JOEditViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    edit.item = _item;
    edit.photo1 = photo1;
    edit.p1h = [NSString stringWithFormat:@"%d",p1h];
    edit.p1w = [NSString stringWithFormat:@"%d",p1w];
    edit.photo2 = photo2;
    edit.photo3 = photo3;
    edit.comment = itemcomment;
    edit.cd = [NSString stringWithFormat:@"%d",condition];
    edit.ms1 = [NSString stringWithFormat:@"%d",means1];
    edit.ms2 = [NSString stringWithFormat:@"%d",means2];
    edit.sz = [NSString stringWithFormat:@"%d",size];
    edit.location = location;
    edit.from = @"3";
    [self presentViewController:edit animated:YES completion:nil];
}

- (void)mymessagelist:(id)sender{
    JOMlistViewController *mlist = [self.storyboard instantiateViewControllerWithIdentifier:@"mlist"];
    mlist.item = _item;
    mlist.photo = photo1;
    [self.navigationController pushViewController:mlist animated:YES];
}
- (void)myitem:(id)sender{
    UIAlertView *alertd = [[UIAlertView alloc] initWithTitle:@"" message:@"あなたの品物です" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alertd.alertViewStyle = UIAlertViewStyleDefault;
    [alertd show];
}

- (void)message:(id)sender{
    if([_from intValue] == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"" message:@"メッセージへ" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
        alerts.alertViewStyle = UIAlertViewStyleDefault;
        [alerts show];
        alerts.tag = 3;
    }
}

- (void)delete:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"削除します" message:@"確認" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    alert.tag = 1;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1:
                //通信まちの間，半透明viewで覆っておく
                waiting = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,835)];
                waiting.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:0.5];
                [self.view addSubview:waiting];
                [self connect];
                break;
        }
    }else if(alertView.tag == 2){
        switch (buttonIndex) {
            case 0://押したボタンがCancelなら何もしない
                break;
            case 1://押したボタンがOKなら通報
                //通報
                NSLog(@"");
                int iid = [[_itemdata valueForKeyPath:@"item_id"] intValue];
                int uid = [[_itemdata valueForKeyPath:@"user_id"] intValue];
                //通信
                dcnct = 3;
                NSString *dataa = [NSString stringWithFormat:@"item_id=%d&user_id=%d&my_id=%d&msg=%@&tag=%d&service=reader", iid, uid, myid, [dalertTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], alertView.tag];
                NSLog(@"postdob = %@", dataa);
                NSURL *url = [NSURL URLWithString:URL_ITEM_DOB];
                NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
                async = [JOAsyncConnection alloc];
                async.delegate = self;
                [async asyncConnect:request];
                break;
        }
    }else if(alertView.tag == 3){
        JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
        send.item = [_itemdata valueForKeyPath:@"item_id"];
        send.itemdata = _itemdata;
        send.photo = [_itemdata valueForKeyPath:@"photo1"];
        send.user = [_itemdata valueForKeyPath:@"user_id"];
        send.seller = @"1";
        send.from = @"1";
        [self.navigationController pushViewController:send animated:YES];
    }
}
- (void)notdelete:(UIButton *)sender{
    NSString *message = [NSString stringWithFormat:@"あと %d日間は削除できません", sender.tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出品後７日間は削除できません" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

//通信して削除
- (void)connect {
    dcnct = 2;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //通信
    NSString *dataa = [NSString stringWithFormat:@"item_id=%@&user_id=%d", _item, myid];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_ITEM_DELETE];
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

-(void)dob:(UIButton*)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通報" message:@"この商品を通報します" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"通報", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    dalertTextField = [alertView textFieldAtIndex:0];
    //alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    dalertTextField.placeholder = @"メッセージ(任意)";
    alertView.tag = sender.tag - 100000;
    [alertView show];
    alertView.tag = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
	itemcheck = [NSMutableArray array];
    if(update == 1){
        // 通知を作成する
        NSNotification *n = [NSNotification notificationWithName:@"myupdated" object:self];
        // 通知実行！
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }
}

@end
