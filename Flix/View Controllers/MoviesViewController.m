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



@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;



@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    // add refresh controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    // loading state while waiting for the movies API begins animating
    self.activityIndicator.layer.cornerRadius = 6;
    [self.activityIndicator startAnimating];
    
}

- (void) fetchMovies {
    
    // make api url for now playing movies
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    // complete api call
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           
        if (error != nil) {

               NSLog(@"%@", [error localizedDescription]);
               
               // creates alert to user
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline."
               preferredStyle:(UIAlertControllerStyleAlert)];
               
               // create a cancel action
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
               
                                                            }];
               // add the cancel action to the alertController
               [alert addAction:cancelAction];
               
               // create Try Again action
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                            style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
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
               self.filteredData = dataDictionary[@"results"];
               
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
    return self.filteredData.count;
}

// creates and configures a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // creates cell from movie
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.filteredData[indexPath.row];

    // displays movie descriptions
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *posterURLString = movie[@"poster_path"];
    
    // check for '/' in beginning of poster_path
    unichar firstChar = [posterURLString characterAtIndex:0];
    if (firstChar != '/') {
        posterURLString = [@"/" stringByAppendingString:posterURLString];
    }
    
    // low res poster image
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *lowResBaseString = @"https://image.tmdb.org/t/p/w45";
        NSString *fullLowResPosterURLString = [lowResBaseString stringByAppendingString:posterURLString];
        NSURL *posterLowResURL = [NSURL URLWithString:fullLowResPosterURLString];
        [cell.posterView setImageWithURL:posterLowResURL];
        [cell.posterBackgroundView setImageWithURL:posterLowResURL];
    }
    else {
        cell.posterView.image = nil;
    }
    
    // high res poster image
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        
        NSString *highResBaseString = @"https://image.tmdb.org/t/p/original";
        NSString *fullHighResPosterURLString = [highResBaseString stringByAppendingString:posterURLString];
        NSURL *posterHighResURL = [NSURL URLWithString:fullHighResPosterURLString];
        [cell.posterView setImageWithURL:posterHighResURL];
        [cell.posterBackgroundView setImageWithURL:posterHighResURL];
    }
    else {
        cell.posterView.image = nil;
    }
    
    // poster rounding + shadow
    cell.posterView.layer.cornerRadius = 6;
    cell.posterViewBg.layer.cornerRadius = 6;
    cell.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    cell.posterViewBg.layer.shadowRadius = 4;
    cell.posterViewBg.layer.shadowOpacity = 0.55;
    cell.posterViewBg.layer.shadowOffset = CGSizeMake(6, 6);
    
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // user input into search abr recieved
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title contains[c] %@)", searchText];

        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredData);
    }
    
    // no user search
    else {
        self.filteredData = self.movies;
    }
    
    [self.tableView reloadData];
 
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // get movie dictionary to pass on to next screen
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    // sends movie array to next controller
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
     
}


@end
