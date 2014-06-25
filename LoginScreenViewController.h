//
//  LoginScreenViewController.h
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/3/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailListViewController.h"

@interface LoginScreenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *hostName;
@property (strong, nonatomic) IBOutlet UITextField *portNumber;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginToServer:(id)sender;

@end
