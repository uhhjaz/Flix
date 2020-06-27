//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Jasdeep Gill on 6/25/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>


@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredData;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self fetchMovies];
    
    // set collection view display layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
}

- (void) fetchMovies {
    
    // create api request url for superhero movies
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/1726/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];
    
    // complete api call
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               
               //Get the array of movies
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               //Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
               self.filteredData = dataDictionary[@"results"];
               
               [self.collectionView reloadData];
           }
       }];
    [task resume];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // creates collection cell for movie
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    
    // check for starting '/' in poster_path url
    unichar firstChar = [posterURLString characterAtIndex:0];
    if(firstChar != '/') {
        NSString *slash = @"/";
        posterURLString = [slash stringByAppendingString:posterURLString];
    }
    
    // get and display poster if it exists
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        [cell.posterBlurBackground setImageWithURL:posterURL];
        [cell.posterView setImageWithURL:posterURL];
    }
    else{
        cell.posterBlurBackground.image = nil;
        cell.posterView.image = nil;
    }
        
    // rounds poster corners and sets shadow
    cell.posterView.layer.cornerRadius = 8;
    cell.posterViewBg.layer.cornerRadius = 8;
    cell.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    cell.posterViewBg.layer.shadowRadius = 3;
    cell.posterViewBg.layer.shadowOpacity = 1;
    cell.posterViewBg.layer.shadowOffset = CGSizeMake(8, 8);
    
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    // sets search bar as reusable collection view item in the header
    UICollectionReusableView *searchView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchBar" forIndexPath:indexPath];
    
    return searchView;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // filter movies if there is user input into search bar
    if (searchText.length != 0) {
       
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title contains[c] %@)", searchText];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredData);
        
    }
    
    // no user input into search
    else {
        self.filteredData = self.movies;
    }
    
    [self.collectionView reloadData];
 
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
    
    // create movie disctionary object
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    // initialize movie field for next controller
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
}


@end
