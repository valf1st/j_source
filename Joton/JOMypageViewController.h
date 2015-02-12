//
//  JOMypageViewController.h
//  Joton
//
//  Created by Val F on 13/03/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JOFunctionsDefined.h"
#import "JODetailViewController.h"
#import "JOAsyncConnection.h"
#import "JOEditViewController.h"

@interface JOMypageViewController : UIViewController<UIScrollViewDelegate, JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;

    UIView *ssv, *mwaiting;
    UIImageView *newiv, *siv, *myiiv;
    NSMutableDictionary *myres, *myres1, *mypagevc;
    NSMutableArray *itemcheck;
    UIActivityIndicatorView *aiv;
    NSArray *sizes, *conditions;
    NSString *myname, *icon;
    UIButton *mysetting, *myrefresh;
    int reload, myid, mcnct, mjl, mj3, mc3, mc1, mypaging, mysort, mydrawn1, myend3, myend1, mupdate, openedOnBrowseTab;
    //jl, j3は貼るときの高さ用の変数, sortは1列表示か3列表示かの変数, pagingはスクロールページングで読み込んでいいかどうかのフラグ, c1, c3はそれぞれ読み込んである品数の変数, drawn1はdraw1を初回のみ書き込むためのフラグ, end3, end1はもう品物がない時にもっと見るを止めるフラグ
}

@property (strong, nonatomic) IBOutlet UIScrollView *myscroll;

@end