//
//  JOBrowse2ViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOBrowse2ViewController.h"

@interface JOBrowse2ViewController ()

@end

@implementation JOBrowse2ViewController

#define T3 20

NSArray *res3;
UIActivityIndicatorView *aiv;
UIView *barView2;
int load2, myid, sp3, j3, c3, paging3, end3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollUp{
    // 一番上までスクロール
    [self.scroll setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(232, 0, 45, 44);
    [search setBackgroundImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:search];
    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    search.tag = 1;

    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    refresh.frame = CGRectMake(276, 0, 45, 44);
    [refresh setBackgroundImage:[UIImage imageNamed:@"iconRefresh.png"] forState:UIControlStateNormal];
    [[self.navigationController navigationBar] addSubview:refresh];
    [refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    refresh.tag = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    load2 = 0;
    sp3 = 0; end3 = 0;
    j3 = 0; paging3 = 0;
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];

    _scroll.delegate = self;
    _scroll.tag = 1;

    //ナビゲーションバーにボタンを追加
    UIButton *thumb = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 40, 44)];
    [thumb setBackgroundImage:[UIImage imageNamed:@"iconThumb.png"]
                     forState:UIControlStateNormal];
    [thumb addTarget:self action:@selector(thumb:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* thumbbtn = [[UIBarButtonItem alloc] initWithCustomView:thumb];
    self.navigationItem.leftBarButtonItems = @[thumbbtn];

    //ナビゲーションバーにロゴを
    UIImageView *logo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame=CGRectMake(0,0,74,19);
    self.navigationItem.titleView=logo;

    //バー
    barView2 = [[UIView alloc] initWithFrame:CGRectMake(0, -440, 320, 480)];
    UIImage *bar = [UIImage imageNamed:@"subNavBack.png"];
    barView2.backgroundColor = [UIColor colorWithPatternImage:bar];
    [self.scroll addSubview:barView2];
    barView2.tag = 1;

    //近くの商品ボタン
    UIButton *near = [UIButton buttonWithType:UIButtonTypeCustom];
    [near setBackgroundImage:[UIImage imageNamed:@"btnNear.png"] forState:UIControlStateNormal];
    near.frame = CGRectMake(10, 446, 146, 30);
    [barView2 addSubview:near];
    near.tag = 1;
    [near addTarget:self action:@selector(near:) forControlEvents:UIControlEventTouchUpInside];

    //掘り出し物ボタン
    UIButton *bargain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bargain.frame = CGRectMake(163, 446, 146, 30);
    [bargain setBackgroundImage:[UIImage imageNamed:@"btnBargain.png"] forState:UIControlStateNormal];
    [barView2 addSubview:bargain];
    bargain.tag = 1;
    [bargain addTarget:self action:@selector(bargain:) forControlEvents:UIControlEventTouchUpInside];

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(reload:) name:@"submit" object:nil];
    [nc addObserver:self selector:@selector(scrollUp) name:@"scrollUp" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if(load2 == 0 || res3 == nil || [res3 isEqual:[NSNull null]]){
        [self getitems];
        load2 = 1;
    }/*else if(res3){
        [self draw];
    }*/
}

//通信して品物とってくる関数
- (void) getitems {
    NSString *dataa = [NSString stringWithFormat:@"startnumber=%d&totalnumber=%d&user_id=%d", sp3, T3, myid];
    NSURL *url = [NSURL URLWithString:URL_ITEMS];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
    sp3 = sp3+T3;
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if([response count] < T3){
            end3 = 1;
        }
        if([res3 count] == 0){
            res3 = response;
            c3 = 0;
        }else{
            c3 = [res3 count];
            res3 = [res3 arrayByAddingObjectsFromArray:response];
        }
        [self draw];
    }
    [aiv stopAnimating];
    paging3 = 0;
}

//描画する
- (void)draw{
    int i;
    for(i=c3 ; i<[res3 count] ; i++){

        NSString *iteminfo = [res3 objectAtIndex:i];
        int itemid = [[iteminfo valueForKeyPath:@"item_id"] intValue];
        //int userid = [[iteminfo valueForKeyPath:@"user_id"] intValue];
        NSString *photon1 = [iteminfo valueForKeyPath:@"photo1"];
        int p1w = [[iteminfo valueForKeyPath:@"photo1w"] intValue];
        int p1h = [[iteminfo valueForKeyPath:@"photo1h"] intValue];
        int price = [[iteminfo valueForKeyPath:@"price"] intValue];

        //ボタンの枠
        /*UIView *fv = [[UIView alloc] init];
        fv.frame = CGRectMake(10+(fmod(i-c3,3)*102), 103*((i-c3-(fmod(i,3)))/3)+60+j3, 96, 96);
        UIImage *bg = [UIImage imageNamed:@"thumbBack.png"];
        fv.backgroundColor = [UIColor colorWithPatternImage:bg];
        [self.scroll addSubview:fv];*/
        UIView *fv = [[UIView alloc] init];
        fv.frame = CGRectMake(5+(fmod(i-c3,2)*157), 172*((i-c3-(fmod(i,2)))/2)+45+j3, 152, 167);
        fv.backgroundColor = [UIColor whiteColor];
        fv.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        fv.layer.borderWidth = 1.0;
        fv.layer.cornerRadius = 5;
        [self.scroll addSubview:fv];
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
            [ai stopAnimating];
        }];
        itembtn.frame = CGRectMake(4, 72-72*p1h/p1w+4, 144, 144*p1h/p1w);
        [fv addSubview:itembtn];

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

        //どのボタンが押されたか判定するためのタグ
        itembtn.tag = i;
        //if(userid != myid){
        [itembtn addTarget:self action:@selector(itembtn:) forControlEvents:UIControlEventTouchUpInside];
        //}
    }

    [_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(320, 172*((i-c3-(fmod(i,2)))/2)+90+j3)];

    j3 = j3 + 172*((i-c3-(fmod(i,2)))/2);
}

- (void)thumb:(UIBarButtonItem*)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)reload:(UIBarButtonItem*)sender {
    if(paging3 == 0){
        load2 = 0;
        for (UIView *subview in [self.scroll subviews]) {
            if(subview.tag == -100000){
                [subview removeFromSuperview];
            }
        }
        self.scroll.showsVerticalScrollIndicator = YES;//きいてない
        [self.scroll flashScrollIndicators];
        j3 = 0; end3 = 0;
        sp3 = 0;
        [self getitems];
    }
}


- (void)search:(UIBarButtonItem*)sender {
    JOBrowse2ViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)itembtn:(UIButton*)sender{
    NSDictionary *iteminfo = [res3 objectAtIndex:sender.tag];
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

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    float cp = sender.contentOffset.y;
    float lp = sender.contentSize.height;
    float sheight = [[UIScreen mainScreen] bounds].size.height;
    float height = sheight - (20+44+50);
    if(cp > lp-height-20){
        if(paging3 == 0 && end3 == 0){
            aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, lp-30, 17, 17)];
            aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [aiv startAnimating];
            [self.scroll addSubview:aiv];
            [self getitems];
            paging3 = 1;
        }
    }
    if(cp < 0){
        barView2.frame = CGRectMake(0, -440+cp, 320, 480);
    }
}

- (void)more:(id)sender{
    [self getitems];
}

- (void)near:(UIBarButtonItem*)sender {
    JOBrowse2ViewController *near = [self.storyboard instantiateViewControllerWithIdentifier:@"near"];
    [self.navigationController pushViewController:near animated:YES];
}
- (void)bargain:(UIBarButtonItem*)sender {
    JOBrowse2ViewController *bargain = [self.storyboard instantiateViewControllerWithIdentifier:@"bargain"];
    [self.navigationController pushViewController:bargain animated:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    for (UIView *subview in [[self.navigationController navigationBar] subviews]) {
        if(subview.tag == 1){
            [subview removeFromSuperview];
        }
    }
}

@end
