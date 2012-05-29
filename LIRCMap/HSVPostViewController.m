//
//  HSVPostViewController.m
//  LIRCMap
//
//  Created by Robert Miller on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSVPostViewController.h"


@interface HSVPostViewController ()
@property(nonatomic, strong) HSVJSONHelper *jsonHelper;
@end

@implementation HSVPostViewController
@synthesize loginName = _loginName;
@synthesize messageTextView = _messageTextView;
@synthesize accessToken = _accessToken;
@synthesize jsonHelper = _jsonHelper;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setJsonHelper:[[HSVJSONHelper alloc] init]];
}

- (void)viewDidUnload
{
    [self setMessageTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)postItBtn:(id)sender {
    // 
    [[self jsonHelper] sendCommentForLat:[self latitude] longitude:[self longitude] comment:[[self messageTextView] text] forUser:[self loginName] tokenID:[self accessToken] callingFunction:self];
}

- (IBAction)cancelBtn:(id)sender {
    [[self messageTextView] setText:@"Post Cancelled"];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}
/*
 * 
 */
-(void)messagePosted:(NSString *)message {
    if(message) {
        NSLog(@"The message %@ was posted" , message);
    } else {
        NSLog(@"An Error occurred while posting the message");
    }
}
-(void)messagesReceived:(NSArray *)messagesArray {
    if(messagesArray) {
        NSLog(@"Received messages for this location");
        NSLog(@"%@", messagesArray);
    }
}
@end
