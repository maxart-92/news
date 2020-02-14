//
//  NewsCollection.h
//  News
//
//  Created by Максим Артемьев on 13.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsCollection : BaseViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *newsCollectionTitle;

@end

NS_ASSUME_NONNULL_END
