//
//  JONewsViewController.m
//  Joton
//
//  Created by Val F on 13/04/16.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JONewsViewController.h"

@interface JONewsViewController ()

@end

@implementation JONewsViewController

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

    self.navigationItem.title = @"運営からのお知らせ";
}

- (void)viewDidAppear:(BOOL)animated{
    [self getnews];
}

- (void)getnews{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int myid = [[ud stringForKey:@"userid"] intValue];
    NSString *dataa = [NSString stringWithFormat:@"user_id=%d", myid];
    NSURL *url = [NSURL URLWithString:URL_NEWS];
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

- (void)draw:(NSArray *)res{
    UIFont *font1 = [UIFont boldSystemFontOfSize:14];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(280, 600);

    if([res count] == 0){
        UILabel *nlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        nlabel.text = @"お知らせはありません";
        [self.scroll addSubview:nlabel];
    }else{
        int j = 0;
        for(int i=0 ; i<[res count] ; i++){
            NSArray *newsinfo = [res objectAtIndex:i];
            NSString *title = [newsinfo valueForKeyPath:@"info_title"];
            NSString *content = [newsinfo valueForKeyPath:@"info_word"];
            NSString *date = [newsinfo valueForKeyPath:@"add_time"];
            //日時
            UILabel *dlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, j+10, 250, 30)];
            dlabel.text = date;
            dlabel.font = [UIFont boldSystemFontOfSize:14];
            dlabel.backgroundColor = [UIColor clearColor];
            [self.scroll addSubview:dlabel];
            //タイトル
            CGSize size1 = [title sizeWithFont:font1 constrainedToSize:bounds lineBreakMode:mode];
            UILabel *tlabel = [[UILabel alloc] init];
            tlabel.backgroundColor = [UIColor clearColor];
            tlabel.font = font1;
            tlabel.numberOfLines = 100;
            tlabel.lineBreakMode = mode;
            tlabel.frame = CGRectMake(10, j+35, 300, size1.height);
            tlabel.text = title;
            tlabel.font = [UIFont boldSystemFontOfSize:14];
            tlabel.backgroundColor = [UIColor clearColor];
            [self.scroll addSubview:tlabel];
            j = j+size1.height;
            //コメント
            NSString *btitle= content;
            CGSize size2 = [btitle sizeWithFont:font2 constrainedToSize:bounds lineBreakMode:mode];
            UILabel *blabel = [[UILabel alloc] init];
            blabel.backgroundColor = [UIColor clearColor];
            blabel.font = font2;
            blabel.numberOfLines = 100;
            blabel.lineBreakMode = mode;
            blabel.frame = CGRectMake(24, j+40, 280, size2.height);
            blabel.text = btitle;
            [self.scroll addSubview:blabel];

            j = 40+j+size2.height;
        }
        [self.scroll setScrollEnabled:YES];
        [self.scroll setContentSize:CGSizeMake(320, j+10)];
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
