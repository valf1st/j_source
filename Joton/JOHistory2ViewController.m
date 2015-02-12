//
//  JOHistory2ViewController.m
//  Joton
//
//  Created by Val F on 13/06/14.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOHistory2ViewController.h"

@interface JOHistory2ViewController ()

@end

@implementation JOHistory2ViewController

UISegmentedControl *hsc2;
NSArray *hisres2;
int reload, myid;

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

    self.navigationItem.hidesBackButton = YES;

    reload = 0;

    //ナビゲーションバーにボタンを追加
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 74, 30)];
    [back setBackgroundImage:[UIImage imageNamed:@"btnMypage.png"]
                     forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"btnMypageOn.png"]
                    forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backbtn = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItems = @[backbtn];

    hsc2 = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"他人の出品", @"自分の出品", nil]];
    hsc2.selectedSegmentIndex=0;
    hsc2.segmentedControlStyle = UISegmentedControlStyleBar;
    hsc2.tintColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.0 alpha:1.0];
    self.navigationItem.titleView = hsc2;
    [hsc2 addTarget:self action:@selector(segment:) forControlEvents:UIControlEventValueChanged];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    myid = [[ud stringForKey:@"userid"] intValue];
}

- (void)viewDidAppear:(BOOL)animated{
    if(reload == 0){
        [self gethistory];
        reload = 1;
    }
}

- (void)gethistory{
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d&service=reader", myid];
    NSURL *url = [NSURL URLWithString:URL_USER_HISTORY2];
    //通信
    NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:30];
    async = [JOAsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        hisres2 = response;
        [self draw];
    }
}

//描画
- (void)draw{
    if([hisres2 count] != 0){
        for(int i=0 ; i<[hisres2 count] ; i++){
            NSString *negoinfo = [hisres2 objectAtIndex:i];
            NSString *photo = [negoinfo valueForKeyPath:@"photo1"];
            NSString *uname = [negoinfo valueForKeyPath:@"user_name"];
            NSString *message = [negoinfo valueForKeyPath:@"message"];
            int uid = [[negoinfo valueForKeyPath:@"seller_user_id"] intValue];
            NSString *icon = [negoinfo valueForKeyPath:@"icon"];
            int stage = [[negoinfo valueForKeyPath:@"nego_stage"] intValue];
            int item_id = [[negoinfo valueForKeyPath:@"item_id"] intValue];
            
            //枠
            UIButton *fv = [UIButton buttonWithType:UIButtonTypeCustom];
            fv.frame = CGRectMake(-1, 66*i, 322, 67);
            fv.layer.borderColor = [UIColor lightGrayColor].CGColor;
            fv.layer.borderWidth = 1.0;
            fv.backgroundColor = [UIColor whiteColor];
            [self.scroll addSubview:fv];
            
            //ラベルはる
            NSString *datetime;
            if(stage == 1){
                datetime = [negoinfo valueForKeyPath:@"request_time"];
            }else if(stage == 2){
                datetime = [negoinfo valueForKeyPath:@"lock_time"];
            }else if(stage == 3){
                datetime = [negoinfo valueForKeyPath:@"dispatch_time"];
            }else if(stage == 4){
                datetime = [negoinfo valueForKeyPath:@"delivered_time"];
            }else if(stage == 5){
                datetime = [negoinfo valueForKeyPath:@"cancel_time"];
            }else if(stage == 6){
                datetime = [negoinfo valueForKeyPath:@"delete_time"];
            }
            [fv addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            fv.tag = i;
            
            //出品者のアイコンをはる
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
            [fv addSubview:userbtn];
            userbtn.tag = uid;
            
            //ユーザー名
            UILabel *nlabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 2, 140, 20)];
            nlabel.text = uname;
            nlabel.textColor = [UIColor blackColor];
            nlabel.font = [UIFont boldSystemFontOfSize:12.6];
            nlabel.backgroundColor = [UIColor clearColor];
            [fv addSubview:nlabel];
            
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
            [fv addSubview:mlabel];
            
            //品物画像はる
			UIImageView *piv;
			if(photo == nil || [photo isEqual:[NSNull null]]){
				UIImage *imgi = [UIImage imageNamed:@"itemImg.png"];
				piv = [[UIImageView alloc] initWithImage:imgi];
			}else{
				NSString *url_item=[NSString stringWithFormat:@"%@/%d/s_%@", URL_IMAGE, item_id, photo];
				NSURL* urli = [NSURL URLWithString:url_item];
				UIImage *placeholderImage = [UIImage imageNamed:@"itemImg.png"];
				piv = [[UIImageView alloc] initWithImage:nil];
				//画像キャッシュ
                __block UIImageView *blockView = piv;
				[piv setImageWithURL:urli placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                    if(error){
                        blockView.image = [UIImage imageNamed:@"itemNoImg.png"];
                    }
                    if(stage == 2){
                        UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 35, 35)];
                        lock.image = [UIImage imageNamed:@"iconRequestLock.png"];
                        [blockView addSubview:lock];
                    }else if(stage == 1){
                        UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelRequest.png"]];
                        stageiv.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stageiv];
                    }else if(stage == 3){
                        UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelSend.png"]];
                        stageiv.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stageiv];
                    }else if(stage == 4){
                        UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelClose.png"]];
                        stageiv.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stageiv];
                    }else if(stage == 5){
                        UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelCancel.png"]];
                        stageiv.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stageiv];
                    }else if(stage == 6){
                        UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelDelete.png"]];
                        stageiv.frame = CGRectMake(26, 0, 39, 39);
                        [blockView addSubview:stageiv];
                    }
                }];
			}
			piv.frame = CGRectMake(256, 1, 65, 65);
			[fv addSubview:piv];
            if(stage == 2){
                UIImageView *lock = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 35, 35)];
                lock.image = [UIImage imageNamed:@"iconRequestLock.png"];
                [piv addSubview:lock];
            }else if(stage == 1){
                UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelRequest.png"]];
                stageiv.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stageiv];
            }else if(stage == 3){
                UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelSend.png"]];
                stageiv.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stageiv];
            }else if(stage == 4){
                UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelClose.png"]];
                stageiv.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stageiv];
            }else if(stage == 6){
                UIImageView *stageiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"labelDelete.png"]];
                stageiv.frame = CGRectMake(26, 0, 39, 39);
                [piv addSubview:stageiv];
            }
            
            if(!(datetime == nil || [datetime isEqual:[NSNull null]])){
                NSString *time = [JOFunctionsDefined sinceFromData:datetime];
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
                [fv addSubview:dlabel];
                //時計マーク
                UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time2.png"]];
                clock.frame = CGRectMake(52, 50, 12, 12);
                [fv addSubview:clock];
            }
            [self.scroll setScrollEnabled:YES];
            [self.scroll setContentSize:CGSizeMake(320, 66*i+67)];
        }
    }else{
        UILabel *nmlabel = [[UILabel alloc] init];
        nmlabel.frame = CGRectMake(10, 40, 300, 50);
        nmlabel.text = @"履歴はありません";
        nmlabel.backgroundColor = [UIColor clearColor];
        nmlabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        nmlabel.textAlignment = NSTextAlignmentCenter;
        [self.scroll addSubview:nmlabel];
    }
}

- (void)noimage:(int)tag{
    UIImageView *piv = (UIImageView *)[self.scroll viewWithTag:tag];
    piv.image = [UIImage imageNamed:@"itemNoImg.png"];
}

- (void)user:(UIButton *)sender{
    NSString* tagtag=[NSString stringWithFormat:@"%d",sender.tag];
    JOUserViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"user"];
    user.user = tagtag;
    [self.navigationController pushViewController:user animated:YES];
}

- (void)btn:(UIButton *)sender{
    NSString *negoinfo = [hisres2 objectAtIndex:sender.tag];
    NSString *photo = [negoinfo valueForKeyPath:@"photo1"];
    NSString *item_id = [negoinfo valueForKeyPath:@"item_id"];
    NSString *user_id = [negoinfo valueForKeyPath:@"buyer_user_id"];
    JOSendViewController *send = [self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    send.item = item_id;
    send.user = user_id;
    send.photo = photo;
    send.seller = @"1";
    [self.navigationController pushViewController:send animated:YES];
}

- (void)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)segment:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    async.delegate = nil;
    hsc2.selectedSegmentIndex=0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
