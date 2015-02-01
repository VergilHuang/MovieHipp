//
//  TabBarController.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/2/1.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];


//    self.tabBar.barTintColor = [UIColor blackColor];
    self.tabBar.barStyle = UIBarStyleBlackOpaque;
    self.tabBar.tintColor = [UIColor cyanColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
