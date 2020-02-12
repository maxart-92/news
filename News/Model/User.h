//
//  User.h
//  News
//
//  Created by Максим Артемьев on 10.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic, nullable) NSString *uid;
@property (strong, nonatomic, nullable) NSString *email;

@property (strong, nonatomic, nullable) NSString *firstName;
@property (strong, nonatomic, nullable) NSString *secondName;

@property (strong, nonatomic) NSMutableArray<NewsModel *> *savedNewsList;

- (void)setUpUser: (FIRUser *) currentUser;

@end

NS_ASSUME_NONNULL_END
