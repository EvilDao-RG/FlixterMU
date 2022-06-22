//
//  movieCell.h
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/15/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface movieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) Movie *movie;
@end

NS_ASSUME_NONNULL_END
