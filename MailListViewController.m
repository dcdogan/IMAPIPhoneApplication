//
//  MailListViewController.m
//  IMAPIPhoneApplication
//
//  Created by DoganCan on 11/4/13.
//  Copyright (c) 2013 Dogan Can Dogan. All rights reserved.
//

#import "MailListViewController.h"
#import "ContentViewController.h"

@interface MailListViewController ()

@end

@implementation MailListViewController{
    
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *bufferedBuilder;
    
    
    NSMutableArray *subjects;
    NSMutableArray *froms;
    NSMutableArray *dates;
    
    int rowIndex;
    
}

@synthesize subjectFromDate = _subjectFromDate;

@synthesize username = _username;
@synthesize password = _password;
@synthesize hostname = _hostname;
@synthesize portNumber = _portNumber;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"------------------------------------------------------------------------------");

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    if(_subjectFromDate){
        
        
        NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
        
        NSArray *lines = [_subjectFromDate componentsSeparatedByCharactersInSet:newlineCharSet];
        
        froms = [[NSMutableArray alloc] init];
        subjects = [[NSMutableArray alloc] init];
        dates = [[NSMutableArray alloc] init];
        
        NSLog(@"My first line is: %@ ", lines[0]);
        NSLog(@"My second line is: %@", lines[1]);
        NSLog(@"My third line is: %@", lines[2]);
        NSLog(@"My fourth line is: %@", lines[3]);
        NSLog(@"My fifth line is: %@", lines[4]);
        NSLog(@"My fifth line is: %@", lines[5]);
        NSLog(@"My fifth line is: %@", lines[6]);
        NSLog(@"My fifth line is: %@", lines[7]);

        NSLog(@"Size is %d", [lines count]);
        
        for(int i=0; i < [lines count]; i++){
            
            if(![lines[i] rangeOfString:@"From: "].location)
                [froms addObject:lines[i]];
            if(![lines[i] rangeOfString:@"Subject: "].location)
                [subjects addObject:lines[i]];
            if(![lines[i] rangeOfString:@"Date: "].location)
                [dates addObject:lines[i]];
        }
        
        NSLog(@"Size of froms: %d", [froms count]);
        NSLog(@"Size of froms: %d", [subjects count]);
        NSLog(@"Size of froms: %d", [dates count]);
        
        for (int i= 0 ; i< [froms count]; i++) {
            NSLog(froms[i]);
        }
        
        for (int i= 0 ; i< [subjects count]; i++) {
            NSLog(subjects[i]);
        }

        for (int i= 0 ; i< [dates count]; i++) {
            NSLog(dates[i]);
        }

        
        
        
    }
    else{
        
        NSLog(@"emptyemptyemptyemptyemptyemptyemptyemptyemptyemptyemptyemptyempty");
    }

    
    
    
    [super viewDidLoad];
    
    
    }

- (void) connectAndReceiveTheContent{
    
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_hostname, _portNumber, &readStream, &writeStream);
    
    
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:loop forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:loop forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    bufferedBuilder = [[NSMutableArray alloc] init];

    
    
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
                        
                        [bufferedBuilder addObject:output];
                        NSLog(@"Size is: %d",[bufferedBuilder count]);
                        NSLog(bufferedBuilder[[bufferedBuilder count]- 1]);
                        
                        
                        
                    }
                }
            }
            
            if([bufferedBuilder count] == 4){
                
                
                ContentViewController  *cvc = [[ContentViewController alloc] init];
                
                cvc.content = bufferedBuilder[4];
                
                [self presentModalViewController:cvc animated:YES];

                
            }
            
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Now we can send commands to server");
            
            if (bufferStream == outputStream)
            {
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
                    [outputStream close];
                    
                }
                
                /*
                
                // set row_index here as the body of message
                 uint8_t getContent[100] = "\n. fetch 1 body[text]\n";
                 
                 len = [outputStream write:getContent maxLength:sizeof(getContent)];
                 
                 if (len > 0)
                 {
                 NSLog(@"Third command is sent\n");
                 [outputStream close];
                 
                 }
                */
                
                
                break;
                
            default:
                break;
            }
            
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *subjectFrom  = [NSString stringWithFormat:@"%@ \n %@ \n %@", [subjects objectAtIndex:indexPath.row], [froms objectAtIndex:indexPath.row], [dates objectAtIndex:indexPath.row]];
    

    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;

    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.textLabel.text = subjectFrom;
    

    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Did selecet row ast index path");
    
    //[self connectAndReceiveTheContent];
    
    rowIndex = indexPath.row;
    
    ContentViewController  *cvc = [[ContentViewController alloc] init];
    
    cvc.content = @"This is a test message for iOS application...\nThis is a test message for iOS \napplication...\nThis is a test message for iOS application...\n Dogan Can Dogan Information Systems";
    
    [self presentModalViewController:cvc animated:YES];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
