//
//  JONoticeViewController.m
//  Joton
//
//  Created by Val F on 13/06/26.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JONoticeViewController.h"

@interface JONoticeViewController ()

@end

@implementation JONoticeViewController

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

    self.navigationItem.title = @"使い方，注意・禁止事項";

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 2140)];
    
    UIFont *font1 = [UIFont boldSystemFontOfSize:15];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(280, 1000);
    
    UILabel *qa = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    qa.text = @"使い方";
    qa.font = font1;
    qa.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:qa];
    
    NSArray *titlearray = [[NSArray alloc] initWithObjects:@"◆ゆずりたい品物を出品する",@"◆欲しい品物を探す",@"◆出品中の品物を編集する",@"◆現金交換の申請",@"◆コイン交換の申請",@"◆ユーザー情報を編集する",@"禁止事項",@"◆出品",@"◆取引",@"◆その他", nil];
    NSArray *bodyarray = [[NSArray alloc] initWithObjects:@"Jotonでは写真１枚あれば簡単にゆずりたい品物を掲載することができます。\n1.譲渡ページから写真を撮影、もしくは選択。\n2.状態、配送方法、サイズ、地域を入力し「確認へ」をクリック。\n3.内容を確認し、「譲渡」をクリック。\n\n※利用規約に反する品物は削除する場合あります。利用規約を確認の上、出品してください。\n※出品中の品物情報はいつでも編集できますが、出品後7日間は削除することができません。",
                          @"Jotonでは出品されている品物をいろいろな方法で探すことができます。\n◆◆新着順\n　1.閲覧ページを開くと新着順で品物が表示されます。\n画面左上のボタンをクリックすることで、一覧とサムネイルの表示を切り替えることができます。\n画面右上の更新ボタンをクリックすることで表示を更新することができます。\n◆◆近くの物を探す\n　1.閲覧ページの「近くの物を探す」をクリック\n「＋－」で絞り込む距離を切り替えることができます。\n◆◆掘り出し物を探す\n　1.閲覧ページの「掘り出し物を探す」をクリック\n自動で掘り出し物を表示します。\n◆◆キーワードで探す\n　1.画面右上の虫眼鏡ボタンをクリックしてキーワード入力画面を表示\n　2.「検索」をクリック\n品物のコメント欄に入力されている文字を検索します。",
                          @"出品中の品物情報はいつでも編集できます。ただし、出品後7日間は削除することができません。\n1.マイページの「自分の出品」から、編集する品物をクリック。\n2.「編集」をクリックして編集ページを表示。\n3.内容を編集し、「更新」をクリック。",
                          @"Jotonでは出品報酬が1,000円以上貯まると現金交換することができます。（ただし、一度も取引を行っていない場合は交換できません。）\n1.マイページの「出品報酬」をクリックし出品報酬ページを表示\n2.「振り込みする」をクリックし振込口座情報を入力してください。\n3.確認し、内容に問題が無ければ「振り込む」をクリック。\n※申請いただいた番号に誤りがあった場合、申請の取り消し、コインの返還できません。ご注意ください。",
                          @"Jotonでは出品報酬が100円以上貯まるとコインと交換することができます。\n1.マイページの「出品報酬」をクリックし出品報酬ページを表示\n2.「コイン交換する」をクリック。",
                          @"Jotonに登録されているメールアドレスなどのユーザー情報はいつでも編集することができます。\n1.マイページの「ユーザー名」、もしくは設定から「ユーザー情報編集」をクリック\n2.内容を編集し「更新」をクリック",
                          @"",
                          @"出品物と直接関係のない画像や単語を品物説明に掲載すること\n出品物と無関係な品物の広告を掲載したり、リンクすること\n真に譲渡する意思がないにもかかわらず、出品をすること\n事実と異なる品物の情報を掲載すること\nわいせつな情報、犯罪を助長する情報、第三者を誹謗・中傷する情報を記載すること",
                          @"真に譲渡する意思が無いにもかかわらず、譲渡申請を行うこと。\nメールアドレスやURLなどを表記して、Joton外での取引を誘引すること",
                          @"法令に違反する行為、法令違反を助長する行為またはそれらのおそれのある行為\n他の利用者、第三者または当社の財産、名誉、信用、プライバシーもしくは著作権、パブリシティー権、商標権、その他の権利を侵害する行為、侵害を助長する行為またはそれらのおそれのある行為\n他の利用者または第三者に迷惑・不利益を与える等の行為、または、本サービスに支障をきたすおそれのある行為\n他のWebサイトに誘導すること\n本サービスが定める方法以外で、利用者自身を含む個人情報を入力・開示すること、または他の利用者に個人情報の入力・開示を要求すること\n個人情報など本サービスで知り得た情報について、品物の発送や連絡など本サービスに関する以外の目的で使用すること、または第三者に譲渡・提供すること\n本サービスが定める取引方法以外の決済で取引すること、またはそのような取引を相手方にもちかけること\n日本国外に在住されている方が利用すること\nそのほか、弊社独自の判断で不適当とみなす行為、またはJotonの運営方針に外れるとみなす行為", nil];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
