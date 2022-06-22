//
//  APIManager.h
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
- (id)init;
- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
