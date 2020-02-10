//
//  ViewController.m
//  News
//
//  Created by Максим Артемьев on 05.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "NewsText.h"

@interface NewsText ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NewsText

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.newsDescription != (NSString*)[NSNull null]){
        self.descriptionLabel.text = self.newsDescription;}
    else self.descriptionLabel.text = @"";
    
    if (self.content != (NSString*)[NSNull null]){
        self.contentTextView.text = self.content;
    }
    else {
        self.contentTextView.text = @"";
    }
    
}

@end
