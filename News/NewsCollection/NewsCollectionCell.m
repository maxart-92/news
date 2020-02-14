//
//  NewsCollectionCell.m
//  News
//
//  Created by Максим Артемьев on 13.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NewsCollectionCell.h"
#import "PureLayout.h"
#import <SDWebImage/SDWebImage.h>

@interface NewsCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UILabel *publishedAt;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoTopConstraint;

@property (strong, nonatomic) NewsModel *newsItem;

@end

@implementation NewsCollectionCell

- (void)bind:(NewsModel *)item{
    
    self.newsItem = item;

    self.layer.cornerRadius = 5;
    self.layer.shadowRadius = 6;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(3, 5);
    
    self.clipsToBounds = false;
    
    self.previewImage.contentMode = UIViewContentModeScaleAspectFill;
    self.previewImage.layer.masksToBounds = true;
    self.previewImage.hidden = false;
    
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = true;
    
    [self.infoTopConstraint autoRemove];
    self.infoTopConstraint = [self.title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.previewImage withOffset:2];
    
    if (self.newsItem.title != (NSString*)[NSNull null]){
        self.title.text = self.newsItem.title;
    } else if (self.newsItem.newsDescription != (NSString*)[NSNull null]){
        self.title.text = self.newsItem.newsDescription;
    } else {
        self.title.text = @"";
    }
    
    if (self.newsItem.name != (NSString*)[NSNull null]){
        self.name.text = self.newsItem.name;
    }else {
        self.name.text = @"";
    }
    
    if (self.newsItem.publishedAt != (NSString*)[NSNull null]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [dateFormatter dateFromString:self.newsItem.publishedAt];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.publishedAt.text = [dateFormatter stringFromDate:date];
    }else {
        self.publishedAt.text = @"";
    }
    
    if (self.newsItem.urlToImage != (NSString*)[NSNull null]){
        [self.previewImage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.previewImage withMultiplier:1./2.];
        [self setupPreviewImage:self.newsItem.urlToImage];
    } else {
        [self.infoTopConstraint autoRemove];
        self.infoTopConstraint = [self.title autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.title.superview withOffset:3];
        self.previewImage.hidden = true;
        [self.activityIndicator stopAnimating];
    }
    
}

- (void)setupPreviewImage:(NSString *)urlToImage{
    dispatch_async(dispatch_get_main_queue(), ^{ @try {
        [self.previewImage sd_setImageWithURL:[NSURL URLWithString:urlToImage]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        if (image){
                                            [self.activityIndicator stopAnimating];
                                            [self.infoTopConstraint autoRemove];
                                            self.infoTopConstraint = [self.title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.previewImage withOffset:8];
                                        } else {
                                            [self.activityIndicator stopAnimating];
                                            [self.infoTopConstraint autoRemove];
                                            self.infoTopConstraint = [self.title autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.title.superview withOffset:10];
                                            self.previewImage.hidden = true;
                                        }
                                    }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    });
}

@end
