//
//  MoviesViewController.m
//  Flix
//
//  Created by Jasdeep Gill on 6/24/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>



@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;




@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    //[self.tableView addSubview:self.refreshControl];

    self.activityIndicator.layer.cornerRadius = 6;
    [self.activityIndicator startAnimating];
    
}

- (void) fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               
               
               NSLog(@"%@", [error localizedDescription]);
               
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                      message:@"The internet connection appears to be offline."
               preferredStyle:(UIAlertControllerStyleAlert)];
               
               // create a cancel action
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                        // handle cancel response here. Doing nothing will dismiss the view.
                                                                 }];
               // add the cancel action to the alertController
               [alert addAction:cancelAction];
               
               // create Try Again action
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                        // handle response here.
                                                                       [self fetchMovies];
                                                                        
                                                                }];
               
               // add the OK action to the alert controller
               [alert addAction:okAction];
               
               [self presentViewController:alert animated:YES completion:^{
               }];
               
           }
        
           else {
               
               //Get the array of movies
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSLog(@"%@", dataDictionary);
               
               //Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
               
               for (NSDictionary *movie in self.movies) {
                   NSLog(@"%@", movie[@"title"]);
               }

               //Reload table view data
               [self.tableView reloadData];
               
           }
           [self.refreshControl endRefreshing];
           [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

// shows how many rows we have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

// creates and configures a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];

    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *posterURLString = movie[@"poster_path"];
    
    // check for '/' in beginning of poster_path
    unichar firstChar = [posterURLString characterAtIndex:0];
    if (firstChar != '/') {
        posterURLString = [@"/" stringByAppendingString:posterURLString];
    }
    
    // low res poster image
    NSString *lowResBaseString = @"https://image.tmdb.org/t/p/w45";
    NSString *fullLowResPosterURLString = [lowResBaseString stringByAppendingString:posterURLString];
    NSURL *posterLowResURL = [NSURL URLWithString:fullLowResPosterURLString];
    [cell.posterView setImageWithURL:posterLowResURL];
    [cell.posterBackgroundView setImageWithURL:posterLowResURL];
    
    // high res poster image
    NSString *highResBaseString = @"https://image.tmdb.org/t/p/original";
    NSString *fullHighResPosterURLString = [highResBaseString stringByAppendingString:posterURLString];
    NSURL *posterHighResURL = [NSURL URLWithString:fullHighResPosterURLString];
    [cell.posterView setImageWithURL:posterHighResURL];
    [cell.posterBackgroundView setImageWithURL:posterHighResURL];
    
    cell.posterView.layer.cornerRadius = 6;
    cell.posterViewBg.layer.cornerRadius = 6;
    cell.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    cell.posterViewBg.layer.shadowRadius = 4;
    cell.posterViewBg.layer.shadowOpacity = 0.55;
    cell.posterViewBg.layer.shadowOffset = CGSizeMake(6, 6);
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
    
}


@end
