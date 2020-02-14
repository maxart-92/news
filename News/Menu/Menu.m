//
//  Menu2ViewController.m
//  News
//
//  Created by Максим Артемьев on 04.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "Menu.h"
#import "NewsList.h"
#import "NewsCollection.h"
#import "Settings.h"
#import <Firebase/Firebase.h>

@interface Menu ()

@property (strong, nonatomic) NSArray *newsTypes;
@property (weak, nonatomic) IBOutlet UIButton *businessButton;
@property (weak, nonatomic) IBOutlet UIButton *wallStreetButton;
@property (weak, nonatomic) IBOutlet UIButton *techCrunchButton;
@property (weak, nonatomic) IBOutlet UIButton *appleButton;
@property (weak, nonatomic) IBOutlet UIButton *bitcoinButton;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation Menu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    [self setupData];
    [self setupNavigationBar];
    [self setupButtonsStyle];
    [self setupTypes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupFeedMode:)
                                                 name:@"setupFeedMode"
                                               object:nil];
    
    //[self.currentUser setUpUser:FIRAuth.auth.currentUser];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setupTypes {
    self.newsTypes = [NSArray arrayWithObjects:
                      @{@"type":@"Business",
                        @"url":@"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"Wall Street",
                        @"url":@"https://newsapi.org/v2/everything?domains=wsj.com&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"TechCrunch",
                        @"url":@"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"Bitcoin",
                        @"url":@"newsapi.org/v2/everything?q=bitcoin&from=2020-01-04&sortBy=publishedAt&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"},
                      @{@"type":@"Apple",
                        @"url":@"https://newsapi.org/v2/everything?q=apple&from=2020-02-01&to=2020-02-01&sortBy=popularity&apiKey=f67e648fe5aa474d9f346ddd1cabdda0"}, nil];
}

- (void)setupNavigationBar {
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.translucent = true;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:198./255 green:73./255 blue:40./255 alpha:1.];
                                                            //colorWithRed:213./255 green:92./255 blue:70./255 alpha:1.];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      //NSFontAttributeName:[UIFont fontWithName:@"Avenir Next Condensed" size:18]
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold]
                                                                      }];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void) setupButtonsStyle {
    NSMutableArray *buttonsArray = [NSMutableArray new];
    [buttonsArray addObject:self.businessButton];
    [buttonsArray addObject:self.wallStreetButton];
    [buttonsArray addObject:self.techCrunchButton];
    [buttonsArray addObject:self.bitcoinButton];
    [buttonsArray addObject:self.appleButton];
    
    for (UIButton *button in buttonsArray){
        button.layer.cornerRadius = 20;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 3;
        [button setTitleColor:([UIColor colorWithRed:198./255 green:73./255 blue:40./255 alpha:1.]) forState:(normal)];
    }
}

- (IBAction)businessButtonPressed:(UIButton *)sender {
    [self openNewsList:0];
}
- (IBAction)wallStreetButtonPressed:(UIButton *)sender {
    [self openNewsList:1];
}
- (IBAction)techCrunchButtonPressed:(UIButton *)sender {
    [self openNewsList:2];
}

- (IBAction)bitcoinButtonPressed:(UIButton *)sender {
    [self openNewsList:3];
}

- (IBAction)appleButtonPressed:(UIButton *)sender {
    [self openNewsList:4];
}

- (void)openNewsList:(int)index{
    if ([self.currentUser.newsFeedMode isEqualToString:@"list"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewsList" bundle:nil];
        NewsList *newsList = (NewsList *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsList class])];
        newsList.newsListTitle = [self.newsTypes[index] objectForKey:@"type"];
        newsList.url = [self.newsTypes[index] objectForKey:@"url"];
        [self.navigationController pushViewController:newsList animated:YES];
    }
    else if ([self.currentUser.newsFeedMode isEqualToString:@"tile"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NewsCollection" bundle:nil];
        NewsCollection *newsList = (NewsCollection *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NewsCollection class])];
        newsList.newsCollectionTitle = [self.newsTypes[index] objectForKey:@"type"];
        newsList.url = [self.newsTypes[index] objectForKey:@"url"];
        [self.navigationController pushViewController:newsList animated:YES];
    }
}

- (IBAction)signOutButtonPressed:(UIBarButtonItem *)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)settingsBarButton:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    Settings *settings = (Settings *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([Settings class])];
    settings.settingsTitle = NSStringFromClass([Settings class]);
    [self.navigationController pushViewController:settings animated:YES];
}

- (void)setupData {
    
    self.userID = [FIRAuth auth].currentUser.uid;
    [[[self.ref child:@"users"] child:self.userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
    self.currentUser = [[User alloc] initWithSnapshot:snapshot];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void) setupFeedMode:(NSNotification *) notification {
    self.currentUser.newsFeedMode = notification.object;
}

@end
