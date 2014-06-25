//
//  ViewController.m
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/3/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;

}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    Username.text = @"";
    Password.text = @"";
    [self disconnect];
    if (counter!=nil){
        [counter invalidate];
        counter=nil;
    }
    
    NSLog(@"StreamEvent %i",streamEvent);
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream==inputStream) {
                
                while ([inputStream hasBytesAvailable]) {
                    uint8_t buffer[1024];
                    int len;
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if(len>0){
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        NSLog(@"output %@",output);
                        [SVProgressHUD dismiss];
                        main = [[Mainmenu alloc]
                                initWithNibName:@"Mainmenu"
                                bundle:nil];
                        //                        [self.view addSubview:main.view];
                        [self presentViewController:main animated:NO completion:NO];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{[SVProgressHUD dismiss];
            });
            
            break;
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
            dispatch_async(dispatch_get_main_queue(), ^{[self dismiss:@"Cannot connect to host!"];
            });
            
            break;
            
        case NSStreamEventEndEncountered:
            dispatch_async(dispatch_get_main_queue(), ^{[self dismiss:@"Connection Error"];
            });
            
            break;
            
        default:
            NSLog(@"Unknown event");
            dispatch_async(dispatch_get_main_queue(), ^{[self dismiss:@"Timeout Expired"];
            });
            
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"imap.aol.com", 143, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;


    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:loop forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:loop forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    NSData *data = [[NSData alloc] initWithData:[pinno dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    [outputStream close];
    
    [loop run];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
