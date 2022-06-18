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


@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
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
               NSLog(@"%@", dataDictionary);

               [self.collectionView reloadData];
           }
       }];
    [task resume];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *movie = self.myMovies[indexPath.item];
    NSString *baseImageURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPath = movie[@"poster_path"];
    NSLog(@"%@", posterPath);
    NSString *fullImageURL = [baseImageURL stringByAppendingString:posterPath];
    NSURL *posterURL = [NSURL URLWithString:fullImageURL];
    [cell.posterView setImageWithURL:posterURL];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myMovies.count;
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionLayout.minimumLineSpacing = 15;
    self.collectionLayout.minimumInteritemSpacing = 10;
    self.collectionLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BOOL isSegue = [segue.identifier isEqualToString:@"CollectionToDetails"];
    NSLog(@"Is this our segue:");
    NSLog(@"%d", isSegue);
    
    if(isSegue){
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        NSLog(@"%@", self.myMovies[indexPath.item]);
        NSDictionary *dataToPass = self.myMovies[indexPath.row];
        DetailsViewController *destiny = [segue destinationViewController];
        destiny.movie = dataToPass;
    }
}


@end
