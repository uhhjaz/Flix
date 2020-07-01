//
//  MovieApiManager.m
//  Flix
//
//  Created by Jasdeep Gill on 7/1/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "MovieApiManager.h"
#import "Movie.h"

@interface MovieApiManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MovieApiManager

- (id)init {
    self = [super init];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    return self;
}

- (void) fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            completion(nil, error);
        }
        
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSArray *dictionaries = dataDictionary[@"results"];
            NSArray *movies = [Movie moviesWithDictionaries:dictionaries];

            // The network request has completed, and succeeded.
            // Invoke the completion block with the movies array.
            // Think of invoking a block like calling a function with parameters
            completion(movies, nil);
        }
    }];
    [task resume];
}

- (void):(NSString *)movieID fetchTrailers:(void(^)(NSString *trailers, NSError *error))completion;{
    // create api request url for trailer videos
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
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
                  NSString *trailerURL = [youtubeBaseURL stringByAppendingString:key];
                  
                  completion(trailerURL, nil);

              }
          }];
    [task resume];
}


@end
