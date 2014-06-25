//
//  ContentViewController.m
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/6/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController
@synthesize content = _content;

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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1500)];
    [[self view] addSubview:textView];
    textView.text = _content;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
