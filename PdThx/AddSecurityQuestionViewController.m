//
//  AddSecurityQuestionViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddSecurityQuestionViewController.h"
#import "PdThxAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AddSecurityQuestionViewController ()

@end

@implementation AddSecurityQuestionViewController

@synthesize submitButton, questionPicker, answerField, securityQuestionEnteredDelegate;
@synthesize navigationTitle, headerText;
@synthesize questionId, questionAnswer;

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
    
    questionId = 1;
    // TODO: Security Question Delegate
    securityQuestionService = [[GetSecurityQuestionsService alloc] init];
    securityQuestionService.questionsLoadedDelegate = self;
    [securityQuestionService getSecurityQuestions:NO];
}

- (void)viewDidUnload
{
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
-(void)viewDidAppear:(BOOL)animated {
    [self setTitle: navigationTitle];
    
    
    UIBarButtonItem *cancelButton =  [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemAction target:self action:@selector(cancelClicked)];
    
    self.navigationItem.leftBarButtonItem= cancelButton;
    [cancelButton release];
}
-(void)cancelClicked {

    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [answerField release];
    [submitButton release];
    [questionPicker release];
    [navigationTitle release];
    [headerText release];
    
    [super dealloc];
}
- (IBAction)showQuestionPicker:(id)sender {
    //[securityQuestionService getSecurityQuestions:NO]; // Get All questions
    questionPicker.hidden = NO;
}
-(void)loadedSecurityQuestions:(NSMutableArray *)questionArray
{
    securityQuestions = questionArray;
    
    [questionPicker reloadAllComponents];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ( [defaults objectForKey:@"securityQuestionId"] == NULL )
        NSLog(@"Null Question Id");
    else 
        NSLog(@"Question ID: %d", [[defaults objectForKey:@"securityQuestionId"] integerValue]);
    
    if ( [[defaults objectForKey:@"securityQuestionId"] intValue] >= 0 ){
        questionId = [[defaults objectForKey:@"securityQuestionId"] integerValue];
        [questionPicker selectedRowInComponent:questionId];
    }
    
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

- (IBAction)doSubmit:(id)sender {
    if ( [answerField.text length] > 0 ){
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


-(IBAction) bgTouched:(id) sender {
    [answerField resignFirstResponder];
    //[questionPicker setHidden:YES];
}

@end
