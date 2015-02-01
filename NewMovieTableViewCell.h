//
//  NewMovieTableViewCell.h
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/22.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface NewMovieTableViewCell : UITableViewCell

- (void)configureWithMovie:(Movie *)movie;

@end
