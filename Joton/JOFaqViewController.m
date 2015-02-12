//
//  JOFaqViewController.m
//  Joton
//
//  Created by Val F on 13/04/16.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOFaqViewController.h"

@interface JOFaqViewController ()

@end

@implementation JOFaqViewController

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

    self.navigationItem.title = @"FAQ・問い合わせ";

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 2040)];

    UIFont *font1 = [UIFont boldSystemFontOfSize:15];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(280, 1000);

    UILabel *qa = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    qa.text = @"Q&A";
    qa.font = font1;
    qa.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:qa];

    NSArray *titlearray = [[NSArray alloc] initWithObjects:@"1.会員登録について",@"2.譲渡について",@"3.出品報酬について",@"4.コイン交換について",@"5.現金交換交換について",@"6.機種変更について",@"7.セキュリティについて",@"8.退会について",@"お問い合わせ",@"「Joton」をご利用いただいているユーザー様", nil];
    NSArray *bodyarray = [[NSArray alloc] initWithObjects:@"Q.会員登録はお金がかかりますか？\nA.登録費、年会費は一切かかりません\n\nQ.1人でいくつも登録することができますか？\nA.原則としてお１人様１アカウントになります。\n\nQ.ログインID(メールアドレス)は変更できますか？\nA.マイページの「ユーザー情報編集」から変更できます。",
                          @"Q.譲渡について教えてください。\nA.誰かにゆずりたい品物を掲載することができます。譲渡することにより報酬を得ることができます。\nまた、掲載されている品物をコインと交換することができます。\n\nQ.出品した品物の情報を変更することはできますか？\nA.マイページの「自分の出品」から品物情報を編集することができます。\n\nQ.出品した品物を削除すことはできますか？\nA.出品後、7日間を経過した品物は削除することができます。",
                          @"Q.出品報酬とは何ですか？\nA.出品して得られる報酬です。出品毎に10円の報酬が貯まります。",
                          @"Q.コイン交換について教えてください。\nA.出品報酬が100円以上たまるとコインと交換することができます。\n\nQ.交換決定後のキャンセルや変更はできますか？\nA.交換決定後のキャンセルや変更はお受けできませんのでご注意ください。",
                          @"Q.現金交換について教えてください。\nA.出品報酬が1,000円以上たまると現金と交換することができますが、一度も取引を行っていない場合は交換できません。\n\nQ.交換決定後のキャンセルや変更はできますか？\nA.交換決定後のキャンセルや変更はお受けできませんのでご注意ください。\n\nQ.口座番号を間違えてしまいました、取り消しできますか？\nA.申請いただいた番号に誤りがあった場合、交換明細にてご案内しておりますが、申請の取り消し、コインの返還できません。ご注意ください。",
                          @"Q.機種変更しても報酬やコインは引き継がれますか？\nA.はい、機種変更以前にお使いいただいた同じID/PASSWORDでログインしていただければアカウント情報は引き継がれます。",
                          @"Q.登録情報が外に漏れることはありませんか？\nA.ご登録いただいた内容はユーザーの同意なくして、第三者に個人情報を開示することはありません。\nプライバシーポリシーをご覧ください。",
                          @"Q.退会するにはどうしたら良いでしょうか？\nA.マイページの「退会」から手続きを行ってください。\n\nQ.間違えて退会してしまいました。元に戻せますか？\nA.個人情報保護の観点から退会手続きが完了した方の登録を元に戻すことはできません。ご注意ください。\n\nQ.お問い合わせしても返信メールが届きません\nA.基本的にお問い合わせいただいた順に順次対応させていただいておりますが、一部調査が必要なため返信にお時間をいただく場合がございます。ご理解の程よろしくお願いします。\nまた、返信メールは下記アドレスより送信させて頂いております。\n　support@joton.jp\n受信拒否設定になっていないか、今一度ご確認下さい。",
                          @"「Joton」をご利用いただき、ありがとうございます。\n本サービスへのお問合わせは以下よりお願い致します。\nお問い合わせいただいた内容を弊社にて確認後ご連絡差し上げます。\n土日・祝日にいただいたお問い合わせは、翌営業日にご返答致します。",@"お寄せいただくご質問の中で、よくある質問を『Q&A』として掲載しております。\nお問い合わせ頂く前に、一度ご確認ください。\nお問い合わせの際は_________________までお願い致します。", nil];
    
    int j = 0;
    for(int i=0 ; i<=9 ; i++){
        UILabel *tlabel = [[UILabel alloc] init];
        CGSize size1 = [[titlearray objectAtIndex:i] sizeWithFont:font1 constrainedToSize:bounds lineBreakMode:mode];
        tlabel.backgroundColor = [UIColor clearColor];
        tlabel.font = font1;
        tlabel.numberOfLines = 200;
        tlabel.lineBreakMode = mode;
        tlabel.frame = CGRectMake(10, j+40, 300, size1.height);
        tlabel.text = [titlearray objectAtIndex:i];
        tlabel.font = [UIFont boldSystemFontOfSize:15];
        tlabel.backgroundColor = [UIColor clearColor];
        [self.scroll addSubview:tlabel];
        j = j+size1.height;
        //コメント
        NSString *btitle= [bodyarray objectAtIndex:i];
        CGSize size2 = [btitle sizeWithFont:font2 constrainedToSize:bounds lineBreakMode:mode];
        UILabel *blabel = [[UILabel alloc] init];
        blabel.backgroundColor = [UIColor clearColor];
        blabel.font = font2;
        blabel.numberOfLines = 200;
        blabel.lineBreakMode = mode;
        blabel.frame = CGRectMake(24, j+50, 280, size2.height);
        blabel.text = btitle;
        [self.scroll addSubview:blabel];
        j = j+size2.height+20;
    }

    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mailBtn.frame = CGRectMake(146, 1934, 100, 30);
    [mailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [mailBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [mailBtn setTitle:@"support@joton.jp" forState:UIControlStateNormal];
    mailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.scroll addSubview:mailBtn];
    [mailBtn addTarget:self action:@selector(mail:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mail:(id)sender{
    NSString *mailtitle = @"お問い合わせ/お客様ID:";
    NSString *mailtext = @"以下をご記入の上、ご送信下さい。\n頂いた内容を基に事務局より回答させて頂きます。\n\n【ID】※こちらのIDは書き換え、削除しないで下さい。\n\n【機種名】\n\n【お問い合わせ内容】\n※お問い合わせの前に一度「よくある質問」の内容をご確認ください。\n※機種変更以前にSMS認証を行っている場合、不正対策として新しい端末からのコイン交換が一時的に利用できなくなっています。大変お手数ですが、機種変更される前の旧電話番号を記載ください。";
    NSString *mail = [NSString stringWithFormat:@"mailto:support@joton.jp?Subject=%@&body=%@", [mailtitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [mailtext stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];

    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:joton@joton.jp?Subject=joton&body=test"]];//これはうごくよ!!
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
