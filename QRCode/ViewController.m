//
//  ViewController.m
//  QRCode
//
//  Created by admin on 15/8/1.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationItem.rightBarButtonItem = item;
}

/**
 *  切换控制器
 *  @param sender 跳转到二维码界面
 */
- (IBAction)clickQR:(UIButton *)sender {
    
    UIStoryboard *stb = [UIStoryboard storyboardWithName:@"QRBase" bundle:nil];
    UITabBarController *tab = [stb instantiateInitialViewController];
    //push
//    [self.navigationController pushViewController:tab animated:YES];
    //MODA
    [self presentViewController:tab animated:YES completion:nil];
    
}

@end
