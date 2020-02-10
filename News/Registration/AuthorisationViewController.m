//
//  RegistrationViewController.m
//  News
//
//  Created by Максим Артемьев on 08.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "AuthorisationViewController.h"
#import "Menu.h"
#import <Firebase/Firebase.h>
//#import <IQKeyboardManager.h>

@interface AuthorisationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation AuthorisationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtonsStyle];
    
    self.warningLabel.alpha = 0;
}

-(void) setupButtonsStyle {
    NSMutableArray *buttonsArray = [NSMutableArray new];
    [buttonsArray addObject:self.loginButton];
    [buttonsArray addObject:self.registerButton];
    
    for (UIButton *button in buttonsArray){
        button.layer.cornerRadius = 10;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1;
        [button setTitleColor:([UIColor whiteColor]) forState:(normal)];
    }
    
}

-(void) displayWarningLabel:(NSString *)withText{
    self.warningLabel.text = withText;
    /*[UIView performWithoutAnimation:^{
        self.warningLabel.alpha = 1;
    }];*/
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.warningLabel.alpha = 1;
    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.warningLabel.alpha = 0;
        } completion:^(BOOL finished) {
        }];
        
    }];
     
}

- (IBAction)loginTapped:(UIButton *)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    if ([email isEqualToString:@""] || [password isEqualToString:@""]){
        [self displayWarningLabel:@"info is incorrect"];
        return;
    }
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
                             if (!error){
                                 //[self goToMenu];
                                 return;
                             } else {
                                 [self displayWarningLabel:@"Error occured"];
                                 return;
                             }
                         }];
}

- (IBAction)registerTapped:(UIButton *)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    if ([email isEqualToString:@""] || [password isEqualToString:@""]){
        [self displayWarningLabel:@"info is incorrect"];
        return;
    }
    [[FIRAuth auth] createUserWithEmail:self.emailTextField.text
                            password:self.passwordTextField.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                                 if (!error){
                                     [self goToMenu];
                                     return;
                                 }
                             }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.handle = [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       if (user){
                           [self goToMenu];
                       }
                   }];
    self.emailTextField.text = @"";
    self.passwordTextField.text = @"";
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[FIRAuth auth] removeAuthStateDidChangeListener:_handle];
}

- (void) goToMenu {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    Menu *menu = (Menu *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([Menu class])];
    [self showViewController:menu sender:nil];
}

@end
