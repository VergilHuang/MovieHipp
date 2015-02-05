//
//  AppDelegate.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "AppDelegate.h"
#import "RankViewController.h"
#import "NewMovieTableViewController.h"
#import "ParseOperation.h"

@interface AppDelegate ()

@property (nonatomic,strong) NSOperationQueue *parseQueue;
@property (nonatomic,strong) RankViewController *rank;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    RankViewController *rankViewController = [[RankViewController alloc] init];
        
    //rankingMovieList request
    NSURLRequest *MovieUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:MovieFeedUrlStr]];
    
    //send request to web server
    [NSURLConnection sendAsynchronousRequest:MovieUrlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //if connectionError encounted
        if (connectionError != nil) {
            
            [rankViewController handleError:connectionError];
            
        }else{
            
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            if (([HTTPURLResponse statusCode]/100) == 2 && [[response MIMEType] isEqualToString:@"application/rss+xml"]) {
                ParseOperation *parseOperation =[[ParseOperation alloc] initWithData:data];
                
                [self.parseQueue addOperation:parseOperation];
            }else{
                NSString *errorStr = NSLocalizedString(@"HTTP Error", @"HTTP 錯誤訊息");
                NSDictionary *userInfoDir = @{NSLocalizedDescriptionKey : errorStr};
                NSError *reportError = [NSError errorWithDomain:errorStr code:[HTTPURLResponse statusCode] userInfo:userInfoDir];
                
                [rankViewController handleError:reportError];
            }
        }
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    self.parseQueue = [NSOperationQueue new];
    // 需要增加觀察者在下面

    sleep(0);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"resignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"didEngerBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"willEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"didBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"willTerminate");
}

@end
