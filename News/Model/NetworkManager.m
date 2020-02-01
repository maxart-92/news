//
//  NetworkManager.m
//  News
//
//  Created by Татьяна Ежакова on 31.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

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
                newsIt.author = [News[i] valueForKey:@"author"];
                newsIt.publishedAt = [News[i] valueForKey:@"publishedAt"];
                [newsList addObject:newsIt];
            }
        }
    }];
    [dataTask resume];
    return newsList;
}

@end
