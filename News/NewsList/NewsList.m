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
#import "THSHTTPCommunication.h"
#import "PureLayout.h"

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface NewsList () <UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate, NewsCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *articlesFromJSON;
@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@property (strong, nonatomic) UIActivityIndicatorView *waiter;
@property (strong, nonatomic) UIView *placeholder;

@property (assign, nonatomic) BOOL isAlertShowing;

@end

@implementation NewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
  
    [self fetchData:self.url];
}

- (void)setupViews {
    
    self.navigationItem.titleView = [self createTitleViewWithTitle:self.newsListTitle];
    self.navigationItem.rightBarButtonItem = [self createSortButtonItem];
    
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

- (UIView *)createTitleViewWithTitle:(NSString *)title{
    
    UIView *view = [UIView new];
    CGFloat availableWidth = self.view.frame.size.width - 140;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    label.textColor = [UIColor blackColor];
    label.text = title;
    [label sizeToFit];
    
    [view addSubview:label];
    
    CGFloat maxWidth = fmin(label.frame.size.width, availableWidth);
    
    label.frame = CGRectMake(fmax(0, (maxWidth - label.frame.size.width) / 2.0), 0, fmin(label.frame.size.width, maxWidth), label.frame.size.height);
    
    view.frame = CGRectMake(0, 0, maxWidth, label.frame.size.height);
    
    return view;
}

- (UIBarButtonItem *)createSortButtonItem {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    
    return barButton;
}

- (void)showBasicErrorAlert:(NSString *)message {
    if (self.isAlertShowing) {
        return;
    }
    
    self.isAlertShowing = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.isAlertShowing = NO;
}

- (void) refreshButtonPressed{
    [self fetchData:self.url];
}

#pragma mark - waiter, placeholder

- (void)showWaiter {
    if (!self.waiter) {
        self.waiter = [[UIActivityIndicatorView alloc] init];
        self.waiter.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.waiter.color = [UIColor colorWithRed:255./255 green:126./255 blue:121./255 alpha:1.];
    }
    
    [self.view addSubview:self.waiter];
    [self.waiter autoCenterInSuperview];
    [self.waiter startAnimating];
}

- (void)hideWaiter {
    [self.waiter stopAnimating];
    [self.waiter removeFromSuperview];
}

- (void)showPlaceholder {
    if (!self.placeholder) {
        self.placeholder = [UIView new];
        
        self.placeholder.backgroundColor = [UIColor colorWithRed:26./255 green:26./255 blue:26./255 alpha:1.];

    }
    [self.view addSubview:self.placeholder];
    [self.placeholder autoPinEdgesToSuperviewEdges];
    [self.view layoutIfNeeded];
}

- (void)showPlaceholderTest {
    if (!self.placeholder) {
        self.placeholder = [UIView new];
        
        self.placeholder.backgroundColor = [UIColor greenColor];
        
    }
    [self.view addSubview:self.placeholder];
    [self.placeholder autoPinEdgesToSuperviewEdges];
    [self.view layoutIfNeeded];
}

- (void)hidePlaceholder {
    [self.placeholder removeFromSuperview];
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
    
    [cell bind:self.newsList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.newsList[indexPath.row].url != (NSString*)[NSNull null]){
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.newsList[indexPath.row].url]];
        svc.delegate = self;
        [self presentViewController:svc animated:true completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (self.newsList[indexPath.row].isOpened){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
     */
    
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - NewsCellDelegate

- (void)updateCellConstraints:(NewsModel *) newsModel{
    long index = [self.newsList indexOfObject:newsModel];
    self.newsList[index].isOpened = true;
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
           // [self showBasicErrorAlert:@"Internet access is required for the application to work"];
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
    self.newsList = [[NetworkManager fetchData] copy];
    
    //NSLog(@"%@ News Title AAAAAAAAAAAAAAAAAAAAAAABBAAAAAAAqwewcfdsdvdgffdgfdgdgdgdfd",self.newsList[1].title);
    //NSLog(@"%d News Count AAAABBBCCCDDDEEE",(int)self.newsList.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
