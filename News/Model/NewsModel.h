//
//  NewsModel.h
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

@property (strong, nonatomic, nullable) NSString *title;
@property (strong, nonatomic, nullable) NSString *author;
@property (strong, nonatomic, nullable) NSString *date;
//@property (strong, nonatomic, nullable) NSString *url;
//@property (strong, nonatomic, nullable) NSString *urlToImage;
//@property (strong, nonatomic, nullable) NSString *publishedAt;

@end

NS_ASSUME_NONNULL_END
