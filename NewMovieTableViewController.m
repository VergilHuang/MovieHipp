//
//  NewMovieTableViewController.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/22.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "NewMovieTableViewController.h"
#import "NewMovieTableViewCell.h"

@interface NewMovieTableViewController ()

@end

@implementation NewMovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newMovieCell forIndexPath:indexPath];

    
    return cell;
}



@end
