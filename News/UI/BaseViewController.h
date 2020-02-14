//
//  BaseViewController.h
//  News
//
//  Created by Максим Артемьев on 12.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

- (UIView *)createTitleViewWithTitle:(NSString *)title;

- (void)showPlaceholder;
- (void)hidePlaceholder;

- (void)showWaiter;
- (void)hideWaiter;

- (void)showBasicErrorAlert:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
