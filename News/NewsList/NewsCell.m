//
//  NewsCell.m
//  News
//
//  Created by Татьяна Ежакова on 30.01.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NewsCell.h"
#import "PureLayout.h"
#import <SDWebImage/SDWebImage.h>

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UILabel *publishedAt;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoTopConstraint;
@property (weak, nonatomic) IBOutlet UIStackView *infoStackView;

@property (strong, nonatomic) NewsModel *newsItem;

@end

@implementation NewsCell
 
- (void)bind:(NewsModel *)item{
    
    self.newsItem = item;
    
    self.previewImage.translatesAutoresizingMaskIntoConstraints = false;
    self.previewImage.contentMode = UIViewContentModeScaleAspectFill;
    self.previewImage.layer.cornerRadius = 10;
    self.previewImage.layer.masksToBounds = true;
    self.previewImage.hidden = false;
    
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = true;
    
    [self.infoTopConstraint autoRemove];
    self.infoTopConstraint = [self.infoStackView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.previewImage withOffset:8];
    
    [self.previewImage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.previewImage withMultiplier:1./2.];
    
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
        [self setupPreviewImage:self.newsItem.urlToImage];
    } else {
        [self.infoTopConstraint autoRemove];
        self.infoTopConstraint = [self.infoStackView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.infoStackView.superview withOffset:10];
        self.previewImage.hidden = true;
        [self.activityIndicator stopAnimating];
    }
    
}

- (void)setupPreviewImage:(NSString *)urlToImage{
    dispatch_async(dispatch_get_main_queue(), ^{ @try {
        [self.previewImage sd_setImageWithURL:[NSURL URLWithString:urlToImage]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        [self.activityIndicator stopAnimating];
                                        //[self.previewImage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.previewImage withMultiplier:(image.size.height/image.size.width)];
                                        [self.delegate updateCellConstraints:self.newsItem];
                                        if (!image){
                                            [self.activityIndicator stopAnimating];
                                            [self.infoTopConstraint autoRemove];
                                            self.infoTopConstraint = [self.infoStackView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.infoStackView.superview withOffset:10];
                                            self.previewImage.hidden = true;
                                            //[self.delegate updateCellConstraints:self.newsItem];
                                        }
                                    }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSLog(@"%@ News Title",self.newsItem.title);
    }
    });
}


- (void)setUpImageSize:(UIImage *)image{
    [self.previewImage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.previewImage withMultiplier:image.size.height/image.size.width];
}

@end
