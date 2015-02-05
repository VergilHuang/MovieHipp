//
//  NewMovieTableViewController.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/22.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "NewMovieTableViewController.h"
#import "NewMovieTableViewCell.h"
#import "WebViewController.h"

#import "RankViewController.h"
#import "ParseNewOperation.h"
#import "Movie.h"

static NSString *kGoToWebIdentifier =@"goToWeb";

@interface NewMovieTableViewController ()<NSXMLParserDelegate>

@property (nonatomic,strong) NSOperationQueue *parseQueue;
@property (nonatomic,strong) NSMutableArray *movieList;
@property (nonatomic,strong) Movie *movie;

@end

@implementation NewMovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(CGFloat)1 green:(CGFloat)130/255 blue:(CGFloat)1/255 alpha:1];
    
    
    
    self.movieList = [NSMutableArray array];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newMovieFeedUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        RankViewController *rankViewController = [RankViewController new];
        //if connectionError encounted
        
        if (connectionError != nil) {
            
            [rankViewController handleError:connectionError];
            
        }else{
            
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            if (([HTTPURLResponse statusCode]/100) == 2 && [[response MIMEType] isEqualToString:@"application/rss+xml"]) {
                ParseNewOperation *parseOperation =[[ParseNewOperation alloc] initWithData:data];
                
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMovies:) name:kAddMovieNotificationName2 object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieError:) name:kMovieErrorNotificationName2 object:nil];
    
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
    [self addMovieToList:[[notif userInfo] valueForKey:kMovieResultsKey2]];
}

- (void)MovieError:(NSNotification *)notif{
    assert([NSThread isMainThread]);
    [self handleError:[[notif userInfo] valueForKey:kMovieMessageErrorKey2]];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newMovieCell forIndexPath:indexPath];
    Movie *movie = self.movieList[indexPath.row];
    [cell configureWithMovie:movie];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
self.movie = (Movie *)self.movieList[indexPath.row];

[self performSegueWithIdentifier:kGoToWebIdentifier sender:indexPath];
[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:kGoToWebIdentifier]) {
        WebViewController *webTable = (WebViewController *)[segue.destinationViewController topViewController];
        
        webTable.title = self.movie.movieName;
        webTable.movie = self.movie;
    }
}
@end
