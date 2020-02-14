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
@property (weak, nonatomic) IBOutlet UISegmentedControl *newsFeedSegmentedControl;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSString *userID;

@end

@implementation Settings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    [self setupViews];
    [self setupNavigationBar];
    [self setupData];
}

//Добавить метод, который отправляет в БД тип ленты в зависимости от выбранного контрола (при выборе)
//В меню добавить метод, который вытаскивает тип ленты из БД и в зависимости от него открывает нужный контроллер

- (void)setupViews {
    self.eMailLabel.text = @"";
    self.firstNameLabel.text = @"";
    self.secondNameLabel.text = @"";
    if ([self.currentUser.newsFeedMode isEqualToString:@"List"]){
        [self.newsFeedSegmentedControl setSelectedSegmentIndex:0];
    } else {
        [self.newsFeedSegmentedControl setSelectedSegmentIndex:1];
    }
    
    [self.firstNameEditButton addTarget:self action:@selector(EditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondNameEditButton addTarget:self action:@selector(EditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupData {
    
    self.userID = [FIRAuth auth].currentUser.uid;
    [[[self.ref child:@"users"] child:self.userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
       
        self.currentUser = [[User alloc] initWithSnapshot:snapshot];
        self.eMailLabel.text = self.currentUser.email;
        self.firstNameLabel.text = self.currentUser.firstName;
        self.secondNameLabel.text = self.currentUser.secondName;
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)setupNavigationBar {
    self.navigationItem.titleView = [self createTitleViewWithTitle:self.settingsTitle];
}

- (void)EditButtonPressed:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button == self.firstNameEditButton){
        [self showAlert:@"First name" message:@"Please, enter your first name" child:@"firstName"];
    } else {
        [self showAlert:@"Second name" message:@"Please, enter your second name" child:@"secondName"];
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message child:(NSString *)child
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    UIAlertAction* saveButton = [UIAlertAction
                                 actionWithTitle:@"Save"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [[[[self.ref child:@"users"] child:self.userID] child:child] setValue:alert.textFields.firstObject.text];
                                     if ([child isEqualToString:@"firstName"]){
                                         self.firstNameLabel.text = alert.textFields.firstObject.text;
                                     } else {
                                         self.secondNameLabel.text = alert.textFields.firstObject.text;
                                     }
                                 }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
    
    [alert addAction:saveButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
