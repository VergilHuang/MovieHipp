//
//  ParseNewOperation.h
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/30.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kAddMovieNotificationName2;
extern NSString *kMovieResultsKey2;
extern NSString *kMovieErrorNotificationName2;
extern NSString *kMovieMessageErrorKey2;

@interface ParseNewOperation : NSOperation

@property (nonatomic,readonly) NSData *movieData;
-(id)initWithData:(NSData *)ParseData;

@end
