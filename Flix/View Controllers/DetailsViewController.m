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
@property (nonatomic, strong) NSString *trailerURL;
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;


@end


@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    
    // check for starting '/' in poster_path url
    unichar firstChar = [posterURLString characterAtIndex:0];
    if(firstChar != '/') {
        NSString *slash = @"/";
        posterURLString = [slash stringByAppendingString:posterURLString];
    }
    
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    self.posterView.layer.cornerRadius = 6;
    
    self.posterViewBg.layer.cornerRadius = 6;
    self.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    self.posterViewBg.layer.shadowRadius = 4;
    self.posterViewBg.layer.shadowOpacity = 0.45;
    
    self.overviewBg.layer.cornerRadius = 25;
    self.overviewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    self.overviewBg.layer.shadowRadius = 20;
    self.overviewBg.layer.shadowOpacity = .80;
    
    
    self.trailerButton.layer.cornerRadius = self.trailerButton.frame.size.height / 2;
    self.trailerButton.layer.shadowColor = UIColor.blackColor.CGColor;
    self.trailerButton.layer.shadowRadius = 3;
    self.trailerButton.layer.shadowOpacity = .55;
    self.trailerButton.layer.shadowOffset = CGSizeMake(3, 3);
    
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    // get date in form YYYY-MM-DD, change to Month Day Year
    NSString *numDate = self.movie[@"release_date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormat dateFromString:numDate];
    [dateFormat setDateFormat:@"MMMM dd YYYY"];
    NSString* dateInWords = [dateFormat stringFromDate:date];

    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.releaseDateLabel.text = dateInWords;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.releaseDateLabel sizeToFit];
    
    [self fetchTrailers];
    
}


- (void) fetchTrailers {
    // api request format -->> https://api.themoviedb.org/3/movie/619264/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US
    
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    NSString *movieID = self.movie[@"id"];
    NSString *fullURLRequestString = [baseURLString stringByAppendingFormat:@"%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", movieID];
    NSLog(@"%@", fullURLRequestString);
    
    NSURL *url = [NSURL URLWithString:fullURLRequestString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
       NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              
              if (error != nil) {
                  NSLog(@"%@", [error localizedDescription]);
              }
              else {
                  
                  //Get the array of movies
                  NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@", dataDictionary);
                  
                  //Store the movies in a property to use elsewhere
                  NSArray *movieTrailers = dataDictionary[@"results"];
                  
                  NSDictionary *featureTrailer = movieTrailers[0];
                  NSString *key = featureTrailer[@"key"];
                  NSLog(@"THE MOVIE KEY IS:%@", key);
                  
                  NSString *youtubeBaseURL = @"https://www.youtube.com/watch?v=";
                  self.trailerURL = [youtubeBaseURL stringByAppendingString:key];
                  NSLog(@"THE YOUTUBE URL IS:%@", self.trailerURL);
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
