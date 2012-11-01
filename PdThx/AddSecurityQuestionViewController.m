//
//  AddSecurityQuestionViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddSecurityQuestionViewController.h"
#import "PdThxAppDelegate.h"
#import "SecurityQuestionSelectOptionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddSecurityQuestionViewController ()

@end

@implementation AddSecurityQuestionViewController

@synthesize chooseQuestionButton, questionLabel;

@synthesize submitButton, answerField, securityQuestionEnteredDelegate;
@synthesize navigationTitle, headerText;
@synthesize questionId, questionAnswer;
@synthesize optionSelector;

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
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    securityQuestions = [appDelegate securityQuestions];
    NSLog(@"Security Questions: %@", securityQuestions);
    [questionLabel setText:[[securityQuestions objectAtIndex:0] objectForKey:@"Question"]];
    questionId = 0;
    
    answerField.delegate = self;
}

- (void)viewDidUnload
{
    [answerField release];
    answerField = nil;
    [submitButton release];
    submitButton = nil;
    [questionLabel release];
    questionLabel = nil;
    [chooseQuestionButton release];
    chooseQuestionButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self setTitle: navigationTitle];
}

-(void)cancelClicked
{

    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [answerField release];
    [submitButton release];
    [navigationTitle release];
    [headerText release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [questionLabel release];
    [chooseQuestionButton release];
    [super dealloc];
}

/*      Setting up Picker View      */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [securityQuestions count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[securityQuestions objectAtIndex:row] objectForKey:@"Question"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    questionId = [[[securityQuestions objectAtIndex:row] objectForKey: @"Id"] intValue];
    //NSString* question = [NSString stringWithString:[[securityQuestions objectAtIndex:row] objectForKey: @"Question"]];
    //currentQuestion.text = question;
    
    //questionPicker.hidden = YES;
}

- (IBAction)doSubmit:(id)sender
{
    [answerField resignFirstResponder];
    
    if ( [answerField.text length] > 0 ){
        if(questionId == 0) {
            questionId = [[[securityQuestions objectAtIndex:0] objectForKey: @"Id"] intValue];
        }
        
        [securityQuestionEnteredDelegate choseSecurityQuestion:questionId withAnswer:answerField.text];
    } else {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid Question Answer"];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(IBAction) bgTouched:(id) sender
{
    [answerField resignFirstResponder];
    //[questionPicker setHidden:YES];
}

- (IBAction)chooseQuestion:(id)sender
{
    optionSelector = [[[SecurityQuestionSelectOptionViewController alloc] initWithFrame:self.view.bounds] autorelease];
    
    [optionSelector setOptionsArray:securityQuestions];
    [optionSelector setOptionSelectDelegate: self];
    [optionSelector setSelectedOption:questionId];
    
    [optionSelector setHeaderText:@"Choose a Question"];
    [optionSelector setDescriptionText:@"This question will be used to recover your account."];
    
    [self.view addSubview:optionSelector];
    [optionSelector show];
}

-(void)didSelectOption:(int)indexSelected
{
    [optionSelector hide];
    questionId = indexSelected;
    
    [questionLabel setText:[[securityQuestions objectAtIndex:indexSelected] objectForKey:@"Question"]];
}

@end
