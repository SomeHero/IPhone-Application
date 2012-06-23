//
//  AddSecurityQuestionViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddSecurityQuestionViewController.h"
#import "PdThxAppDelegate.h"

@interface AddSecurityQuestionViewController ()

@end

@implementation AddSecurityQuestionViewController

@synthesize chooseQuestionButton, submitButton, questionPicker, answerField, securityQuestionEnteredDelegate;

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
    
    answerField.delegate = self;
}

- (void)viewDidUnload
{
    [chooseQuestionButton release];
    chooseQuestionButton = nil;
    [answerField release];
    answerField = nil;
    [submitButton release];
    submitButton = nil;
    [questionPicker release];
    questionPicker = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [chooseQuestionButton release];
    [answerField release];
    [submitButton release];
    [questionPicker release];
    [super dealloc];
}
- (IBAction)showQuestionPicker:(id)sender {
    questionPicker.hidden = NO;
}


/*      Setting up Picker View      */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [(((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).SecurityQuestionArray) count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[(((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).SecurityQuestionArray) objectAtIndex:row] objectForKey:@"Question"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    questionId = row;
    questionPicker.hidden = YES;
}

- (IBAction)doSubmit:(id)sender {
    if ( [answerField.text length] > 0 ){
        [securityQuestionEnteredDelegate choseSecurityQuestion:questionId withAnswer:answerField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Answer" message:@"Please enter a security question and answer." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
