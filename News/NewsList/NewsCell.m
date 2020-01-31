//
//  NewsCell.m
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NewsCell.h"
#import "PureLayout.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) NewsModel *newsItem;

@end

@implementation NewsCell

- (void)bind:(NewsModel *)item{
    
    self.newsItem = item;
    self.previewImage.backgroundColor = [UIColor blueColor];
    self.previewImage.layer.cornerRadius = 10;
    [self.previewImage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.previewImage withMultiplier:1./2.];

    self.item.text = self.newsItem.title;
    self.author.text = self.newsItem.author;
    self.date.text = self.newsItem.date;
}

@end
