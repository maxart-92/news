//
//  MenuViewController.m
//  News
//
//  Created by Максим Артемьев on 03.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "MenuViewControllerOld.h"
#import "MenuCell.h"
#import "NewsList.h"

@interface MenuViewControllerOld () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *newsTypes;

@end

@implementation MenuViewControllerOld

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews {
    self.newsTypes = [NSArray arrayWithObjects:
                      @{@"type":@"Business",
                        @"url":@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"Wall Street",
                        @"url":@"https://newsapi.org/v2/everything?domains=wsj.com&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"TechCrunch",
                        @"url":@"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"Bitcoin",
                        @"url":@"https://newsapi.org/v2/everything?q=bitcoin&from=2020-01-03&sortBy=publishedAt&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"Apple",
                        @"url":@"https://newsapi.org/v2/everything?q=apple&from=2020-02-01&to=2020-02-01&sortBy=popularity&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"}, nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newsTypes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.label.text = [self.newsTypes[indexPath.row] objectForKey:@"type"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewsList" bundle:nil];
    NewsList *newsList = (NewsList *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsList class])];
    newsList.newsListTitle = [self.newsTypes[indexPath.row] objectForKey:@"type"];
    newsList.url = [self.newsTypes[indexPath.row] objectForKey:@"url"];
    [self.navigationController pushViewController:newsList animated:YES];
    
    }


@end
