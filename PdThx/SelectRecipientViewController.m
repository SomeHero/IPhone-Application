//
//  SelectRecipientViewControllerViewController.m
//  PdThx
//
//  Created by Edward Mitchell on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectRecipientViewController.h"

@interface SelectRecipientViewController ()

@end

@implementation SelectRecipientViewController
@synthesize selectRecipientPicker, recipientUriOutputs, recipientUris;

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
}

- (void)viewDidUnload
{
    [self setSelectRecipientPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*      Setting up Picker View      */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [recipientUris count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [recipientUriOutputs objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    chosenRecipient = row;
    //NSString* question = [NSString stringWithString:[[securityQuestions objectAtIndex:row] objectForKey: @"Question"]];
    //currentQuestion.text = question;
    
    //questionPicker.hidden = YES;
}


- (void)dealloc {
    [selectRecipientPicker release];
    [recipientUris release];
    [recipientUriOutputs release];
    [super dealloc];
}
- (IBAction)btnSelectRecipientClicked:(id)sender {
    [selectRecipientDelegate selectRecipient:[recipientUris objectAtIndex:chosenRecipient]];
}
@end
