//
//  NewsList.h
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsList : UIViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;

@end

NS_ASSUME_NONNULL_END
