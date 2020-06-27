//
//  DetailsViewController.m
//  Flix
//
//  Created by Jasdeep Gill on 6/24/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieTrailerViewController.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIView *posterViewBg;
@property (weak, nonatomic) IBOutlet UIView *overviewBg;
@property (strong, nonatomic) NSString *trailerURL;
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;


@end


@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    // check for starting '/' in poster_path url
    unichar firstChar = [posterURLString characterAtIndex:0];
    if(firstChar != '/') {
        NSString *slash = @"/";
        posterURLString = [slash stringByAppendingString:posterURLString];
    }
    
    // get and set movie poster if it exists
    if ([self.movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        [self.posterView setImageWithURL:posterURL];
    }
    else {
        self.posterView.image = nil;
    }
    
    // get and set backdrop poster if it exists
    if ([self.movie[@"backdrop_path"] isKindOfClass:[NSString class]]) {
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
    }
    else {
        self.backdropView.image = nil;
    }
    
    // movie poster rounded corners + shadow
    self.posterView.layer.cornerRadius = 6;
    self.posterViewBg.layer.cornerRadius = 6;
    self.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    self.posterViewBg.layer.shadowRadius = 4;
    self.posterViewBg.layer.shadowOpacity = 0.45;
    
    // overview description rounded corners + shadow
    self.overviewBg.layer.cornerRadius = 25;
    self.overviewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    self.overviewBg.layer.shadowRadius = 20;
    self.overviewBg.layer.shadowOpacity = .80;
    
    // trailer button rounded corners + shadow
    self.trailerButton.layer.cornerRadius = self.trailerButton.frame.size.height / 2;
    self.trailerButton.layer.shadowColor = UIColor.blackColor.CGColor;
    self.trailerButton.layer.shadowRadius = 3;
    self.trailerButton.layer.shadowOpacity = .55;
    self.trailerButton.layer.shadowOffset = CGSizeMake(3, 3);
    
    // get date in form YYYY-MM-DD, change to Month Day Year
    NSString *numDate = self.movie[@"release_date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormat dateFromString:numDate];
    [dateFormat setDateFormat:@"MMMM dd YYYY"];
    NSString* dateInWords = [dateFormat stringFromDate:date];
    
    // set and display movie og language
    NSString *lang = self.movie[@"original_language"];
    self.languageLabel.text = lang;
    NSLog(@"%@", lang);
    
    // set and display number of votes for movie
    NSNumber *votes = self.movie[@"vote_count"];
    self.voteCountLabel.text = [votes stringValue];
    if ( votes == nil ){
        self.voteCountLabel.text = @"N/A";
        self.voteCountLabel.alpha = 0.5;
    }
    
    // set and display movie voted rating
    NSNumber *rating = self.movie[@"vote_average"];
    self.ratingLabel.text = [rating stringValue];
    if ( rating == nil ){
        self.ratingLabel.text = @"N/A";
        self.ratingLabel.alpha = 0.5;
    }

    // set and display text for movie
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.releaseDateLabel.text = dateInWords;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.releaseDateLabel sizeToFit];
    
    [self fetchTrailers];
    
}


- (void) fetchTrailers {
    
    // create api request url for trailer videos
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    NSString *movieID = self.movie[@"id"];
    NSString *fullURLRequestString = [baseURLString stringByAppendingFormat:@"%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", movieID];
    
    // complete api call
    NSURL *url = [NSURL URLWithString:fullURLRequestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
       NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              
              if (error != nil) {
                  NSLog(@"%@", [error localizedDescription]);
              }
              else {
                  //Get the array of movies trailers
                  NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@", dataDictionary);
                  
                  //Store the movie trailer youtube url in a property
                  NSArray *movieTrailers = dataDictionary[@"results"];
                  NSDictionary *featureTrailer = movieTrailers[0];
                  NSString *key = featureTrailer[@"key"];
                  NSString *youtubeBaseURL = @"https://www.youtube.com/watch?v=";
                  self.trailerURL = [youtubeBaseURL stringByAppendingString:key];

              }
          }];
       [task resume];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MovieTrailerViewController *movieTrailerViewController = [segue destinationViewController];
    movieTrailerViewController.urlString = self.trailerURL;
}


@end
