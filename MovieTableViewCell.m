//
//  MovieTableViewCell.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "Movie.h"

@interface MovieTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;

@property (weak, nonatomic) IBOutlet UIImageView *moviePicture;

@end

@implementation MovieTableViewCell

- (void)configureWithMovie:(Movie *)movie{
    self.movieName.text = [NSString stringWithFormat:@"%@",movie.movieName];

    self.movieDescription.text = movie.descriptions;
    
    UIImage *imageurl = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:movie.imageUrl options:NSDataReadingMappedIfSafe error:nil]];
    self.moviePicture.image = imageurl;
}

@end
