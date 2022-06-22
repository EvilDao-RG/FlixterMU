//
//  CollectionViewController.m
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/17/22.
//

#import "CollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "APIManager.h"
#import "Movie.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end


@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // Loading data from the web
    [self fetchMovies];
    // Refresh control setup
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}


- (void)fetchMovies {
    [self.loadingIndicator startAnimating];

    APIManager *manager = [APIManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.myMovies = movies;
        [self.collectionView reloadData];
    }];
    
    [self.refreshControl endRefreshing];
    [self.loadingIndicator stopAnimating];

}

// Assigns the number of sections in the collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// Loads the data for each cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // Prepares each cell to be loaded
    MovieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    // Getting the image URL
    Movie *movie = self.myMovies[indexPath.item];
    NSString *baseImageURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPath = movie.posterUrl;
    NSString *fullImageURL = [baseImageURL stringByAppendingString:posterPath];
    NSURL *posterURL = [NSURL URLWithString:fullImageURL];
    // Setting the image with the URL
    [cell.posterView setImageWithURL:posterURL];
    return cell;
}

// Assigns the numer of items in the collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myMovies.count;
}

// Adjusting collection view layout settings
- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionLayout.minimumLineSpacing = 15;
    self.collectionLayout.minimumInteritemSpacing = 10;
    self.collectionLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
}

// Preparing data for transition to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Confirms the id of the segue
    BOOL isSegue = [segue.identifier isEqualToString:@"CollectionToDetails"];
    
    if(isSegue){
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        NSLog(@"%@", self.myMovies[indexPath.item]);
        Movie *dataToPass = self.myMovies[indexPath.row];
        DetailsViewController *destiny = [segue destinationViewController];
        destiny.movie = dataToPass;
    }
}


@end
