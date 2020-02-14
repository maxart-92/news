//
//  BaseViewController.m
//  News
//
//  Created by Максим Артемьев on 12.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "BaseViewController.h"
#import "PureLayout.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIView *placeholder;
@property (strong, nonatomic) UIActivityIndicatorView *waiter;
@property (assign, nonatomic) BOOL isAlertShowing;

@end

@implementation BaseViewController

- (UIView *)createTitleViewWithTitle:(NSString *)title{
    
    UIView *view = [UIView new];
    CGFloat availableWidth = self.view.frame.size.width - 140;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    
    [view addSubview:label];
    
    CGFloat maxWidth = fmin(label.frame.size.width, availableWidth);
    label.frame = CGRectMake(fmax(0, (maxWidth - label.frame.size.width) / 2.0), 0, fmin(label.frame.size.width, maxWidth), label.frame.size.height);
    view.frame = CGRectMake(0, 0, maxWidth, label.frame.size.height);
    
    return view;
}

- (void)showPlaceholder {
    if (!self.placeholder) {
        self.placeholder = [UIView new];
        
        self.placeholder.backgroundColor = [UIColor colorWithRed:26./255 green:26./255 blue:26./255 alpha:1.];
        
    }
    [self.view addSubview:self.placeholder];
    [self.placeholder autoPinEdgesToSuperviewEdges];
    [self.view layoutIfNeeded];
}

- (void)hidePlaceholder {
    [self.placeholder removeFromSuperview];
}

- (void)showWaiter {
    if (!self.waiter) {
        self.waiter = [[UIActivityIndicatorView alloc] init];
        self.waiter.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.waiter.color = [UIColor colorWithRed:213./255 green:92./255 blue:70./255 alpha:1.];
    }
    
    [self.view addSubview:self.waiter];
    [self.waiter autoCenterInSuperview];
    [self.waiter startAnimating];
}

- (void)hideWaiter {
    [self.waiter stopAnimating];
    [self.waiter removeFromSuperview];
}

- (void)showBasicErrorAlert:(NSString *)message {
    if (self.isAlertShowing) {
        return;
    }
    
    self.isAlertShowing = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ок" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.isAlertShowing = NO;
}

@end
