//
//  ContainerViewController.m
//  News
//
//  Created by Максим Артемьев on 15.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "Container.h"
#import "Menu.h"
#import "Sidebar.h"
#import "Settings.h"
#import "AuthorisationViewController.h"

@interface Container () <MenuDelegate>

@property (strong, nonatomic) BaseViewController *controller;
@property (strong, nonatomic) BaseViewController *sidebar;

@property (assign, nonatomic) BOOL isMove;

@end

@implementation Container

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMove = false;
    
    [self configureMenuController];
}

/*
-(void)configureMenuController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    Menu *menu = (Menu *)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([Menu class])];
    menu.delegate = self;
    self.controller = menu;
    [self.view addSubview:self.controller.view];
    [self addChildViewController:self.controller];
}*/

-(void)configureMenuController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authorisation" bundle:nil];
    AuthorisationViewController *menu = (AuthorisationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Authorisation"];
    //menu.delegate = self;
    self.controller = menu;
    [self.view addSubview:self.controller.view];
    [self addChildViewController:self.controller];
}

-(void)configureSidebarController{
    if (!self.sidebar){
        self.sidebar = [Sidebar new];
        [self.view insertSubview:self.sidebar.view atIndex:0];
        [self addChildViewController:self.sidebar];
    }
}

-(void)showSidebar:(BOOL)shouldMove{
    if (shouldMove){
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                    
                             CGRect frame = self.controller.view.frame;
                             frame.origin.x = self.controller.view.frame.size.width - 140.;
                             self.controller.view.frame = frame;

                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = self.controller.view.frame;
                             frame.origin.x = 0;
                             self.controller.view.frame = frame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

#pragma mark - MenuDelegate

- (void)toggleSidebar{
    [self configureSidebarController];
    self.isMove = !self.isMove;
    [self showSidebar:self.isMove];
}

@end
