//
//  JOSearchViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOSearchViewController.h"

@interface JOSearchViewController ()

@end

@implementation JOSearchViewController

UITextField *searchtf;
NSArray *res;

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

    self.navigationItem.title = @"検索";

    //バー
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 63)];
    UIImage *bar = [UIImage imageNamed:@"formBack.png"];
    barView.backgroundColor = [UIColor colorWithPatternImage:bar];
    [self.view addSubview:barView];
    barView.tag = 1;

    //入力欄背景
    UIImageView *searchbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input.png"]];
    searchbg.frame = CGRectMake(10, 25, 245, 33);
    [barView addSubview:searchbg];
    //むしめがね
    UIImageView *magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnifier.png"]];
    magnifier.frame = CGRectMake(10, 10, 14, 14);
    [searchbg addSubview:magnifier];
    //キーワード入力欄
    searchtf = [[UITextField alloc] initWithFrame:CGRectMake(40, 30, 245, 50)];
    searchtf.borderStyle = UITextBorderStyleNone;
    searchtf.placeholder = @"検索キーワード";
    [barView addSubview:searchtf];
    searchtf.delegate = self;

    //検索ボタン
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(262, 25, 48, 33);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"btnSearch.png"] forState:UIControlStateNormal];
    [barView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
}



//検索
- (void)search:(id)sender
{
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int myid = [[ud stringForKey:@"userid"] intValue];

    if(searchtf.text.length > 0){
        [searchtf resignFirstResponder];
        NSString *dataa = [NSString stringWithFormat:@"user_id=%d&stitle=%@", myid, [searchtf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:URL_ITEM_SEARCH];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        for (UIView *subview in [self.scroll subviews]) {
            if(subview.tag != 1){
                [subview removeFromSuperview];
            }
        }
        res = response;
        [self draw];
    }
}

//描画
- (void)draw{
    if([res count] == 0){
        UILabel *niLabel = [[UILabel alloc] init];
        niLabel.frame = CGRectMake(10, 120, 300, 50);
        niLabel.text = @"該当する品物はありません";
        niLabel.backgroundColor = [UIColor clearColor];
        niLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        niLabel.textAlignment = NSTextAlignmentCenter;
        [self.scroll addSubview:niLabel];
    }else{
        int i;
        for(i=0 ; i<[res count] ; i++){

            NSString *iteminfo = [res objectAtIndex:i];
            int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
            NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
            int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
            int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
            NSLog(@"start");

            //ボタンの枠
            UIView *fv = [[UIView alloc] init];
            fv.frame = CGRectMake(5+(fmod(i,2)*157), 172*((i-(fmod(i,2)))/2)+50, 152, 167);
            fv.backgroundColor = [UIColor whiteColor];
            fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            fv.layer.borderWidth = 1.0;
            fv.layer.cornerRadius = 5;
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
			//if(userid != myid){
				[itembtn addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
			//}
        }
        [self.scroll setScrollEnabled:YES];
        [self.scroll setContentSize:CGSizeMake(320, 172*((i-(fmod(i,3)))/3)+170)];
    }
}

- (void)itembtn:(UIButton*)sender{
    /*NSString *iteminfo = [res objectAtIndex:sender.tag];
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = [iteminfo valueForKeyPath:@"item_id"];
    send.photo = [iteminfo valueForKeyPath:@"photo1"];
    send.user = [iteminfo valueForKeyPath:@"user_id"];
    send.seller = @"1";
    [self.navigationController pushViewController:send animated:YES];*/
    NSDictionary *iteminfo = [res objectAtIndex:sender.tag];
    JODetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.item = [iteminfo valueForKeyPath:@"item_id"];
    detail.itemdata = iteminfo;
    [self.navigationController pushViewController:detail animated:YES];
}

//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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