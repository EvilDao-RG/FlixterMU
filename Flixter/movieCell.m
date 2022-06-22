//
//  movieCell.m
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/15/22.
//

#import "movieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation movieCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setMovie:(Movie *)movie {
    _movie = movie;
    
    self.titleLabel.text = self.movie.title;
    self.descriptionLabel.text = self.movie.synopsis;
    
    
    if (self.movie.posterUrl != nil) {
        NSString *baseImageURL = @"https://image.tmdb.org/t/p/w500";
        NSString *posterPath = movie.posterUrl;
        NSString *fullImageURL = [baseImageURL stringByAppendingString:posterPath];
        // Setting the image with the URL
        NSURL *posterURL = [NSURL URLWithString:fullImageURL];
        
        [self.posterView setImageWithURL:posterURL];
    }
}

@end
