//
//  NetworkManager.m
//  News
//
//  Created by Татьяна Ежакова on 31.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkManager()

@property (strong, nonatomic) NSMutableArray<NewsModel *> *newsList;

@end

@implementation NetworkManager

+ (NSMutableArray<NewsModel *> *) fetchData{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSMutableArray<NewsModel *> *newsList = [NSMutableArray<NewsModel *> new];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSArray *News = [responseObject valueForKey:@"articles"];
            //[self setupModel];
            
            for (int i = 0; i < News.count; i++){
                NewsModel *newsIt = [NewsModel new];
                newsIt.title = [News[i] valueForKey:@"title"];
                newsIt.newsDescription = [News[i] valueForKey:@"description"];
                newsIt.author = [News[i] valueForKey:@"author"];
                newsIt.publishedAt = [News[i] valueForKey:@"publishedAt"];
                newsIt.name = [[News[i] valueForKey:@"source"] valueForKey:@"name"];
                newsIt.url = [News[i] valueForKey:@"url"];
                newsIt.urlToImage = [News[i] valueForKey:@"urlToImage"];
                
                [newsList addObject:newsIt];
                NSLog(@"%d News Count AAAABBBCCCDDDEEE",(int)newsList.count);
            }
        }
    }];
    [dataTask resume];
    NSLog(@"%d News Count AAAABBBCCCDDDEEE",(int)newsList.count);
    //NSLog(@"%@ News Title AAAAAAAAAAAAAAAAAAAAAAABBAAAAAAAqwewcfdsdvdgffdgfdgdgdgdfd", newsList[1].title);
    return newsList;
}

@end
