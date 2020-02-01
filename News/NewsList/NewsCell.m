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
@property (weak, nonatomic) IBOutlet UILabel *item;
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
    self.previewImage.backgroundColor = [UIColor blueColor];
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
        self.item.text = self.newsItem.title;
    } else {
        self.item.text = @"";
    }
    if (self.newsItem.author != (NSString*)[NSNull null]){
        self.name.text = self.newsItem.name;
    }else {
        self.item.text = @"";
    }
    if (self.newsItem.publishedAt != (NSString*)[NSNull null]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *date = [dateFormatter dateFromString:self.newsItem.publishedAt];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.publishedAt.text = [dateFormatter stringFromDate:date];
    }else {
        self.item.text = @"";
    }
    if (self.newsItem.urlToImage != (NSString*)[NSNull null]){
        [self setupPreviewImage:self.newsItem.urlToImage];
    } else {
        self.infoTopConstraint = [self.infoStackView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.infoStackView.superview withOffset:10];
        self.previewImage.hidden = true;
    }
    
}

- (void)setupPreviewImage:(NSString *)urlToImage{
    dispatch_async(dispatch_get_main_queue(), ^{ @try {
        [self.previewImage sd_setImageWithURL:[NSURL URLWithString:urlToImage]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self.activityIndicator stopAnimating];
                                        if (!image){
                                            [self.infoTopConstraint autoRemove];
                                            self.infoTopConstraint = [self.infoStackView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.infoStackView.superview withOffset:10];
                                            self.previewImage.hidden = true;
                                        }
                                    }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSLog(@"%@ News Title",self.newsItem.title);
    }
    });
}
/*
-(void) updateFieldsViewBottomConstraint{
    if (self.mortageProgram.additionalOffers>0){
        self.mortageMoreStackView.hidden = false;
        [self setButtonText];
        [self setButtonImg];
        [self.fieldsViewBottomConstraint autoRemove];
        self.fieldsViewBottomConstraint = [self.mortageMoreStackView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fieldsView withOffset:20];
    } else {
        self.mortageMoreStackView.hidden = true;
        [self.fieldsViewBottomConstraint autoRemove];
        self.fieldsViewBottomConstraint = [self.fieldsView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.fieldsView.superview withOffset:15];
    }
}
*/
@end
