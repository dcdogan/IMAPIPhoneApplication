//
//  LoginScreenViewController.m
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/3/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import "LoginScreenViewController.h"

@interface LoginScreenViewController ()
@end

@implementation LoginScreenViewController{
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *outputBuilder;
    
    NSString *username;
    NSString *password ;
    NSString *hname;
    int port ;

    NSString *loginCredentials;
}


@synthesize hostName = _hostName;
@synthesize portNumber = _portNumber;
@synthesize username = _username;
@synthesize password = _password;

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginToServer:(id)sender {
    
    username = @"dogancandogan@aol.com";
    password = @"17Dcan1991";
    hname = @"imap.aol.com";
    port = 143;

    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)hname, port, &readStream, &writeStream);
    
    
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:loop forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:loop forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    outputBuilder = [[NSMutableArray alloc] init];
    
    
}


- (void)stream:(NSStream *)bufferStream handleEvent:(NSStreamEvent)streamEvent {
    //[self disconnect];
    
    
    NSLog(@"%ith StreamEvent %u",streamEvent, streamEvent);
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream is opened now");
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"Stream is closed");
            break;
        
        case NSStreamEventErrorOccurred:
            NSLog(@"An error occured during reading the buffer");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"Time to read the buffer");
            
            int len;
            
            if (bufferStream==inputStream) {
                
                while ([inputStream hasBytesAvailable]) {
                    uint8_t buffer[2048];
                    
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if(len>0 ){
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        [outputBuilder addObject:output];
                        NSLog(@"Size is: %d",[outputBuilder count]);
                        NSLog(outputBuilder[[outputBuilder count]- 1]);
                        
                        
                        
                    }
                }
            }
            
            if([outputBuilder count] == 4){
                
                MailListViewController *mlvc = [[MailListViewController alloc] init];
                
                mlvc.subjectFromDate = outputBuilder[3];
                
                mlvc.username = _username;
                mlvc.password = _password;
                mlvc.hostname = _hostName;
                mlvc.portNumber = _portNumber;
                
                [self presentModalViewController:mlvc animated:YES];
                
            }
            
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Now we can send commands to server");
            
            if (bufferStream == outputStream)
            {
                loginCredentials = [NSString stringWithFormat:@". LOGIN %@ %@\n", username, password];
                
                uint8_t loginToServer[100] = ". LOGIN dogancandogan@aol.com 17Dcan1991\n";
                int len;
                
                len = [outputStream write:loginToServer maxLength:sizeof(loginToServer)];

                if (len > 0)
                {
                    NSLog(@"First command is sent\n");
                    //[outputStream close];

                }
                
                uint8_t selectInbox[100] = ". select inbox\n";
                
                len = [outputStream write:selectInbox maxLength:sizeof(selectInbox)];
                
                if (len > 0)
                {
                    NSLog(@"Second command is sent\n");
                    //[outputStream close];

                }

                uint8_t getSubjectFromDate[100] = "\n. fetch 1:* body[header.fields (subject from date)]\n";

                len = [outputStream write:getSubjectFromDate maxLength:sizeof(getSubjectFromDate)];
                
                if (len > 0)
                {
                    NSLog(@"Third command is sent\n");
                    [outputStream close];
                }

                /*
                uint8_t getContent[100] = "\n. fetch 1:* body[text]\n";

                len = [outputStream write:getContent maxLength:sizeof(getContent)];
                
                if (len > 0)
                {
                    NSLog(@"Fourth command is sent\n");
                    [outputStream close];
                    
                }
                 */
                
            
            break;
            
        default:
            break;
    }
    
    }
    }




@end
