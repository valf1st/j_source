//
//  JONearViewController.m
//  Joton
//
//  Created by Val F on 13/04/09.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JONearViewController.h"

@interface JONearViewController ()

@end

@implementation JONearViewController

UILabel *kmLabel;
NSArray *range, *nres;
int r, myid, reload;
UIButton *narrowBtn, *broadenBtn;

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

    self.navigationItem.title = @"近くの商品";

    reload = 0;
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    //バー
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, -440, 320, 480)];
    UIImage *bar = [UIImage imageNamed:@"subNavBack.png"];
    barView.backgroundColor = [UIColor colorWithPatternImage:bar];
    [self.view addSubview:barView];
    r = 1;
    range = [[NSArray alloc] initWithObjects: @"5", @"10", @"20", nil];
    //kmラベル
    kmLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 445, 140, 32)];
    kmLabel.backgroundColor = [UIColor whiteColor];
    kmLabel.font = [UIFont boldSystemFontOfSize:15];
    kmLabel.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
    kmLabel.layer.borderWidth = 1.0;
    kmLabel.layer.cornerRadius = 5;
    NSString *ltext = [NSString stringWithFormat:@"%@km以内",[range objectAtIndex:r]];
    kmLabel.text = ltext;
    kmLabel.textAlignment = NSTextAlignmentCenter;
    [barView addSubview:kmLabel];

    //狭くするボタン
    narrowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    narrowBtn.frame = CGRectMake(20, 440, 60, 45);
    [narrowBtn setBackgroundImage:[UIImage imageNamed:@"btnMinus.png"] forState:UIControlStateNormal];
    [barView addSubview:narrowBtn];
    [narrowBtn addTarget:self action:@selector(narrow:) forControlEvents:UIControlEventTouchUpInside];

    //広くするボタン
    broadenBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    broadenBtn.frame = CGRectMake(242, 439.5, 60, 45);
    [broadenBtn setBackgroundImage:[UIImage imageNamed:@"btnPlus.png"] forState:UIControlStateNormal];
    [barView addSubview:broadenBtn];
    [broadenBtn addTarget:self action:@selector(broaden:) forControlEvents:UIControlEventTouchUpInside];
}

//現在地取得
- (void)viewDidAppear:(BOOL)animated {
    if(reload == 0){
        [self where];
        reload = 1;
    }
}
- (void)where{
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [lm startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    lon = newLocation.coordinate.longitude;
    lat = newLocation.coordinate.latitude;
    [lm stopUpdatingLocation];

   /* UILabel *lonlat = [[UILabel alloc] init];
    lonlat.frame = CGRectMake(30, 0, 250, 20);
    lonlat.backgroundColor = [UIColor clearColor];
    lonlat.font = [UIFont systemFontOfSize:12];
    lonlat.text = [NSString stringWithFormat:@"longitude = %f, latitude = %f", lon, lat];
    [self.view addSubview:lonlat];*/

    [self connect:[range objectAtIndex:r]];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == 1){
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"プライバシー設定" message:@"位置情報を取得できませんでした。設定よりプライバシー設定を変更してください。" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"オフラインです" message:@"位置情報を取得できませんでした" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            [self.navigationController popViewControllerAnimated:YES];
            break;
        /*case 1:
            [self asyncConnect:req];
            break;*/
    }
}

//狭くするボタン
- (void)narrow:(id)sender{
    if(r > 0){
        [self where];
        broadenBtn.enabled = YES;
        kmLabel.text = [NSString stringWithFormat:@"%@km以内", [range objectAtIndex:r-1]];
        if(!(lat == 0 && lon == 0)){
            //通信
            [self connect:[range objectAtIndex:r-1]];
        }
        r = r-1;
        if(r == 0){
            narrowBtn.enabled = NO;
        }
    }
}

//広くするボタン
- (void)broaden:(id)sender{
    if(r < 2){
        [self where];
        narrowBtn.enabled = YES;
        kmLabel.text = [NSString stringWithFormat:@"%@km以内", [range objectAtIndex:r+1]];

        if(!(lat == 0 && lon == 0)){
            //通信
            [self connect:[range objectAtIndex:r+1]];
        }
        r = r+1;
        if(r == 2){
            broadenBtn.enabled = NO;
        }
    }
}

//通信
- (void)connect:(NSString *)radius{
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&longitude=%f&latitude=%f&radius=%@", myid, lon, lat, radius];
    NSLog(@"dataa = %@", dataa);
    NSURL *url = [NSURL URLWithString:URL_ITEM_NEAR];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}
- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        for (UIView *subview in [self.scroll subviews]) {
            //if(subview.tag != 1){
                [subview removeFromSuperview];
            //}
        }
        nres = response;
        [self draw];
    }
}

//描画
- (void)draw{
    if([nres count] == 0){
        UILabel *niLabel = [[UILabel alloc] init];
        niLabel.frame = CGRectMake(10, 120, 300, 50);
        niLabel.text = @"該当する品物はありません";
        niLabel.backgroundColor = [UIColor clearColor];
        niLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        niLabel.textAlignment = NSTextAlignmentCenter;
        [self.scroll addSubview:niLabel];
    }else{
        int i;
        for(i=0 ; i<[nres count] ; i++){

            NSString *iteminfo = [nres objectAtIndex:i];
            int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
            NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
            int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
            int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
            int price = [[iteminfo valueForKeyPath:@"price"] intValue];
            NSLog(@"start");

            //ボタンの枠
            UIView *fv = [[UIView alloc] init];
            fv.frame = CGRectMake(5+(fmod(i,2)*157), 172*((i-(fmod(i,2)))/2)+7, 152, 167);
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
        [_scroll setScrollEnabled:YES];
        [_scroll setContentSize:CGSizeMake(320, 172*((i+1-(fmod(i+1,2)))/2)+120)];
    }
}

- (void)itembtn:(UIButton*)sender{
    /*NSString *iteminfo = [nres objectAtIndex:sender.tag];
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = [iteminfo valueForKeyPath:@"item_id"];
    send.photo = [iteminfo valueForKeyPath:@"photo1"];
    send.user = [iteminfo valueForKeyPath:@"user_id"];
    send.seller = @"1";
    [self.navigationController pushViewController:send animated:YES];*/
    NSDictionary *iteminfo = [nres objectAtIndex:sender.tag];
    JOSendViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.item = [iteminfo valueForKeyPath:@"item_id"];
    detail.itemdata = iteminfo;
    [self.navigationController pushViewController:detail animated:YES];
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
