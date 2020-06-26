//
//  MovieCollectionCell.h
//  Flix
//
//  Created by Jasdeep Gill on 6/25/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIView *posterViewBg;
@property (weak, nonatomic) IBOutlet UIImageView *posterBlurBackground;

@end

NS_ASSUME_NONNULL_END
