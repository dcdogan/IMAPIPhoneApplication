//
//  MailContentViewController.h
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/6/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailContentViewController : UIViewController

@property (nonatomic, retain) NSString * subjectFromDate;

@property (nonatomic, retain) NSString * username;

@property (nonatomic, retain) NSString * password;

@property (nonatomic, retain) NSString * hostname;

@property int portNumber;

@property int index;

@end
