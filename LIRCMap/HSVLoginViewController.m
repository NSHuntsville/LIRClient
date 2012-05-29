//
//  HSVLoginViewController.m
//  LIRCMap
//
//  Created by Robert Miller on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSVLoginViewController.h"
#include "AFNetworking.h"
#include "HSVViewController.h"

#define kSERVICE_URL = @"http://localhost:3000";

@interface HSVLoginViewController () {
}
@property (strong, nonatomic) NSString * accessToken; 
@property (strong, nonatomic) HSVJSONHelper * jsonHelper;
@end

@implementation HSVLoginViewController
@synthesize loginField;
@synthesize accessToken = _accessToken;
@synthesize jsonHelper = _jsonHelper;

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
	// Do any additional setup after loading the view.
    [loginField setDelegate:self];
    [self setJsonHelper:[[HSVJSONHelper alloc] init]];
}

- (void)viewDidUnload
{
    [self setLoginField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [[self jsonHelper] getAuthorizationCredentialsForName:loginField.text callingFunction:(id <JSONHelper>)self];
    //Insert some whiz-bang animation here
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y - 200.0), textField.frame.size.width, textField.frame.size.height);
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y + 200.0), textField.frame.size.width, textField.frame.size.height);
	[UIView commitAnimations];
}
- (IBAction)loginBtn:(id)sender {
    [[self jsonHelper] getAuthorizationCredentialsForName:loginField.text callingFunction:(id <JSONHelper>)self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"seeMap"]) {
        HSVViewController *mapVC = [segue destinationViewController];  
        mapVC.loginName = loginField.text;
        mapVC.accessToken = [self accessToken];
        
    }
}

-(void)indicateSuccessfulAuthorizationForName:(NSString *)userName withToken:(NSString *) tokenID {
        if(tokenID) {
            [self setAccessToken:tokenID];
            [self performSegueWithIdentifier:@"seeMap" sender:self];
        }
        else {
            NSLog(@"HSVLoginViewController: Did not retrieve an access token");
        }
}
#pragma mark -
#pragma mark - Login

@end
