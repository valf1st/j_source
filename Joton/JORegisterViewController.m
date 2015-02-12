//
//  JORegisterViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JORegisterViewController.h"

@interface JORegisterViewController ()

@end

@implementation JORegisterViewController

UITextField *nametf, *mailtf, *passtf;
int p, tftag;
NSString *str, *mail, *name, *icon;
UIImagePickerController *picker;
NSArray *rres;
UIView *rview, *alertview;
UILabel *alert;
UIImageView *mailiv, *passiv, *nameiv, *arrowcheck, *iconview;
UIBarButtonItem *confirm;

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

    self.navigationItem.title = @"新規登録";

    [self.scroll setScrollEnabled:YES];
    [self.scroll setContentSize:CGSizeMake(320, 480)];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //ナビゲーションバーにボタンを追加
    confirm = [[UIBarButtonItem alloc] initWithTitle:@"登録" style:UIBarButtonItemStyleBordered target:self action:@selector(reg:)];
    [confirm setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[confirm];

    //fb
    UIButton *fbbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fbbtn.frame = CGRectMake(10, 35, 300, 47);
    [fbbtn setBackgroundImage:[UIImage imageNamed:@"bgFB.png"] forState:UIControlStateNormal];
    [fbbtn setTitle:@"Facebookの情報を使用する" forState:UIControlStateNormal];
    [fbbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.scroll addSubview:fbbtn];
    [fbbtn addTarget:self action:@selector(fb:) forControlEvents:UIControlEventTouchUpInside];
    //アイコン
    UIImageView *fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconFB.png"]];
    fb.frame = CGRectMake(10, 12, 22, 22);
    [fbbtn addSubview:fb];
    //やじるし
    arrowcheck = [[UIImageView alloc] initWithFrame:CGRectMake(280, 15, 11, 17)];
    arrowcheck.image = [UIImage imageNamed:@"iconArrow.png"];
    [fbbtn addSubview:arrowcheck];

    //たいとる
    UILabel *aclabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 95, 200, 20)];
    aclabel.text = @"アカウント";
    aclabel.backgroundColor = [UIColor clearColor];
    aclabel.textColor = [UIColor grayColor];
    aclabel.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll addSubview:aclabel];

    //枠
    UIView *afv = [[UIView alloc]initWithFrame:CGRectMake(10, 120, 300, 91)];
    afv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgAccount.png"]];
    [self.scroll addSubview:afv];

    mailtf = [[UITextField alloc]initWithFrame:CGRectMake(40, 10, 250, 30)];
    mailtf.borderStyle = UITextBorderStyleNone;
    mailtf.placeholder = @"メールアドレス(ログインID)";
    mailtf.keyboardType = UIKeyboardTypeEmailAddress;
    [afv addSubview:mailtf];
    mailtf.delegate = self;
    mailtf.tag = 0;
    //アイコン
    mailiv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 21, 16)];
    mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    [afv addSubview:mailiv];

    passtf = [[UITextField alloc]initWithFrame:CGRectMake(40, 55, 250, 30)];
    passtf.borderStyle = UITextBorderStyleNone;
    passtf.placeholder = @"パスワード";
    passtf.secureTextEntry = YES;
    [afv addSubview:passtf];
    passtf.delegate = self;
    passtf.tag = 1;
    //アイコン
    passiv = [[UIImageView alloc] initWithFrame:CGRectMake(13, 56, 15, 21)];
    passiv.image = [UIImage imageNamed:@"iconPass.png"];
    [afv addSubview:passiv];

    //たいとる
    UILabel *prlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 225, 200, 20)];
    prlabel.text = @"プロフィール";
    prlabel.backgroundColor = [UIColor clearColor];
    prlabel.textColor = [UIColor grayColor];
    prlabel.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll addSubview:prlabel];

    //枠
    UIView *prv = [[UIView alloc]initWithFrame:CGRectMake(10, 250, 300, 137)];
    prv.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgProfile.png"]];
    [self.scroll addSubview:prv];

    nametf = [[UITextField alloc]initWithFrame:CGRectMake(40, 13, 250, 30)];
    nametf.borderStyle = UITextBorderStyleNone;
    nametf.placeholder = @"ユーザー名";
    [prv addSubview:nametf];
    nametf.delegate = self;
    nametf.tag = 2;
    //アイコン
    nameiv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    nameiv.image = [UIImage imageNamed:@"iconUsername.png"];
    [prv addSubview:nameiv];

    //アイコンボタン
    iconview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 80, 80)];
    iconview.image = [UIImage imageNamed:@"iconUser.png"];
    [prv addSubview:iconview];
    //ボタン
    UIButton *iconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconbtn.frame = CGRectMake(5, 50, 290, 90);
    [iconbtn setTitle:@"　　　アイコンを選択" forState:UIControlStateNormal];
    [iconbtn setBackgroundColor:[UIColor clearColor]];
    [iconbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [iconbtn setTitleColor:[UIColor purpleColor] forState:UIControlStateHighlighted];
    [prv addSubview:iconbtn];
    [iconbtn addTarget:self action:@selector(icon:) forControlEvents:UIControlEventTouchUpInside];

    //注意書き
    UILabel *exlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 410, 300, 50)];
    exlabel.backgroundColor = [UIColor clearColor];
    exlabel.lineBreakMode = NSLineBreakByWordWrapping;
    exlabel.numberOfLines = 2;
    exlabel.font = [UIFont systemFontOfSize:13];
    exlabel.textColor = [UIColor darkGrayColor];
    exlabel.text = @"登録をタップすることで，＿＿＿＿＿＿＿＿＿＿\nと＿＿＿＿＿＿に同意したものとみなします。";
    [self.scroll addSubview:exlabel];

    //プライバシーポリシー
    UIButton *prbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    prbtn.frame = CGRectMake(165, 412, 140, 30);
    [prbtn setBackgroundColor:[UIColor clearColor]];
    [prbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [prbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    prbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [prbtn setTitle:@"プライバシーポリシー" forState:UIControlStateNormal];
    [self.scroll addSubview:prbtn];
    [prbtn addTarget:self action:@selector(privacy:) forControlEvents:UIControlEventTouchUpInside];

    //サービス規約
    UIButton *tosbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tosbtn.frame = CGRectMake(17, 428, 100, 30);
    [tosbtn setBackgroundColor:[UIColor clearColor]];
    [tosbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [tosbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    tosbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [tosbtn setTitle:@"サービス規約" forState:UIControlStateNormal];
    [self.scroll addSubview:tosbtn];
    [tosbtn addTarget:self action:@selector(tos:) forControlEvents:UIControlEventTouchUpInside];


    //通信中のview
    rview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 700)];
    rview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:rview];
    rview.hidden = TRUE;

    //alertview
    alertview = [[UIView alloc]initWithFrame:CGRectMake(0, -33, 320, 30)];
    alertview.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgError.png"]];
    [self.view addSubview:alertview];
    alert = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    alert.font = [UIFont systemFontOfSize:14];
    alert.textColor = [UIColor whiteColor];
    alert.backgroundColor = [UIColor clearColor];
    [alertview addSubview:alert];

    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 通知センターに通知要求を登録する
    [nc addObserver:self selector:@selector(pop) name:@"logout" object:nil];
}

- (void)privacy:(id)sender{
    JORegisterViewController *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"privacy"];
    [self.navigationController pushViewController:pv animated:YES];
}

- (void)tos:(id)sender{
    JORegisterViewController *tos = [self.storyboard instantiateViewControllerWithIdentifier:@"tos"];
    [self.navigationController pushViewController:tos animated:YES];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:NO];
}

/*- (void)viewWillAppear:(BOOL)animated{
    //自分のuserid
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *myid = [ud stringForKey:@"userid"];
    if(!(myid == nil || [myid isEqual:[NSNull null]])){
        JORegisterViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tbc"];
        [self presentViewController:tbc animated:NO completion:nil];
    }
}*/

-(void)textFieldDidBeginEditing:(UITextField *)sender{
    tftag = sender.tag;
    if(tftag == 2){
        [self viewup];
    }
}
//-- リターンキーがタップされたときキーボードを隠す処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == 0){
        [passtf becomeFirstResponder];
    }else if(textField.tag == 1){
        [nametf becomeFirstResponder];
        [self viewup];
    }else{
        [textField resignFirstResponder];
        [self viewdown];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag == 0){
        mailiv.image = [UIImage imageNamed:@"iconMail.png"];
    }else if(textField.tag == 1){
        passiv.image = [UIImage imageNamed:@"iconPass.png"];
    }else{
        nameiv.image = [UIImage imageNamed:@"iconUsername.png"];
    }
    return YES;
}

- (void)icon:(id)sender {
    [self.scroll endEditing:YES];
    [self viewdown];
    UIActionSheet *as = [[UIActionSheet alloc] init];
    as.delegate = self;
    as.title = @"";
    [as addButtonWithTitle:@"写真を撮る"];
    [as addButtonWithTitle:@"既存から選ぶ"];
    [as addButtonWithTitle:@"キャンセル"];
    as.cancelButtonIndex = 2;
    //    as.destructiveButtonIndex = 0;
    [as showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        p = 1;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            // カメラかライブラリからの読み込み指定。カメラを指定
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            // トリミングなどを行うか否か
            [imagePickerController setAllowsEditing:YES];
            // Delegateをセット
            imagePickerController.delegate = self;
            // アニメーションをしてカメラUIを起動
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if (buttonIndex == 1) {
        p = 2;
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //        picker.sourceType = (sender == takePictureButton) ?    UIImagePickerControllerSourceTypeCamera :
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController: picker animated:YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    photoFunc = [JOPhotoFunction alloc];
    photoFunc.delegate = self;
    [photoFunc photoFunction:info size:320.0f camera:p];
    NSLog(@"go!");
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion: nil];
}

- (void)didFinishWithPhotoFunction:(UIImage *)aImage width:(int)w height:(int)h{
    NSLog(@"back1");
    iconview.image = aImage;
    NSData *data2 = UIImagePNGRepresentation(aImage);
    icon = [data2 base64EncodedString];
}

//fbコネクト
- (void)fb:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    JOAppDelegate *appDelegate = (JOAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.facebook = [[Facebook alloc] initWithAppId:@"138531592997429" andDelegate:self];

    if (![appDelegate.facebook isSessionValid]) {
        //NSArray *permissions = [NSArray arrayWithObjects:@"user_about_me", @"publish_stream",nil];
        //[appDelegate.facebook authorize:permissions];
        [appDelegate.facebook authorize:nil];
    }else{
        [appDelegate fbDidLogin];
    }

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(fbconnected) name:@"fbrequested" object:nil];
}

- (void)fbconnected{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *fbdata = [defaults valueForKeyPath:@"fbdata"];
    if(fbdata){
        arrowcheck.image = [UIImage imageNamed:@"iconCheck.png"];
        arrowcheck.frame = CGRectMake(270, 12, 21, 21);
        nametf.text = [fbdata valueForKeyPath:@"name"];
        mailtf.text = [fbdata valueForKeyPath:@"email"];

        //picture
        NSArray *picturearray = [[fbdata valueForKeyPath:@"picture"] valueForKeyPath:@"data"];
        NSLog(@"picture = %@", [picturearray description]);
        if([[picturearray valueForKeyPath:@"is_silhouette"] intValue] == 1){
            NSLog(@"no picture");
        }else{
            NSLog(@"picture exists");
            NSString *fburl = [picturearray valueForKeyPath:@"url"];
            NSURL* urli = [NSURL URLWithString:fburl];
            NSURLRequest *request = [NSURLRequest requestWithURL:urli];
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 if (data) {
                     //NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                     UIImage *imgi = [UIImage imageWithData:data];
                     iconview.image = imgi;
                     NSLog(@"picture ok");
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     NSData *data2 = UIImagePNGRepresentation(imgi);
                     icon = [data2 base64EncodedString];
                 }
             }];
        }
    }else{
        NSLog(@"not exist");
    }
}

//登録
- (void)reg:(id)sender{
    name = nametf.text;
    mail = mailtf.text;
    NSString *pass = passtf.text;

    //空なら入力してくださいアラート
    if(name.length == 0 || mail.length == 0 || pass.length == 0){
        if(name.length == 0){
            nameiv.image = [UIImage imageNamed:@"iconUsernameError.png"];
            alert.text = @"ユーザー名を入力してください";
        }
        if(pass.length == 0){
            passiv.image = [UIImage imageNamed:@"iconPassError.png"];
            alert.text = @"パスワードを入力してください";
        }
        if(mail.length == 0){
            mailiv.image = [UIImage imageNamed:@"iconMailError.png"];
            alert.text = @"メールアドレスを入力してください";
        }
        [UIView animateWithDuration:0.5 animations:^
        {
            alertview.frame = CGRectMake(0, 0, 320, 33);
        }];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }else if(![JOFunctionsDefined validEmail:mail]){
        alert.text = @"有効なメールアドレスを入力してください";
        [UIView animateWithDuration:0.5 animations:^
         {
             alertview.frame = CGRectMake(0, 0, 320, 33);
         }];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }else if(pass.length < 6){
        alert.text = @"パスワードは6文字以上入力してください";
        [UIView animateWithDuration:0.5 animations:^
         {
             alertview.frame = CGRectMake(0, 0, 320, 33);
         }];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }else if ([JOFunctionsDefined removeForeign:name]){
        alert.text = @"絵文字は入力できません";
        [UIView animateWithDuration:0.5 animations:^
         {
             alertview.frame = CGRectMake(0, 0, 320, 33);
         }];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //fbコネクト情報
        int fb_connect = 0;
        NSString *fbname;
        NSString *fbmail;
        NSString *access_token;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *fbdata = [defaults valueForKeyPath:@"fbdata"];
        NSString *device_token = [defaults valueForKeyPath:@"device_token"];
        NSLog(@"fbdata = %@", fbdata);
        if(fbdata && ![fbdata isEqual:[NSNull null]]){
            NSLog(@"ok fb connected");
            fb_connect = 1;
            fbname = [fbdata valueForKeyPath:@"name"];
            fbmail = [fbdata valueForKeyPath:@"email"];
            access_token = [defaults valueForKeyPath:@"FBAccessTokenKey"];
        }
        rview.hidden = FALSE;
        confirm.enabled = NO;
        if([icon isEqual:[NSNull null]]){
            icon = @"(null)";
        }
        //NSLog(@"icon = %@", [icon substringWithRange:NSMakeRange(1, 12)]);
        NSLog(@"icon = %@", icon);
        //通信
        NSString *dataa = [NSString stringWithFormat:@"name=%@&mail=%@&pass=%@&icon=%@&terminal=%d&fb_connect=%d&fbname=%@&fbmail=%@&access_token=%@&devuce_token=%@&service=reader", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], mail, pass, icon, 1, fb_connect, fbname, fbmail, access_token, device_token];
        NSURL *url = [NSURL URLWithString:URL_REGISTER];
        //通信
        NSURLRequest *request = [JOFunctionsDefined postRequest:dataa url:url timeout:45];
        async = [JOAsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}

//alertバイバイ
- (void)onTimer:(NSTimer *)timer {
    [UIView animateWithDuration:0.5 animations:^
     {
         alertview.frame = CGRectMake(0, -33, 320, 30);
     }];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        rres = response;
        BOOL result = [[rres valueForKeyPath:@"result"] boolValue];
        //失敗した場合（通信エラーorメアドかぶり）
        if(result == FALSE){
            int mcd = 0;
            mcd = [[rres valueForKeyPath:@"message_cd"] intValue];
            if(mcd == 1){
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"このメールアドレスは既に登録されています" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"失敗" message:@"通信エラー" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
                [alert show];
            }
            rview.hidden = TRUE;
        }else{
            //ユーザーデフォルトにuser_idを収納
            NSString *userid = [rres valueForKeyPath:@"user_id"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userid forKey:@"userid"];
            [ud setObject:name forKey:@"username"];
            [ud setObject:mail forKey:@"email"];
            [ud setObject:@"0" forKey:@"coin"];
            [ud setObject:[rres valueForKeyPath:@"fb_seq_id"] forKey:@"fb_seq_id"];
            [ud setObject:[rres valueForKeyPath:@"tw_seq_id"] forKey:@"tw_seq_id"];
            [ud setObject:[rres valueForKeyPath:@"push"] forKey:@"push"];
            [ud synchronize]; 
            rview.hidden = TRUE;
            //ページ遷移
            JORegisterViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tbc"];
            [self presentViewController:tbc animated:YES completion:nil];
        }
    }
    confirm.enabled = YES;
}

- (void)viewup{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, -50, 320, self.scroll.bounds.size.height);
     }];
}

- (void)viewdown{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.scroll.frame = CGRectMake(0, 0, 320, self.scroll.bounds.size.height);
     }];
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
