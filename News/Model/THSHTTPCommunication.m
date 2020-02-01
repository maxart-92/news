//
//  THSHTTPCommunication.m
//  News
//
//  Created by Татьяна Ежакова on 31.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "THSHTTPCommunication.h"

@interface THSHTTPCommunication ()

@property(nonatomic, copy) void(^successBlock)(NSData *);

@end

@implementation THSHTTPCommunication

- (void)retrieveURL:(NSURL *)url successBlock:(void(^)(NSData *))successBlock{
    // сохраняем данный successBlock для вызова позже
    self.successBlock = successBlock;
    
    // создаем запрос, используя данный url
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // создаем сессию, используя дефолтную конфигурацию и устанавливая наш экземпляр класса как делегат
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    // подготавливаем загрузку
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    // устанавливаем HTTP соединение
    [task resume];
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    // получаем загруженные данные из локального хранилища
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    // гарантируем, что вызов successBlock происходит в главном потоке
    dispatch_async(dispatch_get_main_queue(), ^{
        // вызываем сохраненный ранее блок как колбэк
        self.successBlock(data);
    });
}

@end
