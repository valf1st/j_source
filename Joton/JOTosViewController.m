//
//  JOTosViewController.m
//  Joton
//
//  Created by Val F on 13/04/16.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOTosViewController.h"

@interface JOTosViewController ()

@end

@implementation JOTosViewController

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

    self.navigationItem.title = @"利用規約";

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 10950)];

    NSArray *titlearray = [[NSArray alloc] initWithObjects:@"利用規約",@"1条　定義",@"2条　本サービスの内容",@"3条　本サービスの利用条件",@"4条　手続きの成立",@"5条　個人情報等の取扱い",@"6条　本規約の変更",@"7条　会員登録",@"8条　会員資格",@"9条　ログインIDとパスワードの管理等",@"10条　会員資格の取消等",@"11条　会員の退会",@"12条　品物の出品",@"13条　品物をゆずってもらうためのリク　　　エスト",@"14条　取引",@"15条　当社の役割",@"16条　支払い及び決済等",@"17条　キャンセル及び返品",@"18条　コインの取扱い",@"19条　インターネット接続環境",@"20条　知的財産権",@"21条　禁止事項",@"22条　コンテンツの変更又は削除",@"23条　本サービスの中断",@"24条　本サービスの終了及び変更",@"25条　通知方法",@"26条　免責事項",@"27条　準拠法・裁判管轄", nil];
    NSArray *bodyarray = [[NSArray alloc] initWithObjects:@"この規約(以下「本利用規約」といいます)はバジンプ株式会社（以下「当社」といいます）が会員に提供する本サービスの利用に関して、その諸条件を定めるものです。",
                          @"1.「本サービス」とは、当社が運営するインターネットサービスであるJotonにおいて、当社が提供する会員向けの各種サービスの総称をいいます。\n2.「本規約」とは、本利用規約、プライバシーポリシー及び本サービスに関する「Jotonはじめてガイド」(以下利用ガイド)の全てを指します。\n3.「会員」とは、本規約を承認し、本サービスを利用するために当社所定の入会登録を行い、当社がその入会登録を承認した個人及び法人を指します。\n4.「会員等」とは、会員、会員登録のリクエスト者及び本サービスの閲覧者を指します。ただし、会員等と当該閲覧者を併記する場合があり、また、特に断らない限り、第三者に当該閲覧者も含まれるものとします。\n5.「個人情報」とは、会員が登録した氏名、郵便番号、住所、電話番号、電子メールアドレス、プロフィール情報等の登録情報及び利用履歴等、特定の個人を識別できる情報を指します。\n6.「出品」とは、会員が、本サービスにて、必要なコンテンツを書き込むなどにより他の会員等が閲覧可能となり、品物を取引できる状態にすることを指します。\n7.「品物」とは、本サービスにおいて取引の目的となる物品を指します。\n8.「ゆずる人」とは、本サービスを通じて品物を出品する会員を指します。\n9.「ゆずってもらう人」とは、本サービスを通じて品物をゆずってもらう会員を指します。\n10.「コンテンツ」とは、当社又は会員等が本サービスに掲載又は発信した画像、映像及びテキスト情報等を指します。\n11.「コイン」とは、本サービスにおいて取引をするために必要な仮想通貨を指します。\n12.本条の定義は、特に断らない限り、本利用規約、プライバシーポリシー及び利用ガイドにおいても、適用されます。",
                          @"本サービスの内容は、本利用規約及び本サービスに関する利用ガイドに規定するとおりとします。",
                          @"1.本サービスを利用するためには、本規約に同意頂いた上で、本規約に定めるところに従い会員登録を行う必要があります。本規約に同意頂けない場合は、当社が提供する本サービスをご利用頂くことはできません。なお、本サービスを利用された場合には、本規約に同意頂いたものとみなします。\n2.本規約は、全ての会員に適用され、会員登録手続時及び登録後に、遵守頂く必要があります。",
                          @"会員がインターネット回線を通じて行った登録、出品、ゆずってもらう、退会その他の手続は、当社のサーバーに当該手続に関するデータが送信され、当社のシステムに当該手続の内容が反映された時点をもって有効に成立するものとします。",
                          @"1.当社は、個人情報及びコンテンツ（以下「個人情報等」といいます）を本サービス上に掲載されるプライバシーポリシーに従って取り扱うものとします。\n2.会員等は、本サービスの利用又は本サービスの閲覧の前に、本サービス上で、プライバシーポリシーを必ず確認し、その内容に同意した上で、本サービスを利用し、又は、本サービスにアクセスしてください。\n3.会員は、本サービスを通じて取得した会員等の個人情報等については、本サービスの利用の範囲内においてのみ利用することができ、それ以外の利用はできないものとします。\n4.当社は、当社が取得する個人情報等について、以下の各号に定める目的で利用することができるものとします。\n(1)本人確認及び取引状態の確認等を含む本サービスの提供に必要な範囲での利用\n(2)本サービスの運営上必要な事項の通知\n(3)本サービスの品質管理及び利便性向上のためのアンケート調査及び分析\n(4)本サービスに対する問い合わせ対応\n(5)本サービスの運営に関する事柄についての連絡又は追加サービス等本サービスに関連する情報提供\n(6)本サービス運営上の不正利用その他のトラブル解決\n(7)本サービスにおけるシステムの維持又は不具合対応\n5.当社は、法令に基づく場合又は以下に定める場合を除き、事前に会員の同意を得ることなしに個人情報等を第三者に預託又は提供しません。\n(1)当社が定める期間、コンテンツ、利用履歴及びプロフィール情報を本サービス上において公開する場合\n(2)本サービス上において、知り合い又は知り合いの可能性がある他の会員を友だちとして登録し、又は、その登録を推薦する場合\n(3)コイン購入代金の回収のために必要な場合\n(4)合併その他の事由による事業の承継に伴って事業を承継する者に対して個人情報を提供する場合\n(5)会員が第三者に迷惑をかけ、そのトラブルを解決するために、当社が開示を必要と判断した場合\n6.前項に基づき個人情報等が公開されたことによる会員等の損害について、直接的か間接的かを問わず、当社は一切責任を負わないものとします。会員等は、本条の内容を十分に認識した上で、本サービスを利用する必要があります。\n7.会員は、本サービスに登録した個人情報について、開示、削除、訂正又は利用停止の請求ができるものとし、本人からの請求であることが確認できる場合に限り、当社はこれにすみやかに対応するものとします。",
                          @"1.当社は、当社の判断により、本規約をいつでも任意の理由で変更することができるものとします。\n2.変更後の本規約は、当社が別途定める場合を除いて、本サービス上に表示した時点より効力を生じるものとします。\n3.会員等が、本規約の変更の効力が生じた後に本サービスをご利用になる場合には、変更後の本規約の全ての記載内容に同意したものとみなされ、当該内容の不知又は不承諾を申し立てることはできないものとします。\n4.当社は、本規約の変更により会員等に生じた損害について、直接的か間接的かを問わず、一切の責任を負いません。",
                          @"1.会員登録を行う者は、その本人が、当社所定の手続に従い会員登録申請を行うものとします。\n2.当社は、以下各号のいずれかに該当する場合、当該登録申請を承認しないことがあります。\n(1)次条に定める会員資格を満たしていない場合\n(2)過去に本規約違反等により、当社から会員登録の取消等の処分を受けている場合\n(3)申請内容に虚偽の事項が含まれている場合\n(4)フリーメール以外のメールアドレスを保有していない場合\n(5)暴力団、暴力団員、暴力団準構成員、総会屋、社会運動等標榜ゴロ、特殊知能暴力集団その他これに準じる反社会的勢力（以下「反社会的勢力等」といいます）であると判明した場合又は反社会的勢力等が経営に実質的に関与している法人等であると判明した場合\n(6)その他登録申請を承認することが不適当であると当社が判断する場合\n3.登録内容の変更がある場合は、会員は、直ちに当社所定の手続により登録内容を変更しなければならず、常に会員自身の正確な情報が登録されているよう、登録内容を管理及び修正する責任を負います。\n4.登録内容に変更があったにもかかわらず、会員が当社所定の手続により変更の届出をしていない場合、当社は、登録内容の変更のないものとして取り扱うことができます。変更の届出があった場合でも、変更登録前に行われた取引や各種手続は、変更登録前の情報に依拠する場合があります。\n5.会員が会員登録や登録内容の変更をしたことにより生じた損害に関し、直接的か間接的かを問わず、当社は一切責任を負わないものとします。",
                          @"1.当社の提供する本サービスは、日本語を理解する者で日本に在住の者を対象としたものであり、日本語を理解しない者は、会員となることができないものとします。ただし、日本に長期在住し、日本語を理解する者で、当社が認める者は、会員となることができるものとします。\n2.満18歳未満の方は、会員になることができません。満18歳以上であっても、未成年の方が会員登録をされるときは、会員となること及び本規約に従って本サービスを利用することについて、事前に親権者の包括的な同意を得なければなりません。当該未成年者は、親権者の同意の有無について、当社から親権者に対し、確認の連絡をする場合があることにあらかじめ同意します。\n3.会員は複数の会員アカウントを持つことができないものとします。",
                          @"1.会員は、登録したログインID及びパスワードを自己の責任と費用にて管理するものとし、会員資格、ログインID及びパスワードを第三者に利用させたり、出品、売買、質入、貸与、賃貸したり、その他形態を問わず処分することはできません。\n2.ログインID及びパスワードの管理不十分による情報の漏洩、使用上の過誤、第三者の使用、不正アクセス等による損害の責任は会員が負うものとし、当社は一切責任を負わないものとします。万一、ログインID及びパスワードが不正に利用されたことにより当社に損害が生じた場合、会員は当該損害を賠償するものとします。\n3.ログインID及びパスワードの情報が第三者に漏洩した場合又はそのおそれがある場合、速やかに当社まで連絡するとともに、当社の指示がある場合にはこれに従うものとします。\n4.会員は、第三者がログイン済みのIDとパスワードを使用して不正に本サービスを利用することを防ぐため、本サービスを利用した後、必ずログアウトをしなければなりません。",
                          @"1.当社は、会員が以下の各号のいずれかに該当した場合又は該当したと当社が判断した場合、事前の通知なく、会員資格の取消、会員に関連するコンテンツや情報の全部もしくは一部の削除、本サービスの全部もしくは一部へのアクセスの拒否等の措置をとることができるものとします。その場合、当社は、その理由を説明する義務を負わないものとします。\n(1)法令又は本規約に違反した場合\n(2)不正行為があった場合\n(3)会員が登録した情報が虚偽の情報である場合\n(4)会員が本規約上必要となる手続又は当社への連絡を行わなかった場合\n(5)会員が登録した情報が既存の登録と重複している場合\n(6)会員が、登録した情報の確認、証明のための資料を提出しない場合\n(7)会員が登録した携帯電話番号又はメールアドレスが不通になったことが判明した場合\n(8)会員が、債務超過、無資力、支払停止又は支払不能の状態に陥った場合\n(9)会員について破産手続開始、民事再生手続開始、会社更生手続開始、特別清算開始もしくはその他適用ある倒産手続開始の申立が行われた場合又は解散もしくは営業停止状態である場合\n(10)会員が法人の場合、法人登録の申請につき、当該法人の経営者の同意を得ていないことが判明した場合\n(11)他の会員や第三者に不当に迷惑をかけた場合\n(12)パスワードの入力に関して当社が判断する一定回数以上の入力ミスがあった場合\n(13)当社が定める一定期間内に一定回数以上のログインがなかった場合\n(14)第8条の会員資格を満たさなくなった場合\n(15)会員が自ら又は第三者をして、暴力的な要求行為、法的な責任を超えた不当な要求行為、脅迫的な言動又は暴力を用いる行為、風評を流布し、偽計を用い又は威力を用いて、信用を毀損又は業務を妨害する行為をした場合\n(16)その他当社が会員に相応しくないと判断した場合\n2.当社は、会員資格を取り消された会員に対し、将来にわたって当社が提供する本サービスの利用及びアクセスを禁止することができることとします。\n3.当社は、本条の措置により生じる損害について、直接的か間接的かを問わず、一切の責任を負わないものとします。\n4.当社は、本条の措置の時点で当該会員に支払われることとなっていた金銭あるいはポイント等について、当社の判断により、無効とすることができるものとします。",
                          @"会員が退会を希望する場合は、当社所定の手続により退会することができます。ただし、退会の手続を行った時点で、取引の決済や品物の郵送等取引の手続が未完のものがある場合は退会することができませんので、会員は、一連の未完の取引を本規約に従って遅滞なく円滑に進め、完了させた後、退会手続きを行う必要があります。",
                          @"1.出品する人は、当社所定の手続により品物の出品を行うものとします。本サービスにおいて出品できる品物は、 古着、靴、アクセサリー、ファッション小物、コスメ、その他本サービス上で表示される品物全てとします。\n2.出品する人は次の各号に挙げるものについての出品ができないことについて予め了承します。以下に該当する品物を出品した場合、出品する人の故意又は過失の有無に関わらず、本規約違反行為とみなします。\n(1)法令に違反する品物\n(2)主として武器として使用される又はそのおそれのある目的を持つ品物\n(3)他人の権利を侵害する又はそのおそれのある品物（偽ブランド品を含むがこれに限られないものとします）\n(4)犯罪により入手した品物\n(5)公序良俗に反する品物（アダルト関連の品物、わいせつな品物、児童ポルノに関連する品物を含むがこれらに限られないものとします）\n(6)品物の取引につき法律上の許認可が必要な品物\n(7)人体・健康に影響を及ぼすおそれのある一切の品物\n(8)コンピュータウィルスを含むデジタルコンテンツ\n(9）その他、当社が不適切と判断する一切の品物\n3.会員が真に出品する意思のない出品、その出品を見た人がその品物情報だけでは正しく品物を理解できないか又は混乱する可能性のある出品、品物説明で十分な説明を行わない出品等を行ってはなりません。出品に関して当社が不適切と判断した場合において、その出品やその出品に対して発生していたゆずってもらう行為等を当社の判断で取り消すことができるものとし、また、当社の判断により、会員資格の取り消しも行うことができるものとします。本項に基づく当社の措置によって会員に生じる損害について、直接的か間接的かを問わず、当社は一切責任を負わないものとします。\n4.会員は、出品にあたっては、古物営業法、特定商取引に関する法律、不当景品類及び不当表示防止法、不正競争防止法、商標法、著作権法その他の法律を遵守しなければなりません。",
                          @"1.ゆずってもらう者は、当社所定の手続により品物をゆずってもらうためのリクエストを行うものとします。\n2.会員は、真にゆずってもらう意思がないにもかかわらず、ゆずってもらうリクエストをしてはなりません。当該リクエストによって、会員等及び第三者に生じる損害につき、直接的か間接的かを問わず、当社は一切責任を負わないものとします。",
                          @"1.ゆずってもらう者からのリクエストに対し、出品する人が承諾することにより、次条第1項に定めるとおり当社とゆずってもらう者と出品する人との間に品物の売買契約が成立するものとします。\n2.出品する人は、ゆずってもらう者からのリクエストに対し承諾するか否かを自由に判断することができるものとします。\n3.ゆずってもらう者は、当社の定める方法により取引に必要なコインを支払うものとします。\n4.出品する人は、品物の発送を完了し、当社の定める方法によりゆずってもらう者に発送済みの連絡をするものとします。\n5.ゆずってもらう者は、届いた品物をすみやかに確認し、当社の定める方法により届いたことを連絡をするものとします。\n6.出品する人とゆずってもらう者の間で品物等に関する問題が発生した場合は原則として両者間で解決するものとします。ただし、取引で生ずるコインに関する問題に関しては状況に応じて当社も協議に入る場合があります。",
                          @"1.当社は、出品された品物を管理し、会員同士の取引をする場を提供するものとします。会員の取引についての責任は一切負わないものであります。",
                          @"1.本サービスのシステム利用に関して支払い又は決済が必要となる場合の詳細については本サービス中の利用ガイドで定められるところによるものとします。\n2.前項の支払い及び決済は、本サービスのオンラインシステムを通じて行われるものとします。\n3.本サービス利用に関し、会員によって支払われたコイン購入についての領収書等は発行されないものとします。\n4.本条に定める支払いに必要な振込手数料その他の費用は、当該会員が負担するものとします。\n5.会員が本規約に従って必要な支払いを行わない場合もしくは遅延した場合又は本サービスに入力したクレジットカードもしくは金融機関の口座の利用が停止されたことが認められた場合には、当社は、当該会員に通知することなく、当該会員による本サービスの利用を停止することができるものとします。\n6.会員が本サービスに入力した決済手段又は金融機関の情報が第三者に利用され、又は入力情報の内容が不正確であったことによって会員に生じた損害については、当社は一切責任を負わないものとします。",
                          @"1.本サービスを利用して出品する人とゆずってもらう者とが、両社で合意した場合は返品を自由に行えるものとします。なお、両者で合意したキャンセル又は返品について当社は一切責任を負いません。\n2.品物に瑕疵がある場合、品物説明と実際の品物が明らかに異なる場合は出品する人が責任を負うものとします。出品する人の責任及び費用により、修理又は交換等の対応を行うものとします。",
                          @"当社は、会員に対してコインを付与することがありますが、理由のいかんを問わず、会員が退会した場合又は会員資格を消滅した場合には、当該時点において保有するコインはすべて失効するものとします。コインの詳細については利用ガイドに定めるとおりとします。",
                          @"1.本サービスをご利用頂くためには、インターネットに接続する必要があり、会員の費用と責任において、本サービスを利用するために必要となる通信回線・機器・ソフトウェアその他一切の手段をご用意頂くことが必要となります。その通信手段・機器・ソフトウェアの設置や操作についても、会員の費用と責任において、適切に行って頂く必要があります。\n2.当社は、前項の機器等の準備、設置、操作に関し、一切関与せず、会員に対するサポートも行いません。\n3.会員は、本サービスを利用する過程で、種々のネットワークを経由することがあることを理解し、接続しているネットワークや機器等によっては、それらに接続したり、それらを通過するために、データや信号等の内容が変更される可能性があることを理解したうえで、本サービスを利用するものとします。",
                          @"1.当社の本サービスに含まれる工業所有権、ノウハウ、プログラム、著作権その他の知的財産権及びそれらに関連する全ての権利は当社に帰属するものとし、あらかじめ当社より書面による承諾を得た場合を除いて、これらの複製、販売等はできないものとします。会員が当社の本サービスを利用する目的でアップロードした著作物の著作権については、当該著作物の著作権者に帰属します。\n2.本サービス上で会員が作成したコンテンツの著作権等の知的財産権は会員に帰属するものとします。ただし、会員は、当社が掲載されたコンテンツを会員の承諾を得ることなく、何らの制限なく自由に編集又は使用することにつき許諾するものとします。また、会員は、かかる利用に対して、当社によるコンテンツの改変や公表の有無等について、著作者人格権を行使しないものとします。\n3.会員が、本サービスにおいて投稿するコンテンツは、原則として自己が著作権その他一切の権利を有するコンテンツに限るものとします。会員が、自己以外の第三者の権利が含まれるコンテンツ（以下「第三者コンテンツ」といいます）の掲載を希望される場合には、本規約の内容及び当該掲載について、当該コンテンツの著作権者を含む一切の権利者（被写体としてプライバシー権を有する方、肖像権を有する方、コンテンツを構成する文章、映像等の著作権を有する方を含みますがこれらに限りません）の承諾を必ず得るものとし、当該承諾を得た第三者コンテンツのみを掲載するものとします。\n4.会員が前項に違反し、当社、他の会員等又は第三者コンテンツの権利者との間にトラブルが発生した場合、会員は自己の費用と責任において当該トラブルの解決を図るものとし、当社に一切の迷惑をかけないものとします。",
                          @"1.会員は、本サービスの利用にあたって、以下の行為又はそのおそれがある行為を行ってはならないものとします。\n(1)当社、他の会員又は第三者の所有権、著作権を含む一切の知的財産権、肖像権、パブリシティー権等の正当な権利を侵害する行為\n(2)当社、他の会員又は第三者に不利益、損害を与える行為\n(3)公序良俗に反する行為\n(4)法律、法令等又は本規約に違反する行為\n(5)本サービスの全部又は一部（コンテンツ、情報、情報の集合体、システム構成又は個別プログラムソースを含むがこれらに限られない）を、転用、転売、送信、頒布、使用、複写、複製、翻訳、翻案、貸与等いかなる手法によるかを問わず、商業目的で利用する行為\n(6)当社の承認がないにも関わらず、本サービスに関連して営利を目的とする行為\n(7)本サービスの運営を妨害する行為\n(8)本サービス上に登録されている品物を本サービスを介さずに行う直接取引やそれを勧誘する行為\n(9)出品する人が自社URLを記載する等の営業行為\n(10)本サービスの信用を失墜、毀損させる行為\n(11)虚偽の情報を登録する行為\n(12)不正に本サービスを利用する行為\n(13)18歳未満の方に本サービス利用を促す行為\n(14)不正に本サービスのポイントを取得する行為\n(15)その他、当社が不適切と判断する行為\n2.前項の場合において、当社が何らかの損害を被った場合、会員は当社に対して損害の賠償をしなければならないものとします。",
                          @"1.当社は、会員が本規約に違反したり又は本規約の精神に照らして不適切な行為を行ったと判断した場合は、当該会員が本サービスに掲載したあらゆるコンテンツを、事前の通知なく、当社の独自の判断で削除できるものとします。\n2.当社は、コンテンツが本サービス内容として適切でないと判断した場合、事前の通知なく、当社の独自の判断で変更又は削除できるものとします。",
                          @"当社は、本サービスの安定的な運営に最善を尽くすものとしますが、以下の各号のいずれかに該当する場合には、会員に事前に通知することなく一時的に本サービスの全部又は一部を中断することができるものとし、当該事由に起因して会員等に損害が発生した場合であっても、一切の責任を負わないものとします。\n(1)サーバー、通信回線若しくはその他の設備の故障、障害の発生又はその他の事由により本サービスの提供ができなくなった場合\n(2)システム（サーバー、通信回線や電源、それらを収容する建築物などを含む）の保守、点検、修理、変更を定期的に又は緊急に行う場合\n(3)火災、停電等により本サービスの提供ができなくなった場合\n(4)地震、噴火、洪水、津波等の天災により本サービスの提供ができなくなった場合\n(5)戦争、変乱、暴動、騒乱、労働争議等その他不可抗力により本サービスの提供ができなくなった場合\n(6)法令又はこれに基づく措置により本サービスの提供ができなくなった場合\n(7)その他、運用上又は技術上当社が本サービスの一時的な中断を必要と判断した場合",
                          @"1.当社は、いつでも任意の理由により、会員に事前に通知することなく、本サービスの全部又は一部を終了又は変更できるものとします。ただし、当社は、本サービスの終了及び変更を行う場合、事前に電子メール又は本サービスのサイト等により会員にその旨を通知するよう努めるものとします。\n2.当社は、前項の本サービスの終了又は変更に起因する損害について、直接的か間接的かを問わず、会員及び第三者に対して一切責任を負わないものとします。",
                          @"1.当社は、会員に通知及び連絡の必要があると当社が判断した場合、会員が登録したスマートフォン用アプリ、会員情報の電子メールアドレス又は住所に対し、メッセージング機能、電子メール又は郵便を用いて通知及び連絡を行います。ただし、親権者の同意を確認するための連絡の場合は、電話により連絡をする場合があります。\n2.当社からの通知及び連絡が不着であったり遅延したりといったことによって生じる損害において、当社は一切の責任を負いません。\n3.会員等が当社に通知、連絡又は問合せをする必要が生じた場合、当社が提供する本サービスのウェブサイト、スマートフォン用アプリ上に記載の窓口に対し、お問い合わせフォームの送信、電子メール又は郵便をもって行うこととし、電話や来訪は受け付けておりません。\n4.前項に基づき会員等から問合せがあった場合、当社は、当社が定める方法により、会員等の本人確認を行うことができるものとします。また、問合せに対する回答方法（電子メール、書面による郵送、電話等）については、その都度当社が最適と考える回答方法を利用して回答することができるものとし、その回答方法は会員等が決めることはできないものとします。",
                          @"1.当社は、本規約に別途定めるもののほか、本サービスに関連して会員間又は会員と第三者間で発生した一切のトラブルについて、一切の責任を負わず、一切関与しません。万一トラブルが生じた際には、当事者間で解決するものとし、当該トラブルにより当社が損害を被った場合は、当事者は連帯して当該損害を賠償するものとします。/n2.当社は、将来本サービスを利用するという前提の下で起こったトラブルについて、一切の責任を負わず、一切関与しません。万一トラブルが生じた場合は、当事者間で解決するものとし、当該トラブルにより当社が損害を被った場合は、当事者は連帯して当該損害を賠償するものとします。\n3.会員等と第三者との間で、本サービスに関連して、裁判やクレーム、請求等あらゆるトラブルを含む紛争が生じた場合、各自の責任や費用で解決するものとし、当社は、当該紛争に関し、一切関与しません。会員等は、当該紛争の対応のために当社に生じた弁護士費用を含むあらゆる費用及び賠償金等を、連帯して負担することに同意するものとします。\n4.会員等は、当社との間で紛争が生じた場合、当該紛争に関連して当社に発生した弁護士費用を含むあらゆる費用を、連帯して負担することに同意するものとします。\n5.本規約において、万が一当社が損害を賠償することとなった場合、故意又は重過失がある場合を除き、当該賠償金額は当社が当事者から受領した手数料の累積総額を上限とします。\n6.当社は、本サービスの内容・品質・水準、サービスの安定的な提供、本サービスの利用に伴う結果等については、一切保証しません。\n7.本サービス提供における、不正確、不適切又は不明瞭な内容、表現又は行為等により、会員及び第三者に対して損害が生じた場合であっても、直接的か間接的かを問わず、当社は、その損害について一切責任を負わないものとします。\n8.当社は、会員等に対して、適宜情報提供やアドバイスを行うことがありますが、それらに対して責任を負うものではありません。また、そのアドバイスや情報提供の正確性や有用性を保証しません。\n9.当社は、本サービスに関連するコンテンツの中に、コンピュータウィルス等有害なものが含まれていないことについては、一切保証しません。当社は、本サービスに関連するコンテンツの中に、コンピュータウィルス等有害なものが含まれていたことにより生じた損害について、直接的か間接的かを問わず、会員等及び第三者に対して一切責任を負わないものとします。\n10.当社は、会員が利用した機器・通信回線・ソフトウェア等により会員又は第三者に生じた損害について、直接的か間接的かを問わず、一切責任を負わないものとします。\n11.当社は、本サービスへのアクセス不能、会員のコンピュータにおける障害、エラー、バグの発生等について、一切責任を負わないものとします。\n12.当社は、コンピュータ、システム、通信回線等の障害により、会員等及び第三者が被った一切の損害（データ消失、システムの中断、不正アクセス等）について、直接的か間接的かを問わず、一切責任を負わないものとします。\n13.当社は、会員等が書き込んだ他のウェブサイト等へのURLにより、そのリンク先で生じた損害について、直接的か間接的かを問わず、一切責任を負わないものとします。",
                          @"本規約は、日本法に基づき解釈されるものとし、会員等と当社の間で生じた紛争については、その内容に応じて東京簡易裁判所又は東京地方裁判所を第一審の専属的合意管轄裁判所とします。", nil];
    UIFont *font1 = [UIFont boldSystemFontOfSize:15];
    UIFont *font2 = [UIFont systemFontOfSize:13];
    UILineBreakMode mode = NSLineBreakByWordWrapping;
    CGSize bounds = CGSizeMake(280, 1000);

    int j = 0;
    for(int i=0 ; i<=27 ; i++){
        UILabel *tlabel = [[UILabel alloc] init];
        CGSize size1 = [[titlearray objectAtIndex:i] sizeWithFont:font1 constrainedToSize:bounds lineBreakMode:mode];
        tlabel.backgroundColor = [UIColor clearColor];
        tlabel.font = font1;
        tlabel.numberOfLines = 100;
        tlabel.lineBreakMode = mode;
        tlabel.frame = CGRectMake(10, j+10, 280, size1.height);
        tlabel.text = [titlearray objectAtIndex:i];
        [self.scroll addSubview:tlabel];
        j = j+size1.height;
        //コメント
        NSString *btitle= [bodyarray objectAtIndex:i];
        CGSize size2 = [btitle sizeWithFont:font2 constrainedToSize:bounds lineBreakMode:mode];
        UILabel *blabel = [[UILabel alloc] init];
        blabel.backgroundColor = [UIColor clearColor];
        blabel.font = font2;
        blabel.numberOfLines = 100;
        blabel.lineBreakMode = mode;
        blabel.frame = CGRectMake(24, j+20, 280, size2.height);
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