//
//  MovieTableViewCell.h
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;

@interface MovieTableViewCell : UITableViewCell

- (void)configureWithMovie:(Movie *)movie;

@end
