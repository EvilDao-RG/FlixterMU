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
    // Making the request to the API
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=60403b0c608ff580639e5a011ac4aabe"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Connection failed" message: @"Movies could not be loaded" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *reload = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *reload){
               }];
               [alert addAction:reload];
               [self presentViewController:alert animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.myMovies = dataDictionary[@"results"];
               [self.collectionView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    [self.loadingIndicator stopAnimating];
    [task resume];
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
    NSDictionary *movie = self.myMovies[indexPath.item];
    NSString *baseImageURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPath = movie[@"poster_path"];
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
        NSDictionary *dataToPass = self.myMovies[indexPath.row];
        DetailsViewController *destiny = [segue destinationViewController];
        destiny.movie = dataToPass;
    }
}


@end
