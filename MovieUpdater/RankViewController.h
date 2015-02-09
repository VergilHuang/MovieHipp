//
//  ViewController.h
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kMovieCellIdentifier;

//feed url
static NSString *MovieFeedUrlStr = @"https://tw.movies.yahoo.com/rss/tpeboxoffice";

@interface RankViewController : UITableViewController

- (void)handleError:(NSError *)error;

@property (nonatomic,strong) UISearchController *searchController;

@end

