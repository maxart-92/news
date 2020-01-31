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
#import "THSHTTPCommunication.h"

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>


@interface NewsList () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *News;
@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@end

@implementation NewsList


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
  
    [self retrieveArticles];
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

- (void)setupModel {
    self.newsList = [NSMutableArray new];
    for (int i = 0; i < self.News.count; i++){
        
        NewsModel *newsIt = [NewsModel new];
        
        if ([self.News[i] valueForKey:@"title"] != nil) {
            newsIt.title = [self.News[i] valueForKey:@"title"];
        }
        if ([self.News[i] valueForKey:@"author"] != nil) {
            newsIt.author = [self.News[i] valueForKey:@"author"];
        }
        if ([self.News[i] valueForKey:@"publishedAt"] != nil) {
            newsIt.date = [self.News[i] valueForKey:@"publishedAt"];
        }
        
        NSLog(@"%@ News Title",newsIt.title);
        [self.newsList addObject:newsIt];
        
        NSLog(@"%d News Count",(int)self.newsList.count);
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return 2;
    NSLog(@"%d News Count in numberOfRowsInSection",(int)self.newsList.count);
    return 5;
    //return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewsCell class]) forIndexPath:indexPath];
    
    NSLog(@"%d News Count in cellForRowAtIndexPath",(int)self.newsList.count);
    [cell bind:self.newsList[indexPath.row]];
    
    return cell;
}

#pragma mark - Data

- (void) retrieveArticles{
    THSHTTPCommunication *https = [[THSHTTPCommunication alloc] init];
    NSMutableArray *newsListTest = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"];
    
    // получаем новости, используя экземпляр класса THSHTTPCommunication
    [https retrieveURL:url successBlock:^(NSData *response)
     {
         NSError *error = nil;
         
         // десериализуем полученную информацию
         NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
         if (!error)
         {
             self.News = data[@"articles"];
             if (self.News){
                //[self setupModel];
                 
                 for (int i = 0; i < self.News.count; i++){
                     
                     NewsModel *newsIt = [NewsModel new];
                     
                     if ([self.News[i] valueForKey:@"title"] != nil) {
                         newsIt.title = [self.News[i] valueForKey:@"title"];
                     }
                     if ([self.News[i] valueForKey:@"author"] != nil) {
                         newsIt.author = [self.News[i] valueForKey:@"author"];
                     }
                     if ([self.News[i] valueForKey:@"publishedAt"] != nil) {
                         newsIt.date = [self.News[i] valueForKey:@"publishedAt"];
                     }
                     
                     NSLog(@"%@ News Title",newsIt.title);
                     [newsListTest addObject:newsIt];
                     
                     NSLog(@"%d News Count in setupModel",(int)self.newsList.count);
                 }
                 self.newsList = [NSMutableArray new];
                 self.newsList = newsListTest;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                 });
             }
         }
     }];
}

- (void) fetchData {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        self.News = [responseObject valueForKey:@"articles"];
        [self setupModel];
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}

@end
