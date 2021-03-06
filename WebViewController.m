//
//  WebTableViewcontroller.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/14.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "WebViewcontroller.h"
#import "Movie.h"
#import <Social/Social.h>

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)socialAction:(UIBarButtonItem *)sender;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.indicator.color = [UIColor cyanColor];
    self.indicator.hidesWhenStopped = YES;
    [self.indicator sizeToFit];
    [self.indicator startAnimating];
    
    if ([[self.movie.linkUrl absoluteString] isEqualToString:@"https://tw.movies.yahoo.com/movieinfo_main.html/id=0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This Movie is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.movie.linkUrl];
    [self.webView sizeToFit];
    [self.webView loadRequest:request];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self.indicator stopAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)socialAction:(UIBarButtonItem *)sender {
    
    if ([[self.movie.linkUrl absoluteString] isEqualToString:@"https://tw.movies.yahoo.com/movieinfo_main.html/id=0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This Movie is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        //check if device available for service FB
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *social = [[SLComposeViewController alloc] init];
            [social setInitialText:[NSString stringWithFormat:@"I'd LIKE To Share This Movie：%@",self.movie.movieName]];
            [social addURL:self.movie.linkUrl];
            [social addImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:self.movie.imageUrl]]];
            
            [self presentViewController:social animated:YES completion:^{
                NSLog(@"post message success!");
            }];
        }else{
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erorr！", nil) message:NSLocalizedString(@"Sorry >_<\nYour device not allowed to share message to FaceBook", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
@end
