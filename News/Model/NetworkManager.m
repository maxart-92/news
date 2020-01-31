//
//  NetworkManager.m
//  News
//
//  Created by Татьяна Ежакова on 31.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>


@interface NetworkManager ()

@property (strong, nonatomic) NSArray *News;
@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@end

@implementation NetworkManager

+ (NSMutableArray *) fetchData{
    
    NSMutableArray *newsList = [NSMutableArray new];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSLog(@"%d News Count",(int)newsList.count);
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            NSArray *News = [responseObject valueForKey:@"articles"];
            //[self setupModel];
            
            for (int i = 0; i < News.count; i++){
                NewsModel *newsIt = [NewsModel new];
                newsIt.title = [News[i] valueForKey:@"title"];
                NSLog(@"%@ News Title",newsIt.title);
                newsIt.author = [News[i] valueForKey:@"author"];
                newsIt.date = [News[i] valueForKey:@"publishedAt"];
                [newsList addObject:newsIt];
                NSLog(@"%d News Count",(int)newsList.count);
            }
            
            //[self setupModel];
            /*
             dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
             });
             */
            
        }
    }];
    [dataTask resume];
    return newsList;
}

- (void)setupModel {
    self.newsList = [NSMutableArray new];
    for (int i = 0; i < self.News.count; i++){
        NewsModel *newsIt = [NewsModel new];
        newsIt.title = [self.News[i] valueForKey:@"title"];
        NSLog(@"%@ News Title",newsIt.title);
        newsIt.author = [self.News[i] valueForKey:@"author"];
        newsIt.date = [self.News[i] valueForKey:@"publishedAt"];
        [self.newsList addObject:newsIt];
        NSLog(@"%d News Count",(int)self.newsList.count);
        
        /*
         self.newsItem.title = [self.News[i] valueForKey:@"title"];
         NSLog(@"%@",self.newsItem.title);
         self.newsItem.author = [self.News[i] valueForKey:@"author"];
         self.newsItem.date = [self.News[i] valueForKey:@"publishedAt"];
         [self.newsList addObject:self.newsItem];
         */
    }
}

/*
 func fetchData() {
 
 NetworkManager.fetchData(url: url2) { (allInfo, articles) in
 self.allInfo = allInfo
 self.articles = articles
 //print(allInfo.articles![0].title!)
 DispatchQueue.main.async {
 self.tableView.reloadData()
 }
 }
 
 }
 */

/*
class NetworkManager {
    static func fetchData(url: String, completion: @escaping (_ allInfo: AllInfo, _ articles: [Article])->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let allInfo = try decoder.decode(AllInfo.self, from: data)
                let articles = allInfo.articles!
                completion(allInfo, articles)
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
}
*/
 
@end
