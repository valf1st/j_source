//
//  JOUploadViewController.m
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOUploadViewController.h"

@interface JOUploadViewController ()

@end

@implementation JOUploadViewController

UIButton *camera, *camroll, *cancel, *rotate, *next;
UIImageView *imageView;
UIImage *saveImage;
int p;
NSString *photodata;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title = @"譲渡";

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    //self.hidesBottomBarWhenPushed = YES;

    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 20, 320, 320);
    [self.view addSubview:imageView];

    camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(80, 200, 160, 40);
    [camera setBackgroundImage:[UIImage imageNamed:@"btnCamera.png"] forState:UIControlStateNormal];
    //[camera setTitle:@"写真をとる" forState:UIControlStateNormal];
    [self.view addSubview:camera];
    [camera addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];

    camroll = [UIButton buttonWithType:UIButtonTypeCustom];
    camroll.frame = CGRectMake(80, 250, 160, 40);
    [camroll setBackgroundImage:[UIImage imageNamed:@"btnSelect.png"] forState:UIControlStateNormal];
    //[camroll setTitle:@"既存から選ぶ" forState:UIControlStateNormal];
    [self.view addSubview:camroll];
    [camroll addTarget:self action:@selector(camroll:) forControlEvents:UIControlEventTouchUpInside];

    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(80, 300, 160, 40);
    [cancel setBackgroundImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
    //[cancel setTitle:@"キャンセル" forState:UIControlStateNormal];
    [self.view addSubview:cancel];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];

    //回転ボタン
    rotate = [UIButton buttonWithType:UIButtonTypeCustom];
    rotate.frame = CGRectMake(30, 370, 35, 32);
    UIImage *rot = [UIImage imageNamed:@"iconRotation.png"];
    [rotate setBackgroundImage:rot forState:UIControlStateNormal];
    [self.view addSubview:rotate];
    [rotate addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];

    //決定ボタン
    next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(230, 370, 53, 31);
    [next setBackgroundImage:[UIImage imageNamed:@"btnDone.png"] forState:UIControlStateNormal];
    [self.view addSubview:next];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    rotate.hidden = TRUE;
    next.hidden = TRUE;
}

- (void)camera:(id)sender {
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
        
        //imageView.image = image;
        
    }
}

//choose from library ボタン
- (void)camroll:(id)sender {
    p = 2;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //    picker.sourceType = (sender == takePictureButton) ?    UIImagePickerControllerSourceTypeCamera :
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion: nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    photoFunc = [JOPhotoFunction alloc];
    photoFunc.delegate = self;
    [photoFunc photoFunction:info size:640.0f camera:p];
    NSLog(@"go!");
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion: nil];
}

- (void)didFinishWithPhotoFunction:(UIImage *)aImage width:(int)w height:(int)h{
    NSLog(@"back1");
    imageView.image = aImage;
    imageView.frame = CGRectMake(0, 180-160*h/w, 320, 320*h/w);
    image1 = aImage;
    //photodata = str;

    camera.hidden = TRUE;
    camroll.hidden = TRUE;
    cancel.hidden = TRUE;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    //self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    rotate.hidden = FALSE;
    next.hidden = FALSE;

    w1 = [NSString stringWithFormat:@"%d", w];
    h1 = [NSString stringWithFormat:@"%d", h];
}


- (void)next:(id)sender {

    NSLog(@"bring!!");
    //image1 = imageView.image;
    //photo1 = photodata;

    JOEnterViewController *enter = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
    enter.w1 = w1;
    enter.h1 = h1;
    [self.navigationController pushViewController:enter animated:YES];
}

- (void)rotate:(id)sender {
    // 90度回転する
	//imageView.transform = CGAffineTransformMakeRotation(90.0f * M_PI / 180.0f);
	image1 = [photoFunc rotateImage:imageView.image angle:270];
	imageView.image = image1;

	//NSData *data = UIImagePNGRepresentation(image1);
	//NSString *str = [data base64EncodedString];
	//photodata = str;
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    imageView.image = NULL;
    camera.hidden = FALSE;
    camroll.hidden = FALSE;
    cancel.hidden = FALSE;
    rotate.hidden = TRUE;
    next.hidden = TRUE;
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    //タブバー隠す
    //JOUploadViewController *controller = [[JOUploadViewController alloc] init];
    //controller.hidesBottomBarWhenPushed = YES;
    //self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setHidesBottomBarWhenPushed:YES];
    // this will hide the Tabbar
    [self.tabBarController.tabBar setHidden:YES];
}*/
- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

@end
