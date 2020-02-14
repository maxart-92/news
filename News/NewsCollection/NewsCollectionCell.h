//
//  NewsCollectionCell.h
//  News
//
//  Created by Максим Артемьев on 13.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsCollectionCell : UICollectionViewCell

- (void)bind:(NewsModel *)item;

@end

NS_ASSUME_NONNULL_END
