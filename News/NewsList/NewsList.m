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

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>


@interface NewsList () <UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate, NewsCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *articlesFromJSON;
@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@end

@implementation NewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
  
    [self fetchData];
}

- (void)setupViews {
    
    NSString *cellId = NSStringFromClass([NewsCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
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
    
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - NewsCellDelegate

- (void)updateCellConstraints:(NewsModel *) newsModel{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Data

- (void) fetchData {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            self.articlesFromJSON = [responseObject valueForKey:@"articles"];
            [self setupModel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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
