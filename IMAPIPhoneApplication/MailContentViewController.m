//
//  MailContentViewController.m
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/6/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import "MailContentViewController.h"

@interface MailContentViewController ()

@end

@implementation MailContentViewController

@synthesize username = _username;
@synthesize password = _password;
@synthesize portNumber = _portNumber;
@synthesize hostname = _hostname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"mail content is called");
    
    NSLog(@"here are the parameters: ");
    
    NSLog(@"testtesttesttesttesttest : %@   %@   %d   %@   ",_username, _password, _portNumber, _hostname );

    UITextView *myTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 30, 100, 30)];
    myTextView.text = @"some text";
    //some other setup like setting the font for the UITextView...
    [self.view addSubview:myTextView];
    [myTextView sizeToFit];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
