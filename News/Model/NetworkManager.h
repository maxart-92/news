//
//  NetworkManager.h
//  News
//
//  Created by Татьяна Ежакова on 31.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (NSMutableArray *) fetchData;

@end

NS_ASSUME_NONNULL_END
