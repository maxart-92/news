//
//  Menu2ViewController.h
//  News
//
//  Created by Максим Артемьев on 04.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MenuDelegate <NSObject>

- (void)toggleSidebar;

@end

@interface Menu : BaseViewController

@property (weak, nonatomic) id<MenuDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
