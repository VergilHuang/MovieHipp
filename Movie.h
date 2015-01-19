//
//  Movie.h
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property(nonatomic,strong) NSString *movieName;
@property(nonatomic,strong) NSURL *linkUrl;
@property(nonatomic,strong) NSString *descriptions;
@property(nonatomic,strong) NSURL *imageUrl;

@end
