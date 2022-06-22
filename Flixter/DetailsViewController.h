//
//  DetailsViewController.h
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/16/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Movie *movie;
@end

NS_ASSUME_NONNULL_END
