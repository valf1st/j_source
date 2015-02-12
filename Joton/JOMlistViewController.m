//
//  JOMlistViewController.m
//  Joton
//
//  Created by Val F on 13/03/27.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOMlistViewController.h"

@interface JOMlistViewController ()

@end

@implementation JOMlistViewController

@synthesize item = _item;
@synthesize photo = _photo;

UIImageView *newiv;
int reload;

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

    reload = 0;
    self.navigationItem.title = @"交渉相手";
}

- (void)viewDidAppear:(BOOL)animated{
    if(reload == 0){
        [self getnegos];
        reload = 1;
    }
}

- (void)getnegos{
    NSLog(@"item = %@", _item);

    //通信
    NSString *dataa = [NSString stringWithFormat:@"item_id=%@&service=reader", _item];
    NSURL *url = [NSURL URLWithString:URL_NEGO_LIST];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        [self draw:response];
    }
}

//描画
- (void)draw:(NSArray *)res{
    if([res count] <= 0){
        //メッセージありませんラベル
        UILabel *nmLabel = [[UILabel alloc] init];
        nmLabel.frame = CGRectMake(10, 20, 300, 50);
        nmLabel.text = @"まだメッセージはありません";
        nmLabel.backgroundColor = [UIColor clearColor];
        nmLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        nmLabel.textAlignment = NSTextAlignmentCenter;
        [self.scroll addSubview:nmLabel];
    }else{
        //あったらはりまくる
        for(int i=0 ; i<[res count] ; i++){
            NSString *msginfo = [res objectAtIndex:i];
            NSString *buyer = [msginfo valueForKeyPath:@"uname"];
            int uid = [[msginfo valueForKeyPath:@"buyer_user_id"] intValue];
            int msg_stage = [[msginfo valueForKeyPath:@"msg_stage"] intValue];
            //int unchecked = [[msginfo valueForKeyPath:@"unchecked"] intValue];
            NSString *icon = [msginfo valueForKeyPath:@"icon"];
            NSString *message = [msginfo valueForKeyPath:@"message"];
            NSString *addtime = [msginfo valueForKeyPath:@"add_time"];
            int checked = [[msginfo valueForKeyPath:@"checked"] intValue];
            int receiver = [[msginfo valueForKeyPath:@"receiver_user_id"] intValue];

            //テーブルビューと見せかけたラベルとみせかけたボタン
            UIButton *lbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lbBtn.frame = CGRectMake(0, 66*i, 320, 67);
            lbBtn.backgroundColor = [UIColor whiteColor];
            lbBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            lbBtn.layer.borderWidth = 1.0;
            [self.scroll addSubview:lbBtn];
            [lbBtn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            lbBtn.tag = uid;
            //アイコンはる
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
            userbtn.frame = CGRectMake(6, 6, 40, 40);
            [userbtn addTarget:self action:@selector(user:) forControlEvents:UIControlEventTouchUpInside];
            [lbBtn addSubview:userbtn];
            userbtn.tag = uid;
            //ユーザー名
            UILabel *nlabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 2, 140, 20)];
            nlabel.text = buyer;
            nlabel.font = [UIFont boldSystemFontOfSize:12.6];
            nlabel.textColor = [UIColor blackColor];
            nlabel.backgroundColor = [UIColor clearColor];
            [lbBtn addSubview:nlabel];

            //時間
            NSString *time = [JOFunctionsDefined sinceFromData:addtime];
            //時間
            UILabel *dlabel = [[UILabel alloc] init];
            dlabel.frame = CGRectMake(67.5, 48.5, 100, 15);
            dlabel.backgroundColor = [UIColor clearColor];
            dlabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
            dlabel.font = [UIFont systemFontOfSize:12.4];
            dlabel.text = time;
            [lbBtn addSubview:dlabel];
            //時計マーク
            UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time2.png"]];
            clock.frame = CGRectMake(52, 50, 12, 12);
            [lbBtn addSubview:clock];

            //本文
            UILabel *mlabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 20, 200, 20)];
            mlabel.text = message;
            mlabel.font = [UIFont systemFontOfSize:12.4];
            mlabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
            mlabel.lineBreakMode = NSLineBreakByWordWrapping;
            mlabel.numberOfLines = 1;
            mlabel.backgroundColor = [UIColor clearColor];
            [lbBtn addSubview:mlabel];

            //品物画像はる
			UIImageView *piv;
			if(_photo == nil || [_photo isEqual:[NSNull null]]){
				UIImage *imgi = [UIImage imageNamed:@"itemImg.png"];
				piv = [[UIImageView alloc] initWithImage:imgi];
			}else{
				NSString *url_item=[NSString stringWithFormat:@"%@/%@/s_%@", URL_IMAGE, _item, _photo];
				NSURL* urli = [NSURL URLWithString:url_item];
				UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
				piv = [[UIImageView alloc] initWithImage:nil];
				//画像キャッシュ
                __block UIImageView *blockView = piv;
				[piv setImageWithURL:urli placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        blockView.image = [UIImage imageNamed:@"itemNoImg.png"];
                    }
                    if(msg_stage == 2){
                        UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 35, 35)];
                        lock.image = [UIImage imageNamed:@"iconRequestLock.png"];
                        [blockView addSubview:lock];
                    }else if(msg_stage == 1){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelRequest.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(msg_stage == 3){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelSend.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(msg_stage == 4){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelClose.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }else if(msg_stage == 6){
                        UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelDelete.png"]];
                        stage.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stage];
                    }
                }];
			}
			piv.frame = CGRectMake(256, 1, 65, 65);
			[lbBtn addSubview:piv];
            if(msg_stage == 2){
                UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 35, 35)];
                lock.image = [UIImage imageNamed:@"iconRequestLock.png"];
                [piv addSubview:lock];
            }else if(msg_stage == 1){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelRequest.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(msg_stage == 3){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelSend.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(msg_stage == 4){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelClose.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }else if(msg_stage == 6){
                UIImageView *stage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelDelete.png"]];
                stage.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stage];
            }

            //自分のuserid
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            int myid = [[ud stringForKey:@"userid"] intValue];
            //最後のmsgが相手からのでかつ未読ならマーク
            if(checked == 0 && receiver == myid){
                /*UIImageView *newiv = [[UIImageView alloc] initWithFrame:CGRectMake(200, 25, 47, 28)];
                 newiv.image = [UIImage imageNamed:@"iconNew.png"];
                 [lbBtn addSubview:newiv];
                 newiv.tag = -lbBtn.tag;*/
                [lbBtn setBackgroundColor:[UIColor colorWithRed:0.992 green:0.976 blue:0.847 alpha:1.0]];
            }

            [self.scroll setScrollEnabled:YES];
            [self.scroll setContentSize:CGSizeMake(320, 66*i+67)];
        }
    }
}

- (void)btn:(UIButton *)sender{
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = _item;
    send.user = [NSString stringWithFormat:@"%d", sender.tag];
    send.photo = _photo;
    send.seller = @"0";
    [self.navigationController pushViewController:send animated:YES];
    //newマーク消す
    UIImageView *new = (UIImageView *)[self.scroll viewWithTag:-sender.tag];
    new.hidden = TRUE;
}

- (void)user:(UIButton *)sender{
    NSString* tagtag=[NSString stringWithFormat:@"%d",sender.tag];
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = tagtag;
    [self.navigationController pushViewController:user animated:YES];
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
