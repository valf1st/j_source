//
//  JOMoneyViewController.m
//  Joton
//
//  Created by Val F on 13/04/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOMoneyViewController.h"

@interface JOMoneyViewController ()

@end

@implementation JOMoneyViewController

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

    mnreload = 0; m1 = 1; m2 = 0; m3 = 0; mj = 0; mt = 0; mj2 = 0; mt2 = 0; connect = 0;

    self.navigationItem.title = @"出品報酬";

    //ユーザーデフォルトからid取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    //枠
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 118)];
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgMoney.png"]];
    [self.scroll addSubview:fv];
    fv.tag = 1;
    //ラベルず
    UILabel *blabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    blabel.text = @"出品報酬";
    blabel.font = [UIFont systemFontOfSize:13];
    blabel.textColor = [UIColor lightGrayColor];
    [fv addSubview:blabel];
    UILabel *xlabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, 300, 20)];
    xlabel.text = @" 1000円から振り込み可能　100円からコイン交換可能";
    xlabel.font = [UIFont systemFontOfSize:11.5];
    xlabel.backgroundColor = [UIColor clearColor];
    xlabel.textColor = [UIColor lightGrayColor];
    [fv addSubview:xlabel];

    //コインと交換ボタン
    cxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cxBtn.frame = CGRectMake(155, 65, 140, 60);
    cxBtn.backgroundColor = [UIColor clearColor];
    [cxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cxBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    cxBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cxBtn setClipsToBounds:YES];
    //NSString* lbmtext=[NSString stringWithFormat:@"     %@ 円", money];
    [cxBtn setTitle:@"コイン交換する　" forState:UIControlStateNormal];
    [fv addSubview:cxBtn];
    [cxBtn addTarget:self action:@selector(cxpop:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *cxiv = [[UIImageView alloc] initWithFrame:CGRectMake(128, 21, 11, 17)];
    cxiv.image = [UIImage imageNamed:@"iconArrow.png"];
    [cxBtn addSubview:cxiv];
    cxBtn.hidden = TRUE;
    cxBtn.tag = 2;

    //お振り込みボタン
    mxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mxBtn.frame = CGRectMake(0, 65, 140, 60);
    mxBtn.backgroundColor = [UIColor clearColor];
    [mxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [mxBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    mxBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [mxBtn setClipsToBounds:YES];
    //NSString* lbmtext=[NSString stringWithFormat:@"     %@ 円", money];
    [mxBtn setTitle:@"振り込みする" forState:UIControlStateNormal];
    [fv addSubview:mxBtn];
    [mxBtn addTarget:self action:@selector(mx:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *mxiv = [[UIImageView alloc] initWithFrame:CGRectMake(130, 21, 11, 17)];
    mxiv.image = [UIImage imageNamed:@"iconArrow.png"];
    [mxBtn addSubview:mxiv];
    mxBtn.hidden = TRUE;
    mxBtn.tag = 3;

    //注意書き
    UILabel *nlabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 132, 300, 50)];
    nlabel.text = @"※1出品につき10円の報酬があります\n※過去に取引を行ったことがない場合、振り込みできない場合が\n　あります";
    nlabel.backgroundColor = [UIColor clearColor];
    nlabel.font = [UIFont systemFontOfSize:10];
    nlabel.textColor = [UIColor lightGrayColor];
    nlabel.numberOfLines = 100;
    nlabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.scroll addSubview:nlabel];

    //コインと交換popup
    cxpop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    cxpop.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:cxpop];
    cxpop.hidden = TRUE;
    //popup
    UIView *popLabel = [[UIView alloc] initWithFrame:CGRectMake(22, 155, 276, 166)];
    popLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgExchange.png"]];
    [cxpop addSubview:popLabel];
    //背景ぜんぶボタン
    UIButton *c1btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [c1btn setBackgroundColor:[UIColor clearColor]];
    c1btn.frame = CGRectMake(0, 0, 320, 155);
    [cxpop addSubview:c1btn];
    [c1btn addTarget:self action:@selector(popx:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *c2btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [c2btn setBackgroundColor:[UIColor clearColor]];
    c2btn.frame = CGRectMake(0, 321, 320, 300);
    [cxpop addSubview:c2btn];
    [c2btn addTarget:self action:@selector(popx:) forControlEvents:UIControlEventTouchUpInside];
    //とじるボタン
    UIButton *xBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    xBtn.frame = CGRectMake(270, 139, 44, 44);
    [xBtn setBackgroundImage:[UIImage imageNamed:@"iconClose.png"] forState:UIControlStateNormal];
    [cxpop addSubview:xBtn];
    [xBtn addTarget:self action:@selector(popx:) forControlEvents:UIControlEventTouchUpInside];
    //表示
    UILabel *lbs = [[UILabel alloc] init];
    lbs.frame = CGRectMake(35, 185, 290, 25);
    lbs.backgroundColor = [UIColor clearColor];
    lbs.text = @"100円を1コインと交換しますか?";
    [cxpop addSubview:lbs];
    //交換ボタン
    UIButton *cexBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cexBtn.frame = CGRectMake(52, 250, 215, 44);
    [cexBtn setBackgroundImage:[UIImage imageNamed:@"btnExchange.png"] forState:UIControlStateNormal];
    [cxpop addSubview:cexBtn];
    [cexBtn addTarget:self action:@selector(cx:) forControlEvents:UIControlEventTouchUpInside];

    connect = 0;
    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(update:) name:@"moneyupdated" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    if(mnreload == 0){
        [self getmhistory];
        mnreload = 1;
    }
}

- (void)getmhistory{
    connect = 0;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&service=reader", myid];
    NSURL *url = [NSURL URLWithString:URL_USER_MONEY];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if(connect == 1){
            NSLog(@"response = %@", [response description]);
            BOOL result = [[response valueForKeyPath:@"result"] boolValue];
            if(result){
                NSString *ctotal = [response valueForKeyPath:@"total"];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:ctotal forKey:@"coin"];
                NSString *cxmessage = [NSString stringWithFormat:@"%@ コインになりました", ctotal];
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"成功" message:cxmessage delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
                //viewリフレッシュ
                for (UIView *subview in [self.scroll subviews]) {
                    if(subview.tag > 3){
                        [subview removeFromSuperview];
                    }
                }
                [self getmhistory];
                JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.myflag = @"1";
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
        }else{
            hres = response;
            [self draw];
        }
    }
}

//描画
- (void)draw{
    //if(result != FALSE){
    int mbalance;

    if([hres count] == 0){
        mbalance = 0;
    }else{
        NSArray *newest = [hres objectAtIndex:0];
        mbalance = [[newest valueForKeyPath:@"total"] intValue];
    }

    //上の枠内コイン数
    UILabel *lbn = [[UILabel alloc] init];
    lbn.frame = CGRectMake(130, 40, 100, 20);
    //lbn.backgroundColor = [UIColor clearColor];
    lbn.textColor = [UIColor darkGrayColor];
    lbn.font = [UIFont boldSystemFontOfSize:18];
    NSString* lbntext=[NSString stringWithFormat:@"%d 円", mbalance];
    lbn.text = lbntext;
    [self.scroll addSubview:lbn];

    if(mbalance < 100){
        //お振込まであと
        UILabel *blabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 92, 130, 30)];
        blabel.text = [NSString stringWithFormat:@"あと　　 %d円", 1000-mbalance];
        blabel.font = [UIFont boldSystemFontOfSize:16];
        blabel.textColor = [UIColor darkGrayColor];
        [self.scroll addSubview:blabel];
        //コイン交換まであと
        UILabel *clabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 92, 130, 30)];
        clabel.text = [NSString stringWithFormat:@"あと　　 %d円", 100-mbalance];
        clabel.font = [UIFont boldSystemFontOfSize:16];
        clabel.textColor = [UIColor darkGrayColor];
        [self.scroll addSubview:clabel];
    }else if(mbalance < 1000){
        //お振り込みまであと
        UILabel *blabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 92, 130, 30)];
        blabel.text = [NSString stringWithFormat:@"あと　　 %d円", 1000-mbalance];
        blabel.font = [UIFont boldSystemFontOfSize:16];
        blabel.textColor = [UIColor darkGrayColor];
        [self.scroll addSubview:blabel];
        //コイン交換できます
        cxBtn.hidden = FALSE;
    }else{
        mxBtn.hidden = FALSE;
        cxBtn.hidden = FALSE;
    }

    NSDate *now1 = [NSDate date];
    NSString *now = [NSString stringWithFormat:@"%@", now1];
    int year1 = [[now substringWithRange:NSMakeRange(0, 4)] intValue];
    int month1 = [[now substringWithRange:NSMakeRange(5, 2)] intValue];
    int month2, year2;
    if(month1 == 1){
        month2 = 12;
        year2 = year1 - 1;
    }else{
        month2 = month1 - 1;
        year2 = year1;
    }

    //月の見出し
    UIButton *m1btn = [UIButton buttonWithType:UIButtonTypeCustom];
    m1btn.frame = CGRectMake(10, 186, 300, 45);
    [m1btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryHeader.png"] forState:UIControlStateNormal];
    [m1btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryHeader.png"] forState:UIControlStateHighlighted];
    [m1btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m1btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m1btn setTitle:[NSString stringWithFormat:@"%d 年 %d 月　　合計金額　　", year1, month1]forState:UIControlStateNormal];
    [self.scroll addSubview:m1btn];
    [m1btn addTarget:self action:@selector(m1:) forControlEvents:UIControlEventTouchUpInside];
    //合計コイン
    UILabel *t1label = [[UILabel alloc]initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
    t1label.backgroundColor = [UIColor clearColor];
    t1label.font = [UIFont boldSystemFontOfSize:15];
    t1label.textAlignment = NSTextAlignmentCenter;
    t1label.text = [NSString stringWithFormat:@"%d",mbalance];
    [m1btn addSubview:t1label];
    //プラマイアイコン
    iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
    iv1.image = [UIImage imageNamed:@"iconMinus.png"];
    [m1btn addSubview:iv1];

    //view1
    mv1 = [[UIView alloc]init];
    mv1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:mv1];
    //現金履歴の見出し
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(0, 0, 60, 45);
    dateLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    dateLabel.layer.borderWidth = 1.0;
    dateLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = @"日付";
    [mv1 addSubview:dateLabel];
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.frame = CGRectMake(59, 0, 181.5, 45);
    indexLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    indexLabel.textColor = [UIColor blackColor];
    indexLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    indexLabel.layer.borderWidth = 1.0;
    indexLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = @"項目";
    [mv1 addSubview:indexLabel];
    UILabel *deltaLabel = [[UILabel alloc] init];
    deltaLabel.frame = CGRectMake(239.5, 0, 60.5, 45);
    deltaLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    deltaLabel.textColor = [UIColor blackColor];
    deltaLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    deltaLabel.layer.borderWidth = 1.0;
    deltaLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    deltaLabel.textAlignment = NSTextAlignmentCenter;
    deltaLabel.text = @"変化量";
    [mv1 addSubview:deltaLabel];

    //履歴はりまくる
    for(int i=0 ; i<[hres count] ; i++){
        NSArray *moneyinfo = [hres objectAtIndex:i];
        NSString *delta = [moneyinfo valueForKeyPath:@"delta"];
        int gorc = [[moneyinfo valueForKeyPath:@"g_or_c"] intValue];
        NSString *addtime = [moneyinfo valueForKeyPath:@"add_time"];
        int month = [[addtime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[addtime substringWithRange:NSMakeRange(8, 2)] intValue];
        NSString *when = [NSString stringWithFormat:@"%d/%d", month, date];

        if(month != month1){
            mj = i;
            break;
        }else if(i == [hres count]-1){
            mj = i+1;
        }

        UIButton *mhButton = [[UIButton alloc] init];
        mhButton.frame = CGRectMake(0, 44+44*i, 300, 45);
        [mhButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        mhButton.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        mhButton.layer.borderWidth = 1.0;
        if(i % 2){
            mhButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        }else{
            mhButton.backgroundColor = [UIColor whiteColor];
        }
        NSString *reason;
        if(gorc == 1){
            delta = [NSString stringWithFormat:@"-%@",delta];
            int creason = [[moneyinfo valueForKeyPath:@"consume_reason"] intValue];
            if(creason == 1){
                reason = @"コインと交換";
            }else if(creason == 2){
                reason = @"　お振込　　";
            }else{
                reason = @"　品物削除　";
            }
        }else{
            int greason = [[moneyinfo valueForKeyPath:@"gain_reason"] intValue];
            if(greason == 1){
                reason = @"　　出品　　";
            }
        }
        NSString *mhtext = reason;
        [mhButton setTitle:mhtext forState:UIControlStateNormal];
        [mv1 addSubview:mhButton];

        //日付
        UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
        tlabel.text = when;
        tlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        tlabel.layer.borderWidth = 1.0;
        tlabel.backgroundColor = [UIColor clearColor];
        tlabel.textAlignment = NSTextAlignmentCenter;
        [mhButton addSubview:tlabel];
        //変化量
        UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
        if(gorc == 1){
            dlabel.textColor = [UIColor colorWithRed:1.0 green:0.1 blue:0.0 alpha:1.0];
        }else{
            dlabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        }
        dlabel.text = delta;
        dlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        dlabel.layer.borderWidth = 1.0;
        dlabel.backgroundColor = [UIColor clearColor];
        dlabel.textAlignment = NSTextAlignmentCenter;
        [mhButton addSubview:dlabel];

        [self.scroll setScrollEnabled:YES];
        //[self.scroll setContentSize:CGSizeMake(320, 221+44*i)];
        mv1.frame = CGRectMake(10, 230, 300, 89+44*i);
    }

    if(mj == 0){
        mv1.frame = CGRectMake(10, 230, 300, 89+44);
        UILabel *nhlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 300, 45)];
        nhlabel.text = @"履歴はありません";
        nhlabel.textAlignment = NSTextAlignmentCenter;
        nhlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        nhlabel.layer.borderWidth = 1.0;
        [mv1 addSubview:nhlabel];
        mj = 1;
    }
    [self draw2:month2 year:(year2)];
}

- (void)draw2:(int)month year:(int)year{
    //２月め
    int month3, year3;
    if(month == 1){
        month3 = 12;
        year3 = year - 1;
    }else{
        month3 = month - 1;
        year3 = year;
    }
    //月の見出し
    NSLog(@"mj = %d", mj);
    m2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    m2Btn.frame = CGRectMake(10, 274+44*mj, 300, 45);
    NSLog(@"m2 = %d", 274+44*mj);
    m2Btn.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    m2Btn.layer.borderWidth = 1.0;
    [m2Btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0]];
    [m2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m2Btn setTitle:[NSString stringWithFormat:@"%d 年 %d 月　　合計金額　　", year, month]forState:UIControlStateNormal];
    [self.scroll addSubview:m2Btn];
    [m2Btn addTarget:self action:@selector(m2:) forControlEvents:UIControlEventTouchUpInside];
    //プラマイアイコン
    iv2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
    iv2.image = [UIImage imageNamed:@"iconPlus.png"];
    [m2Btn addSubview:iv2];
    //合計コイン
    UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
    dlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    dlabel.layer.borderWidth = 1.0;
    dlabel.font = [UIFont boldSystemFontOfSize:15];
    dlabel.backgroundColor = [UIColor clearColor];
    dlabel.textAlignment = NSTextAlignmentCenter;
    [m2Btn addSubview:dlabel];

    //view2
    mv2 = [[UIView alloc]init];
    mv2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:mv2];
    //現金履歴の見出し
    UILabel *date2Label = [[UILabel alloc] init];
    date2Label.frame = CGRectMake(0, 0, 60, 45);
    date2Label.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    date2Label.textColor = [UIColor blackColor];
    date2Label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    date2Label.layer.borderWidth = 1.0;
    date2Label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    date2Label.textAlignment = NSTextAlignmentCenter;
    date2Label.text = @"日付";
    [mv2 addSubview:date2Label];
    UILabel *index2Label = [[UILabel alloc] init];
    index2Label.frame = CGRectMake(59, 0, 181.5, 45);
    index2Label.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    index2Label.textColor = [UIColor blackColor];
    index2Label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    index2Label.layer.borderWidth = 1.0;
    index2Label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    index2Label.textAlignment = NSTextAlignmentCenter;
    index2Label.text = @"項目";
    [mv2 addSubview:index2Label];
    UILabel *delta2Label = [[UILabel alloc] init];
    delta2Label.frame = CGRectMake(239.5, 0, 60.5, 45);
    delta2Label.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    delta2Label.textColor = [UIColor blackColor];
    delta2Label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    delta2Label.layer.borderWidth = 1.0;
    delta2Label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    delta2Label.textAlignment = NSTextAlignmentCenter;
    delta2Label.text = @"変化量";
    [mv2 addSubview:delta2Label];

    //履歴はりまくる
    for(int i=mj ; i<[hres count] ; i++){
        mt = i-mj;
        NSArray *moneyinfo = [hres objectAtIndex:i];
        NSString *delta = [moneyinfo valueForKeyPath:@"delta"];
        int gorc = [[moneyinfo valueForKeyPath:@"g_or_c"] intValue];
        NSString *addtime = [moneyinfo valueForKeyPath:@"add_time"];
        int monthh = [[addtime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[addtime substringWithRange:NSMakeRange(8, 2)] intValue];
        NSString *when = [NSString stringWithFormat:@"%d/%d", month, date];
        if(i == mj){
            dlabel.text = [moneyinfo valueForKeyPath:@"total"];
        }

        if(monthh != month){
            mj2 = mt;
            break;
        }else if(i == [hres count]-1){
            mj2 = mt+1;
        }

        UIButton *mhButton = [[UIButton alloc] init];
        mhButton.frame = CGRectMake(0, 44+44*mt, 300, 45);
        [mhButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        mhButton.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        mhButton.layer.borderWidth = 1.0;
        if(i % 2){
            mhButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        }else{
            mhButton.backgroundColor = [UIColor whiteColor];
        }
        NSString *reason;
        if(gorc == 1){
            delta = [NSString stringWithFormat:@"-%@",delta];
            int creason = [[moneyinfo valueForKeyPath:@"consume_reason"] intValue];
            if(creason == 1){
                reason = @"コインと交換";
            }else if(creason == 2){
                reason = @"　お振込　　";
            }else{
                reason = @"　品物削除　";
            }
        }else{
            int greason = [[moneyinfo valueForKeyPath:@"gain_reason"] intValue];
            if(greason == 1){
                reason = @"　　出品　　";
            }
        }
        NSString *mhtext = reason;
        [mhButton setTitle:mhtext forState:UIControlStateNormal];
        [mv2 addSubview:mhButton];

        //日付
        UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
        tlabel.text = when;
        tlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        tlabel.layer.borderWidth = 1.0;
        tlabel.backgroundColor = [UIColor clearColor];
        tlabel.textAlignment = NSTextAlignmentCenter;
        [mhButton addSubview:tlabel];
        //変化量
        UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
        dlabel.text = delta;
        if(gorc == 1){
            dlabel.textColor = [UIColor colorWithRed:1.0 green:0.1 blue:0.0 alpha:1.0];
        }else{
            dlabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        }
        dlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        dlabel.layer.borderWidth = 1.0;
        dlabel.backgroundColor = [UIColor clearColor];
        dlabel.textAlignment = NSTextAlignmentCenter;
        [mhButton addSubview:dlabel];
        
        //[self.scroll setScrollEnabled:YES];
        //[self.scroll setContentSize:CGSizeMake(320, 500+44*cj)];
        mv2.frame = CGRectMake(10, 318+44*mj, 300, 89+44*mt);
    }
    if(mj2 == 0){
        mt = 0;
        UILabel *nhlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 300, 45)];
        nhlabel.text = @"履歴はありません";
        nhlabel.textAlignment = NSTextAlignmentCenter;
        nhlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        nhlabel.layer.borderWidth = 1.0;
        [mv2 addSubview:nhlabel];
        mv2.frame = CGRectMake(10, 318+44*mj, 300, 89+44*mt);
        mj2 = 1;
        dlabel.text = @"0";
    }else{
        //ct = ct + 1;
        mj2 = mt + 1;
    }
    mv2.hidden = TRUE;
    [self draw3:month3 year:(year3)];
}

- (void)draw3:(int)month year:(int)year{
    //３月め
    //月の見出し
    m3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    m3Btn.frame = CGRectMake(10, 318+44*mj, 300, 45);
    m3Btn.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    [m3Btn setBackgroundColor:[UIColor clearColor]];
    [m3Btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateNormal];
    [m3Btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateHighlighted];
    [m3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m3Btn setTitle:[NSString stringWithFormat:@"%d 年 %d 月　　合計金額　　", year, month]forState:UIControlStateNormal];
    [self.scroll addSubview:m3Btn];
    [m3Btn addTarget:self action:@selector(m3:) forControlEvents:UIControlEventTouchUpInside];
    //プラマイアイコン
    iv3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
    iv3.image = [UIImage imageNamed:@"iconPlus.png"];
    [m3Btn addSubview:iv3];
    //合計コイン
    d3label = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
    d3label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    d3label.layer.borderWidth = 0.0;
    d3label.font = [UIFont boldSystemFontOfSize:15];
    d3label.backgroundColor = [UIColor clearColor];
    d3label.textAlignment = NSTextAlignmentCenter;
    [m3Btn addSubview:d3label];
    
    //view2
    mv3 = [[UIView alloc]init];
    mv3.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:mv3];
    //現金履歴の見出し
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(0, 0, 60, 45);
    dateLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    dateLabel.layer.borderWidth = 1.0;
    dateLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = @"日付";
    [mv3 addSubview:dateLabel];
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.frame = CGRectMake(59, 0, 181.5, 45);
    indexLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    indexLabel.textColor = [UIColor blackColor];
    indexLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    indexLabel.layer.borderWidth = 1.0;
    indexLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = @"項目";
    [mv3 addSubview:indexLabel];
    UILabel *deltaLabel = [[UILabel alloc] init];
    deltaLabel.frame = CGRectMake(239.5, 0, 60.5, 45);
    deltaLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    deltaLabel.textColor = [UIColor blackColor];
    deltaLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    deltaLabel.layer.borderWidth = 1.0;
    deltaLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    deltaLabel.textAlignment = NSTextAlignmentCenter;
    deltaLabel.text = @"変化量";
    [mv3 addSubview:deltaLabel];
    
    //履歴はりまくる
    for(int i=mj2 ; i<[hres count] ; i++){
        mt2 = i-mj2;
        NSArray *moneyinfo = [hres objectAtIndex:i];
        NSString *delta = [moneyinfo valueForKeyPath:@"delta"];
        int gorc = [[moneyinfo valueForKeyPath:@"g_or_c"] intValue];
        NSString *addtime = [moneyinfo valueForKeyPath:@"add_time"];
        int monthh = [[addtime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[addtime substringWithRange:NSMakeRange(8, 2)] intValue];
        NSString *when = [NSString stringWithFormat:@"%d/%d", monthh, date];
        if(i == mj2){
            NSLog(@"mj2 = %d, moneyinfo = %@", mj2, moneyinfo);
            d3label.text = [moneyinfo valueForKeyPath:@"total"];
        }

        if(mj2 == [hres count]){
            NSLog(@"yes");
        }

        if(monthh != month){
            break;
        }

        UIButton *mhButton = [[UIButton alloc] init];
        mhButton.frame = CGRectMake(0, 44+44*mt2, 300, 45);
        [mhButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        mhButton.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        mhButton.layer.borderWidth = 1.0;
        if(i % 2){
            mhButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        }else{
            mhButton.backgroundColor = [UIColor whiteColor];
        }
        NSString *reason;
        if(gorc == 1){
            delta = [NSString stringWithFormat:@"-%@",delta];
            int creason = [[moneyinfo valueForKeyPath:@"consume_reason"] intValue];
            if(creason == 1){
                reason = @"コインと交換";
            }else if(creason == 2){
                reason = @"　お振込　　";
            }else{
                reason = @"　品物削除　";
            }
        }else{
            int greason = [[moneyinfo valueForKeyPath:@"gain_reason"] intValue];
            if(greason == 1){
                reason = @"　　出品　　";
            }
        }
        NSString *mhtext = reason;
        [mhButton setTitle:mhtext forState:UIControlStateNormal];
        [mv3 addSubview:mhButton];

        //日付
        UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
        tlabel.text = when;
        tlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        tlabel.layer.borderWidth = 1.0;
        tlabel.backgroundColor = [UIColor clearColor];
        tlabel.textAlignment = NSTextAlignmentCenter;
        [mhButton addSubview:tlabel];
        //変化量
        UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
        dlabel.text = delta;
        if(gorc == 1){
            dlabel.textColor = [UIColor colorWithRed:1.0 green:0.1 blue:0.0 alpha:1.0];
        }else{
            dlabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        }
        dlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        dlabel.layer.borderWidth = 1.0;
        dlabel.backgroundColor = [UIColor clearColor];
        dlabel.textAlignment = NSTextAlignmentCenter;
        [mhButton addSubview:dlabel];

        //[self.scroll setScrollEnabled:YES];
        //[self.scroll setContentSize:CGSizeMake(320, 500+44*cj)];
        mv3.frame = CGRectMake(10, 362+44*mj, 300, 89+44*mt2);
    }
    if(mt2 == 0){
        UILabel *nhlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 300, 45)];
        nhlabel.text = @"履歴はありません";
        nhlabel.textAlignment = NSTextAlignmentCenter;
        nhlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        nhlabel.layer.borderWidth = 1.0;
        [mv3 addSubview:nhlabel];
        mv3.frame = CGRectMake(10, 362+44*mj, 300, 89+44*mt2);
        d3label.text = @"0";
    }
    mv3.hidden = TRUE;
    [self.scroll setContentSize:CGSizeMake(320, 410+44*mj)];
}

- (void)cxpop:(id)sender{
    cxpop.hidden = FALSE;
}

- (void)popx:(id)sender{
    cxpop.hidden = TRUE;
}

- (void)cx:(id)sender{
    cxpop.hidden = TRUE;
    [self connectc];
}

- (void)mx:(id)sender{
    JOBankViewController *bank = [self.storyboard instantiateViewControllerWithIdentifier:@"bank"];
    //bank.mbalance = [NSString stringWithFormat:@"%d", mbalance];
    [self presentViewController:bank animated:YES completion:nil];
}

- (void)m1:(id)sender{
    if(m1 == 1){
        mv1.hidden = TRUE;
        m1 = 0;
        iv1.image = [UIImage imageNamed:@"iconPlus.png"];
        m2Btn.frame = CGRectMake(10, 230, 300, 45);
        mv2.frame = CGRectMake(10, 274, 300, 89+44*mt);
        if(m2 == 0){
            m3Btn.frame = CGRectMake(10, 274, 300, 45);
            mv3.frame = CGRectMake(10, 318, 300, 89+44*mt2);
            NSLog(@"11");
        }else{
            m3Btn.frame = CGRectMake(10, 318+44*mj2, 300, 45);
            mv3.frame = CGRectMake(10, 362+44*mj2, 300, 89+44*mt2);
            NSLog(@"22");
        }
    }else{
        mv1.hidden = FALSE;
        m1 = 1;
        iv1.image = [UIImage imageNamed:@"iconMinus.png"];
        m2Btn.frame = CGRectMake(10, 274+44*mj, 300, 45);
        mv2.frame = CGRectMake(10, 318+44*mj, 300, 89+44*mt);
        if(m2 == 0){
            m3Btn.frame = CGRectMake(10, 318+44*mj, 300, 45);
            mv3.frame = CGRectMake(10, 362+44*mj, 300, 89+44*mt2);
            NSLog(@"33");
        }else{
            m3Btn.frame = CGRectMake(10, 362+44*mj2+44*mj, 300, 45);
            mv3.frame = CGRectMake(10, 406+44*mj2+44*mj, 300, 89+44*mt2);
            NSLog(@"44");
        }
    }
    if(m3 == 0){
        [self.scroll setContentSize:CGSizeMake(320, mv3.frame.origin.y +10)];
    }else{
        [self.scroll setContentSize:CGSizeMake(320, mv3.frame.origin.y + mv3.bounds.size.height +10)];
    }
}

- (void)m2:(id)sender{
    if(m2 == 1){
        mv2.hidden = TRUE;
        m2 = 0;
        iv2.image = [UIImage imageNamed:@"iconPlus.png"];
        if(m1 == 0){
            m3Btn.frame = CGRectMake(10, 274, 300, 45);
            mv3.frame = CGRectMake(10, 318, 300, 89+44*mt2);
            NSLog(@"1111");
        }else{
            m3Btn.frame = CGRectMake(10, 318+44*mj, 300, 45);
            mv3.frame = CGRectMake(10, 362+44*mj, 300, 89+44*mt2);
            NSLog(@"2222");
        }
    }else{
        mv2.hidden = FALSE;
        m2 = 1;
        iv2.image = [UIImage imageNamed:@"iconMinus.png"];
        if(m1 == 0){
            m3Btn.frame = CGRectMake(10, 318+44*mj2, 300, 45);
            mv3.frame = CGRectMake(10, 362+44*mj2, 300, 89+44*mt2);
            NSLog(@"3333 cj2 = %d", mj2);
        }else{
            m3Btn.frame = CGRectMake(10, 362+44*mj2+44*mj, 300, 45);
            mv3.frame = CGRectMake(10, 406+44*mj2+44*mj, 300, 89+44*mt2);
            NSLog(@"4444 cj2 = %d", mj2);
        }
    }
    if(m3 == 0){
        [self.scroll setContentSize:CGSizeMake(320, mv3.frame.origin.y +10)];
    }else{
        [self.scroll setContentSize:CGSizeMake(320, mv3.frame.origin.y + mv3.bounds.size.height +10)];
    }
}

- (void)m3:(id)sender{
    if(m3 == 1){
        mv3.hidden = TRUE;
        m3 = 0;
        iv3.image = [UIImage imageNamed:@"iconPlus.png"];
        m3Btn.layer.borderWidth = 0.0;
        [m3Btn setBackgroundColor:[UIColor clearColor]];
        [m3Btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateNormal];
        [m3Btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateHighlighted];
        d3label.layer.borderWidth = 0.0;
        [self.scroll setContentSize:CGSizeMake(320, mv3.frame.origin.y +10)];
    }else{
        mv3.hidden = FALSE;
        m3 = 1;
        [m3Btn setBackgroundImage:nil forState:UIControlStateNormal];
        d3label.layer.borderWidth = 1.0;
        iv3.image = [UIImage imageNamed:@"iconMinus.png"];
        m3Btn.layer.borderWidth = 1.0;
        [m3Btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0]];
        [self.scroll setContentSize:CGSizeMake(320, mv3.frame.origin.y + mv3.bounds.size.height +10)];
    }
}

- (void)update:(UIBarButtonItem*)sender {
    mnreload = 0;
    //viewリフレッシュ
    for (UIView *subview in [self.scroll subviews]) {
        if(subview.tag > 3){
            [subview removeFromSuperview];
        }
    }
    [self getmhistory];
    // 通知を作成する
    NSNotification *n = [NSNotification notificationWithName:@"myupdated" object:self];
    // 通知実行！
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)connectc {
    connect = 1;
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&service=reader", myid];
    NSURL *url = [NSURL URLWithString:URL_COIN_EXCHANGE];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
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
