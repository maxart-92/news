//
//  BaseViewController.m
//  News
//
//  Created by Максим Артемьев on 12.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

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

@end
