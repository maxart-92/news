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

- (instancetype)initWithSnapshot: (FIRDataSnapshot *) snapshot{
    if (self = [super init]) {
        self.email = snapshot.value[@"email"];
        self.firstName = snapshot.value[@"firstName"];
        self.secondName = snapshot.value[@"secondName"];
        self.newsFeedMode = snapshot.value[@"newsFeedMode"];
    }
    
    return self;
}

@end
