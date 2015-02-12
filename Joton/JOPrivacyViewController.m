//
//  JOPrivacyViewController.m
//  Joton
//
//  Created by Val F on 13/06/06.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOPrivacyViewController.h"

@interface JOPrivacyViewController ()

@end

@implementation JOPrivacyViewController

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

    self.navigationItem.title = @"プライバシーポリシー";
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 1630)];

    UIFont *font1 = [UIFont boldSystemFontOfSize:15];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(280, 1000);

    NSArray *titlearray = [[NSArray alloc] initWithObjects:@"1.個人情報の収集について",@"2.個人情報の利用について",@"3.個人情報の共有について",@"4.個人情報の修正と削除について",@"5.アクセスログ・ファイルについて",@"6.リンクについて",@"7.セキュリティについて",@"8.プライバシー・ステートメントの更新につ　いて",@"9.プライバシーに関する意見・苦情・意義申　し立てについて", nil];
    NSArray *bodyarray = [[NSArray alloc] initWithObjects:@"このプライバシー・ステートメントに述べられている「個人情報」とは、氏名、住所、Eメールアドレス、本ウェブサ イトのアクセス記録、嗜好情報等の特定の個人を識別することができる情報をいいます。 本ウェブサイトでは、会員登録、お問い合わせ等をご利用いただく際に、皆さまの個人情報を収集することがあります。 当社による個人情報の収集は、あくまで皆さまの自発的な提供によるものであり、皆さまが個人情報を提供された 場合は、当社がこのプライバシー・ステートメントに則って個人情報を利用することを皆さまが許諾したものとします。 ただし当社は、プライバシー・ステートメントに開示されている事と異なった方法で、本人に許可なく個人情報を 第三者に開示することはございません。て",
                          @"個人情報を収集する場合には、収集の目的を明確にします。お問い合わせへの回答、お支払い等、 皆さまの要望に応じたサービスを提供する目的で利用を行います。また、当社から皆さまへのご連絡としてメールマガ ジン等、必要に応じてご提供する場合があります。",
                          @"当社は、あらかじめ本人の同意を得ず、利用目的の範囲外で個人情報を取り扱うことはありません。 ただし裁判所、警察、消費者センターまたはこれらに準じた権限を持った機関から合法的な要請がある場合は、これに応じて情報を開示させていただきます。",
                          @"皆さまの個人情報が変わる場合（例えばメールアドレス等）、あるいは皆さまが個人情報の削除を希望される場合には、 当社は皆さまから提供された個人情報を修正、あるいは削除いたします。また一部内容を除き、 弊社からの連絡を拒否する事が出来ます。",
                          @"当社は、本ウェブサイトの利用者の動向を調査する為にアクセスログ・ファイルを使用します。 これにより、当社は、IPアドレス、ブラウザの種類、リファラー等についての統計的なサイト利用情報を得ることが できますが、個人情報の収集・解析のために利用することはありません。",
                          @"本ウェブサイトは、いくつかの外部サイトへのリンクを含みますが、個人情報を共有するものではありません。 リンク先ウェブサイトにて行われる個人情報の収集に関しては当社では一切責任を負えませんので、 リンク先ウェブサイトのプライバシー・ステートメントを必ずご参照下さい。",
                          @"本ウェブサイトは、皆さまの大切な個人情報をご登録いただくにあたり、SSLと呼ばれる特殊暗号通信技術の使用や Firewallというセキュリティーシステムで保護された専用のサーバで管理し、外部からの不正アクセスや情報の 漏洩防止に最善を尽くしています。 また個人情報保護に関する社内外セミナー等を実施し、個人情報の管理体制を一層強化しています。",
                          @"プライバシー・ステートメントを変更する場合は、この変更について本ウェブサイトに掲載します。 最新のプライバシー・ステートメントをサイトに掲載することにより、常にプライバシー情報の収集や使用方法を 知ることができます。定期的にご確認下さいますようお願い申し上げます。 また当初情報が収集された時点で述べた内容と異なった方法で個人情報を使用する場合も、本ウェブサイトに 掲載にてご連絡させていただきます。本ウェブサイトが異なった方法で個人情報の使用をしてよいかどうかに ついての選択権は、皆さまが有しております。",
                          @"皆さまが、本ウェブサイトで掲示したプライバシー・ステートメントを守っていないと思う場合には、お問合せ（＿＿＿＿＿＿＿＿＿＿ から）を通じて当社にまずご連絡してください。内容確認後、折り返しメールで の連絡をした後、適切な処理ができるよう努めます。\n当社は、「プライバシー・ステートメント」についての皆さまのご意見、ご感想をお待ちしております。", nil];

    int j = 0;
    for(int i=0 ; i<=8 ; i++){
        UILabel *tlabel = [[UILabel alloc] init];
        CGSize size1 = [[titlearray objectAtIndex:i] sizeWithFont:font1 constrainedToSize:bounds lineBreakMode:mode];
        tlabel.backgroundColor = [UIColor clearColor];
        tlabel.font = font1;
        tlabel.numberOfLines = 200;
        tlabel.lineBreakMode = mode;
        tlabel.frame = CGRectMake(10, j+10, 300, size1.height);
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
        blabel.frame = CGRectMake(24, j+20, 280, size2.height);
        blabel.text = btitle;
        [self.scroll addSubview:blabel];
        j = j+size2.height+20;
    }

    //問い合わせメールボタン
    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mailBtn.frame = CGRectMake(139, 1507, 135, 20);
    mailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [mailBtn setBackgroundColor:[UIColor clearColor]];
    [mailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [mailBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [mailBtn setTitle:@"こちらのお問い合わせ" forState:UIControlStateNormal];
    [self.scroll addSubview:mailBtn];
    [mailBtn addTarget:self action:@selector(mail:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mail:(id)sender{
    NSString *mailtitle = @"お問い合わせ/お客様ID:";
    NSString *mailtext = @"以下をご記入の上、ご送信下さい。\n頂いた内容を基に事務局より回答させて頂きます。\n\n【ID】※こちらのIDは書き換え、削除しないで下さい。\n\n【機種名】\n\n【お問い合わせ内容】\n※お問い合わせの前に一度「よくある質問」の内容をご確認ください。\n※機種変更以前にSMS認証を行っている場合、不正対策として新しい端末からのコイン交換が一時的に利用できなくなっています。大変お手数ですが、機種変更される前の旧電話番号を記載ください。";
    NSString *mail = [NSString stringWithFormat:@"mailto:support@joton.jp?Subject=%@&body=%@", [mailtitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [mailtext stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
