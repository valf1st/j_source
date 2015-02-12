//
//  JOUploadViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOPhotoFunction.h"
#import "JOEnterViewController.h"

extern UIImage *image1;

@interface JOUploadViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, JOPhotoFunctionDelegate>{
    JOPhotoFunction *photoFunc;
}

@end
