//
//  MovieViewController.m
//  Flixter
//
//  Created by Gael Rodriguez Gomez on 6/15/22.
//

#import "MovieViewController.h"
#import "movieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


@end

@implementation MovieViewController

- (void)viewDidLoad {
    // Setting up data
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.loadingIndicator startAnimating];
    
    // Do any additional setup after loading the view.
    // Do the call
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

               [self.tableView reloadData];
           }
       }];
    [self.loadingIndicator stopAnimating];
    [task resume];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myMovies.count;
    //return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    movieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.myMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.descriptionLabel.text = movie[@"overview"];
    
    NSString *baseImageURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterPath = movie[@"poster_path"];
    NSString *fullImageURL = [baseImageURL stringByAppendingString:posterPath];
    NSURL *posterURL = [NSURL URLWithString:fullImageURL];
    [cell.posterView setImageWithURL:posterURL];
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    BOOL isSegue = [segue.identifier isEqualToString:@"CatalogToDetails"];
    NSLog(@"Is this our segue:");
    NSLog(@"%d", isSegue);
    
    if(isSegue){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSLog(@"%@", self.myMovies[indexPath.row]);
        NSDictionary *dataToPass = self.myMovies[indexPath.row];
        DetailsViewController *destiny = [segue destinationViewController];
        destiny.movie = dataToPass;
    }
}

@end
