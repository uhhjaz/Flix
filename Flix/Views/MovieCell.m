//
//  MovieCell.m
//  Flix
//
//  Created by Jasdeep Gill on 6/24/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell


- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMovie:(Movie *)movie {
     self.synopsisLabel.text = movie.synopsisLabel;
     self.titleLabel.text = movie.title;
     
     //[self.posterView setImageWithURL:movie.posterLowResUrl];
     //[self.posterBackgroundView setImageWithURL:movie.posterLowResUrl];
    
     [self.posterView setImageWithURL:movie.posterHighResUrl];
     [self.posterBackgroundView setImageWithURL:movie.posterHighResUrl];
    
     // poster rounding + shadow
     self.posterView.layer.cornerRadius = 6;
     self.posterViewBg.layer.cornerRadius = 6;
     self.posterViewBg.layer.shadowColor = UIColor.blackColor.CGColor;
     self.posterViewBg.layer.shadowRadius = 4;
     self.posterViewBg.layer.shadowOpacity = 0.55;
     self.posterViewBg.layer.shadowOffset = CGSizeMake(6, 6);
}

@end
