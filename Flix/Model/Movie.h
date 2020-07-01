//
//  Movie.h
//  Flix
//
//  Created by Jasdeep Gill on 7/1/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterLowResUrl;
@property (nonatomic, strong) NSURL *posterHighResUrl;
@property (nonatomic, strong) NSString *synopsisLabel;
@property (nonatomic, strong) NSURL *backdropUrl;
@property (nonatomic, strong) NSString *languageLabel;
@property (nonatomic, strong) NSString *ratingLabel;
@property (nonatomic, strong) NSString *voteCountLabel;
@property (strong, nonatomic) NSString *trailerURL;
@property (strong, nonatomic) NSString *releaseDateLabel;
@property (strong, nonatomic) NSString *movieID;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
