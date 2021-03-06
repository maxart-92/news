//
//  NewsList.m
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NewsList.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import "SafariServices/SafariServices.h"
#import "NewsText.h"

#import "TUSafariActivity/TUSafariActivity.h"

#import "THSHTTPCommunication.h"
#import "PureLayout.h"

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface NewsList () <UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate, NewsCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIBarButtonItem *refreshButtonItem;
@property (strong, nonatomic) UIBarButtonItem *changeColorSchemeButtonItem;

@property (strong, nonatomic) NSArray *articlesFromJSON;
@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@property (assign, nonatomic) BOOL isDarkTheme;

@end

@implementation NewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupNavigationBar];
  
    [self fetchData:self.url];
}

- (void)setupViews {

    self.isDarkTheme = false;
    
    NSString *cellId = NSStringFromClass([NewsCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupNavigationBar {
    self.navigationItem.titleView = [self createTitleViewWithTitle:self.newsListTitle];
    self.navigationItem.rightBarButtonItem = [self createRefreshButtonItem];
    
    /*
    self.refreshButtonItem = [self createRefreshButtonItem];
    self.changeColorSchemeButtonItem = [self createChangeColorSchemeButtonItem];
    
    NSMutableArray *items = [NSMutableArray new];
    if (self.refreshButtonItem) {
        [items addObject:self.refreshButtonItem];
    }
    [items addObject:self.changeColorSchemeButtonItem];
    self.navigationItem.rightBarButtonItems = items;
    */
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    /*
     UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonTapped:)];
     self.navigationItem.leftBarButtonItem = backButton;
     */
}

/*
-(void) onBackButtonTapped:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
 */

- (UIBarButtonItem *)createRefreshButtonItem {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    //barButton.tintColor = [UIColor whiteColor];
    
    return barButton;
}


- (UIBarButtonItem *)createChangeColorSchemeButtonItem {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeColorSchemeButtonPressed)];
    
    return barButton;
}


- (void) refreshButtonPressed{
    [self fetchData:self.url];
}


- (void) changeColorSchemeButtonPressed{
    if (self.isDarkTheme){
        self.isDarkTheme = false;
    } else {
    self.isDarkTheme = true;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"%d News Count in numberOfRowsInSection",(int)self.newsList.count);
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewsCell class]) forIndexPath:indexPath];

    /* сделать в классе ячейки метод по смене темы, принимающий bool или сделать его прям в методе bind
    if (self.isDarkTheme){
        cell.backgroundColor = [UIColor blackColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
     */
    
    [cell bind:self.newsList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.newsList[indexPath.row].url != (NSString*)[NSNull null]){
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.newsList[indexPath.row].url]];
        svc.delegate = self;
        [self presentViewController:svc animated:true completion:nil];
    }
    /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewsText" bundle:nil];
        NewsText *newsText = (NewsText *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsText class])];
        newsText.newsDescription = self.newsList[indexPath.row].newsDescription;
        newsText.content = self.newsList[indexPath.row].content;
        [self.navigationController pushViewController:newsText animated:YES];*/
        /*
        NSURL *URL = [NSURL URLWithString:self.newsList[indexPath.row].url];
        TUSafariActivity *activity = [[TUSafariActivity alloc] init];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[activity]];
        
        [self presentViewController:activityViewController animated:YES completion:nil];
         */
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - NewsCellDelegate

- (void)updateCellConstraints:(NewsModel *) newsModel{
    long index = [self.newsList indexOfObject:newsModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
            [self showBasicErrorAlert:error.localizedDescription];
            [self hideWaiter];
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            self.articlesFromJSON = [responseObject valueForKey:@"articles"];
            [self setupModel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
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
        /*test
        if (i == 2){
            newsIt.urlToImage = (NSString*)[NSNull null];
        }
         */
        /*
        NSLog(@"%@ News Title AAAAAAAAAAAAAAAAAAAAAAABBAAAAAAA",newsIt.title);
        }*/
        [self.newsList addObject:newsIt];
        //NSLog(@"%d News Count",(int)self.newsList.count);
    }
}

#pragma mark - Old_Data
- (void) retrieveArticles{
    THSHTTPCommunication *https = [[THSHTTPCommunication alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"];
    self.newsList = [NSMutableArray new];
    // получаем новости, используя экземпляр класса THSHTTPCommunication
    [https retrieveURL:url successBlock:^(NSData *response)
     {
         NSError *error = nil;
         
         // десериализуем полученную информацию
         NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
         if (!error)
         {
             self.articlesFromJSON = data[@"articles"];
             if (self.articlesFromJSON){
                 [self setupModel];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                 });
             }
         }
     }];
}

- (void) loadData{
    self.newsList = [NSMutableArray new];
    self.newsList = [NetworkManager fetchData];
    
    //NSLog(@"%@ News Title AAAAAAAAAAAAAAAAAAAAAAABBAAAAAAAqwewcfdsdvdgffdgfdgdgdgdfd",self.newsList[1].title);
    //NSLog(@"%d News Count AAAABBBCCCDDDEEE",(int)self.newsList.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
