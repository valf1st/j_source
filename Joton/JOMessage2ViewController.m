//
//  JOMessage2ViewController.m
//  Joton
//
//  Created by Val F on 13/06/12.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOMessage2ViewController.h"

@interface JOMessage2ViewController ()

@end

@implementation JOMessage2ViewController

#define S2 30

int reload, myid, msp2, pagingm2, endm2, mc2;
NSString *myname, *myicon;
NSMutableDictionary *msg2res;
UISegmentedControl *sc2;
UIActivityIndicatorView *ai;
UIButton *m2refresh;

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

    self.navigationItem.title = @"メッセージ";

    reload = 0; msp2 = 0; endm2 = 0;
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
    myname = [ud stringForKey:@"username"];
    myicon = [ud stringForKey:@"user_icon"];

    self.navigationItem.hidesBackButton = YES;

    _scroll.delegate = self;

    sc2 = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"他人の出品", @"自分の出品", nil]];
    sc2.selectedSegmentIndex=1;
    sc2.segmentedControlStyle = UISegmentedControlStyleBar;
    sc2.tintColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.0 alpha:1.0];
    [self.navigationController.navigationBar.topItem setTitleView:sc2];
    [sc2 addTarget:self action:@selector(segment:) forControlEvents:UIControlEventValueChanged];

    //ナビゲーションバーにボタンを追加
    /*UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44, 45)];
    [refresh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"]
                       forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* refreshbtn = [[UIBarButtonItem alloc] initWithCustomView:refresh];
    self.navigationItem.rightBarButtonItems = @[refreshbtn];*/

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(backTab:) name:@"moveTab" object:nil];
    [nc addObserver:self selector:@selector(reload:) name:@"reload" object:nil];
    [nc addObserver:self selector:@selector(scrollUp) name:@"scrollUp" object:nil];
}

- (void)scrollUp{
    // 一番上までスクロール
    [self.scroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

- (void)backTab:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    m2refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    m2refresh.frame = CGRectMake(276, 0, 45, 44);
    [m2refresh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:m2refresh];
    [m2refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];

    if(reload == 0 || msg2res == nil || [msg2res isEqual:[NSNull null]]){
        msg2res = NULL;
        [self getmymessage];
        reload = 1;
    }
}

- (void)btn:(UIButton *)sender{
    NSString *iteminfo = [msg2res valueForKeyPath:[NSString stringWithFormat:@"%d", sender.tag-1]];
    NSLog(@"tag = %d", sender.tag);
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = [iteminfo valueForKeyPath:@"item_id"];
    send.photo = [iteminfo valueForKeyPath:@"photo"];
    send.user = [iteminfo valueForKeyPath:@"buyer_user_id"];
    send.seller = @"0";
    [self.navigationController pushViewController:send animated:YES];
    //newマーク消す
    /*UIImageView *new = (UIImageView *)[self.scroll viewWithTag:-sender.tag];
    new.hidden = TRUE;*/
    UIButton *new = (UIButton *)[self.scroll viewWithTag:sender.tag];
    [new setBackgroundColor:[UIColor whiteColor]];
}

- (void)reload:(UIBarButtonItem*)sender {
    if(pagingm2 == 0){
        msg2res = NULL;
        msg2res = [[NSMutableDictionary alloc] init];
        for (UIView *subview in [self.scroll subviews]) {
            if(subview.tag > 0){
                [subview removeFromSuperview];
            }
        }
        for (UIView *subview in [self.view subviews]) {
            if(subview.tag == 1){
                [subview removeFromSuperview];
            }
        }
        msp2 = 0;
        [self getmymessage];
    }
}

- (void)getmymessage{
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&startnumber=%d&totalnumber=%d", myid, msp2, S2];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_REQ_MYMESSAGES];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
    msp2 = msp2 + S2;
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSMutableDictionary *)response{
    if(load){
        if([[response valueForKeyPath:@"end"]intValue] == 1){
            endm2 = 1;
        }
        if([msg2res count] == 0){
            msg2res = response;
            mc2 = 0;
        }else{
            mc2 = [msg2res count]-1;
            //msg2res = [msg2res arrayByAddingObjectsFromArray:response];
            for(int i=0 ; i<[response count]-1 ; i++){
                [msg2res setObject:[response objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d", mc2+i]];
            }
        }
        [self draw];
    }
    pagingm2 = 0;
    [ai stopAnimating];
}

//描画
- (void)draw{
    if([msg2res count] <= 0){
        UILabel *nmlabel = [[UILabel alloc] init];
        nmlabel.frame = CGRectMake(10, 70, 300, 50);
        nmlabel.text = @"まだメッセージはありません";
        nmlabel.backgroundColor = [UIColor clearColor];
        nmlabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        nmlabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:nmlabel];
        nmlabel.tag = 1;
    }else{
        //あったらはりまくる
        for(int i=mc2 ; i<[msg2res count]-1 ; i++){
            NSArray *msginfo = [msg2res valueForKeyPath:[NSString stringWithFormat:@"%d", i]];
            NSString *message = [msginfo valueForKeyPath:@"message"];
            NSString *uname = [msginfo valueForKeyPath:@"uname"];
            //int uid = [[msginfo valueForKeyPath:@"seller_user_id"] intValue];
            int nego_stage = [[msginfo valueForKeyPath:@"nego_stage"] intValue];
            NSString *icon = [msginfo valueForKeyPath:@"icon"];
            int iid = [[msginfo valueForKeyPath:@"item_id"] intValue];
            NSString *photo = [msginfo valueForKeyPath:@"photo"];
            NSString *addtime = [msginfo valueForKeyPath:@"add_time"];
            int checked = [[msginfo valueForKeyPath:@"checked"] intValue];
            int receiver = [[msginfo valueForKeyPath:@"receiver_user_id"] intValue];
            int sender = [[msginfo valueForKeyPath:@"sender_user_id"] intValue];

            //テーブルビューと見せかけたラベルとみせかけたボタン
            UIButton *lbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lbBtn.frame = CGRectMake(-1, 66*i, 322, 67);
            lbBtn.backgroundColor = [UIColor whiteColor];
            lbBtn.layer.borderColor = [UIColor colorWithWhite:0.878 alpha:1.0].CGColor;
            lbBtn.layer.borderWidth = 1.0;
            [self.scroll addSubview:lbBtn];
            [lbBtn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            lbBtn.tag = i+1;

            //出品者のアイコンをはる
            int uid;
            if(myid == sender){
                uid = receiver;
            }else{
                uid = sender;
            }
			__weak UIButton *userbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *url_photo=[NSString stringWithFormat:@"%@/%d/s_%@", URL_ICON, uid, icon];
            NSURL* url = [NSURL URLWithString:url_photo];
			UIImage *placeholderImage = [UIImage imageNamed:@"iconUser.png"];
            if(icon == nil || [icon isEqual:[NSNull null]]){
				[userbtn setBackgroundImage:[UIImage imageNamed:@"iconUser.png"] forState:UIControlStateNormal];
			}else{
                //画像キャッシュ
                [userbtn setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        [userbtn setBackgroundImage:[UIImage imageNamed:@"itemNoImg.png"] forState:UIControlStateNormal];
                    }
                }];
            }
            userbtn.frame = CGRectMake(6, 6, 42, 42);
            [userbtn addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
            [lbBtn addSubview:userbtn];
            userbtn.tag = uid;

            //ユーザー名
            UILabel *nlabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 2, 140, 20)];
            nlabel.text = uname;
            nlabel.textColor = [UIColor blackColor];
            nlabel.font = [UIFont boldSystemFontOfSize:12.6];
            nlabel.backgroundColor = [UIColor clearColor];
            [lbBtn addSubview:nlabel];
            //メッセージ
            UILabel *mlabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 20, 200, 20)];
            /*if(sender == 0){
                mlabel.text = message;
            }else if(receiver == myid){
                mlabel.text = [NSString stringWithFormat:@"%@ : %@", uname, message];
            }else{
                mlabel.text = [NSString stringWithFormat:@"%@ : %@", myname, message];
            }*/
            mlabel.text = message;
            mlabel.lineBreakMode = NSLineBreakByWordWrapping;
            mlabel.numberOfLines = 1;
            mlabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
            mlabel.font = [UIFont systemFontOfSize:12.4];
            mlabel.backgroundColor = [UIColor clearColor];
            [lbBtn addSubview:mlabel];


            NSString *time = [JOFunctionsDefined sinceFromData:addtime];
            UIFont *fontt = [UIFont systemFontOfSize:12.4];
            UILineBreakMode modet = NSLineBreakByWordWrapping;
            CGSize boundst = CGSizeMake(90, 20);
            CGSize sizet = [time sizeWithFont:fontt constrainedToSize:boundst lineBreakMode:modet];
            //時間
            UILabel *dlabel = [[UILabel alloc] init];
            dlabel.frame = CGRectMake(67.5, 48.5, sizet.width, 15);
            dlabel.backgroundColor = [UIColor clearColor];
            dlabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
            dlabel.textAlignment = NSTextAlignmentRight;
            dlabel.font = fontt;
            dlabel.text = time;
            [lbBtn addSubview:dlabel];
            //時計マーク
            UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time2.png"]];
            clock.frame = CGRectMake(52, 50, 12, 12);
            [lbBtn addSubview:clock];

			//品物画像はる
			UIImageView *piv;
			if(photo == nil || [photo isEqual:[NSNull null]]){
				UIImage *imgi = [UIImage imageNamed:@"itemImg.png"];
				piv = [[UIImageView alloc] initWithImage:imgi];
			}else{
				NSString *url_item=[NSString stringWithFormat:@"%@/%d/s_%@", URL_IMAGE, iid, photo];
				NSURL* urli = [NSURL URLWithString:url_item];
				UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
				piv = [[UIImageView alloc] initWithImage:nil];
				//画像キャッシュ
                __block UIImageView *blockView = piv;
				[piv setImageWithURL:urli placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        blockView.image = [UIImage imageNamed:@"itemNoImg.png"];
                    }
                    if(nego_stage == 2){
                        UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 35, 35)];
                        lock.image = [UIImage imageNamed:@"iconRequestLock.png"];
                        [blockView addSubview:lock];
                    }else if(nego_stage == 1){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelRequest.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(nego_stage == 3){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelSend.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(nego_stage == 4){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelClose.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(nego_stage == 5){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelCancel.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(nego_stage == 6){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelDelete.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }
                }];
			}
			piv.frame = CGRectMake(256, 1, 65, 65);
			[lbBtn addSubview:piv];
            if(nego_stage == 2){
                UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 35, 35)];
                lock.image = [UIImage imageNamed:@"iconRequestLock.png"];
                [piv addSubview:lock];
            }else if(nego_stage == 1){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelRequest.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(nego_stage == 3){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelSend.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(nego_stage == 4){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelClose.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(nego_stage == 5){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelCancel.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(nego_stage == 6){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelDelete.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }

            //最後のmsgが相手からのでかつ未読ならマーク
            if(checked == 0 && receiver == myid){
                /*UIImageView *newiv = [[UIImageView alloc] initWithFrame:CGRectMake(200, 25, 47, 28)];
                newiv.image = [UIImage imageNamed:@"iconNew.png"];
                [lbBtn addSubview:newiv];
                newiv.tag = -lbBtn.tag;*/
                [lbBtn setBackgroundColor:[UIColor colorWithRed:0.992 green:0.976 blue:0.847 alpha:1.0]];
            }

            [self.scroll setScrollEnabled:YES];
            [self.scroll setContentSize:CGSizeMake(320, 66*i+110)];
        }
    }
}

- (void)user:(UIButton *)sender{
    NSString* tagtag=[NSString stringWithFormat:@"%d",sender.tag];
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = tagtag;
    [self.navigationController pushViewController:user animated:YES];
}

- (void)segment:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    float lp = sender.contentSize.height;
    float sheight = [[UIScreen mainScreen] bounds].size.height;
    float height = sheight - (20+44+50);
    if(cp > lp-height-20){
        if(pagingm2 == 0 && endm2 == 0){
            ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
            ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [ai startAnimating];
            [self.scroll addSubview:ai];
            [self getmymessage];
            pagingm2 = 1;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    sc2.selectedSegmentIndex=1;
    m2refresh.hidden = TRUE;
}

@end
