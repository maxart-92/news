//
//  ViewController.h
//  News
//
//  Created by Максим Артемьев on 05.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsText : UIViewController

@property (strong, nonatomic, nullable) NSString *newsDescription;
@property (strong, nonatomic, nullable) NSString *content;

@end
NS_ASSUME_NONNULL_END
