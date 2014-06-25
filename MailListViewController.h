//
//  MailListViewController.h
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/4/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailListViewController : UITableViewController

@property (nonatomic, retain) NSString * subjectFromDate;

@property (nonatomic, retain) NSString * username;

@property (nonatomic, retain) NSString * password;

@property (nonatomic, retain) NSString * hostname;

@property int portNumber;

@end
