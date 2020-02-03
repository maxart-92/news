//
//  NewsCell.h
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NewsCellDelegate <NSObject>

- (void)updateCellConstraints:(NewsModel *)newsModel;

@end

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) id<NewsCellDelegate> delegate;

- (void)bind: (NewsModel *)newsItem;

@end

NS_ASSUME_NONNULL_END
