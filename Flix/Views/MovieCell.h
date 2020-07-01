//
//  MovieCell.h
//  Flix
//
//  Created by Jasdeep Gill on 6/24/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *posterBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *posterViewBg;
@property (nonatomic, strong) Movie *movie;

- (void)setMovie:(Movie *)movie;

@end

NS_ASSUME_NONNULL_END
