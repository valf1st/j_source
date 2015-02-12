//
//  JOHowtoViewController.m
//  Joton
//
//  Created by Val F on 13/05/09.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOHowtoViewController.h"

@interface JOHowtoViewController ()

@end

@implementation JOHowtoViewController

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

    self.navigationItem.title = @"取引の流れ";

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 1690)];

    //てきすと
    UILabel *exl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 290, 110)];
    exl.backgroundColor = [UIColor clearColor];
    exl.font = [UIFont systemFontOfSize:14.5];
    exl.lineBreakMode = NSLineBreakByWordWrapping;
    exl.numberOfLines = 6;
    exl.text = @"Jotonでの取引には下記のようなステップをふむことで取引が成立します。\nステップはすべてメッセージを通じて行います。\n※品物を出品した人を出品者、品物を入手したい人を希望者とします。";
    exl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [self.scroll addSubview:exl];

    UIImageView *ss = [[UIImageView alloc]initWithFrame:CGRectMake(10, 130, 300, 1314)];
    ss.image = [UIImage imageNamed:@"tradeFlow.png"];
    [self.scroll addSubview:ss];

    //てきすと
    UILabel *exl2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 1450, 290, 230)];
    exl2.backgroundColor = [UIColor clearColor];
    exl2.font = [UIFont systemFontOfSize:14.5];
    exl2.lineBreakMode = NSLineBreakByWordWrapping;
    exl2.numberOfLines = 15;
    exl2.text = @"（注１）出品者が「品物を発送しました」をクリックしてから、７日間以内に希望者が「到着しました」をクリックしなかった場合、希望者には「届きません」ボタンが表示されます。\n「到着しました」「届きません」のどちらもクリックされずに３日間経過すると、自動的に取引成立となりますのでご注意ください。\n\n※取引で発生したユーザー間でのトラブルに関し、弊社は関与いたしません。";
    exl2.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [self.scroll addSubview:exl2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
