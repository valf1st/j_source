//
//  JOPhotoViewController.h
//  Joton
//
//  Created by Val F on 13/03/21.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOPhotoFunction.h"
#import "JOConfirmViewController.h"

extern UIImage *image1;
extern NSString *w1;
extern NSString *h1;
extern UIImage *image2;
extern NSString *w2;
extern NSString *h2;
extern NSInteger p2;//削除フラグ
extern UIImage *image3;
extern NSString *w3;
extern NSString *h3;
extern NSInteger p3;//削除フラグ

@interface JOPhotoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, JOPhotoFunctionDelegate>{
    JOPhotoFunction *photoFunc;
}

@property (nonatomic,copy) NSString *wphoto;
@property (nonatomic,copy) NSString *exist;

- (IBAction)cancelBtn:(id)sender;

@end
