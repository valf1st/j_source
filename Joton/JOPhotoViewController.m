//
//  JOPhotoViewController.m
//  Joton
//
//  Created by Val F on 13/03/21.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOPhotoViewController.h"

@interface JOPhotoViewController ()

@end

@implementation JOPhotoViewController

//@synthesize wphoto = _wphoto;

UIButton *camera, *camroll, *rotate, *next, *delete;
UIImageView *imageView;
UIImage *saveImage;
int p, width, height;
NSString *str;

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

    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 50, 320, 320);
    [self.view addSubview:imageView];

    camera = [UIButton buttonWithType:UIButtonTypeCustom];
    camera.frame = CGRectMake(80, 200, 160, 40);
    [camera setBackgroundImage:[UIImage imageNamed:@"btnCamera.png"] forState:UIControlStateNormal];
    [self.view addSubview:camera];
    [camera addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];

    camroll = [UIButton buttonWithType:UIButtonTypeCustom];
    camroll.frame = CGRectMake(80, 250, 160, 40);
    [camroll setBackgroundImage:[UIImage imageNamed:@"btnSelect.png"] forState:UIControlStateNormal];
    [self.view addSubview:camroll];
    [camroll addTarget:self action:@selector(camroll:) forControlEvents:UIControlEventTouchUpInside];

    if([_exist intValue] == 1){
        delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(80, 300, 160, 40);
        [delete setBackgroundImage:[UIImage imageNamed:@"btnDeleteImg.png"] forState:UIControlStateNormal];
        [self.view addSubview:delete];
        [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }

    //回転ボタン
    rotate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rotate.frame = CGRectMake(30, 370, 35, 32);
    UIImage *rot = [UIImage imageNamed:@"iconRotation.png"];
    [rotate setBackgroundImage:rot forState:UIControlStateNormal];
    [self.view addSubview:rotate];
    [rotate addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];

    //決定ボタン
    next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    if([_wphoto intValue] == 1){
        image1 = aImage;
        //photo2 = str;
    }else
    if([_wphoto intValue] == 2){
        image2 = aImage;
        //photo2 = str;
    }else{
        image3 = aImage;
        //photo3 = str;
    }
    width = w;
    height = h;

    camera.hidden = TRUE;
    camroll.hidden = TRUE;
    delete.hidden = TRUE;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    //self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    rotate.hidden = FALSE;
    next.hidden = FALSE;
}

- (void)delete:(id)sender{
    if([_wphoto intValue] == 2){
        image2 = NULL;
        p2 = 1;
    }else{
        image3 = NULL;
        p3 = 1;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)next:(id)sender {

    NSLog(@"wphoto = %@", _wphoto);
    if([_wphoto intValue] == 1){
        image1 = imageView.image;
        w1 = [NSString stringWithFormat:@"%d",width];
        h1 = [NSString stringWithFormat:@"%d",height];
    }else if([_wphoto intValue] == 2){
        image2 = imageView.image;
        w2 = [NSString stringWithFormat:@"%d",width];
        h2 = [NSString stringWithFormat:@"%d",height];
    }else{
        image3 = imageView.image;
        w3 = [NSString stringWithFormat:@"%d",width];
        h3 = [NSString stringWithFormat:@"%d",height];
    }

    //撮影だったらカメラロールに保存
    if(p == 1){
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rotate:(id)sender {
    // 90度回転する
	//imageView.transform = CGAffineTransformMakeRotation(90.0f * M_PI / 180.0f);
    if([_wphoto intValue] == 1){
        image1 = [photoFunc rotateImage:imageView.image angle:270];
        imageView.image = image1;
    }else if([_wphoto intValue] == 2){
        image2 = [photoFunc rotateImage:imageView.image angle:270];
        imageView.image = image2;
    }else{
        image3 = [photoFunc rotateImage:imageView.image angle:270];
        imageView.image = image3;
    }
	//NSData *data = UIImagePNGRepresentation(image1);
	//NSString *str = [data base64EncodedString];
	//photodata = str;
}

- (IBAction)cancelBtn:(id)sender {
    if([_wphoto intValue] == 1){
        image1 = NULL;
    }else if([_wphoto intValue] == 2){
        image2 = NULL;
        p2 = 0;
    }else{
        image3 = NULL;
        p3 = 0;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end