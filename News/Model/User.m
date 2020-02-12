//
//  User.m
//  News
//
//  Created by Максим Артемьев on 10.02.2020.
//  Copyright © 2020 Максим Артемьев. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setUpUser: (FIRUser *) currentUser{
    self.uid = currentUser.uid;
    self.email = currentUser.email;
}

@end
