//
//  JOBank2ViewController.h
//  Joton
//
//  Created by Val F on 13/06/19.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFunctionsDefined.h"
#import "JOAsyncConnection.h"

@interface JOBank2ViewController : UIViewController<JOAsyncConnectionDelegate>{
    JOAsyncConnection *async;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (nonatomic, copy) NSString *sname;
@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSString *rakuten;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *amount;

@end
