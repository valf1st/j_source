//
//  JOTabBarController.m
//  Joton
//
//  Created by Val F on 2013/05/01.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "JOTabBarController.h"

@interface JOTabBarController ()

@end

@implementation JOTabBarController

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
	
	// 自分自身をデリゲートに設定
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSLog(@"no:%d",self.selectedIndex);
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]){

		//出品画面を表示する
		JOUploadViewController *controller;
		controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadNavigationID"];
		//モーダルの表示
		[self presentViewController:controller animated:YES completion:nil];

        //JOUploadViewController *controller = [[JOUploadViewController alloc] init];
		//[self presentViewController:controller animated:YES completion:nil];

		//viewController.hidesBottomBarWhenPushed = YES;
		//self.hidesBottomBarWhenPushed = YES;
        return NO;
    }else{
        NSNotification *n = [NSNotification notificationWithName:@"scrollUp" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }

    return YES;
}

@end
