//
//  ParseOperation.h
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/9.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kAddMovieNotificationName;
extern NSString *kMovieResultsKey;
extern NSString *kMovieErrorNotificationName;
extern NSString *kMovieMessageErrorKey;


@interface ParseOperation : NSOperation

@property (nonatomic,readonly) NSData *movieData;

-(id)initWithData:(NSData *)ParseData;

@end
