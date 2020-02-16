//
//  RegistrationViewController.m
//  News
//
//  Created by Максим Артемьев on 08.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "AuthorisationViewController.h"
#import "Container.h"
#import "Menu.h"
//#import "User.h"
#import <Firebase/Firebase.h>
#import <IQKeyboardManager.h>

@interface AuthorisationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

//@property (strong, nonatomic) User *currentUser;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation AuthorisationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtonsStyle];
    
    self.ref = [[FIRDatabase database] reference];
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
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]){
        [self displayWarningLabel:@"All fields must be filled"];
        return;
    }
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error){
            [self displayWarningLabel:error.localizedDescription];
            return;
        }
    }];
}

- (IBAction)registerTapped:(UIButton *)sender {
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]){
        [self displayWarningLabel:@"All fields must be filled"];
        return;
    }
    [[FIRAuth auth] createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (!error){
            
            [[[self.ref child:@"users"] child:authResult.user.uid] setValue:@{@"email": authResult.user.email}];
            [[[[self.ref child:@"users"] child:authResult.user.uid] child:@"newsFeedMode"] setValue:@"list"];
            
            /*
            [[[_ref child:@"users"] child:user.uid] setValue:@{@"username": username} withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
                if (error) {
                    NSLog(@"Data could not be saved: %@", error);
                } else {
                    NSLog(@"Data saved successfully.");
                }
            }];*/
            
            return;
        } else {
            [self displayWarningLabel:error.localizedDescription];
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

- (void) goToMenu{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    Menu *menu = (Menu *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([Menu class])];
    [self showViewController:menu sender:nil];
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Container" bundle:nil];
    Container *menu = (Container *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([Container class])];
    [self showViewController:menu sender:nil];
     */
}

@end
