//
//  JOCoinViewController.m
//  Joton
//
//  Created by Val F on 13/04/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOCoinViewController.h"

@interface JOCoinViewController ()

@end

@implementation JOCoinViewController

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

    self.navigationItem.title = @"コイン履歴";

    //ユーザーデフォルトからid取得
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    m1 = 1; m2 = 0; m3 = 0; cj = 0; cj2 = 0; reloadc = 0;
    //枠
    UIView *fv = [[UIView alloc] init];
    fv.frame = CGRectMake(10, 10, 300, 61);
    fv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSumCoin.png"]];
    [self.scroll addSubview:fv];
    //見出し
    UILabel *iLabel = [[UILabel alloc] init];
    iLabel.frame = CGRectMake(0, 5, 300, 20);
    iLabel.backgroundColor = [UIColor clearColor];
    iLabel.textColor = [UIColor grayColor];
    iLabel.font = [UIFont systemFontOfSize:12];
    iLabel.text = @"　使用可能コイン数";
    [fv addSubview:iLabel];
}

- (void)viewDidAppear:(BOOL)animated{
    if(reloadc == 0){
        [self getchistory];
        reloadc = 1;
    }
}

- (void)getchistory{
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&service=reader", myid];
    NSURL *url = [NSURL URLWithString:URL_USER_COIN];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        cres = response;
        [self draw];
    }
}

//描画
- (void)draw{
    //if(result != FALSE){
    int cbalance;

    if([cres count] == 0){
        cbalance = 0;
    }else{
        //NSArray *newest = [cres objectAtIndex:0];
        //cbalance = [[newest valueForKeyPath:@"total"] intValue];
        cbalance = [[cres valueForKeyPath:@"available"] intValue];
    }

    //上の枠内コイン数
    UILabel *lbn = [[UILabel alloc] init];
    lbn.frame = CGRectMake(130, 40, 100, 20);
    //lbn.backgroundColor = [UIColor clearColor];
    lbn.textColor = [UIColor darkGrayColor];
    lbn.font = [UIFont boldSystemFontOfSize:18];
    NSString* lbntext=[NSString stringWithFormat:@"%d コイン", cbalance];
    lbn.text = lbntext;
    [self.scroll addSubview:lbn];

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
    m1btn.frame = CGRectMake(10, 86, 300, 45);
    [m1btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryHeader.png"] forState:UIControlStateNormal];
    [m1btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryHeader.png"] forState:UIControlStateHighlighted];
    [m1btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m1btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m1btn setTitle:[NSString stringWithFormat:@"%d 年 %d 月　　合計コイン　　", year1, month1]forState:UIControlStateNormal];
    [self.scroll addSubview:m1btn];
    [m1btn addTarget:self action:@selector(m1:) forControlEvents:UIControlEventTouchUpInside];
    //合計コイン
    UILabel *t1label = [[UILabel alloc]initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
    t1label.backgroundColor = [UIColor clearColor];
    t1label.font = [UIFont boldSystemFontOfSize:15];
    t1label.textAlignment = NSTextAlignmentCenter;
    t1label.text = [NSString stringWithFormat:@"%d",cbalance];
    [m1btn addSubview:t1label];
    //プラマイアイコン
    iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
    iv1.image = [UIImage imageNamed:@"iconMinus.png"];
    [m1btn addSubview:iv1];

    //view1
    cv1 = [[UIView alloc]init];
    cv1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:cv1];
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
    [cv1 addSubview:dateLabel];
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.frame = CGRectMake(59, 0, 181.5, 45);
    indexLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    indexLabel.textColor = [UIColor blackColor];
    indexLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    indexLabel.layer.borderWidth = 1.0;
    indexLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = @"項目";
    [cv1 addSubview:indexLabel];
    UILabel *deltaLabel = [[UILabel alloc] init];
    deltaLabel.frame = CGRectMake(239.5, 0, 60.5, 45);
    deltaLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    deltaLabel.textColor = [UIColor blackColor];
    deltaLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    deltaLabel.layer.borderWidth = 1.0;
    deltaLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    deltaLabel.textAlignment = NSTextAlignmentCenter;
    deltaLabel.text = @"変化量";
    [cv1 addSubview:deltaLabel];

    //履歴はりまくる
    for(int i=0 ; i<[cres count] ; i++){
        NSArray *coininfo = [cres valueForKeyPath:[NSString stringWithFormat:@"%d", i]];
        NSString *delta = [coininfo valueForKeyPath:@"delta"];
        int gorc = [[coininfo valueForKeyPath:@"g_or_c"] intValue];
        NSString *addtime = [coininfo valueForKeyPath:@"add_time"];
        int month = [[addtime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[addtime substringWithRange:NSMakeRange(8, 2)] intValue];
        int settled = [[coininfo valueForKeyPath:@"settled"] intValue];
        NSString *when = [NSString stringWithFormat:@"%d/%d", month, date];

        if(month != month1){
            cj = i;
            break;
        }else if(i == [cres count]-1){
            cj = i;
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
            int creason = [[coininfo valueForKeyPath:@"consume_reason"] intValue];
            if(creason == 1){
                reason = @"品物購入";
                mhButton.tag = [[coininfo valueForKeyPath:@"item_id"]intValue];
            }
        }else{
            int greason = [[coininfo valueForKeyPath:@"gain_reason"] intValue];
            if(greason == 1){
                reason = @"100円と交換";
                mhButton.enabled = NO;
            }else if(greason == 2){
                reason = @"　譲渡　";
                mhButton.enabled = YES;
                mhButton.tag = [[coininfo valueForKeyPath:@"item_id"]intValue];
            }
        }
        if([delta isEqualToString:@"0"] || [delta isEqualToString:@"-0"]){
            delta = @"";
        }
        NSString *mhtext = reason;
        [mhButton setTitle:mhtext forState:UIControlStateNormal];
        [cv1 addSubview:mhButton];
        [mhButton addTarget:self action:@selector(item:) forControlEvents:UIControlEventTouchUpInside];
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
        if(settled == 0){
            [mhButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else if(settled == 1){
            [mhButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [mhButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 1)];
            bar.backgroundColor = [UIColor lightGrayColor];
            [mhButton addSubview:bar];
        }
        [mhButton addSubview:dlabel];

        [self.scroll setScrollEnabled:YES];
        //[self.scroll setContentSize:CGSizeMake(320, 221+44*i)];
        cv1.frame = CGRectMake(10, 130, 300, 89+44*i);
    }

    if(cj == 0){
        cv1.frame = CGRectMake(10, 130, 300, 89+44);
        UILabel *nhlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 300, 45)];
        nhlabel.text = @"履歴はありません";
        nhlabel.textAlignment = NSTextAlignmentCenter;
        nhlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        nhlabel.layer.borderWidth = 1.0;
        [cv1 addSubview:nhlabel];
        cj = 1;
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
    NSLog(@"cj = %d", cj);
    m2btn = [UIButton buttonWithType:UIButtonTypeCustom];
    m2btn.frame = CGRectMake(10, 174+44*cj, 300, 45);
    NSLog(@"m2 = %d", 174+44*cj);
    m2btn.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    m2btn.layer.borderWidth = 1.0;
    [m2btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0]];
    [m2btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m2btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m2btn setTitle:[NSString stringWithFormat:@"%d 年 %d 月　　合計コイン　　", year, month]forState:UIControlStateNormal];
    [self.scroll addSubview:m2btn];
    [m2btn addTarget:self action:@selector(m2:) forControlEvents:UIControlEventTouchUpInside];
    //プラマイアイコン
    iv2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
    iv2.image = [UIImage imageNamed:@"iconPlus.png"];
    [m2btn addSubview:iv2];
    //合計コイン
    UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
    dlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    dlabel.layer.borderWidth = 1.0;
    dlabel.font = [UIFont boldSystemFontOfSize:15];
    dlabel.backgroundColor = [UIColor clearColor];
    dlabel.textAlignment = NSTextAlignmentCenter;
    [m2btn addSubview:dlabel];

    //view2
    cv2 = [[UIView alloc]init];
    cv2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:cv2];
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
    [cv2 addSubview:date2Label];
    UILabel *index2Label = [[UILabel alloc] init];
    index2Label.frame = CGRectMake(59, 0, 181.5, 45);
    index2Label.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    index2Label.textColor = [UIColor blackColor];
    index2Label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    index2Label.layer.borderWidth = 1.0;
    index2Label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    index2Label.textAlignment = NSTextAlignmentCenter;
    index2Label.text = @"項目";
    [cv2 addSubview:index2Label];
    UILabel *delta2Label = [[UILabel alloc] init];
    delta2Label.frame = CGRectMake(239.5, 0, 60.5, 45);
    delta2Label.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    delta2Label.textColor = [UIColor blackColor];
    delta2Label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    delta2Label.layer.borderWidth = 1.0;
    delta2Label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    delta2Label.textAlignment = NSTextAlignmentCenter;
    delta2Label.text = @"変化量";
    [cv2 addSubview:delta2Label];

    //履歴はりまくる
    for(int i=cj ; i<[cres count] ; i++){
        ct = i-cj;
        NSArray *coininfo = [cres valueForKeyPath:[NSString stringWithFormat:@"%d", i]];
        NSString *delta = [coininfo valueForKeyPath:@"delta"];
        int gorc = [[coininfo valueForKeyPath:@"g_or_c"] intValue];
        int settled = [[coininfo valueForKeyPath:@"settled"] intValue];
        NSString *addtime = [coininfo valueForKeyPath:@"add_time"];
        int monthh = [[addtime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[addtime substringWithRange:NSMakeRange(8, 2)] intValue];
        NSString *when = [NSString stringWithFormat:@"%d/%d", month, date];
        if(i == cj){
            dlabel.text = [coininfo valueForKeyPath:@"total"];
        }

        if(monthh != month){
            cj2 = ct;
            break;
        }else if(i == [cres count]-1){
            cj2 = ct+1;
        }

        UIButton *mhButton = [[UIButton alloc] init];
        mhButton.frame = CGRectMake(0, 44+44*ct, 300, 45);
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
            int creason = [[coininfo valueForKeyPath:@"consume_reason"] intValue];
            if(creason == 1){
                reason = @"品物購入";
                mhButton.tag = [[coininfo valueForKeyPath:@"item_id"]intValue];
            }
        }else{
            int greason = [[coininfo valueForKeyPath:@"gain_reason"] intValue];
            if(greason == 1){
                reason = @"100円と交換";
                mhButton.enabled = NO;
            }else if(greason == 2){
                reason = @"　譲渡　";
                mhButton.enabled = YES;
                mhButton.tag = [[coininfo valueForKeyPath:@"item_id"]intValue];
            }
        }
        if([delta isEqualToString:@"0"] || [delta isEqualToString:@"-0"]){
            delta = @"";
        }
        NSString *mhtext = reason;
        [mhButton setTitle:mhtext forState:UIControlStateNormal];
        [cv2 addSubview:mhButton];
        [mhButton addTarget:self action:@selector(item:) forControlEvents:UIControlEventTouchUpInside];
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
        if(settled == 0){
            [mhButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else if(settled == 1){
            [mhButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [mhButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 1)];
            bar.backgroundColor = [UIColor lightGrayColor];
            [mhButton addSubview:bar];
        }
        [mhButton addSubview:dlabel];

        //[self.scroll setScrollEnabled:YES];
        //[self.scroll setContentSize:CGSizeMake(320, 500+44*cj)];
        cv2.frame = CGRectMake(10, 218+44*cj, 300, 89+44*ct);
    }
    if(cj2 == 0){
        ct = 0;
        UILabel *nhlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 300, 45)];
        nhlabel.text = @"履歴はありません";
        nhlabel.textAlignment = NSTextAlignmentCenter;
        nhlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        nhlabel.layer.borderWidth = 1.0;
        [cv2 addSubview:nhlabel];
        cv2.frame = CGRectMake(10, 218+44*cj, 300, 89+44*ct);
        cj2 = 1;
        dlabel.text = @"0";
    }else{
        //ct = ct + 1;
        cj2 = ct + 1;
    }
    cv2.hidden = TRUE;
    [self draw3:month3 year:(year3)];
}

- (void)draw3:(int)month year:(int)year{
    //３月め
    //月の見出し
    m3btn = [UIButton buttonWithType:UIButtonTypeCustom];
    m3btn.frame = CGRectMake(10, 218+44*cj, 300, 45);
    m3btn.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    [m3btn setBackgroundColor:[UIColor clearColor]];
    [m3btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateNormal];
    [m3btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateHighlighted];
    [m3btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m3btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m3btn setTitle:[NSString stringWithFormat:@"%d 年 %d 月　　合計コイン　　", year, month]forState:UIControlStateNormal];
    [self.scroll addSubview:m3btn];
    [m3btn addTarget:self action:@selector(m3:) forControlEvents:UIControlEventTouchUpInside];
    //プラマイアイコン
    iv3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
    iv3.image = [UIImage imageNamed:@"iconPlus.png"];
    [m3btn addSubview:iv3];
    //合計コイン
    d3label = [[UILabel alloc] initWithFrame:CGRectMake(239.5, 0, 60.5, 45)];
    d3label.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    d3label.layer.borderWidth = 0.0;
    d3label.font = [UIFont boldSystemFontOfSize:15];
    d3label.backgroundColor = [UIColor clearColor];
    d3label.textAlignment = NSTextAlignmentCenter;
    [m3btn addSubview:d3label];

    //view2
    cv3 = [[UIView alloc]init];
    cv3.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.scroll addSubview:cv3];
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
    [cv3 addSubview:dateLabel];
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.frame = CGRectMake(59, 0, 181.5, 45);
    indexLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    indexLabel.textColor = [UIColor blackColor];
    indexLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    indexLabel.layer.borderWidth = 1.0;
    indexLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = @"項目";
    [cv3 addSubview:indexLabel];
    UILabel *deltaLabel = [[UILabel alloc] init];
    deltaLabel.frame = CGRectMake(239.5, 0, 60.5, 45);
    deltaLabel.backgroundColor = [UIColor colorWithRed:0.988 green:0.949 blue:0.722 alpha:1.0];
    deltaLabel.textColor = [UIColor blackColor];
    deltaLabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
    deltaLabel.layer.borderWidth = 1.0;
    deltaLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    deltaLabel.textAlignment = NSTextAlignmentCenter;
    deltaLabel.text = @"変化量";
    [cv3 addSubview:deltaLabel];

    //履歴はりまくる
    for(int i=cj2 ; i<[cres count] ; i++){
        ct2 = i-cj2;
        NSArray *coininfo = [cres valueForKeyPath:[NSString stringWithFormat:@"%d", i]];
        NSString *delta = [coininfo valueForKeyPath:@"delta"];
        int gorc = [[coininfo valueForKeyPath:@"g_or_c"] intValue];
        int settled = [[coininfo valueForKeyPath:@"settled"] intValue];
        NSString *addtime = [coininfo valueForKeyPath:@"add_time"];
        int monthh = [[addtime substringWithRange:NSMakeRange(5, 2)] intValue];
        int date = [[addtime substringWithRange:NSMakeRange(8, 2)] intValue];
        NSString *when = [NSString stringWithFormat:@"%d/%d", monthh, date];
        if(i == cj2){
            d3label.text = [coininfo valueForKeyPath:@"total"];
        }

        if(cj2 == [cres count]){
            NSLog(@"yes");
        }

        if(monthh != month){
            break;
        }

        UIButton *mhButton = [[UIButton alloc] init];
        mhButton.frame = CGRectMake(0, 44+44*ct2, 300, 45);
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
            int creason = [[coininfo valueForKeyPath:@"consume_reason"] intValue];
            if(creason == 1){
                reason = @"品物購入";
                mhButton.tag = [[coininfo valueForKeyPath:@"item_id"]intValue];
            }
        }else{
            int greason = [[coininfo valueForKeyPath:@"gain_reason"] intValue];
            if(greason == 1){
                reason = @"100円と交換";
                mhButton.enabled = NO;
            }else if(greason == 2){
                reason = @"　譲渡　";
                mhButton.enabled = YES;
                mhButton.tag = [[coininfo valueForKeyPath:@"item_id"]intValue];
            }
        }
        if([delta isEqualToString:@"0"] || [delta isEqualToString:@"-0"]){
            delta = @"";
        }
        NSString *mhtext = reason;
        [mhButton setTitle:mhtext forState:UIControlStateNormal];
        [cv3 addSubview:mhButton];
        [mhButton addTarget:self action:@selector(item:) forControlEvents:UIControlEventTouchUpInside];
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
        if(settled == 0){
            [mhButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else if(settled == 1){
            [mhButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [mhButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 1)];
            bar.backgroundColor = [UIColor lightGrayColor];
            [mhButton addSubview:bar];
        }
        [mhButton addSubview:dlabel];

        //[self.scroll setScrollEnabled:YES];
        //[self.scroll setContentSize:CGSizeMake(320, 500+44*cj)];
        cv3.frame = CGRectMake(10, 262+44*cj, 300, 89+44*ct2);
    }
    if(ct2 == 0){
        UILabel *nhlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 300, 45)];
        nhlabel.text = @"履歴はありません";
        nhlabel.textAlignment = NSTextAlignmentCenter;
        nhlabel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.2 alpha:1.0].CGColor;
        nhlabel.layer.borderWidth = 1.0;
        [cv3 addSubview:nhlabel];
        cv3.frame = CGRectMake(10, 262+44*cj, 300, 89+44*ct2);
        d3label.text = @"0";
    }
    cv3.hidden = TRUE;
    [self.scroll setContentSize:CGSizeMake(320, 310+44*cj)];
}

-(void)item:(UIButton*)sender{
    JODetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.item = [NSString stringWithFormat:@"%d", sender.tag];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)m1:(id)sender{
    if(m1 == 1){
        cv1.hidden = TRUE;
        m1 = 0;
        iv1.image = [UIImage imageNamed:@"iconPlus.png"];
        m2btn.frame = CGRectMake(10, 130, 300, 45);
        cv2.frame = CGRectMake(10, 174, 300, 89+44*ct);
        if(m2 == 0){
            cv1.hidden = TRUE;
            m3btn.frame = CGRectMake(10, 174, 300, 45);
            cv3.frame = CGRectMake(10, 218, 300, 89+44*ct2);
            NSLog(@"11");
        }else{
            m3btn.frame = CGRectMake(10, 218+44*cj2, 300, 45);
            cv3.frame = CGRectMake(10, 262+44*cj2, 300, 89+44*ct2);
            NSLog(@"22");
        }
    }else{
        cv1.hidden = FALSE;
        m1 = 1;
        iv1.image = [UIImage imageNamed:@"iconMinus.png"];
        m2btn.frame = CGRectMake(10, 174+44*cj, 300, 45);
        cv2.frame = CGRectMake(10, 218+44*cj, 300, 89+44*ct);
        if(m2 == 0){
            m3btn.frame = CGRectMake(10, 218+44*cj, 300, 45);
            cv3.frame = CGRectMake(10, 262+44*cj, 300, 89+44*ct2);
            NSLog(@"33");
        }else{
            m3btn.frame = CGRectMake(10, 262+44*cj2+44*cj, 300, 45);
            cv3.frame = CGRectMake(10, 306+44*cj2+44*cj, 300, 89+44*ct2);
            NSLog(@"44");
        }
    }
    if(m3 == 0){
        [self.scroll setContentSize:CGSizeMake(320, cv3.frame.origin.y +10)];
    }else{
        [self.scroll setContentSize:CGSizeMake(320, cv3.frame.origin.y + cv3.bounds.size.height +10)];
    }
}

- (void)m2:(id)sender{
    if(m2 == 1){
        cv2.hidden = TRUE;
        m2 = 0;
        iv2.image = [UIImage imageNamed:@"iconPlus.png"];
        if(m1 == 0){
            m3btn.frame = CGRectMake(10, 174, 300, 45);
            cv3.frame = CGRectMake(10, 218, 300, 89+44*ct2);
            NSLog(@"1111");
        }else{
            m3btn.frame = CGRectMake(10, 218+44*cj, 300, 45);
            cv3.frame = CGRectMake(10, 262+44*cj, 300, 89+44*ct2);
            NSLog(@"2222");
        }
    }else{
        cv2.hidden = FALSE;
        m2 = 1;
        iv2.image = [UIImage imageNamed:@"iconMinus.png"];
        if(m1 == 0){
            m3btn.frame = CGRectMake(10, 218+44*cj2, 300, 45);
            cv3.frame = CGRectMake(10, 262+44*cj2, 300, 89+44*ct2);
            NSLog(@"3333 cj2 = %d", cj2);
        }else{
            m3btn.frame = CGRectMake(10, 262+44*cj2+44*cj, 300, 45);
            cv3.frame = CGRectMake(10, 306+44*cj2+44*cj, 300, 89+44*ct2);
            NSLog(@"4444 cj2 = %d", cj2);
        }
    }
    if(m3 == 0){
        [self.scroll setContentSize:CGSizeMake(320, cv3.frame.origin.y +10)];
    }else{
        [self.scroll setContentSize:CGSizeMake(320, cv3.frame.origin.y + cv3.bounds.size.height +10)];
    }
}

- (void)m3:(id)sender{
    if(m3 == 1){
        cv3.hidden = TRUE;
        m3 = 0;
        iv3.image = [UIImage imageNamed:@"iconPlus.png"];
        m3btn.layer.borderWidth = 0.0;
        [m3btn setBackgroundColor:[UIColor clearColor]];
        [m3btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateNormal];
        [m3btn setBackgroundImage:[UIImage imageNamed:@"bgHistoryFooter.png"] forState:UIControlStateHighlighted];
        d3label.layer.borderWidth = 0.0;
        [self.scroll setContentSize:CGSizeMake(320, cv3.frame.origin.y +10)];
    }else{
        cv3.hidden = FALSE;
        m3 = 1;
        [m3btn setBackgroundImage:nil forState:UIControlStateNormal];
        d3label.layer.borderWidth = 1.0;
        iv3.image = [UIImage imageNamed:@"iconMinus.png"];
        m3btn.layer.borderWidth = 1.0;
        [m3btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0]];
        [self.scroll setContentSize:CGSizeMake(320, cv3.frame.origin.y + cv3.bounds.size.height +10)];
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
