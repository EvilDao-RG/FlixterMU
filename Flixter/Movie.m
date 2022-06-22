//
//  Movie.m
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/21/22.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    self.posterUrl = dictionary[@"poster_path"];
    
    return self;
}


+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray* movies = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in dictionaries){
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];

        [movies addObject:movie];
    }
    return [NSArray arrayWithArray:movies];
}

@end
