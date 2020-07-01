//
//  Movie.m
//  Flix
//
//  Created by Jasdeep Gill on 7/1/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "Movie.h"
#import "UIImageView+AFNetworking.h"

@implementation Movie


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    self.title = dictionary[@"title"];
    self.synopsisLabel = dictionary[@"overview"];
  
    NSString *posterURLString = dictionary[@"poster_path"];
    
    // check for '/' in beginning of poster_path
    unichar firstChar = [posterURLString characterAtIndex:0];
    if (firstChar != '/') {
        posterURLString = [@"/" stringByAppendingString:posterURLString];
    }
    
    // low res poster image
    if ([dictionary[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *lowResBaseString = @"https://image.tmdb.org/t/p/w45";
        NSString *fullLowResPosterURLString = [lowResBaseString stringByAppendingString:posterURLString];
        self.posterLowResUrl = [NSURL URLWithString:fullLowResPosterURLString];
    }
    else {
       // self.posterLowResUrl = [NSURL URLWithString:@"https://via.placeholder.com/150"];
    }
    
    // high res poster image
    if ([dictionary[@"poster_path"] isKindOfClass:[NSString class]]) {
        
        NSString *highResBaseString = @"https://image.tmdb.org/t/p/original";
        NSString *fullHighResPosterURLString = [highResBaseString stringByAppendingString:posterURLString];
        self.posterHighResUrl = [NSURL URLWithString:fullHighResPosterURLString];
    }
    else {
        //self.posterHighResUrl = [NSURL URLWithString:@"https://via.placeholder.com/150"];
    }
    
   
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    // get and set backdrop poster if it exists
    if ([dictionary[@"backdrop_path"] isKindOfClass:[NSString class]]) {
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        self.backdropUrl = [NSURL URLWithString:fullBackdropURLString];
    }
    else {
        //self.backdropUrl = [NSURL URLWithString:@"https://via.placeholder.com/150"];
    }
    
    // get date in form YYYY-MM-DD, change to Month Day Year
     NSString *numDate = dictionary[@"release_date"];
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"YYYY-MM-dd"];
     NSDate *date = [dateFormat dateFromString:numDate];
     [dateFormat setDateFormat:@"MMMM dd YYYY"];
     NSString* dateInWords = [dateFormat stringFromDate:date];
     self.releaseDateLabel = dateInWords;
    
     // set and display movie og language
     NSString *lang = dictionary[@"original_language"];
     self.languageLabel = lang;
     NSLog(@"%@", lang);
     
     // set and display number of votes for movie
     NSNumber *votes = dictionary[@"vote_count"];
     self.voteCountLabel = [votes stringValue];
     if ( votes == nil ){
         self.voteCountLabel = @"N/A";
         //self.voteCountLabel.alpha = 0.5;
     }
     
     // set and display movie voted rating
     NSNumber *rating = dictionary[@"vote_average"];
     self.ratingLabel = [rating stringValue];
     if ( rating == nil ){
         self.ratingLabel = @"N/A";
         //self.ratingLabel.alpha = 0.5;
     }
    
    self.movieID = dictionary[@"id"];
    
    return self;
  }


+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *userDictionary = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:userDictionary];
        NSLog(@"%@", userDictionary.title);
    }
    return movies;
}


@end
