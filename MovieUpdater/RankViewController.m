//
//  ViewController.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/8.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "RankViewController.h"
#import "ParseOperation.h"
#import "AppDelegate.h"

#import "Movie.h"
#import "MovieTableViewCell.h"
#import "WebViewcontroller.h"

#import <CFNetwork/CFNetwork.h>

NSString *kMovieCellIdentifier = @"movieCell";


@interface RankViewController ()<UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *movieList;
@property (nonatomic,strong) Movie *movie;
@property (nonatomic,strong) NSMutableArray *searchList;


- (void)handleError:(NSError *)error;
@end

@implementation RankViewController{
    Movie *tempMovie;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieList = [NSMutableArray array];
    tempMovie = [Movie new];
    
    //change color of text on the navigationbar
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;


    //View apperence set up
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(CGFloat)1 green:(CGFloat)130/255 blue:(CGFloat)1/255 alpha:1];
    
    
    //notification receive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMovies:) name:kAddMovieNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieError:) name:kMovieErrorNotificationName object:nil];
    
    [self configureSearchBar];

}

- (void)viewWillAppear:(BOOL)animated{
    self.searchController.searchBar.hidden = NO;
//    [self configureSearchBar];
    //reset the searchResult list.
    if ([self.searchController.searchBar isFirstResponder] == NO ) {
        self.searchList = nil;
    }
}


- (void)configureSearchBar{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.definesPresentationContext = YES;
    self.searchController.searchBar.placeholder = @"請輸入電影名稱關鍵字";
    self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;


    //set up searchBar height
    CGRect rect = self.searchController.searchBar.frame;
    rect.size.height = 44.0;
    self.searchController.searchBar.frame = rect;
    

    self.tableView.tableHeaderView = self.searchController.searchBar;

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
    if (cell == nil) {
        cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMovieCellIdentifier];
    }
    if (self.searchList != nil) {
        Movie *movie = (Movie *)self.searchList[indexPath.row];
        [cell configureWithMovie:movie];
    }else{
    Movie *movie = (Movie *)(self.movieList)[indexPath.row];
    [cell configureWithMovie:movie];
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (self.searchList != nil) {
        return self.searchList.count;
    }
    return self.movieList.count;
}

#pragma mark - UITableViewDelegate

static NSString *kGoWebIdentifier = @"goWeb";


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchList != nil) {
        self.movie = (Movie *)self.searchList[indexPath.row];
    }else{
    self.movie = (Movie *)self.movieList[indexPath.row];
    }
    [self performSegueWithIdentifier:kGoWebIdentifier sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hideSearchBar];
}

- (void)hideSearchBar{
    self.searchController.searchBar.text = @"";
//    self.searchController.searchBar
    [self.searchController.searchBar resignFirstResponder];
    self.searchController.active = NO;
    self.searchController.searchBar.hidden = YES;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:kGoWebIdentifier]) {
        WebViewController *webTable = (WebViewController *)[segue.destinationViewController topViewController];
        
        webTable.title = self.movie.movieName;
        webTable.movie = self.movie;
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    if (self.searchList == nil) {
        self.searchList = [NSMutableArray array];
    }
    if ([searchController isActive]) {
        if (searchString.length > 0) {
            for (NSUInteger i = 0; i < self.movieList.count; i++) {
                tempMovie = (Movie *)self.movieList[i];
                if ([tempMovie.movieName containsString:searchString]) {
                    [self.searchList addObject:tempMovie];
                }
            }
        }else{
            self.searchList = nil;
        }
    }else{
        self.searchList = nil;
    }
    [self.tableView reloadData];
}


@end
