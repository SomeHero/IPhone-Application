//
//  MECodeSetupViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MECodeSetupViewController.h"

@interface MECodeSetupViewController ()
                    ///////REMOVE THIS CLASS
@end

@implementation MECodeSetupViewController
@synthesize meCodeField;
@synthesize createDateField;
@synthesize approvedField;
@synthesize checkAvailButton;
@synthesize submitButton;

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
    // Do any additional setup after loading the view from its nib.
    meCodeField.delegate = self;
    createDateField.delegate = self;
    approvedField.delegate = self;
}


- (IBAction)clickedCheckAvailButton:(id)sender {
    NSLog(@"Clicked Avail Button");
    NSLog(@"Field Values:");
    NSLog(@"MeCode: %@", meCodeField.text);
    NSLog(@"Date: %@", createDateField.text);
    NSLog(@"Approved: %@", approvedField.text);
}

- (void)viewDidUnload
{
    [self setMeCodeField:nil];
    [self setCreateDateField:nil];
    [self setApprovedField:nil];
    [self setCheckAvailButton:nil];
    [meCodeField release];
    meCodeField = nil;
    [checkAvailButton release];
    checkAvailButton = nil;
    [createDateField release];
    createDateField = nil;
    [approvedField release];
    approvedField = nil;
    [submitButton release];
    submitButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [meCodeField release];
    [createDateField release];
    [approvedField release];
    [checkAvailButton release];
    [meCodeField release];
    [checkAvailButton release];
    [createDateField release];
    [approvedField release];
    [submitButton release];
    [super dealloc];
}


- (IBAction)clickedSubmitButton:(id)sender {
    
}

- (IBAction)meCodeChanged:(id)sender 
{
   
    
    if ( [meCodeField.text length] > 0  && [meCodeField.text characterAtIndex:0] != '$')
        meCodeField.text = [NSString stringWithFormat:@"%@%@", @"$", meCodeField.text];
}


#pragma mark UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [meCodeField resignFirstResponder];
    return NO;
}

@end
