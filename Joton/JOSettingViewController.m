//
//  JOSettingViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOSettingViewController.h"

@interface JOSettingViewController ()

@end

@implementation JOSettingViewController

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

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    self.navigationItem.title = @"設定";

    //情報編集枠
    UIView *elv = [[UIView alloc]initWithFrame:CGRectMake(10, 13, 300, 91)];
    elv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:elv];
    //ユーザー情報編集
    UIButton *btnedit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnedit.frame = CGRectMake(0, 5, 300, 40);
    [btnedit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnedit setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnedit.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnedit setTitle:@"ユーザー情報編集　　　　　　　" forState:UIControlStateNormal];
    [elv addSubview:btnedit];
    [btnedit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *aiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    aiv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnedit addSubview:aiv];
    //プッシュ設定
    UIButton *btnpush = [UIButton buttonWithType:UIButtonTypeCustom];
    btnpush.frame = CGRectMake(0, 48, 300, 40);
    [btnpush setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnpush setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnpush.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnpush setTitle:@"プッシュ通知設定　　　　　　　" forState:UIControlStateNormal];
    [elv addSubview:btnpush];
    [btnpush addTarget:self action:@selector(notification:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *biv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    biv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnpush addSubview:biv];


    //説明枠
    UIView *nlv = [[UIView alloc]initWithFrame:CGRectMake(10, 115, 300, 268)];
    nlv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgSetting.png"]];
    [self.scroll addSubview:nlv];
    //利用規約
    UIButton *btntou = [UIButton buttonWithType:UIButtonTypeCustom];
    btntou.frame = CGRectMake(0, 5, 300, 40);
    [btntou setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btntou setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btntou.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btntou setTitle:@"利用規約　　　　　　　　　　　" forState:UIControlStateNormal];
    [nlv addSubview:btntou];
    [btntou addTarget:self action:@selector(tos:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *civ = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    civ.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btntou addSubview:civ];
    //プライバシーポリシー
    UIButton *btnpv = [UIButton buttonWithType:UIButtonTypeCustom];
    btnpv.frame = CGRectMake(0, 48, 300, 40);
    [btnpv setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnpv setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnpv.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnpv setTitle:@"プライバシーポリシー　　　　　" forState:UIControlStateNormal];
    [nlv addSubview:btnpv];
    [btnpv addTarget:self action:@selector(pv:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *div = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    div.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnpv addSubview:div];
    //おしらせ
    UIButton *btneq = [UIButton buttonWithType:UIButtonTypeCustom];
    btneq.frame = CGRectMake(0, 93, 300, 40);
    [btneq setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btneq setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btneq.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btneq setTitle:@"運営からのお知らせ　　　　　　" forState:UIControlStateNormal];
    [nlv addSubview:btneq];
    [btneq addTarget:self action:@selector(news:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *eiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    eiv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btneq addSubview:eiv];
    //faq
    UIButton *btny = [UIButton buttonWithType:UIButtonTypeCustom];
    btny.frame = CGRectMake(0, 135, 300, 40);
    [btny setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btny setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btny.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btny setTitle:@"FAQ・問い合わせ　　　　　　　" forState:UIControlStateNormal];
    [nlv addSubview:btny];
    [btny addTarget:self action:@selector(faq:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *fiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    fiv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btny addSubview:fiv];
    //取引の流れ
    UIButton *btnz = [UIButton buttonWithType:UIButtonTypeCustom];
    btnz.frame = CGRectMake(0, 180, 300, 40);
    [btnz setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnz setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnz.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnz setTitle:@"取引の流れ　　　　　　　　　　" forState:UIControlStateNormal];
    [nlv addSubview:btnz];
    [btnz addTarget:self action:@selector(howto:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *giv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    giv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnz addSubview:giv];
    //使い方
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(0, 225, 300, 40);
    [btnn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btnn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [btnn setTitle:@"使い方　　　　　　　　　　　　\n注意・禁止事項" forState:UIControlStateNormal];
    [nlv addSubview:btnn];
    [btnn addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *jiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    jiv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnn addSubview:jiv];


    //情報編集枠
    UIView *olv = [[UIView alloc]initWithFrame:CGRectMake(10, 400, 300, 91)];
    olv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:olv];
    //ログアウト
    UIButton *btnlo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnlo.frame = CGRectMake(0, 5, 300, 40);
    [btnlo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnlo setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnlo.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnlo setTitle:@"ログアウト　　　　　　　　　　" forState:UIControlStateNormal];
    [olv addSubview:btnlo];
    [btnlo addTarget:self action:@selector(btnlo_pushed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *hiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    hiv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnlo addSubview:hiv];
    //退会
    UIButton *btnresign = [UIButton buttonWithType:UIButtonTypeCustom];
    btnresign.frame = CGRectMake(0, 48, 300, 40);
    [btnresign setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnresign setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btnresign.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [btnresign setTitle:@"退会　　　　　　　　　　　　　" forState:UIControlStateNormal];
    [olv addSubview:btnresign];
    [btnresign addTarget:self action:@selector(resign:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *iiv = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 11, 17)];
    iiv.image = [UIImage imageNamed:@"iconArrow2.png"];
    [btnresign addSubview:iiv];

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 505)];
}

//編集
- (void)edit:(id)sender{
    JOSettingViewController *myedit = [self.storyboard instantiateViewControllerWithIdentifier:@"myedit0"];
    [self presentViewController:myedit animated:YES completion:nil];
}

//プッシュ通知
- (void)notification:(id)sender{
    JOSettingViewController *notification = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
    [self.navigationController pushViewController:notification animated:YES];
}

//ログアウト
- (void)btnlo_pushed:(UIButton*)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ログアウトしますか?" message:@"確認" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    //alert.tag = firstAlertTag;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (alertView.tag == firstAlertTag)  {
    switch (buttonIndex) {
        case 0://押したボタンがCancelなら何もしない
            break;
        case 1://押したボタンがOKなら画面遷移(リクエストは次ページで送信)
            NSLog(@"");
            //ユーザーデフォルトを空にする
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud removeObjectForKey:@"userid"];
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

            // 通知を作成する
            NSNotification *n = [NSNotification notificationWithName:@"logout" object:self];
            // 通知実行！
            [[NSNotificationCenter defaultCenter] postNotification:n];
            
            //JOSettingViewController *testVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"start"];
            //[self.navigationController presentViewController:testVC2 animated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            //}
    }
}

- (void)tos:(id)sender{
    JOSettingViewController *tos = [self.storyboard instantiateViewControllerWithIdentifier:@"tos"];
    [self.navigationController pushViewController:tos animated:YES];
}

- (void)pv:(id)sender{
    JOSettingViewController *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"privacy"];
    [self.navigationController pushViewController:pv animated:YES];
}

- (void)news:(id)sender{
    JOSettingViewController *news = [self.storyboard instantiateViewControllerWithIdentifier:@"news"];
    [self.navigationController pushViewController:news animated:YES];
}

- (void)faq:(id)sender{
    JOSettingViewController *faq = [self.storyboard instantiateViewControllerWithIdentifier:@"faq"];
    [self.navigationController pushViewController:faq animated:YES];
}

- (void)howto:(id)sender{
    JOSettingViewController *howto = [self.storyboard instantiateViewControllerWithIdentifier:@"howto"];
    [self.navigationController pushViewController:howto animated:YES];
}

- (void)notice:(id)sender{
    JOSettingViewController *notice = [self.storyboard instantiateViewControllerWithIdentifier:@"notice"];
    [self.navigationController pushViewController:notice animated:YES];
}

- (void)resign:(id)sender{
    JOSettingViewController *resign = [self.storyboard instantiateViewControllerWithIdentifier:@"resign"];
    [self.navigationController pushViewController:resign animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
