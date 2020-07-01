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
#import "Movie.h"
#import "MovieApiManager.h"


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
    
    [self.posterView setImageWithURL:self.movie.posterHighResUrl];
    [self.backdropView setImageWithURL:self.movie.backdropUrl];
    
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
    
    // set and display movie og language
    self.languageLabel.text = self.movie.languageLabel;
    
    // set and display number of votes for movie
    self.voteCountLabel.text = self.movie.voteCountLabel;
    //self.voteCountLabel.alpha = 0.5;

    // set and display movie voted rating
    self.ratingLabel.text = self.movie.ratingLabel;
    //self.ratingLabel.alpha = 0.5;

    // set and display text for movie
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsisLabel;
    self.releaseDateLabel.text = self.movie.releaseDateLabel;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.releaseDateLabel sizeToFit];
    
    [self fetchTrailers];
    
}


- (void) fetchTrailers {
    
    NSString *movieID = self.movie.movieID;

    MovieApiManager *manager = [MovieApiManager new];
    
    [manager :movieID fetchTrailers:^(NSString *trailers, NSError *error) {
        if (trailers) {
            NSLog(@"Successfully loaded movies timeline");
            self.trailerURL = trailers;
            
            
        } else {
            NSLog(@"Error getting movies : %@", error.localizedDescription);
            
        }
    
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MovieTrailerViewController *movieTrailerViewController = [segue destinationViewController];
    movieTrailerViewController.urlString = self.trailerURL;
}


@end
