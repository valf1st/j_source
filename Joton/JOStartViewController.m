//
//  JOStartViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOStartViewController.h"

@interface JOStartViewController ()

@end

@implementation JOStartViewController

UIImageView *sbar, *pci;

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

    //self.navigationItem.title = @"ようこそ";//効きません

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float sheight = screenBound.size.height;

    //使い方表示
    UIScrollView *howto = [[UIScrollView alloc]init];
    if(sheight < 500){
        howto.frame = CGRectMake(0, 0, 320, 395);
    }else{
        howto.frame = CGRectMake(0, 0, 320, 460);
    }
    howto.backgroundColor = [UIColor whiteColor];
    [howto setScrollEnabled:YES];
    [howto setContentSize:CGSizeMake(1600, 280)];
    howto.pagingEnabled = YES;
    [howto setShowsHorizontalScrollIndicator:NO];
    howto.bounces = NO;
    [self.view addSubview:howto];
    howto.delegate = self;

    UIImageView *tutorial = [[UIImageView alloc] init];
    if(sheight < 500){
        tutorial.frame = CGRectMake(0, 0, 1600, 395);
        tutorial.image = [UIImage imageNamed:@"tutorial4s.png"];
    }else{
        tutorial.frame = CGRectMake(0, 0, 1600, 460);
        tutorial.image = [UIImage imageNamed:@"tutorial.png"];
    }
    [howto addSubview:tutorial];



    sbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    sbar.image = [UIImage imageNamed:@"nav.png"];
    [self.view addSubview:sbar];
    //ようこそ陰
    UILabel *shadow = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 40)];
    shadow.text = @"ようこそ";
    shadow.backgroundColor = [UIColor clearColor];
    shadow.textColor = [UIColor colorWithRed:0.7 green:0.5 blue:0.1 alpha:1.0];
    shadow.textAlignment = NSTextAlignmentCenter;
    shadow.font = [UIFont boldSystemFontOfSize:20];
    [sbar addSubview:shadow];
    //ようこそ
    UILabel *welcome = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 42)];
    welcome.text = @"ようこそ";
    welcome.backgroundColor = [UIColor clearColor];
    welcome.textColor = [UIColor whiteColor];
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.font = [UIFont boldSystemFontOfSize:20];
    [sbar addSubview:welcome];

    //pagecontrol
    pci = [[UIImageView alloc] init];
    if(sheight < 500){
        pci.frame = CGRectMake(120, 390, 79, 6);
    }else{
        pci.frame = CGRectMake(120, 460, 79, 6);
    }
    pci.image = [UIImage imageNamed:@"selected1.png"];
    [self.view addSubview:pci];

    //ボタン背景
    UIView *btnbg = [[UIView alloc] initWithFrame:CGRectMake(0, sheight-67, 320, 47)];
    btnbg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgTopBtn.png"]];
    [self.view addSubview:btnbg];
    //ろぐいん
    UIButton *libtn = [UIButton buttonWithType:UIButtonTypeCustom];
    libtn.frame = CGRectMake(11, 7, 92, 36);
    [libtn setBackgroundImage:[UIImage imageNamed:@"btnTopLogin.png"] forState:UIControlStateNormal];
    [btnbg addSubview:libtn];
    [libtn addTarget:self action:@selector(libtn:) forControlEvents:UIControlEventTouchUpInside];
    //新規登録
    UIButton *regbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regbtn.frame = CGRectMake(216, 7, 92, 36);
    [regbtn setBackgroundImage:[UIImage imageNamed:@"btnTopRegister.png"] forState:UIControlStateNormal];
    [btnbg addSubview:regbtn];
    [regbtn addTarget:self action:@selector(regbtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(page > 0){
        [UIView animateWithDuration:0.2 animations:^
         {
             sbar.frame = CGRectMake(0, 0, 320, 44);
         }];
        if(page == 1){
            pci.image = [UIImage imageNamed:@"selected2.png"];
        }else if(page == 2){
            pci.image = [UIImage imageNamed:@"selected3.png"];
        }else if(page == 3){
            pci.image = [UIImage imageNamed:@"selected4.png"];
        }else if(page == 4){
            pci.image = [UIImage imageNamed:@"selected5.png"];
        }
    }else{
        pci.image = [UIImage imageNamed:@"selected1.png"];
        [UIView animateWithDuration:0.2 animations:^
         {
             sbar.frame = CGRectMake(0, -44, 320, 44);
         }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *myid = [ud stringForKey:@"userid"];
    if(!(myid == nil || [myid isEqual:[NSNull null]])){
        JOStartViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tbc"];
        [self presentViewController:tbc animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)regbtn:(id)sender{
    JOStartViewController *reg = [self.storyboard instantiateViewControllerWithIdentifier:@"reg"];
    [self.navigationController pushViewController:reg animated:YES];
}

- (void)libtn:(id)sender{
    JOStartViewController *li = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:li animated:YES];
}

@end
