//
//  NewMovieTableViewCell.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/22.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "NewMovieTableViewCell.h"

@interface NewMovieTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *moviePicture;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;

@end


@implementation NewMovieTableViewCell

- (void)configureWithMovie:(Movie *)movie{
    self.movieName.text = [NSString stringWithFormat:@"%@",movie.movieName];
    self.movieName.shadowColor = [UIColor cyanColor];
    self.movieName.shadowOffset = CGSizeMake(1, 1);
    
    self.movieDescription.text = movie.descriptions;
    
    UIImage *imageurl = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:movie.imageUrl options:NSDataReadingMappedIfSafe error:nil]];
    self.moviePicture.image = imageurl;


}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
