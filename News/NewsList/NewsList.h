//
//  NewsList.h
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsList : BaseViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *newsListTitle;

@end

NS_ASSUME_NONNULL_END
