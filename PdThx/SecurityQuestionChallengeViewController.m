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

@synthesize securityQuestionChallengeDelegate, btnUnlockAccount, currUser;

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
   lblSecurityQuestion.text = currUser.securityQuestion;
    
}
- (void)viewDidUnload
{
    [btnUnlockAccount release];
    btnUnlockAccount = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnSubmitClicked:(id)sender {
    [securityQuestionService validateSecurityAnswer: txtSecurityQuestionAnswer.text forUserId:currUser.userId];
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

- (void)dealloc {
    [btnUnlockAccount release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
@end
