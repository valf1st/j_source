//
//  JOUserViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOSendViewController.h"
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOUserViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;

    UIView *usv;
    UIImageView *usiv, *upiv;
    NSArray *sizes, *conditions;
    NSMutableDictionary *ures, *ures1;
    UIActivityIndicatorView *aiv;
    NSString *uicon, *uname;
    UITextField *alertTextField;
    int ureload, ujl, uj3, uc3, uc1, upaging3, usort, udrawn1, uend3, uend1, ucnct, myid;
    //ujl, uj3は貼るときの高さ用の変数, sortは1列表示か3列表示かの変数, pagingはスクロールページングで読み込んでいいかどうかのフラグ, uc1, uc3はそれぞれ読み込んである品数の変数, drawn1はdraw1を初回のみ書き込むためのフラグ
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic,copy) NSString *user;

@end
