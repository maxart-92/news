//
//  THSHTTPCommunication.h
//  News
//
//  Created by Татьяна Ежакова on 31.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THSHTTPCommunication : NSObject<NSURLSessionDownloadDelegate>

- (void)retrieveURL:(NSURL *)url successBlock:(void(^)(NSData *))successBlock;

@end

NS_ASSUME_NONNULL_END
