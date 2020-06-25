//
//  DetailsViewController.m
//  Flix
//
//  Created by Jasdeep Gill on 6/24/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIView *posterViewBg;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.posterView.layer.cornerRadius = 6;
    
    self.posterViewBg.layer.cornerRadius = 6;
    self.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
    self.posterViewBg.layer.shadowRadius = 4;
    self.posterViewBg.layer.shadowOpacity = 0.45;
    
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
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
