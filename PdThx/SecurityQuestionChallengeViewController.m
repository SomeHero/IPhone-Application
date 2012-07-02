//
//  SecurityQuestionChallengeViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecurityQuestionChallengeViewController.h"

@interface SecurityQuestionChallengeViewController ()

@end

@implementation SecurityQuestionChallengeViewController

@synthesize securityQuestionChallengeDelegate;

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
    
    securityQuestionService = [[SecurityQuestionService alloc] init];
    [securityQuestionService setSecurityQuestionAnsweredDelegate: self];
    
}
-(void)viewDidAppear:(BOOL)animated {
   lblSecurityQuestion.text = user.securityQuestion;
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnSubmitClicked:(id)sender {
    [securityQuestionService validateSecurityAnswer: txtSecurityQuestionAnswer.text forUserId:user.userId];
}

-(IBAction) bgTouched:(id) sender {
    [txtSecurityQuestionAnswer resignFirstResponder];
}

-(void)securityQuestionAnsweredDidComplete {
    [securityQuestionChallengeDelegate securityQuestionAnsweredCorrect];
}
-(void)securityQuestionAnsweredDidFail:(NSString*)errorMessage {
    [securityQuestionChallengeDelegate securityQuestionAnsweredInCorrect:errorMessage];
}



@end
