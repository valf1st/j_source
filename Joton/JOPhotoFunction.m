//
//  JOPhotoFunction.m
//  Joton
//
//  Created by Val F on 13/04/08.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOPhotoFunction.h"

@interface JOPhotoFunction ()

@end

@implementation JOPhotoFunction

@synthesize delegate;

- (void)photoFunction:(NSDictionary *)info size:(float)size camera:(int)p{
    // オリジナル画像
	UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	// 編集画像
	UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage *saveImage;
	if(editedImage){
		saveImage = editedImage;
	}else{
		saveImage = originalImage;
	}
    UIImage *aImage = saveImage;
    //撮影だったらカメラロールに保存
    if(p == 1){
        UIImageWriteToSavedPhotosAlbum(aImage, nil, nil, nil);
    }
    
    //if ([picker respondsToSelector:@selector(presentingViewController)]) {
        // 取得した画像の縦サイズ、横サイズを取得する
        int imageW = aImage.size.width;
        int imageH = aImage.size.height;
        NSLog(@"%d %d", imageW, imageH);
        //もし640よりでかかったら
        /*if(imageW > size || imageH > size){
            // リサイズする倍率を作成する。
            float scale = (imageW > imageH ? size/imageH : size/imageW);
            // リサイズ後の画像を取得します。
            CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
            UIGraphicsBeginImageContext(resizedSize);
            [aImage drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
            UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *data2 = UIImagePNGRepresentation(resizedImage);
            NSLog(@"gggg1");
            //NSString *str = [data2 base64EncodedString];
            NSLog(@"hhhh1");
            //[delegate didFinishWithPhotoFunction:str image:aImage];
            [delegate didFinishWithPhotoFunction:aImage];
        }else{*/
            //NSData *data2 = UIImagePNGRepresentation(aImage);
            NSLog(@"gggg2");
            //NSString *str = [data2 base64EncodedString];
            NSLog(@"hhhh2");
            //[delegate didFinishWithPhotoFunction:str image:aImage];
    [delegate didFinishWithPhotoFunction:aImage width:imageW height:imageH];
        //}
        
    /*} else {
        NSLog(@"bbbb");
        //[[picker parentViewController] dismissViewControllerAnimated:YES completion: nil];
    }*/
}

// ==================================================
// 画像の回転
// 入力
// (UIImage *)image 回転したい画像
// (CGRect)rect 回転したい角度(0,90,180,270)
// 出力
// 回転した画像
// ==================================================
- (UIImage*)rotateImage:(UIImage*)img angle:(int)angle
{
    CGImageRef img_ref = [img CGImage];
    CGContextRef context;
    UIImage *rotate_image;
    switch (angle) {
        case 0:
            rotate_image = img;
            return rotate_image;
            break;
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, M_PI/2.0);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI/2.0);
            break;
        default:
            return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), img_ref);
    rotate_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return rotate_image;
}

+ (id)instance
{
    static id _instance = nil;
    @synchronized(self) {
        if (!_instance){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

@end
