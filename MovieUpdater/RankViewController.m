//
//  ViewController.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "RankViewController.h"
#import "ParseOperation.h"

#import "Movie.h"
#import "MovieTableViewCell.h"
#import "WebViewcontroller.h"

#import <CFNetwork/CFNetwork.h>

NSString *kMovieCellIdentifier = @"movieCell";

static NSString *MovieFeedUrlStr = @"https://tw.movies.yahoo.com/rss/tpeboxoffice";

@interface RankViewController ()

@property (nonatomic,strong) NSMutableArray *movieList;
@property (nonatomic,strong) NSOperationQueue *parseQueue;
@property (nonatomic,strong) Movie *movie;

@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieList = [NSMutableArray array];
    self.title = NSLocalizedString(@"Yahoo 電影排行榜", nil);
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.85 blue:0.9 alpha:0.1];
    self.navigationController.navigationBar.translucent = YES;
    
    
    
    NSURLRequest *MovieUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:MovieFeedUrlStr]];
    
    //send request to web server
    [NSURLConnection sendAsynchronousRequest:MovieUrlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //if connectionError encounted
        if (connectionError != nil) {
            
            [self handleError:connectionError];
            
        }else{
            
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            if (([HTTPURLResponse statusCode]/100) == 2 && [[response MIMEType] isEqualToString:@"application/rss+xml"]) {
                ParseOperation *parseOperation =[[ParseOperation alloc] initWithData:data];
                
                [self.parseQueue addOperation:parseOperation];
            }else{
                NSString *errorStr = NSLocalizedString(@"HTTP Error", @"HTTP 錯誤訊息");
                NSDictionary *userInfoDir = @{NSLocalizedDescriptionKey : errorStr};
                NSError *reportError = [NSError errorWithDomain:errorStr code:[HTTPURLResponse statusCode] userInfo:userInfoDir];
                
                [self handleError:reportError];
            }
        }
    }];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    self.parseQueue = [NSOperationQueue new];
    // 需要增加觀察者在下面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMovies:) name:kAddMovieNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieError:) name:kMovieErrorNotificationName object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAddMovieNotificationName
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kMovieErrorNotificationName
                                                  object:nil];
}

- (void)handleError:(NSError *)error{
    NSString *errorDescreption = [error localizedDescription];
    
    NSString *errorTittle = NSLocalizedString(@"Error", nil);
    NSString *okTittle = NSLocalizedString(@"OK", nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorTittle message:errorDescreption delegate:self cancelButtonTitle:okTittle otherButtonTitles:nil, nil];
    
    [alert show];
    
}

#pragma mark - ConfigureWithNotifacation

- (void)AddMovies:(NSNotification *)notif{
    assert([NSThread isMainThread]);
    [self addMovieToList:[[notif userInfo] valueForKey:kMovieResultsKey]];
}

- (void)MovieError:(NSNotification *)notif{
    assert([NSThread isMainThread]);
    [self handleError:[[notif userInfo] valueForKey:kMovieMessageErrorKey]];
}

#pragma mark - addMovieToList Method

- (void)addMovieToList:(NSArray *)movies{
    NSUInteger startingRow = [self.movieList count];
    NSUInteger MoviesCount = [movies count];
    NSMutableArray *movieArray = [[NSMutableArray alloc] initWithCapacity:MoviesCount];
    //開始列初始為0 在加入物件之後開始列為物件總數
    //每次加一批MoviesCount的數量
    for (NSUInteger row = startingRow; row < (startingRow + MoviesCount); row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [movieArray addObject:indexPath];
    }
    //累加到 電影清單
    [self.movieList addObjectsFromArray:movies];
    
    [self.tableView insertRowsAtIndexPaths:movieArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMovieCellIdentifier];
    Movie *movie = (Movie *)(self.movieList)[indexPath.row];
    [cell configureWithMovie:movie];
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.movieList.count;
}

#pragma mark - UITableViewDelegate

static NSString *kGoWebIdentifier = @"goWeb";


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.movie = (Movie *)self.movieList[indexPath.row];
    [self performSegueWithIdentifier:kGoWebIdentifier sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:kGoWebIdentifier]) {
        WebViewController *webTable = (WebViewController *)[segue.destinationViewController topViewController];
        
        webTable.title = self.movie.movieName;
        webTable.movie = self.movie;
    }
}

@end
