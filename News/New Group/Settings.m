//
//  Settings.m
//  News
//
//  Created by Максим Артемьев on 10.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "Settings.h"
#import "User.h"
#import <Firebase/Firebase.h>

@interface Settings ()

@property (weak, nonatomic) IBOutlet UILabel *eMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstNameEditButton;
@property (weak, nonatomic) IBOutlet UIButton *secondNameEditButton;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) User *currentUser;

@end

@implementation Settings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eMailLabel.text = @"";
    self.ref = [[FIRDatabase database] reference];
    
    [self setupViews];
    [self setupNavigationBar];
    /*
    self.currentUser = [User new];
    [self.currentUser setUpUser:FIRAuth.auth.currentUser];
    self.eMailLabel.text = self.currentUser.email;
     */
}

- (void)setupViews {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[self.ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        self.currentUser = [User new];
        self.currentUser.email = snapshot.value[@"email"];
        self.eMailLabel.text = self.currentUser.email;
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)setupNavigationBar {
    self.navigationItem.titleView = [self createTitleViewWithTitle:self.settingsTitle];
}

@end
