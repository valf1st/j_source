//
//  JOMessageViewController.m
//  Joton
//
//  Created by Val F on 13/03/21.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOMessageViewController.h"

@interface JOMessageViewController ()

@end

@implementation JOMessageViewController

#define S 30

int myid, reload, msp, pagingm, endm, mc;
NSString *myname;
NSArray *msgres;
UISegmentedControl *sc;
UIActivityIndicatorView *ai;
UIButton *m1refresh;

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

    sc = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"他人の出品", @"自分の出品", nil]];
    sc.selectedSegmentIndex=0;
    sc.segmentedControlStyle = UISegmentedControlStyleBar;
    sc.tintColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.0 alpha:1.0];
    [self.navigationController.navigationBar.topItem setTitleView:sc];
    [sc addTarget:self action:@selector(segment:) forControlEvents:UIControlEventValueChanged];

    /*UIImageView *newmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconNew.png"]];
    newmark.frame = CGRectMake(0, 0, 47, 28);
    [self.navigationItem addSubview:newmark];*/

    _scroll.delegate = self;

    reload = 0; msp = 0;

    msg2 = [self.storyboard instantiateViewControllerWithIdentifier:@"msg2"];

    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
    myname = [ud stringForKey:@"username"];

    //ナビゲーションバーにボタンを追加
    /*UIButton *refreshh = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 44, 45)];
    [refreshh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"]
                       forState:UIControlStateNormal];
    [refreshh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* refreshbtn = [[UIBarButtonItem alloc] initWithCustomView:refreshh];
    self.navigationItem.rightBarButtonItems = @[refreshbtn];*/


    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(reload:) name:@"moveTab" object:nil];
    [nc addObserver:self selector:@selector(submit) name:@"submit" object:nil];
    [nc addObserver:self selector:@selector(scrollUp) name:@"scrollUp" object:nil];
}

- (void)scrollUp{
    // 一番上までスクロール
    [self.scroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

- (void)submit{
    [self.tabBarController setSelectedIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"pushed"]){
        NSArray *option = [ud objectForKey:@"pushed"];
        /*UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"pushed" message:[option valueForKeyPath:@"item_id"] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];*/
        NSLog(@"option = %@", option);

        NSString *tab = [option valueForKeyPath:@"tab"];
        if([tab intValue] == 1){
            JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
            send.item = [option valueForKeyPath:@"item_id"];
            //send.photo = [iteminfo valueForKeyPath:@"photo"];
            send.user = [option valueForKeyPath:@"sender_id"];
            send.seller = @"1";
            send.photo = [option valueForKeyPath:@"photo"];
            [self.navigationController pushViewController:send animated:NO];
        }else{
            JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
            send.item = [option valueForKeyPath:@"item_id"];
            //send.photo = [iteminfo valueForKeyPath:@"photo"];
            send.user = [option valueForKeyPath:@"sender_id"];
            send.seller = @"0";
            send.photo = [option valueForKeyPath:@"photo"];
            [self.navigationController pushViewController:send animated:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    m1refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    m1refresh.frame = CGRectMake(276, 0, 45, 44);
    [m1refresh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:m1refresh];
    [m1refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];

    if(reload == 0 || msgres == nil || [msgres isEqual:[NSNull null]]){
        msgres = NULL;
        msp = 0;
        [self getmessage];
        reload = 1;
    }
}

- (void)getmessage{
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&startnumber=%d&totalnumber=%d", myid, msp, S];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_REQ_MESSAGES];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
    msp = msp + S;
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    NSLog(@"response count = %d", [response count]);
    if(load){
        if([response count] < S-1){
            endm = 1;
        }
        if([msgres count] == 0){
            msgres = response;
            mc = 0;
        }else{
            mc = [msgres count];
            msgres = [msgres arrayByAddingObjectsFromArray:response];
        }
        [self draw];
    }
    pagingm = 0;
    [ai stopAnimating];
}

//描画
- (void)draw{
    if([msgres count] <= 0){
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
        for(int i=mc ; i<[msgres count] ; i++){
            NSLog(@"count = %d", [msgres count]);
            NSString *msginfo = [msgres objectAtIndex:i];
            NSString *message = [msginfo valueForKeyPath:@"message"];
            NSString *uname = [msginfo valueForKeyPath:@"uname"];
            int uid = [[msginfo valueForKeyPath:@"seller_user_id"] intValue];
            int nego_stage = [[msginfo valueForKeyPath:@"nego_stage"] intValue];
            NSString *icon = [msginfo valueForKeyPath:@"icon"];
            int iid = [[msginfo valueForKeyPath:@"item_id"] intValue];
            NSString *photo = [msginfo valueForKeyPath:@"photo"];
            NSString *addtime = [msginfo valueForKeyPath:@"add_time"];
            int checked = [[msginfo valueForKeyPath:@"checked"] intValue];
            int receiver = [[msginfo valueForKeyPath:@"receiver_user_id"] intValue];
            //int sender = [[msginfo valueForKeyPath:@"sender_user_id"] intValue];

        
            //テーブルビューと見せかけたラベルとみせかけたボタン
            UIButton *lbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lbBtn.frame = CGRectMake(-1, 66*i, 322, 67);
            lbBtn.backgroundColor = [UIColor whiteColor];
            lbBtn.layer.borderColor = [UIColor colorWithWhite:0.878 alpha:1.0].CGColor;
            lbBtn.layer.borderWidth = 1.0;
            [self.scroll addSubview:lbBtn];
            [lbBtn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            lbBtn.tag = i+1;


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
            //dlabel.frame = CGRectMake(235-sizet.width, 8, sizet.width, 20);
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
                        UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 35, 35)];
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
                UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 35, 35)];
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

- (void)btn:(UIButton *)sender{
    NSString *iteminfo = [msgres objectAtIndex:sender.tag-1];
    NSLog(@"tag = %d", sender.tag);
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = [iteminfo valueForKeyPath:@"item_id"];
    send.photo = [iteminfo valueForKeyPath:@"photo"];
    send.user = [iteminfo valueForKeyPath:@"seller_user_id"];
    send.seller = @"1";
    [self.navigationController pushViewController:send animated:YES];
    //newマーク消す
    /*UIImageView *new = (UIImageView *)[self.scroll viewWithTag:-sender.tag];
    new.hidden = TRUE;*/
    UIButton *new = (UIButton *)[self.scroll viewWithTag:sender.tag];
    [new setBackgroundColor:[UIColor whiteColor]];
}

- (void)user:(UIButton *)sender{
    NSString* tagtag=[NSString stringWithFormat:@"%d",sender.tag];
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = tagtag;
    [self.navigationController pushViewController:user animated:YES];
}

- (void)reload:(id)sender {
    if(pagingm == 0){
        msp = 0;
        msgres = NULL;
        msgres = [[NSArray alloc] init];
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
        [self getmessage];
    }
}

- (void)segment:(id)sender{
    [self.navigationController pushViewController:msg2 animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    float lp = sender.contentSize.height;
    float sheight = [[UIScreen mainScreen] bounds].size.height;
    float height = sheight - (20+44+50);
    if(cp > lp-height-20){
        if(pagingm == 0 && endm == 0){
            ai = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
            ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [ai startAnimating];
            [self.scroll addSubview:ai];
            [self getmessage];
            pagingm = 1;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    sc.selectedSegmentIndex=0;
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    m1refresh.hidden = TRUE;
}

@end