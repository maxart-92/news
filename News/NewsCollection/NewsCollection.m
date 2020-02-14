//
//  NewsCollection.m
//  News
//
//  Created by Максим Артемьев on 13.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NewsCollection.h"
#import "NewsModel.h"
#import "NewsCollectionCell.h"
#import <AFNetworking/AFNetworking.h>
#import "PureLayout.h"

@interface NewsCollection () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *articlesFromJSON;
@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@property (assign, nonatomic) CGFloat galleryMinimumLineSpacing;
@property (assign, nonatomic) CGFloat leftContentInset;
@property (assign, nonatomic) CGFloat rightContentInset;
@property (assign, nonatomic) CGFloat topContentInset;
@property (assign, nonatomic) CGFloat bottomContentInset;

@end

@implementation NewsCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupNavigationBar];
    
    [self fetchData:self.url];
}

- (void)setupViews {
    
    self.galleryMinimumLineSpacing = 10;
    self.topContentInset = 10;
    self.leftContentInset = 10;
    self.bottomContentInset = 10;
    self.rightContentInset = 10;
    
    self.view.backgroundColor = [UIColor colorWithRed:26./255 green:26./255 blue:26./255 alpha:1.];
    
    self.collectionView = [self createCollectionView];
    [self.view addSubview:self.collectionView];
    
    NSString *cellId = NSStringFromClass([NewsCollectionCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [self.collectionView autoPinEdgeToSuperviewMargin:ALEdgeTop withInset:0];
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
}

-(UICollectionView *) createCollectionView{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = self.galleryMinimumLineSpacing;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    //collectionView.backgroundColor = [UIColor colorWithRed:26./255 green:26./255 blue:26./255 alpha:1.];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.contentInset = UIEdgeInsetsMake(self.topContentInset, self.leftContentInset, self.bottomContentInset, self.rightContentInset);
    
    return collectionView;
}

- (void)setupNavigationBar {
    self.navigationItem.titleView = [self createTitleViewWithTitle:self.newsCollectionTitle];
    self.navigationItem.rightBarButtonItem = [self createRefreshButtonItem];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (UIBarButtonItem *)createRefreshButtonItem {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    
    return barButton;
}

- (void) refreshButtonPressed{
    [self fetchData:self.url];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newsList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewsCollectionCell class]) forIndexPath:indexPath];
    [cell bind:self.newsList[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = (self.collectionView.frame.size.height - self.topContentInset-self.bottomContentInset-self.galleryMinimumLineSpacing)/2;
    CGFloat cellWidth = (self.collectionView.frame.size.width - self.leftContentInset-self.rightContentInset-self.galleryMinimumLineSpacing)/1.5;
    
    return CGSizeMake(cellWidth, cellHeight);
}


#pragma mark - Data

- (void) fetchData: (NSString *) url {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    [self showPlaceholder];
    [self showWaiter];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            //[self showBasicErrorAlert:@"Something wrong with connection. Internet access is required for the application to work"];
            [self showBasicErrorAlert:error.localizedDescription];
            [self hideWaiter];
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            self.articlesFromJSON = [responseObject valueForKey:@"articles"];
            [self setupModel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            [self hideWaiter];
            [self hidePlaceholder];
        }
    }];
    [dataTask resume];
    
}

- (void)setupModel {
    self.newsList = [NSMutableArray new];
    for (int i = 0; i < self.articlesFromJSON.count; i++){
        NewsModel *newsIt = [NewsModel new];
        newsIt.title = [self.articlesFromJSON[i] valueForKey:@"title"];
        newsIt.newsDescription = [self.articlesFromJSON[i] valueForKey:@"description"];
        newsIt.author = [self.articlesFromJSON[i] valueForKey:@"author"];
        newsIt.publishedAt = [self.articlesFromJSON[i] valueForKey:@"publishedAt"];
        newsIt.name = [[self.articlesFromJSON[i] valueForKey:@"source"] valueForKey:@"name"];
        newsIt.url = [self.articlesFromJSON[i] valueForKey:@"url"];
        newsIt.urlToImage = [self.articlesFromJSON[i] valueForKey:@"urlToImage"];
        newsIt.content = [self.articlesFromJSON[i] valueForKey:@"content"];
 
        [self.newsList addObject:newsIt];
    }
}

@end
