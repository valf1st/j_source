//
//  JOBargainViewController.m
//  Joton
//
//  Created by Val F on 13/05/16.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOBargainViewController.h"

@interface JOBargainViewController ()

@end

@implementation JOBargainViewController

#define N 1
#define M 50 //最古からM個の品物の中からNこ選んでくる。N<Mになるように!!

NSArray *bres, *conditions, *sizes;
int myid, connect, reloadb;
UIScrollView *slide;
UITextField *alertTextField;
UIView *barViewb;

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

    self.navigationItem.title = @"掘り出し物";

    reloadb = 0;
    _scroll.tag = 1;
    _scroll.delegate = self;
    //_scroll.bounces = NO;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    //バー
    barViewb = [[UIView alloc] initWithFrame:CGRectMake(0, -440, 320, 480)];
    UIImage *bar = [UIImage imageNamed:@"subNavBack.png"];
    barViewb.backgroundColor = [UIColor colorWithPatternImage:bar];
    [self.scroll addSubview:barViewb];
    barViewb.tag = 1;

    conditions = [[NSArray alloc] initWithObjects:@"-", @"新品", @"新品同様", @"普通", @"劣る", nil];
    sizes = [[NSArray alloc] initWithObjects:@"-", @"持てない", @"大きめ", @"普通", @"小さい", nil];

    //掘り出しボタン
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bgBtn.frame = CGRectMake(10, 445, 301, 30);
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"btnBargainDetail.png"] forState:UIControlStateNormal];
    [barViewb addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(bargain:) forControlEvents:UIControlEventTouchUpInside];
    bgBtn.tag = 1;
}

- (void)viewDidAppear:(BOOL)animated{
    if(reloadb == 0){
        [self connect];
        reloadb = 1;
    }
}

//掘り出し
- (void)bargain:(id)sender{
    [self connect];
}

- (void)connect{
    connect = 1;
    NSString *dataa = [NSString stringWithFormat:@"number=%d&olderthan=%d", N, M];
    NSURL *url = [NSURL URLWithString:URL_ITEM_BARGAIN];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if(connect == 1){
            for (UIView *subview in [self.view subviews]) {
                if(subview.tag != 1){
                    [subview removeFromSuperview];
                }
            }
            for (UIView *subview in [self.scroll subviews]) {
                if(subview.tag == -1){
                    [subview removeFromSuperview];
                }
            }
            bres = response;
            [self draw];
        }else{
            if([response valueForKeyPath:@"result"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"通報しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                NSString *tag = [response valueForKeyPath:@"tag"];
                UIButton *dob = (UIButton *)[self.scroll viewWithTag:[tag intValue]+100000];
                dob.hidden = TRUE;
            }
        }
    }
}

//描画
- (void)draw{
    int i;
    for(i=0 ; i<[bres count] ; i++){

        NSString *iteminfo = [bres objectAtIndex:i];
        int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
        NSString *photo1 = [iteminfo valueForKeyPath:@"photo1"];
        NSString *photo2 = [iteminfo valueForKeyPath:@"photo2"];
        NSString *photo3 = [iteminfo valueForKeyPath:@"photo3"];
        NSString *username = [iteminfo valueForKeyPath:@"user_name"];
        NSString *itemcomment = [iteminfo valueForKeyPath:@"description"];
        int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
        int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
        int userid = [[iteminfo valueForKeyPath:@"user_id"] intValue];
        int price = [[iteminfo valueForKeyPath:@"price"] intValue];
        int size = [[iteminfo valueForKeyPath:@"dimension"] intValue];
        int condition = [[iteminfo valueForKeyPath:@"state"] intValue];
        int means1 = [[iteminfo valueForKeyPath:@"ms1"] intValue];
        int means2 = [[iteminfo valueForKeyPath:@"ms2"] intValue];
        NSString *dobbing = [iteminfo valueForKeyPath:@"dobbing"];
        NSString *icon = [iteminfo valueForKeyPath:@"icon"];

        //ボタンの枠
        UIView *fv = [[UIView alloc] init];
        //fv.frame = CGRectMake(10+(fmod(i,3)*102), 103*((i-(fmod(i,3)))/3)+120, 96, 96);
        fv.frame = CGRectMake(5, 50, 310, 500);
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 5;
        [self.scroll addSubview:fv];
        fv.tag = -1;

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
                item2.frame = CGRectMake(300, 0, 296, 296);
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
                item3.frame = CGRectMake(600, 0, 296, 296);
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
                item3.frame = CGRectMake(600, 0, 296, 296);
                [slide3Btn setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
                [fv addSubview:slide3Btn];
                [slide3Btn addTarget:self action:@selector(slide3:) forControlEvents:UIControlEventTouchUpInside];
                slide3Btn.tag = i+1;
            }else{
                [slide setContentSize:CGSizeMake(593, 296)];
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
            slide.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:0.8];
            [fv addSubview:slide];
            slide.delegate = self;
            
			item.frame = CGRectMake(0, 148-148*p1h/p1w, 296, 296*p1h/p1w);
			[slide addSubview:item];
        }else{
			//１まいはスライドなし
			item.frame = CGRectMake(7, 46, 296, 296*p1h/p1w);
			[fv addSubview:item];
            m = 286-286*p1h/p1w;
        }
		//画像にリンクをつける
		if(myid != userid){
			[item addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
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
                btndob.frame = CGRectMake(190, 0, 119, 44);
                [btndob setBackgroundImage:[UIImage imageNamed:@"btnWarning.png"] forState:UIControlStateNormal];
                [btndob addTarget:self action:@selector(dob:) forControlEvents:UIControlEventTouchUpInside];
                [foot addSubview:btndob];
                btndob.tag = 100000 + i;
            }
            
            fv.frame = CGRectMake(5, 48, 310, 486+size1.height-m);
        }else{
            fv.frame = CGRectMake(5, 48, 310, 443+size1.height-m);
        }
        [_scroll setContentSize:CGSizeMake(320, fv.bounds.size.height +60)];
    }
}

- (void)itembtn:(UIButton*)sender{
    NSString *iteminfo = [bres objectAtIndex:sender.tag];
     JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
     send.item = [iteminfo valueForKeyPath:@"item_id"];
     send.photo = [iteminfo valueForKeyPath:@"photo1"];
     send.user = [iteminfo valueForKeyPath:@"user_id"];
     send.seller = @"1";
     [self.navigationController pushViewController:send animated:YES];
    /*NSDictionary *iteminfo = [res objectAtIndex:sender.tag];
    JODetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.item = [iteminfo valueForKeyPath:@"item_id"];
    detail.itemdata = iteminfo;
    [self.navigationController pushViewController:detail animated:YES];*/
}

- (void)user:(UIButton*)sender{
    NSString* tagtag=[NSString stringWithFormat:@"%d",sender.tag];
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = tagtag;
    [self.navigationController pushViewController:user animated:YES];
}

- (void)slide2:(UIButton *)sender{
    UIScrollView *slideview = (UIScrollView *)[self.scroll viewWithTag:-sender.tag];
    float cp = slideview.contentOffset.x;
    if(cp == 0){
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(290, 0.0f) animated:YES];
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
        [slideview setContentOffset:CGPointMake(290, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img2.png"] forState:UIControlStateNormal];
    }else if(cp == 290){
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(580, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img3.png"] forState:UIControlStateNormal];
    }else{
        //スクロールさせる
        [slideview setContentOffset:CGPointMake(0, 0.0f) animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnNext3Img1.png"] forState:UIControlStateNormal];
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
            NSArray *dobbeditem = [bres objectAtIndex:alertView.tag];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    if(cp < 0){
        barViewb.frame = CGRectMake(0, -440+cp, 320, 480);
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
